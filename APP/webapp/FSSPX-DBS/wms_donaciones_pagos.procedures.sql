-- ============================================================
-- MODULO: Donaciones - Pagos (Ficha de pago / Pagar en tienda con QR) - Procedures
-- Requiere que la tabla de wms_donaciones_pagos.tables.sql ya exista.
--
-- El listado de donaciones combinado (QR + Stripe) para "Listado de Donaciones"
-- (dash.donaciones.proyectodetalles.php) vive en wms_donaciones.procedures.sql
-- (wms_donaciones_pagos_listar_por_proyecto), no aqui: al mezclar dos tablas de metodo de
-- pago distintas, pertenece mas al lado del proyecto que al de un metodo de pago especifico.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_ficha_pago_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_ficha_pago_consultar_por_folio;
DROP PROCEDURE IF EXISTS wms_donaciones_ficha_pago_actualizar_estatus;
DROP PROCEDURE IF EXISTS wms_donaciones_ficha_pago_eliminar;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_ficha_pago_insertar
-- Da de alta una ficha de pago (orden "Pagar con QR"), en estatus 'pendiente'.
-- El folio_qr ya llega generado desde PHP (Donaciones::valideParms2GenerarFichaPago).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_ficha_pago_insertar (
  IN p_folio_qr          VARCHAR(40),
  IN p_fk_proyecto       INT UNSIGNED,
  IN p_donante_nombre    VARCHAR(100),
  IN p_donante_apellidos VARCHAR(100),
  IN p_donante_correo    VARCHAR(150),
  IN p_donante_telefono  VARCHAR(20),
  IN p_monto             DECIMAL(12,2),
  IN p_moneda            CHAR(3)
)
BEGIN
  INSERT INTO wms_donaciones_fichas_pago (
    folio_qr, fk_proyecto,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda
  ) VALUES (
    p_folio_qr, p_fk_proyecto,
    p_donante_nombre, p_donante_apellidos, p_donante_correo, p_donante_telefono,
    p_monto, p_moneda
  );

  SELECT
    id_ficha_pago,
    folio_qr,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_fichas_pago
  WHERE id_ficha_pago = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_ficha_pago_consultar_por_folio
-- Trae una ficha de pago por su folio público (usado por la futura pantalla
-- mob/pagoenlibreria/{folio_qr} para mostrar el QR y los datos de la orden).
-- Incluye titulo/imagen/tipo del proyecto para no requerir una segunda consulta.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_ficha_pago_consultar_por_folio (
  IN p_folio_qr VARCHAR(40)
)
BEGIN
  SELECT
    fp.id_ficha_pago,
    fp.folio_qr,
    fp.fk_proyecto,
    fp.donante_nombre,
    fp.donante_apellidos,
    fp.donante_correo,
    fp.donante_telefono,
    fp.monto,
    fp.moneda,
    fp.estatus_pago,
    fp.fecha_registro,
    fp.fecha_pago,
    p.proyecto_titulo,
    p.proyecto_imagen,
    p.tipo_proyecto
  FROM wms_donaciones_fichas_pago fp
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = fp.fk_proyecto
  WHERE fp.folio_qr = p_folio_qr
    AND fp.status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_ficha_pago_actualizar_estatus
-- Cambia el estatus de una ficha (ej. 'pendiente' -> 'pagado' cuando la tienda confirma el
-- cobro). NO toca proyecto_recaudado: ese valor ya no se guarda/mantiene en ninguna columna,
-- se calcula EN VIVO con un SUM() sobre las fichas 'pagado' cada vez que se consulta un
-- proyecto (ver wms_donaciones.procedures.sql). Una sola fuente de verdad, sin nada que
-- sincronizar aqui ni riesgo de que se desincronice.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_ficha_pago_actualizar_estatus (
  IN p_folio_qr    VARCHAR(40),
  IN p_estatus_pago ENUM('pendiente','pagado')
)
BEGIN
  UPDATE wms_donaciones_fichas_pago
  SET
    estatus_pago = p_estatus_pago,
    fecha_pago   = CASE WHEN p_estatus_pago = 'pagado' THEN NOW() ELSE fecha_pago END
  WHERE folio_qr = p_folio_qr
    AND status = 1;

  SELECT
    id_ficha_pago,
    folio_qr,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_fichas_pago
  WHERE folio_qr = p_folio_qr;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_ficha_pago_eliminar
-- Hard delete de una ficha de pago completa. Uso EXCLUSIVO: rollback cuando una rifa reserva su
-- orden QR pero la reserva de numeros de boleto falla a medio carrito (condicion de carrera muy
-- rara, ver Donaciones::reservarBoletosRifa()) -- deja huerfana una ficha sin ningun boleto
-- ligado, y hay que deshacerla en vez de dejarla 'pendiente' para siempre. NO se usa en el flujo
-- normal de donacion/QR.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_ficha_pago_eliminar (
  IN p_id_ficha_pago INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_fichas_pago
  WHERE id_ficha_pago = p_id_ficha_pago;
END$$

DELIMITER ;
