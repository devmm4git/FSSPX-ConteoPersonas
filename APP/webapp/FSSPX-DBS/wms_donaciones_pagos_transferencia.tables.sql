-- ============================================================
-- MODULO: Donaciones - Pagos (Depósito por Transferencia / SPEI)
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos (wms_donaciones.tables.sql) y
-- wms_donaciones_cuentas_deposito (wms_donaciones_cuentas_deposito.tables.sql) ya existan.
--
-- Flujo: el donante llena el formulario público (monto, nombre, apellidos, correo, teléfono) y
-- elige "Depositar". Se genera un registro con folio único (folio_transferencia) y un concepto
-- de depósito único (concepto, ej. "DON-CAPILLA-782") -- el donante ve esos datos junto con los
-- datos bancarios de la cuenta de depósito asignada al proyecto en
-- mobile.dash.donaciones.pagoentransferencia.php. Al darle "Finalizar" se genera
-- token_confirmacion y se le manda un correo con la liga única
-- (/mob/pagoentransferencia/confirmapago/{token_confirmacion}) para subir su comprobante --
-- esa pantalla de carga es un desarrollo posterior, por eso comprobante_url/fecha_comprobante
-- ya existen aquí pero todavía nada las llena.
--
-- A diferencia del pago con QR (que un sacerdote/librería confirma in situ) o Stripe (que
-- confirma el webhook), aquí NO hay ninguna confirmación automática: el estatus pasa de
-- 'pendiente' a 'pagado' cuando el administrador revisa el comprobante subido (paso futuro).
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_pagos_transferencia;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_pagos_transferencia
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_pagos_transferencia (
  id_pago_transferencia INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  -- Folio público que identifica la orden en la URL: /mob/pagoentransferencia/{folio_transferencia}.
  -- Generado en PHP como DT-{fecha}-{hora}-{bloque aleatorio}, mismo criterio que folio_qr/folio_stripe.
  folio_transferencia    VARCHAR(40)   NOT NULL,

  fk_proyecto            INT UNSIGNED  NOT NULL,
  fk_cuenta_deposito     INT UNSIGNED  NOT NULL,

  donante_nombre         VARCHAR(100)  NOT NULL,
  donante_apellidos      VARCHAR(100)  NOT NULL,
  donante_correo         VARCHAR(150)  NOT NULL,
  donante_telefono       VARCHAR(20)   NOT NULL,

  monto                  DECIMAL(12,2) NOT NULL,
  moneda                 CHAR(3)       NOT NULL DEFAULT 'mxn',

  -- Concepto obligatorio único que el donante debe capturar en su banca al hacer el depósito/SPEI
  -- (ej. "DON-CAPILLA-782"), para poder conciliar manualmente qué depósito corresponde a qué
  -- orden -- ver Donaciones::generarConceptoTransferencia().
  concepto               VARCHAR(60)   NOT NULL,

  -- Token aleatorio (no correlativo/adivinable) para la liga de "subir mi comprobante" que se le
  -- manda por correo al darle "Finalizar": /mob/pagoentransferencia/confirmapago/{token_confirmacion}.
  -- NULL = todavía no le ha dado "Finalizar" -- es justo la señal que usa
  -- mobile.dash.donaciones.pagoentransferencia.js para decidir si mostrar el formulario o el
  -- estado "ya finalizado" (MySQL permite varios NULL bajo una UNIQUE KEY sin chocar entre sí).
  token_confirmacion     VARCHAR(64)   NULL,

  -- Se llenan cuando el donante sube su comprobante en mobile.dash.donaciones.pagoentransferencia.
  -- cargarecibodepago.php (vía la liga única del correo).
  comprobante_url        VARCHAR(255)  NULL,
  fecha_comprobante      DATETIME      NULL,

  -- "Datos de la Transacción (Opcional)" del formulario de carga de comprobante -- agiliza la
  -- conciliación manual del administrador, pero nunca son obligatorios ni se usan para confirmar
  -- el pago solos (el administrador siempre valida contra el comprobante real).
  numero_autorizacion       VARCHAR(50) NULL,
  fecha_deposito_reportada  DATETIME    NULL,

  -- 'pendiente' = orden generada, el donante todavía no sube/el administrador no confirma nada.
  -- 'pagado'    = el administrador confirmó el depósito contra el comprobante (paso futuro).
  estatus_pago           ENUM('pendiente','pagado') NOT NULL DEFAULT 'pendiente',

  status                 TINYINT(1)    NOT NULL DEFAULT 1,
  fecha_registro         DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_pago             DATETIME      NULL, -- se llena cuando estatus_pago pasa a 'pagado'

  PRIMARY KEY (id_pago_transferencia),
  UNIQUE KEY uq_pago_transferencia_folio (folio_transferencia),
  UNIQUE KEY uq_pago_transferencia_token (token_confirmacion),
  KEY idx_pago_transferencia_proyecto (fk_proyecto),
  KEY idx_pago_transferencia_cuenta (fk_cuenta_deposito),
  KEY idx_pago_transferencia_estatus (estatus_pago),
  CONSTRAINT fk_pago_transferencia_proyecto
    FOREIGN KEY (fk_proyecto) REFERENCES wms_donaciones_proyectos (id_proyecto),
  CONSTRAINT fk_pago_transferencia_cuenta
    FOREIGN KEY (fk_cuenta_deposito) REFERENCES wms_donaciones_cuentas_deposito (id_cuenta_deposito)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
