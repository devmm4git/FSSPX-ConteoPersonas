-- ============================================================
-- MODULO: Donaciones - Cuentas Bancarias para Depósito y SPEI
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos (ver wms_donaciones.tables.sql) ya
-- exista, por el ALTER TABLE al final de este archivo.
--
-- A diferencia de wms_donaciones_stripe_cuentas, estas cuentas NO están ligadas a un distrito:
-- son cuentas bancarias OFICIALES de la Fraternidad (una lista global, administrada desde
-- "Cuentas Bancarias para Depósito y SPEI"), y cualquier proyecto puede asignarse a cualquiera
-- de ellas -- por eso no hay fk_distrito aquí, a propósito.
--
-- Cada proyecto (wms_donaciones_proyectos.fk_cuenta_deposito) queda asignado a UNA cuenta de
-- depósito; si no tiene ninguna asignada, el método de pago "Depositar" simplemente no se puede
-- usar para ese proyecto (a diferencia de Stripe, aquí NO hay cuenta "default" de respaldo).
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_cuentas_deposito;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_cuentas_deposito
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_cuentas_deposito (
  id_cuenta_deposito   INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  -- Nombre que SOLO ve el admin en el <select> "Cuenta de Depósito" del formulario "Editar
  -- Proyecto" y en esta pantalla de catálogo -- NO se muestra al fiel (eso sigue siendo `banco`,
  -- vía mobile.dash.donaciones.pagoentransferencia.php). Permite distinguir cuentas que comparten
  -- el mismo banco (ej. "BBVA - Capilla Roma Norte" vs "BBVA - Capilla Polanco").
  nombre_interno       VARCHAR(100)  NOT NULL,

  banco                VARCHAR(100)  NOT NULL,
  beneficiario         VARCHAR(150)  NOT NULL,
  numero_cuenta        VARCHAR(30)   NOT NULL,
  clabe_interbancaria  VARCHAR(18)   NOT NULL,

  -- Moneda en la que recibe depósitos esta cuenta ('mxn' | 'usd'), minúsculas -- mismo formato
  -- que wms_donaciones_proyectos.moneda.
  moneda               CHAR(3)       NOT NULL DEFAULT 'mxn',

  -- Opcional (el resto de los campos son obligatorios, ver
  -- DonacionesCuentasDeposito::valideParms2InsertarCuenta()).
  sucursal             VARCHAR(100)  NULL,

  status               TINYINT(1)    NOT NULL DEFAULT 1,
  fecha_registro       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion  DATETIME      NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id_cuenta_deposito)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- fk_cuenta_deposito en wms_donaciones_proyectos -- columna nueva (no existía en
-- wms_donaciones.tables.sql, se agrega aquí ya con esta tabla creada, mismo patrón aditivo que
-- fk_stripe_cuenta en wms_donaciones_stripe_cuentas.tables.sql).
-- --------------------------------------------------------
ALTER TABLE wms_donaciones_proyectos
  ADD COLUMN fk_cuenta_deposito INT UNSIGNED NULL,
  ADD KEY idx_proyectos_cuenta_deposito (fk_cuenta_deposito),
  ADD CONSTRAINT fk_proyectos_cuenta_deposito
    FOREIGN KEY (fk_cuenta_deposito) REFERENCES wms_donaciones_cuentas_deposito (id_cuenta_deposito);
