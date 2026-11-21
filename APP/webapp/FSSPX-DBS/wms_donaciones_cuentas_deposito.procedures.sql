-- ============================================================
-- MODULO: Donaciones - Cuentas Bancarias para Depósito y SPEI - Procedures
-- Requiere que la tabla de wms_donaciones_cuentas_deposito.tables.sql ya exista.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_cuenta_deposito_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_cuenta_deposito_actualizar;
DROP PROCEDURE IF EXISTS wms_donaciones_cuenta_deposito_actualizar_status;
DROP PROCEDURE IF EXISTS wms_donaciones_cuentas_deposito_listar;
DROP PROCEDURE IF EXISTS wms_donaciones_cuenta_deposito_detalle;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_cuenta_deposito_insertar
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_cuenta_deposito_insertar (
  IN p_nombre_interno      VARCHAR(100),
  IN p_banco               VARCHAR(100),
  IN p_beneficiario        VARCHAR(150),
  IN p_numero_cuenta       VARCHAR(30),
  IN p_clabe_interbancaria VARCHAR(18),
  IN p_moneda              CHAR(3),
  IN p_sucursal            VARCHAR(100)
)
BEGIN
  INSERT INTO wms_donaciones_cuentas_deposito (
    nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria, moneda, sucursal
  ) VALUES (
    p_nombre_interno, p_banco, p_beneficiario, p_numero_cuenta, p_clabe_interbancaria, p_moneda, p_sucursal
  );

  SELECT
    id_cuenta_deposito, nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria,
    moneda, sucursal, status, fecha_registro
  FROM wms_donaciones_cuentas_deposito
  WHERE id_cuenta_deposito = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_cuenta_deposito_actualizar
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_cuenta_deposito_actualizar (
  IN p_id_cuenta_deposito  INT UNSIGNED,
  IN p_nombre_interno      VARCHAR(100),
  IN p_banco               VARCHAR(100),
  IN p_beneficiario        VARCHAR(150),
  IN p_numero_cuenta       VARCHAR(30),
  IN p_clabe_interbancaria VARCHAR(18),
  IN p_moneda              CHAR(3),
  IN p_sucursal            VARCHAR(100)
)
BEGIN
  UPDATE wms_donaciones_cuentas_deposito
  SET
    nombre_interno       = p_nombre_interno,
    banco                = p_banco,
    beneficiario         = p_beneficiario,
    numero_cuenta        = p_numero_cuenta,
    clabe_interbancaria  = p_clabe_interbancaria,
    moneda               = p_moneda,
    sucursal             = p_sucursal
  WHERE id_cuenta_deposito = p_id_cuenta_deposito
    AND status = 1;

  SELECT
    id_cuenta_deposito, nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria,
    moneda, sucursal, status, fecha_registro
  FROM wms_donaciones_cuentas_deposito
  WHERE id_cuenta_deposito = p_id_cuenta_deposito;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_cuenta_deposito_actualizar_status
-- Activa/desactiva una cuenta (soft delete) -- mismo botón "Desactivar" que el resto de los
-- listados administrativos de este módulo.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_cuenta_deposito_actualizar_status (
  IN p_id_cuenta_deposito INT UNSIGNED,
  IN p_status             TINYINT(1)
)
BEGIN
  UPDATE wms_donaciones_cuentas_deposito
  SET status = p_status
  WHERE id_cuenta_deposito = p_id_cuenta_deposito;

  SELECT
    id_cuenta_deposito, nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria,
    moneda, sucursal, status, fecha_registro
  FROM wms_donaciones_cuentas_deposito
  WHERE id_cuenta_deposito = p_id_cuenta_deposito;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_cuentas_deposito_listar
-- Lista las cuentas activas -- usado tanto por la pantalla "Cuentas Bancarias para Depósito y
-- SPEI" como por el <select> "Cuenta de Depósito" del formulario "Editar Proyecto" (sin filtrar
-- por distrito: son cuentas oficiales globales).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_cuentas_deposito_listar ()
BEGIN
  SELECT
    id_cuenta_deposito, nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria,
    moneda, sucursal, status, fecha_registro
  FROM wms_donaciones_cuentas_deposito
  WHERE status = 1
  ORDER BY nombre_interno ASC;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_cuenta_deposito_detalle
-- Una sola cuenta -- usado para precargar el popup "Editar" y para pintar los datos bancarios
-- en mobile.dash.donaciones.pagoentransferencia.php (vía el proyecto -> fk_cuenta_deposito).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_cuenta_deposito_detalle (
  IN p_id_cuenta_deposito INT UNSIGNED
)
BEGIN
  SELECT
    id_cuenta_deposito, nombre_interno, banco, beneficiario, numero_cuenta, clabe_interbancaria,
    moneda, sucursal, status, fecha_registro
  FROM wms_donaciones_cuentas_deposito
  WHERE id_cuenta_deposito = p_id_cuenta_deposito
    AND status = 1;
END$$

DELIMITER ;
