-- ============================================================
-- MODULO: Horarios de Misa - Procedures
-- Requiere que las tablas de wms_horarios_misa.tables.sql ya existan.
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS wms_horarios_misa_insertar;
DROP PROCEDURE IF EXISTS wms_horarios_misa_actualizar;
DROP PROCEDURE IF EXISTS wms_horarios_misa_eliminar;
DROP PROCEDURE IF EXISTS wms_horarios_misa_consultar;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_horarios_misa_insertar
-- Solo inserta. Si ya existe la combinacion (fk_capilla, dia, hora), el
-- UNIQUE KEY de la tabla truena con error de duplicado -> no se sobreescribe
-- nada por accidente. Para editar un horario existente usar el _actualizar.
-- --------------------------------------------------------
CREATE PROCEDURE wms_horarios_misa_insertar (
  IN p_fk_capilla        INT UNSIGNED,
  IN p_fk_tipo_actividad  INT UNSIGNED,
  IN p_dia_semana         TINYINT UNSIGNED,
  IN p_hora               TIME
)
BEGIN
  INSERT INTO wms_horarios_misa (fk_capilla, fk_tipo_actividad, horario_dia_semana, horario_hora)
  VALUES (p_fk_capilla, p_fk_tipo_actividad, p_dia_semana, p_hora);

  SELECT
    h.id_horario,
    h.fk_capilla,
    h.horario_dia_semana,
    h.horario_hora,
    ta.id_tipo_actividad,
    ta.tipo_actividad_nombre,
    ta.tipo_actividad_variante
  FROM wms_horarios_misa h
  INNER JOIN wms_horarios_tipos_actividad ta ON ta.id_tipo_actividad = h.fk_tipo_actividad
  WHERE h.id_horario = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_horarios_misa_actualizar
-- Se ejecuta unicamente cuando se edita un horario ya existente.
-- Identifica la fila por id_horario (no por la llave natural), asi que
-- aunque cambien dia/hora/capilla/actividad sigue siendo la misma fila.
-- --------------------------------------------------------
CREATE PROCEDURE wms_horarios_misa_actualizar (
  IN p_id_horario         INT UNSIGNED,
  IN p_fk_capilla         INT UNSIGNED,
  IN p_fk_tipo_actividad  INT UNSIGNED,
  IN p_dia_semana         TINYINT UNSIGNED,
  IN p_hora               TIME
)
BEGIN
  UPDATE wms_horarios_misa
  SET
    fk_capilla         = p_fk_capilla,
    fk_tipo_actividad  = p_fk_tipo_actividad,
    horario_dia_semana = p_dia_semana,
    horario_hora       = p_hora
  WHERE id_horario = p_id_horario;

  SELECT
    h.id_horario,
    h.fk_capilla,
    h.horario_dia_semana,
    h.horario_hora,
    ta.id_tipo_actividad,
    ta.tipo_actividad_nombre,
    ta.tipo_actividad_variante
  FROM wms_horarios_misa h
  INNER JOIN wms_horarios_tipos_actividad ta ON ta.id_tipo_actividad = h.fk_tipo_actividad
  WHERE h.id_horario = p_id_horario;
END$$


-- --------------------------------------------------------
-- Procedure: wms_horarios_misa_eliminar
-- Soft delete (status = 0), coherente con el filtro h.status = 1
-- que ya usa wms_horarios_misa_consultar.
-- --------------------------------------------------------
CREATE PROCEDURE wms_horarios_misa_eliminar (
  IN p_id_horario INT UNSIGNED
)
BEGIN
  UPDATE wms_horarios_misa SET status = 0 WHERE id_horario = p_id_horario;
END$$


-- --------------------------------------------------------
-- Procedure: wms_horarios_misa_consultar
-- Recorre capilla -> priorato -> distrito. p_fk_priorato y p_fk_capilla
-- son filtros opcionales (NULL o 0 = sin filtrar); p_fk_distrito es obligatorio.
-- Regresa ordenado de menor a mayor (priorato, capilla, dia, hora).
-- --------------------------------------------------------
CREATE PROCEDURE wms_horarios_misa_consultar (
  IN p_fk_distrito INT UNSIGNED,
  IN p_fk_priorato INT UNSIGNED,
  IN p_fk_capilla  INT UNSIGNED
)
BEGIN
  SELECT
    d.id_distrito,
    d.distrito_pais,
    p.id_priorato,
    p.priorato_nombre,
    c.id_capilla,
    c.capilla_nombre,
    c.capilla_pais,
    c.capilla_estado,
    c.capilla_municipio,
    c.capilla_colonia,
    c.capilla_calle,
    c.capilla_numero_exterior,
    c.capilla_numero_interior,
    c.capilla_cp,
    c.capilla_telefono,
    h.id_horario,
    h.horario_dia_semana,
    h.horario_hora,
    ta.id_tipo_actividad,
    ta.tipo_actividad_nombre,
    ta.tipo_actividad_variante
  FROM wms_capillas c
  INNER JOIN wms_prioratos p ON p.id_priorato = c.fk_priorato
  INNER JOIN wms_distritos d ON d.id_distrito = p.fk_distrito
  LEFT JOIN wms_horarios_misa h ON h.fk_capilla = c.id_capilla AND h.status = 1
  LEFT JOIN wms_horarios_tipos_actividad ta ON ta.id_tipo_actividad = h.fk_tipo_actividad
  WHERE d.id_distrito = p_fk_distrito
    AND c.status = 1
    AND p.status = 1
    AND (p_fk_priorato IS NULL OR p_fk_priorato = 0 OR p.id_priorato = p_fk_priorato)
    AND (p_fk_capilla IS NULL OR p_fk_capilla = 0 OR c.id_capilla = p_fk_capilla)
  ORDER BY p.priorato_nombre, c.capilla_nombre, h.horario_dia_semana, h.horario_hora;
END$$

DELIMITER ;