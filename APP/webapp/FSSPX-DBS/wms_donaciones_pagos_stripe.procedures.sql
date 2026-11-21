-- ============================================================
-- MODULO: Donaciones - Pagos (Pago con Tarjeta via Stripe) - Procedures
-- Requiere que la tabla de wms_donaciones_pagos_stripe.tables.sql ya exista.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_pago_stripe_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_stripe_consultar_por_payment_intent;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_stripe_consultar_por_folio;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_stripe_actualizar_estatus;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_stripe_eliminar;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_stripe_insertar
-- Da de alta un registro de pago con Stripe, en estatus 'pendiente'. El folio_stripe y el
-- stripe_payment_intent_id ya llegan generados desde PHP
-- (Donaciones::valideParms2GenerarPagoStripe, después de crear el PaymentIntent en Stripe).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_stripe_insertar (
  IN p_folio_stripe             VARCHAR(40),
  IN p_fk_proyecto              INT UNSIGNED,
  IN p_donante_nombre           VARCHAR(100),
  IN p_donante_apellidos        VARCHAR(100),
  IN p_donante_correo           VARCHAR(150),
  IN p_donante_telefono         VARCHAR(20),
  IN p_monto                    DECIMAL(12,2),
  IN p_moneda                   CHAR(3),
  IN p_stripe_payment_intent_id VARCHAR(100)
)
BEGIN
  INSERT INTO wms_donaciones_pagos_stripe (
    folio_stripe, fk_proyecto,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda, stripe_payment_intent_id
  ) VALUES (
    p_folio_stripe, p_fk_proyecto,
    p_donante_nombre, p_donante_apellidos, p_donante_correo, p_donante_telefono,
    p_monto, p_moneda, p_stripe_payment_intent_id
  );

  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE id_pago_stripe = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_stripe_consultar_por_payment_intent
-- Trae un registro por su stripe_payment_intent_id. Es lo que trae cada evento del webhook,
-- así que es la forma en que StripeWebhookEventsHandler localiza el registro a actualizar.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_stripe_consultar_por_payment_intent (
  IN p_stripe_payment_intent_id VARCHAR(100)
)
BEGIN
  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id
    AND status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_stripe_consultar_por_folio
-- Trae un registro por su folio público propio (folio_stripe).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_stripe_consultar_por_folio (
  IN p_folio_stripe VARCHAR(40)
)
BEGIN
  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE folio_stripe = p_folio_stripe
    AND status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_stripe_actualizar_estatus
-- Cambia el estatus de un registro (llamado por Donaciones::actualizarEstatusPagoStripe,
-- desde StripeWebhookEventsHandler, cuando Stripe confirma o falla el cobro). NO toca
-- proyecto_recaudado: se calcula EN VIVO igual que con los pagos QR (ver
-- wms_donaciones.procedures.sql).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_stripe_actualizar_estatus (
  IN p_stripe_payment_intent_id VARCHAR(100),
  IN p_estatus_pago ENUM('pendiente','pagado','fallido','cancelado')
)
BEGIN
  UPDATE wms_donaciones_pagos_stripe
  SET
    estatus_pago = p_estatus_pago,
    fecha_pago   = CASE WHEN p_estatus_pago = 'pagado' THEN NOW() ELSE fecha_pago END
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id
    AND status = 1;

  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_stripe_eliminar
-- Hard delete de un registro de pago con Stripe completo. Uso EXCLUSIVO: rollback cuando una
-- rifa crea el PaymentIntent pero la reserva de numeros de boleto falla a medio carrito
-- (condicion de carrera muy rara, ver Donaciones::reservarBoletosRifa()) -- el PaymentIntent en
-- Stripe tambien se cancela desde PHP en ese mismo momento. NO se usa en el flujo normal.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_stripe_eliminar (
  IN p_id_pago_stripe INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_pagos_stripe
  WHERE id_pago_stripe = p_id_pago_stripe;
END$$

DELIMITER ;
