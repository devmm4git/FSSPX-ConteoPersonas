-- ============================================================
-- MODULO: Donaciones - Procedures
-- Requiere que las tablas de wms_donaciones.tables.sql ya existan, y que
-- wms_donaciones_fichas_pago (ver wms_donaciones_pagos.tables.sql),
-- wms_donaciones_pagos_stripe (ver wms_donaciones_pagos_stripe.tables.sql) y
-- wms_donaciones_pagos_transferencia (ver wms_donaciones_pagos_transferencia.tables.sql)
-- tambien existan: los procedures que devuelven un proyecto calculan proyecto_recaudado EN VIVO
-- sumando los pagos 'pagado' de los 3 metodos de pago (QR + Stripe + Transferencia), en vez de
-- leer una columna que habria que ir manteniendo sincronizada a mano (eso fue justo la causa de
-- que el recaudado se quedara en $0 aunque ya hubiera pagos confirmados). Una sola fuente de
-- verdad: la suma real de pagos de cada metodo.
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS wms_donaciones_proyecto_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_monto_sugerido_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_proyectos_consultar;
DROP PROCEDURE IF EXISTS wms_donaciones_montos_sugeridos_consultar;
DROP PROCEDURE IF EXISTS wms_donaciones_proyecto_detalle;
DROP PROCEDURE IF EXISTS wms_donaciones_proyecto_actualizar_estado;
DROP PROCEDURE IF EXISTS wms_donaciones_proyecto_actualizar;
DROP PROCEDURE IF EXISTS wms_donaciones_montos_sugeridos_eliminar_por_proyecto;
DROP PROCEDURE IF EXISTS wms_donaciones_pagos_listar_por_proyecto;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyecto_insertar
-- Da de alta un proyecto/donación. Los montos sugeridos NO se mandan aquí:
-- se insertan aparte, uno por uno, con wms_donaciones_monto_sugerido_insertar
-- (mismo patrón que wms_horarios_misa_insertar, que el controller llama una
-- vez por cada día seleccionado).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyecto_insertar (
  IN p_fk_distrito        INT UNSIGNED,
  IN p_titulo             VARCHAR(150),
  IN p_descripcion        TEXT,
  IN p_imagen             VARCHAR(255),
  IN p_tipo_proyecto      ENUM('proyecto','donacion','deposito','rifa'),
  IN p_estado             ENUM('borrador','activo','pausado','finalizado'),
  IN p_moneda             CHAR(3),
  IN p_mostrar_meta            TINYINT(1),
  IN p_mostrar_totalrecaudado  TINYINT(1),
  IN p_meta               DECIMAL(12,2),
  IN p_fecha_limite       DATE,
  IN p_rifa_rango_inicio  INT UNSIGNED,
  IN p_rifa_rango_fin     INT UNSIGNED,
  IN p_rifa_total_boletos INT UNSIGNED,
  IN p_fk_stripe_cuenta   INT UNSIGNED,
  IN p_fk_cuenta_deposito INT UNSIGNED,
  IN p_responsable_nombre   VARCHAR(150),
  IN p_responsable_telefono VARCHAR(20),
  IN p_habilitar_stripe   TINYINT(1),
  IN p_habilitar_deposito TINYINT(1),
  IN p_habilitar_paypal   TINYINT(1),
  IN p_habilitar_libreria TINYINT(1)
)
BEGIN
  INSERT INTO wms_donaciones_proyectos (
    fk_distrito,
    proyecto_titulo, proyecto_descripcion, proyecto_imagen,
    tipo_proyecto, proyecto_estado, moneda, mostrar_meta, mostrar_totalrecaudado,
    proyecto_meta, proyecto_fecha_limite,
    rifa_rango_inicio, rifa_rango_fin, rifa_total_boletos,
    fk_stripe_cuenta, fk_cuenta_deposito,
    responsable_nombre, responsable_telefono,
    habilitar_stripe, habilitar_deposito, habilitar_paypal, habilitar_libreria
  ) VALUES (
    p_fk_distrito,
    p_titulo, p_descripcion, p_imagen,
    p_tipo_proyecto, p_estado, p_moneda, p_mostrar_meta, p_mostrar_totalrecaudado,
    p_meta, p_fecha_limite,
    p_rifa_rango_inicio, p_rifa_rango_fin, p_rifa_total_boletos,
    p_fk_stripe_cuenta, p_fk_cuenta_deposito,
    p_responsable_nombre, p_responsable_telefono,
    p_habilitar_stripe, p_habilitar_deposito, p_habilitar_paypal, p_habilitar_libreria
  );

  SELECT
    id_proyecto,
    fk_distrito,
    proyecto_titulo,
    proyecto_descripcion,
    proyecto_imagen,
    tipo_proyecto,
    proyecto_estado,
    moneda,
    mostrar_meta,
    mostrar_totalrecaudado,
    fk_stripe_cuenta,
    fk_cuenta_deposito,
    responsable_nombre,
    responsable_telefono,
    habilitar_stripe,
    habilitar_deposito,
    habilitar_paypal,
    habilitar_libreria,
    proyecto_meta,
    (
      (SELECT COALESCE(SUM(fp.monto), 0)
         FROM wms_donaciones_fichas_pago fp
         WHERE fp.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND fp.estatus_pago = 'pagado'
           AND fp.status = 1)
      +
      (SELECT COALESCE(SUM(ps.monto), 0)
         FROM wms_donaciones_pagos_stripe ps
         WHERE ps.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND ps.estatus_pago = 'pagado'
           AND ps.status = 1)
      +
      (SELECT COALESCE(SUM(dt.monto), 0)
         FROM wms_donaciones_pagos_transferencia dt
         WHERE dt.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND dt.estatus_pago = 'pagado'
           AND dt.status = 1)
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_monto_sugerido_insertar
-- Inserta un monto sugerido para un proyecto ya existente. El controller lo
-- llama una vez por cada monto que el administrador agregó en el formulario.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_monto_sugerido_insertar (
  IN p_fk_proyecto    INT UNSIGNED,
  IN p_monto_sugerido DECIMAL(10,2),
  IN p_orden          TINYINT UNSIGNED
)
BEGIN
  INSERT INTO wms_donaciones_montos_sugeridos (fk_proyecto, monto_sugerido, monto_orden)
  VALUES (p_fk_proyecto, p_monto_sugerido, p_orden);

  SELECT
    id_monto_sugerido,
    fk_proyecto,
    monto_sugerido,
    monto_orden
  FROM wms_donaciones_montos_sugeridos
  WHERE id_monto_sugerido = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_montos_sugeridos_consultar
-- Lista TODOS los montos sugeridos de un proyecto (sin filtrar por status),
-- en el orden en que se agregaron.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_montos_sugeridos_consultar (
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  SELECT
    id_monto_sugerido,
    fk_proyecto,
    monto_sugerido,
    monto_orden
  FROM wms_donaciones_montos_sugeridos
  WHERE fk_proyecto = p_fk_proyecto
  ORDER BY monto_orden, monto_sugerido;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyectos_consultar
-- Lista/filtra los proyectos para el panel "Gestión de Donaciones" (admin) y para el
-- listado público de la app móvil (mobile.dash.donaciones.php).
-- p_fk_distrito: filtro obligatorio, solo regresa proyectos de ese distrito.
-- p_search: filtra por titulo/descripcion (LIKE). NULL o '' = sin filtrar.
-- p_tipo_proyecto: filtra por 'proyecto', 'donacion', 'deposito' o 'rifa'. NULL o '' = sin filtrar.
-- p_estado: filtra por estado ('activo', etc). NULL o '' = sin filtrar (usado por el admin;
--           la app móvil manda 'activo' para no exponer borradores/pausados/finalizados).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyectos_consultar (
  IN p_fk_distrito   INT UNSIGNED,
  IN p_search        VARCHAR(150),
  IN p_tipo_proyecto VARCHAR(20),
  IN p_estado        VARCHAR(20)
)
BEGIN
  SELECT
    id_proyecto,
    fk_distrito,
    proyecto_titulo,
    proyecto_descripcion,
    proyecto_imagen,
    tipo_proyecto,
    proyecto_estado,
    moneda,
    mostrar_meta,
    mostrar_totalrecaudado,
    fk_stripe_cuenta,
    fk_cuenta_deposito,
    responsable_nombre,
    responsable_telefono,
    habilitar_stripe,
    habilitar_deposito,
    habilitar_paypal,
    habilitar_libreria,
    proyecto_meta,
    (
      (SELECT COALESCE(SUM(fp.monto), 0)
         FROM wms_donaciones_fichas_pago fp
         WHERE fp.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND fp.estatus_pago = 'pagado'
           AND fp.status = 1)
      +
      (SELECT COALESCE(SUM(ps.monto), 0)
         FROM wms_donaciones_pagos_stripe ps
         WHERE ps.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND ps.estatus_pago = 'pagado'
           AND ps.status = 1)
      +
      (SELECT COALESCE(SUM(dt.monto), 0)
         FROM wms_donaciones_pagos_transferencia dt
         WHERE dt.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND dt.estatus_pago = 'pagado'
           AND dt.status = 1)
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE status = 1
    AND fk_distrito = p_fk_distrito
    AND (p_search IS NULL OR p_search = '' OR
         proyecto_titulo LIKE CONCAT('%', p_search, '%') OR
         proyecto_descripcion LIKE CONCAT('%', p_search, '%'))
    AND (p_tipo_proyecto IS NULL OR p_tipo_proyecto = '' OR tipo_proyecto = p_tipo_proyecto)
    AND (p_estado IS NULL OR p_estado = '' OR proyecto_estado = p_estado)
  ORDER BY fecha_registro DESC;
END$$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyecto_detalle
-- Trae un solo proyecto por su id_proyecto (usado por el botón "Editar" para
-- precargar el panel "Nuevo proyecto" con la información existente).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyecto_detalle (
  IN p_id_proyecto INT UNSIGNED
)
BEGIN
  SELECT
    id_proyecto,
    fk_distrito,
    proyecto_titulo,
    proyecto_descripcion,
    proyecto_imagen,
    tipo_proyecto,
    proyecto_estado,
    moneda,
    mostrar_meta,
    mostrar_totalrecaudado,
    fk_stripe_cuenta,
    fk_cuenta_deposito,
    responsable_nombre,
    responsable_telefono,
    habilitar_stripe,
    habilitar_deposito,
    habilitar_paypal,
    habilitar_libreria,
    proyecto_meta,
    (
      (SELECT COALESCE(SUM(fp.monto), 0)
         FROM wms_donaciones_fichas_pago fp
         WHERE fp.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND fp.estatus_pago = 'pagado'
           AND fp.status = 1)
      +
      (SELECT COALESCE(SUM(ps.monto), 0)
         FROM wms_donaciones_pagos_stripe ps
         WHERE ps.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND ps.estatus_pago = 'pagado'
           AND ps.status = 1)
      +
      (SELECT COALESCE(SUM(dt.monto), 0)
         FROM wms_donaciones_pagos_transferencia dt
         WHERE dt.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND dt.estatus_pago = 'pagado'
           AND dt.status = 1)
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyecto_actualizar_estado
-- Cambia unicamente el estado del proyecto (Pausar / Reanudar / Finalizar).
-- No toca los demas campos, a diferencia de una edicion completa.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyecto_actualizar_estado (
  IN p_id_proyecto  INT UNSIGNED,
  IN p_nuevo_estado ENUM('borrador','activo','pausado','finalizado')
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET proyecto_estado = p_nuevo_estado
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;

  SELECT
    id_proyecto,
    fk_distrito,
    proyecto_titulo,
    proyecto_descripcion,
    proyecto_imagen,
    tipo_proyecto,
    proyecto_estado,
    moneda,
    mostrar_meta,
    mostrar_totalrecaudado,
    fk_stripe_cuenta,
    fk_cuenta_deposito,
    responsable_nombre,
    responsable_telefono,
    habilitar_stripe,
    habilitar_deposito,
    habilitar_paypal,
    habilitar_libreria,
    proyecto_meta,
    (
      (SELECT COALESCE(SUM(fp.monto), 0)
         FROM wms_donaciones_fichas_pago fp
         WHERE fp.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND fp.estatus_pago = 'pagado'
           AND fp.status = 1)
      +
      (SELECT COALESCE(SUM(ps.monto), 0)
         FROM wms_donaciones_pagos_stripe ps
         WHERE ps.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND ps.estatus_pago = 'pagado'
           AND ps.status = 1)
      +
      (SELECT COALESCE(SUM(dt.monto), 0)
         FROM wms_donaciones_pagos_transferencia dt
         WHERE dt.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND dt.estatus_pago = 'pagado'
           AND dt.status = 1)
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto;
END$$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_proyecto_actualizar
-- Edicion completa de un proyecto ya existente (todos los campos, identificado
-- por id_proyecto). Los montos sugeridos NO se tocan aqui: el controller
-- primero llama wms_donaciones_montos_sugeridos_eliminar_por_proyecto y luego
-- reinserta los vigentes con wms_donaciones_monto_sugerido_insertar, igual que
-- en el alta.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_proyecto_actualizar (
  IN p_id_proyecto        INT UNSIGNED,
  IN p_titulo             VARCHAR(150),
  IN p_descripcion        TEXT,
  IN p_imagen             VARCHAR(255),
  IN p_tipo_proyecto      ENUM('proyecto','donacion','deposito','rifa'),
  IN p_estado             ENUM('borrador','activo','pausado','finalizado'),
  IN p_moneda             CHAR(3),
  IN p_mostrar_meta            TINYINT(1),
  IN p_mostrar_totalrecaudado  TINYINT(1),
  IN p_meta               DECIMAL(12,2),
  IN p_fecha_limite       DATE,
  IN p_rifa_rango_inicio  INT UNSIGNED,
  IN p_rifa_rango_fin     INT UNSIGNED,
  IN p_rifa_total_boletos INT UNSIGNED,
  IN p_fk_stripe_cuenta   INT UNSIGNED,
  IN p_fk_cuenta_deposito INT UNSIGNED,
  IN p_responsable_nombre   VARCHAR(150),
  IN p_responsable_telefono VARCHAR(20),
  IN p_habilitar_stripe   TINYINT(1),
  IN p_habilitar_deposito TINYINT(1),
  IN p_habilitar_paypal   TINYINT(1),
  IN p_habilitar_libreria TINYINT(1)
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET
    proyecto_titulo      = p_titulo,
    proyecto_descripcion = p_descripcion,
    proyecto_imagen      = p_imagen,
    tipo_proyecto        = p_tipo_proyecto,
    proyecto_estado      = p_estado,
    moneda               = p_moneda,
    mostrar_meta            = p_mostrar_meta,
    mostrar_totalrecaudado  = p_mostrar_totalrecaudado,
    proyecto_meta        = p_meta,
    proyecto_fecha_limite = p_fecha_limite,
    rifa_rango_inicio    = p_rifa_rango_inicio,
    rifa_rango_fin       = p_rifa_rango_fin,
    rifa_total_boletos   = p_rifa_total_boletos,
    fk_stripe_cuenta     = p_fk_stripe_cuenta,
    fk_cuenta_deposito   = p_fk_cuenta_deposito,
    responsable_nombre   = p_responsable_nombre,
    responsable_telefono = p_responsable_telefono,
    habilitar_stripe     = p_habilitar_stripe,
    habilitar_deposito   = p_habilitar_deposito,
    habilitar_paypal     = p_habilitar_paypal,
    habilitar_libreria   = p_habilitar_libreria
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;

  SELECT
    id_proyecto,
    fk_distrito,
    proyecto_titulo,
    proyecto_descripcion,
    proyecto_imagen,
    tipo_proyecto,
    proyecto_estado,
    moneda,
    mostrar_meta,
    mostrar_totalrecaudado,
    fk_stripe_cuenta,
    fk_cuenta_deposito,
    responsable_nombre,
    responsable_telefono,
    habilitar_stripe,
    habilitar_deposito,
    habilitar_paypal,
    habilitar_libreria,
    proyecto_meta,
    (
      (SELECT COALESCE(SUM(fp.monto), 0)
         FROM wms_donaciones_fichas_pago fp
         WHERE fp.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND fp.estatus_pago = 'pagado'
           AND fp.status = 1)
      +
      (SELECT COALESCE(SUM(ps.monto), 0)
         FROM wms_donaciones_pagos_stripe ps
         WHERE ps.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND ps.estatus_pago = 'pagado'
           AND ps.status = 1)
      +
      (SELECT COALESCE(SUM(dt.monto), 0)
         FROM wms_donaciones_pagos_transferencia dt
         WHERE dt.fk_proyecto = wms_donaciones_proyectos.id_proyecto
           AND dt.estatus_pago = 'pagado'
           AND dt.status = 1)
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_montos_sugeridos_eliminar_por_proyecto
-- Hard delete: borra el registro (no soft delete) de TODOS los montos
-- sugeridos de un proyecto. Se usa al editar un proyecto, justo antes de
-- reinsertar los montos que quedaron en el formulario (los que el admin
-- quitó simplemente no se reinsertan).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_montos_sugeridos_eliminar_por_proyecto (
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_montos_sugeridos
  WHERE fk_proyecto = p_fk_proyecto;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_pagos_listar_por_proyecto
-- Lista, paginado, las donaciones YA CONFIRMADAS ('pagado') de un proyecto combinando AMBOS
-- métodos de pago -- QR (wms_donaciones_fichas_pago) y tarjeta (wms_donaciones_pagos_stripe) --
-- para "Listado de Donaciones" en dash.donaciones.proyectodetalles.php. Las fichas/pagos
-- 'pendiente' (o 'fallido'/'cancelado' en Stripe) no son donaciones reales todavia, asi que
-- no se listan.
--
-- metodo_pago ('qr' | 'stripe') y folio (folio_qr o folio_stripe, según corresponda) viajan
-- normalizados bajo un solo nombre de columna para que el frontend no tenga que distinguir de
-- qué tabla vino cada fila.
--
-- Orden fijo por fecha_pago ASC sobre el conjunto YA COMBINADO (mas antigua primero, tal como
-- se pidio). El total de donaciones que hacen match (sin el LIMIT) viaja en cada fila como
-- total_donaciones (COUNT(*) OVER()), asi el frontend arma la paginacion sin una segunda
-- consulta. Usa PREPARE/EXECUTE por compatibilidad amplia entre versiones de MySQL.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_pagos_listar_por_proyecto (
  IN p_fk_proyecto INT UNSIGNED,
  IN p_limit       INT UNSIGNED,
  IN p_offset      INT UNSIGNED
)
BEGIN
  SET @dp_fk_proyecto = p_fk_proyecto;
  SET @dp_limit = p_limit;
  SET @dp_offset = p_offset;

  PREPARE stmt FROM
    'SELECT
      combinado.metodo_pago,
      combinado.folio,
      combinado.fk_proyecto,
      combinado.donante_nombre,
      combinado.donante_apellidos,
      combinado.donante_correo,
      combinado.donante_telefono,
      combinado.monto,
      combinado.moneda,
      combinado.estatus_pago,
      combinado.fecha_registro,
      combinado.fecha_pago,
      combinado.stripe_payment_intent_id,
      COUNT(*) OVER() AS total_donaciones
    FROM (
      SELECT
        ''qr'' AS metodo_pago,
        folio_qr AS folio,
        fk_proyecto, donante_nombre, donante_apellidos, donante_correo, donante_telefono,
        monto, moneda, estatus_pago, fecha_registro, fecha_pago,
        NULL AS stripe_payment_intent_id
      FROM wms_donaciones_fichas_pago
      WHERE fk_proyecto = ?
        AND estatus_pago = ''pagado''
        AND status = 1

      UNION ALL

      SELECT
        ''stripe'' AS metodo_pago,
        folio_stripe AS folio,
        fk_proyecto, donante_nombre, donante_apellidos, donante_correo, donante_telefono,
        monto, moneda, estatus_pago, fecha_registro, fecha_pago,
        stripe_payment_intent_id
      FROM wms_donaciones_pagos_stripe
      WHERE fk_proyecto = ?
        AND estatus_pago = ''pagado''
        AND status = 1

      UNION ALL

      SELECT
        ''transferencia'' AS metodo_pago,
        folio_transferencia AS folio,
        fk_proyecto, donante_nombre, donante_apellidos, donante_correo, donante_telefono,
        monto, moneda, estatus_pago, fecha_registro, fecha_pago,
        NULL AS stripe_payment_intent_id
      FROM wms_donaciones_pagos_transferencia
      WHERE fk_proyecto = ?
        AND estatus_pago = ''pagado''
        AND status = 1
    ) AS combinado
    ORDER BY combinado.fecha_pago ASC
    LIMIT ? OFFSET ?';

  EXECUTE stmt USING @dp_fk_proyecto, @dp_fk_proyecto, @dp_fk_proyecto, @dp_limit, @dp_offset;
  DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
