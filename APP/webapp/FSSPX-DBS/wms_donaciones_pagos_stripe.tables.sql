-- ============================================================
-- MODULO: Donaciones - Pagos (Pago con Tarjeta via Stripe)
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos ya exista
-- (ver wms_donaciones.tables.sql).
--
-- Tabla INDEPENDIENTE de wms_donaciones_fichas_pago (QR, ver wms_donaciones_pagos.tables.sql):
-- esa ya está en producción y no se toca ni se reutiliza -- cada método de pago tiene su
-- propia tabla y su propio folio.
--
-- Flujo: el donante llena el formulario público (monto, nombre, apellidos, correo, teléfono)
-- y elige pagar de inmediato con tarjeta. El servidor crea un PaymentIntent en Stripe (monto
-- dinámico, sin price_id/suscripción) y este registro queda en 'pendiente' hasta que el
-- webhook de Stripe (payment_intent.succeeded / payment_intent.payment_failed) confirma el
-- resultado real del cobro -- el webhook es la fuente de verdad de "se cobró", no la
-- confirmación del lado del cliente, que puede perderse si el donante cierra la pestaña
-- antes de que termine el 3D Secure.
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_pagos_stripe;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_pagos_stripe
-- Un registro = un intento de pago con tarjeta (un PaymentIntent de Stripe).
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_pagos_stripe (
  id_pago_stripe        INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  -- Folio público propio de este método de pago (independiente de folio_qr), generado en
  -- PHP como FS-{fecha}-{hora}-{bloque aleatorio}, ej. FS-20260305-143022-9F3A2B.
  folio_stripe          VARCHAR(40)   NOT NULL,

  fk_proyecto           INT UNSIGNED  NOT NULL,

  donante_nombre        VARCHAR(100)  NOT NULL,
  donante_apellidos     VARCHAR(100)  NOT NULL,
  donante_correo        VARCHAR(150)  NOT NULL,
  donante_telefono      VARCHAR(20)   NOT NULL,

  monto                 DECIMAL(12,2) NOT NULL,
  moneda                CHAR(3)       NOT NULL DEFAULT 'usd',

  -- ID del PaymentIntent de Stripe (pi_...). Es lo que trae cada evento del webhook, así que
  -- es la clave con la que se localiza/actualiza este registro (ver
  -- wms_donaciones_pago_stripe_consultar_por_payment_intent / _actualizar_estatus).
  stripe_payment_intent_id VARCHAR(100) NOT NULL,

  -- 'pendiente' = PaymentIntent creado, todavía sin confirmar por el webhook.
  -- 'pagado'    = payment_intent.succeeded.
  -- 'fallido'   = payment_intent.payment_failed.
  -- 'cancelado' = el PaymentIntent se canceló (ej. el donante abandonó el pago).
  estatus_pago          ENUM('pendiente','pagado','fallido','cancelado') NOT NULL DEFAULT 'pendiente',

  status                TINYINT(1)    NOT NULL DEFAULT 1,
  fecha_registro        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_pago            DATETIME      NULL, -- se llena cuando estatus_pago pasa a 'pagado'

  PRIMARY KEY (id_pago_stripe),
  UNIQUE KEY uq_pago_stripe_folio (folio_stripe),
  UNIQUE KEY uq_pago_stripe_payment_intent (stripe_payment_intent_id),
  KEY idx_pago_stripe_proyecto (fk_proyecto),
  KEY idx_pago_stripe_estatus (estatus_pago),
  CONSTRAINT fk_pago_stripe_proyecto
    FOREIGN KEY (fk_proyecto) REFERENCES wms_donaciones_proyectos (id_proyecto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
