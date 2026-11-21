-- ============================================================
-- MODULO: Donaciones - Pagos (Depósito por Transferencia / SPEI) - Procedures
-- Requiere que la tabla de wms_donaciones_pagos_transferencia.tables.sql ya exista.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_actualizar_concepto;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_consultar_por_folio;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_consultar_por_token;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_generar_token;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_subir_comprobante;
DROP PROCEDURE IF EXISTS wms_donaciones_pagos_transferencia_listar_por_proyecto;
DROP PROCEDURE IF EXISTS wms_donaciones_pago_transferencia_marcar_pagado;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_insertar
-- Da de alta la orden, en estatus 'pendiente'. folio_transferencia ya llega generado desde PHP;
-- p_concepto aquí es solo un PLACEHOLDER temporal (ej. el folio) -- el concepto real, que
-- incluye el PK de esta misma fila (ej. "DON-CAPILLA-1042"), se arma DESPUÉS de este INSERT
-- (recién aquí se conoce el id_pago_transferencia) y se graba con
-- wms_donaciones_pago_transferencia_actualizar_concepto, en el mismo request (ver
-- Donaciones::valideParms2GenerarPagoTransferencia()) -- el placeholder nunca llega a mostrarse.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_insertar (
  IN p_folio_transferencia VARCHAR(40),
  IN p_fk_proyecto         INT UNSIGNED,
  IN p_fk_cuenta_deposito  INT UNSIGNED,
  IN p_donante_nombre      VARCHAR(100),
  IN p_donante_apellidos   VARCHAR(100),
  IN p_donante_correo      VARCHAR(150),
  IN p_donante_telefono    VARCHAR(20),
  IN p_monto               DECIMAL(12,2),
  IN p_moneda              CHAR(3),
  IN p_concepto            VARCHAR(60)
)
BEGIN
  -- token_confirmacion se deja NULL a propósito: el real se genera hasta "Finalizar" (ver
  -- wms_donaciones_pago_transferencia_generar_token) -- NULL es justo la señal de "orden
  -- pendiente, todavía no finalizada" que usa el frontend.
  INSERT INTO wms_donaciones_pagos_transferencia (
    folio_transferencia, fk_proyecto, fk_cuenta_deposito,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda, concepto
  ) VALUES (
    p_folio_transferencia, p_fk_proyecto, p_fk_cuenta_deposito,
    p_donante_nombre, p_donante_apellidos, p_donante_correo, p_donante_telefono,
    p_monto, p_moneda, p_concepto
  );

  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.fk_proyecto, t.fk_cuenta_deposito,
    t.donante_nombre, t.donante_apellidos, t.donante_correo, t.donante_telefono,
    t.monto, t.moneda, t.concepto, t.token_confirmacion, t.estatus_pago, t.fecha_registro, t.fecha_pago,
    c.banco, c.beneficiario, c.numero_cuenta, c.clabe_interbancaria, c.sucursal,
    p.proyecto_titulo
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = t.fk_proyecto
  WHERE t.id_pago_transferencia = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_actualizar_concepto
-- 2do paso del alta (ver wms_donaciones_pago_transferencia_insertar): graba el concepto REAL,
-- que ya incluye el id_pago_transferencia de esta misma fila para que sea único y fácilmente
-- rastreable en la conciliación manual (ej. "DON-CAPILLA-1042").
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_actualizar_concepto (
  IN p_id_pago_transferencia INT UNSIGNED,
  IN p_concepto              VARCHAR(60)
)
BEGIN
  UPDATE wms_donaciones_pagos_transferencia
  SET concepto = p_concepto
  WHERE id_pago_transferencia = p_id_pago_transferencia;

  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.fk_proyecto, t.fk_cuenta_deposito,
    t.donante_nombre, t.donante_apellidos, t.donante_correo, t.donante_telefono,
    t.monto, t.moneda, t.concepto, t.token_confirmacion, t.estatus_pago, t.fecha_registro, t.fecha_pago,
    c.banco, c.beneficiario, c.numero_cuenta, c.clabe_interbancaria, c.sucursal,
    p.proyecto_titulo
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = t.fk_proyecto
  WHERE t.id_pago_transferencia = p_id_pago_transferencia;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_consultar_por_folio
-- Trae la orden + los datos bancarios de su cuenta de depósito asignada + el título del
-- proyecto -- todo lo que necesita pintar mobile.dash.donaciones.pagoentransferencia.php en una
-- sola consulta.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_consultar_por_folio (
  IN p_folio_transferencia VARCHAR(40)
)
BEGIN
  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.fk_proyecto, t.fk_cuenta_deposito,
    t.donante_nombre, t.donante_apellidos, t.donante_correo, t.donante_telefono,
    t.monto, t.moneda, t.concepto, t.token_confirmacion, t.estatus_pago, t.fecha_registro, t.fecha_pago,
    c.banco, c.beneficiario, c.numero_cuenta, c.clabe_interbancaria, c.sucursal,
    p.proyecto_titulo
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = t.fk_proyecto
  WHERE t.folio_transferencia = p_folio_transferencia
    AND t.status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_consultar_por_token
-- Trae la orden por su token_confirmacion -- usado por
-- mobile.dash.donaciones.pagoentransferencia.cargarecibodepago.php (la pantalla de "Adjuntar
-- Comprobante" que llega la liga del correo). Nunca regresa nada si el token es NULL (ninguna
-- orden sin finalizar puede tener esta pantalla).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_consultar_por_token (
  IN p_token_confirmacion VARCHAR(64)
)
BEGIN
  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.fk_proyecto, t.fk_cuenta_deposito,
    t.donante_nombre, t.donante_apellidos, t.donante_correo, t.donante_telefono,
    t.monto, t.moneda, t.concepto, t.token_confirmacion, t.comprobante_url,
    t.numero_autorizacion, t.fecha_deposito_reportada, t.estatus_pago, t.fecha_registro, t.fecha_pago,
    c.banco, c.beneficiario, c.numero_cuenta, c.clabe_interbancaria, c.sucursal,
    p.proyecto_titulo
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = t.fk_proyecto
  WHERE t.token_confirmacion = p_token_confirmacion
    AND t.token_confirmacion IS NOT NULL
    AND t.status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_generar_token
-- Le asigna el token_confirmacion real a la orden cuando el donante le da "Finalizar" (ver
-- Donaciones::valideParms2FinalizarPagoTransferencia()) -- a partir de ahí esa liga
-- (/mob/pagoentransferencia/confirmapago/{token_confirmacion}) es la que se le manda por correo.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_generar_token (
  IN p_folio_transferencia VARCHAR(40),
  IN p_token_confirmacion  VARCHAR(64)
)
BEGIN
  UPDATE wms_donaciones_pagos_transferencia
  SET token_confirmacion = p_token_confirmacion
  WHERE folio_transferencia = p_folio_transferencia
    AND status = 1;

  -- OJO: este SELECT necesita el mismo JOIN a cuenta de depósito + proyecto que insertar/
  -- consultar_por_folio/consultar_por_token (faltaba aquí -- causaba que el correo "Sube tu
  -- comprobante" saliera con PROYECTO y BANCO en blanco, ver
  -- Donaciones::enviarCorreoComprobanteTransferencia()).
  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.fk_proyecto, t.fk_cuenta_deposito,
    t.donante_nombre, t.donante_apellidos, t.donante_correo, t.donante_telefono,
    t.monto, t.moneda, t.concepto, t.token_confirmacion, t.estatus_pago, t.fecha_registro, t.fecha_pago,
    c.banco, c.beneficiario, c.numero_cuenta, c.clabe_interbancaria, c.sucursal,
    p.proyecto_titulo
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = t.fk_proyecto
  WHERE t.folio_transferencia = p_folio_transferencia;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_subir_comprobante
-- Graba la URL del comprobante ya subido (el archivo físico lo sube PHP con Utils->uploadFile()
-- antes de llamar este procedure) y los 2 campos opcionales de "Datos de la Transacción" --
-- NO cambia estatus_pago: sigue 'pendiente' hasta que un administrador lo revise y confirme
-- manualmente (ver wms_donaciones_pago_transferencia_marcar_pagado).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_subir_comprobante (
  IN p_id_pago_transferencia    INT UNSIGNED,
  IN p_comprobante_url          VARCHAR(255),
  IN p_numero_autorizacion      VARCHAR(50),
  IN p_fecha_deposito_reportada DATETIME
)
BEGIN
  UPDATE wms_donaciones_pagos_transferencia
  SET
    comprobante_url = p_comprobante_url,
    fecha_comprobante = NOW(),
    numero_autorizacion = p_numero_autorizacion,
    fecha_deposito_reportada = p_fecha_deposito_reportada
  WHERE id_pago_transferencia = p_id_pago_transferencia
    AND status = 1;

  SELECT
    id_pago_transferencia, folio_transferencia, fk_proyecto, fk_cuenta_deposito,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda, concepto, token_confirmacion, comprobante_url,
    numero_autorizacion, fecha_deposito_reportada, estatus_pago, fecha_registro
  FROM wms_donaciones_pagos_transferencia
  WHERE id_pago_transferencia = p_id_pago_transferencia;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pagos_transferencia_listar_por_proyecto
-- Lista las órdenes 'pendiente' de un proyecto (con o sin comprobante ya subido) -- la "cola" de
-- depósitos que un administrador tiene que revisar y conciliar manualmente en
-- dash.donaciones.proyectodetalles.php. Las que ya se marcaron 'pagado' dejan de aparecer aquí
-- (ya están contabilizadas en wms_donaciones_pagos_listar_por_proyecto, el listado de donaciones
-- confirmadas).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pagos_transferencia_listar_por_proyecto (
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  SELECT
    t.id_pago_transferencia, t.folio_transferencia, t.donante_nombre, t.donante_apellidos,
    t.donante_correo, t.donante_telefono, t.monto, t.moneda, t.concepto,
    t.comprobante_url, t.numero_autorizacion, t.fecha_deposito_reportada,
    t.estatus_pago, t.fecha_registro, t.fecha_comprobante,
    c.banco, c.numero_cuenta
  FROM wms_donaciones_pagos_transferencia t
  INNER JOIN wms_donaciones_cuentas_deposito c ON c.id_cuenta_deposito = t.fk_cuenta_deposito
  WHERE t.fk_proyecto = p_fk_proyecto
    AND t.estatus_pago = 'pendiente'
    AND t.status = 1
  ORDER BY t.fecha_registro DESC;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pago_transferencia_marcar_pagado
-- El administrador, tras revisar el comprobante subido y verificar que coincide con lo
-- reportado, confirma el depósito -- a partir de aquí SÍ se contabiliza en proyecto_recaudado y
-- aparece en el listado de donaciones confirmadas (ver wms_donaciones_pagos_listar_por_proyecto
-- en wms_donaciones.procedures.sql). Idempotente (el "!= 'pagado'" evita pisar fecha_pago si ya
-- se había confirmado).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pago_transferencia_marcar_pagado (
  IN p_id_pago_transferencia INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_pagos_transferencia
  SET estatus_pago = 'pagado', fecha_pago = NOW()
  WHERE id_pago_transferencia = p_id_pago_transferencia
    AND status = 1
    AND estatus_pago != 'pagado';

  SELECT
    id_pago_transferencia, folio_transferencia, fk_proyecto, fk_cuenta_deposito,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda, concepto, estatus_pago, fecha_registro, fecha_pago
  FROM wms_donaciones_pagos_transferencia
  WHERE id_pago_transferencia = p_id_pago_transferencia;
END$$

DELIMITER ;
