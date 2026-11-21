-- ============================================================
-- MODULO: Donaciones - Integraciones Stripe (multi-cuenta)
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos (ver wms_donaciones.tables.sql) y, por
-- ende, wms_distritos (ver wms_horarios_misa.tables.sql) ya existan.
--
-- Permite registrar VARIAS cuentas de Stripe (una por distrito/obra/rifa, ej. "Distrito México",
-- "Seminario y Vocaciones") en vez de una sola cuenta global fija en dash/php/class/stripe/.env.
-- Cada proyecto (wms_donaciones_proyectos.fk_stripe_cuenta) queda asignado a UNA cuenta; si no
-- tiene ninguna asignada, se usa la cuenta marcada como es_default=1 (ver
-- StripeCuentas::obtenerCuentaParaProyecto()).
--
-- Cada cuenta guarda credenciales de AMBOS entornos (Live y Sandbox/Test) para poder probar sin
-- tener que borrar las credenciales reales -- modo_activo decide cual de los dos juegos se usa
-- de verdad al cobrar.
--
-- Cifrado: las secret keys y los webhook signing secrets NUNCA se guardan en texto plano -- se
-- cifran con AES-256-CBC (ver StripeCuentas::encriptar()/desencriptar()) usando una llave de
-- aplicacion que vive fuera de la base de datos (DONACIONES_ENCRYPTION_KEY, ver
-- dash/php/class/stripe/.env -- cifrar algo con una llave guardada junto a lo cifrado no protege
-- nada). Los publishable keys NO se cifran: son publicos por diseño (viajan al frontend).
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_stripe_cuentas;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_stripe_cuentas
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_stripe_cuentas (
  id_cuenta_stripe        INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  -- Distrito dueño de la cuenta (jerarquia wms_distritos, misma tabla que
  -- wms_donaciones_proyectos.fk_distrito) -- mismo criterio: por ahora el frontend no tiene un
  -- selector jerárquico completo, solo un <select> plano de wms_distritos_listar.
  fk_distrito             INT UNSIGNED  NOT NULL,

  nombre_cuenta           VARCHAR(150)  NOT NULL,
  descripcion             TEXT          NULL,

  -- Cual de los 2 entornos se usa de verdad al generar un PaymentIntent para un proyecto
  -- asignado a esta cuenta (ver Donaciones::valideParms2GenerarPagoStripe()).
  modo_activo             ENUM('live','test') NOT NULL DEFAULT 'test',

  -- Solo puede haber una cuenta con es_default=1 a la vez (se aplica en el procedure de
  -- insertar/actualizar, no con una UNIQUE KEY, porque "0 o 1 fila en 1" no se puede expresar
  -- como UNIQUE simple). Los proyectos sin fk_stripe_cuenta asignado usan esta.
  es_default              TINYINT(1)    NOT NULL DEFAULT 0,

  -- Entorno LIVE (produccion). El publishable no se cifra (es publico); secret y webhook si.
  live_publishable_key        VARCHAR(255) NULL,
  live_secret_key_cifrado     TEXT         NULL,
  live_webhook_secret_cifrado TEXT         NULL,

  -- Entorno TEST (sandbox)
  test_publishable_key        VARCHAR(255) NULL,
  test_secret_key_cifrado     TEXT         NULL,
  test_webhook_secret_cifrado TEXT         NULL,

  status                  TINYINT(1)    NOT NULL DEFAULT 1,
  fecha_registro          DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion     DATETIME      NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id_cuenta_stripe),
  KEY idx_stripe_cuentas_distrito (fk_distrito),
  CONSTRAINT fk_stripe_cuentas_distrito
    FOREIGN KEY (fk_distrito) REFERENCES wms_distritos (id_distrito)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- fk_stripe_cuenta en wms_donaciones_proyectos (columna ya definida en wms_donaciones.tables.sql,
-- sin FK inline porque esta tabla -- a la que apunta -- todavia no existia en ese momento del
-- orden de carga). Se agrega aqui, ya con ambas tablas creadas.
-- --------------------------------------------------------
ALTER TABLE wms_donaciones_proyectos
  ADD KEY idx_proyectos_stripe_cuenta (fk_stripe_cuenta),
  ADD CONSTRAINT fk_proyectos_stripe_cuenta
    FOREIGN KEY (fk_stripe_cuenta) REFERENCES wms_donaciones_stripe_cuentas (id_cuenta_stripe);
