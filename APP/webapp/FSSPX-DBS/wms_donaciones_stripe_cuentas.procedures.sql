-- ============================================================
-- MODULO: Donaciones - Integraciones Stripe (multi-cuenta) - Procedures
-- Requiere que las tablas de wms_donaciones_stripe_cuentas.tables.sql ya existan.
--
-- Los campos *_secret_key_cifrado / *_webhook_secret_cifrado viajan siempre YA cifrados desde
-- PHP (StripeCuentas::encriptar()) y se regresan siempre YA cifrados (nunca se desencriptan
-- dentro de SQL) -- el descifrado solo pasa en PHP, justo antes de usarlos para cobrar
-- (ver Donaciones::valideParms2GenerarPagoStripe()) o para el boton "Ver" del admin.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuenta_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuenta_actualizar;
DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuentas_listar;
DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuentas_listar_por_distrito;
DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuenta_detalle;
DROP PROCEDURE IF EXISTS wms_donaciones_stripe_cuenta_proyectos_asignados;
DROP PROCEDURE IF EXISTS wms_donaciones_proyectos_desasignar_cuenta_stripe;
DROP PROCEDURE IF EXISTS wms_donaciones_proyecto_asignar_cuenta_stripe;
DROP PROCEDURE IF EXISTS wms_donaciones_proyectos_listar_para_asignar;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuenta_insertar
-- Si p_es_default=1, primero le quita el default a cualquier otra cuenta activa -- solo puede
-- haber una cuenta default a la vez (no se modela con una UNIQUE KEY: "cuando mucho una fila con
-- este valor" no se puede expresar así en SQL puro).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuenta_insertar (
  IN p_fk_distrito                 INT UNSIGNED,
  IN p_nombre_cuenta               VARCHAR(150),
  IN p_descripcion                 TEXT,
  IN p_modo_activo                 ENUM('live','test'),
  IN p_es_default                  TINYINT(1),
  IN p_live_publishable_key        VARCHAR(255),
  IN p_live_secret_key_cifrado     TEXT,
  IN p_live_webhook_secret_cifrado TEXT,
  IN p_test_publishable_key        VARCHAR(255),
  IN p_test_secret_key_cifrado     TEXT,
  IN p_test_webhook_secret_cifrado TEXT
)
BEGIN
  IF p_es_default = 1 THEN
    UPDATE wms_donaciones_stripe_cuentas SET es_default = 0 WHERE status = 1;
  END IF;

  INSERT INTO wms_donaciones_stripe_cuentas (
    fk_distrito, nombre_cuenta, descripcion, modo_activo, es_default,
    live_publishable_key, live_secret_key_cifrado, live_webhook_secret_cifrado,
    test_publishable_key, test_secret_key_cifrado, test_webhook_secret_cifrado
  ) VALUES (
    p_fk_distrito, p_nombre_cuenta, p_descripcion, p_modo_activo, p_es_default,
    p_live_publishable_key, p_live_secret_key_cifrado, p_live_webhook_secret_cifrado,
    p_test_publishable_key, p_test_secret_key_cifrado, p_test_webhook_secret_cifrado
  );

  SELECT
    c.id_cuenta_stripe, c.fk_distrito, d.distrito_pais, c.nombre_cuenta, c.descripcion, c.modo_activo, c.es_default,
    c.live_publishable_key, c.live_secret_key_cifrado, c.live_webhook_secret_cifrado,
    c.test_publishable_key, c.test_secret_key_cifrado, c.test_webhook_secret_cifrado,
    c.fecha_registro
  FROM wms_donaciones_stripe_cuentas c
  INNER JOIN wms_distritos d ON d.id_distrito = c.fk_distrito
  WHERE c.id_cuenta_stripe = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuenta_actualizar
-- Los campos *_cifrado son opcionales al actualizar (si vienen NULL, se conserva lo que ya
-- había -- así el admin puede editar solo el nombre/descripcion sin verse obligado a
-- recapturar las 4 llaves cada vez que edita).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuenta_actualizar (
  IN p_id_cuenta_stripe            INT UNSIGNED,
  IN p_fk_distrito                 INT UNSIGNED,
  IN p_nombre_cuenta               VARCHAR(150),
  IN p_descripcion                 TEXT,
  IN p_modo_activo                 ENUM('live','test'),
  IN p_es_default                  TINYINT(1),
  IN p_live_publishable_key        VARCHAR(255),
  IN p_live_secret_key_cifrado     TEXT,
  IN p_live_webhook_secret_cifrado TEXT,
  IN p_test_publishable_key        VARCHAR(255),
  IN p_test_secret_key_cifrado     TEXT,
  IN p_test_webhook_secret_cifrado TEXT
)
BEGIN
  IF p_es_default = 1 THEN
    UPDATE wms_donaciones_stripe_cuentas SET es_default = 0 WHERE status = 1 AND id_cuenta_stripe != p_id_cuenta_stripe;
  END IF;

  UPDATE wms_donaciones_stripe_cuentas
  SET
    fk_distrito = p_fk_distrito,
    nombre_cuenta = p_nombre_cuenta,
    descripcion = p_descripcion,
    modo_activo = p_modo_activo,
    es_default = p_es_default,
    live_publishable_key = p_live_publishable_key,
    live_secret_key_cifrado = COALESCE(p_live_secret_key_cifrado, live_secret_key_cifrado),
    live_webhook_secret_cifrado = COALESCE(p_live_webhook_secret_cifrado, live_webhook_secret_cifrado),
    test_publishable_key = p_test_publishable_key,
    test_secret_key_cifrado = COALESCE(p_test_secret_key_cifrado, test_secret_key_cifrado),
    test_webhook_secret_cifrado = COALESCE(p_test_webhook_secret_cifrado, test_webhook_secret_cifrado)
  WHERE id_cuenta_stripe = p_id_cuenta_stripe
    AND status = 1;

  SELECT
    c.id_cuenta_stripe, c.fk_distrito, d.distrito_pais, c.nombre_cuenta, c.descripcion, c.modo_activo, c.es_default,
    c.live_publishable_key, c.live_secret_key_cifrado, c.live_webhook_secret_cifrado,
    c.test_publishable_key, c.test_secret_key_cifrado, c.test_webhook_secret_cifrado,
    c.fecha_registro
  FROM wms_donaciones_stripe_cuentas c
  INNER JOIN wms_distritos d ON d.id_distrito = c.fk_distrito
  WHERE c.id_cuenta_stripe = p_id_cuenta_stripe;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuentas_listar
-- Lista todas las cuentas activas. Los *_cifrado viajan tal cual (cifrados) -- PHP los enmascara
-- (ej. "••••881c") para pintar la tarjeta sin desencriptar nada de más.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuentas_listar ()
BEGIN
  SELECT
    c.id_cuenta_stripe, c.fk_distrito, d.distrito_pais, c.nombre_cuenta, c.descripcion, c.modo_activo, c.es_default,
    c.live_publishable_key, c.live_secret_key_cifrado, c.live_webhook_secret_cifrado,
    c.test_publishable_key, c.test_secret_key_cifrado, c.test_webhook_secret_cifrado,
    c.fecha_registro
  FROM wms_donaciones_stripe_cuentas c
  INNER JOIN wms_distritos d ON d.id_distrito = c.fk_distrito
  WHERE c.status = 1
  ORDER BY c.es_default DESC, c.fecha_registro ASC;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuentas_listar_por_distrito
-- Listado ligero (solo id + nombre + es_default, sin credenciales) de las cuentas activas de UN
-- distrito -- para el <select> "Cuentas Stripe" del formulario "Nuevo Proyecto"
-- (dash.donaciones.php). A diferencia de wms_donaciones_stripe_cuentas_listar, este SI filtra por
-- distrito: la administracion de "Integraciones Stripe" es una vista global (cualquier admin ve
-- todas las cuentas), pero al capturar un proyecto solo debe ofrecerse la(s) cuenta(s) del propio
-- distrito del usuario (ver Donaciones::valideParms2ConsultarCuentasStripeDelDistrito()).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuentas_listar_por_distrito (
  IN p_fk_distrito INT UNSIGNED
)
BEGIN
  SELECT id_cuenta_stripe, nombre_cuenta, es_default
  FROM wms_donaciones_stripe_cuentas
  WHERE fk_distrito = p_fk_distrito
    AND status = 1
  ORDER BY es_default DESC, nombre_cuenta ASC;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuenta_detalle
-- Una sola cuenta, para precargar el popup "Editar".
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuenta_detalle (
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  SELECT
    c.id_cuenta_stripe, c.fk_distrito, d.distrito_pais, c.nombre_cuenta, c.descripcion, c.modo_activo, c.es_default,
    c.live_publishable_key, c.live_secret_key_cifrado, c.live_webhook_secret_cifrado,
    c.test_publishable_key, c.test_secret_key_cifrado, c.test_webhook_secret_cifrado,
    c.fecha_registro
  FROM wms_donaciones_stripe_cuentas c
  INNER JOIN wms_distritos d ON d.id_distrito = c.fk_distrito
  WHERE c.id_cuenta_stripe = p_id_cuenta_stripe
    AND c.status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_stripe_cuenta_proyectos_asignados
-- Proyectos actualmente asignados a una cuenta -- para pintar los "chips" de "Asignado a:" en
-- cada tarjeta y para preseleccionar el multi-select del popup "Editar".
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_stripe_cuenta_proyectos_asignados (
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  SELECT id_proyecto, proyecto_titulo
  FROM wms_donaciones_proyectos
  WHERE fk_stripe_cuenta = p_id_cuenta_stripe
    AND status = 1
  ORDER BY proyecto_titulo;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyectos_desasignar_cuenta_stripe
-- Libera (fk_stripe_cuenta = NULL) todos los proyectos de una cuenta -- el primer paso de
-- reconciliar la asignacion al guardar el popup (igual que
-- wms_donaciones_montos_sugeridos_eliminar_por_proyecto limpia antes de reinsertar).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyectos_desasignar_cuenta_stripe (
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET fk_stripe_cuenta = NULL
  WHERE fk_stripe_cuenta = p_id_cuenta_stripe;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyecto_asignar_cuenta_stripe
-- Asigna un proyecto a una cuenta. El controller la llama una vez por cada proyecto marcado en
-- el multi-select del popup, despues de desasignar los vigentes.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyecto_asignar_cuenta_stripe (
  IN p_id_proyecto      INT UNSIGNED,
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET fk_stripe_cuenta = p_id_cuenta_stripe
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyectos_listar_para_asignar
-- Listado ligero (id + titulo + cuenta actualmente asignada) de todos los proyectos activos,
-- para armar el multi-select "Asignar a Proyectos" del popup -- sin filtrar por distrito: la
-- administracion de pasarelas de pago es una vista global, no por parroquia.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyectos_listar_para_asignar ()
BEGIN
  SELECT id_proyecto, proyecto_titulo, fk_stripe_cuenta
  FROM wms_donaciones_proyectos
  WHERE status = 1
  ORDER BY proyecto_titulo;
END$$

DELIMITER ;
