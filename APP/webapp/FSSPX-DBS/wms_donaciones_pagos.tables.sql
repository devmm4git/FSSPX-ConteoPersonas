-- ============================================================
-- MODULO: Donaciones - Pagos (Ficha de pago / Pagar en tienda con QR)
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos ya exista
-- (ver wms_donaciones.tables.sql).
--
-- Flujo: el donante llena el formulario público (monto, nombre, apellidos, correo,
-- teléfono) y elige "Pagar con QR". Se genera una ficha de pago con un folio único
-- (folio_qr) que identifica la orden; el donante paga después en una tienda física
-- usando ese folio/QR, y el estatus pasa de 'pendiente' a 'pagado' (esa confirmación
-- es un paso futuro, no incluido todavía).
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_fichas_pago;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_fichas_pago
-- Una ficha = una orden de pago pendiente de liquidarse en tienda.
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_fichas_pago (
  id_ficha_pago       INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  -- Folio público (no correlativo/adivinable) que identifica la ficha en la URL del QR:
  -- https://fsp.mm4.me/mob/pagoenlibreria/{folio_qr}. Se genera en PHP como
  -- FP-{fecha}-{hora}-{bloque aleatorio}, ej. FP-20260305-143022-9F3A2B.
  folio_qr            VARCHAR(40)   NOT NULL,

  fk_proyecto         INT UNSIGNED  NOT NULL,

  donante_nombre      VARCHAR(100)  NOT NULL,
  donante_apellidos   VARCHAR(100)  NOT NULL,
  donante_correo      VARCHAR(150)  NOT NULL,
  donante_telefono    VARCHAR(20)   NOT NULL,

  monto               DECIMAL(12,2) NOT NULL,

  -- Moneda al momento de generar la ficha (copiada de wms_donaciones_proyectos.moneda, ver
  -- Donaciones::valideParms2GenerarFichaPago()): mismo criterio que wms_donaciones_pagos_stripe.
  -- moneda, para que el registro quede historico aunque el proyecto cambie de moneda despues.
  moneda              CHAR(3)       NOT NULL DEFAULT 'usd',

  -- 'pendiente' = ficha generada, todavía no se paga en tienda.
  -- 'pagado'    = tienda confirmó el pago (actualización futura, no incluida aún).
  estatus_pago        ENUM('pendiente','pagado') NOT NULL DEFAULT 'pendiente',

  status              TINYINT(1)    NOT NULL DEFAULT 1,
  fecha_registro      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_pago          DATETIME      NULL, -- se llena cuando estatus_pago pasa a 'pagado'

  PRIMARY KEY (id_ficha_pago),
  UNIQUE KEY uq_ficha_pago_folio (folio_qr),
  KEY idx_ficha_pago_proyecto (fk_proyecto),
  KEY idx_ficha_pago_estatus (estatus_pago),
  CONSTRAINT fk_ficha_pago_proyecto
    FOREIGN KEY (fk_proyecto) REFERENCES wms_donaciones_proyectos (id_proyecto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
