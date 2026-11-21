-- ============================================================
-- MODULO: Horarios de Misa - Catalogos (distritos / prioratos / capillas)
-- Archivo ADITIVO: no borra ni toca las tablas ni los procedures existentes
-- de wms_horarios_misa.tables.sql / wms_horarios_misa.procedures.sql.
-- Solo agrega los 3 procedures de listado que necesita el selector en
-- cascada (Distrito -> Priorato -> Capilla) de la app movil.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_distritos_listar;
DROP PROCEDURE IF EXISTS wms_prioratos_listar;
DROP PROCEDURE IF EXISTS wms_capillas_listar;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_distritos_listar
-- Lista todos los distritos activos, orden alfabetico por pais.
-- --------------------------------------------------------
CREATE PROCEDURE wms_distritos_listar ()
BEGIN
  SELECT
    d.id_distrito,
    d.distrito_pais
  FROM wms_distritos d
  WHERE d.status = 1
  ORDER BY d.distrito_pais;
END$$

-- --------------------------------------------------------
-- Procedure: wms_prioratos_listar
-- Lista los prioratos activos de un distrito.
-- --------------------------------------------------------
CREATE PROCEDURE wms_prioratos_listar (
  IN p_fk_distrito INT UNSIGNED
)
BEGIN
  SELECT
    p.id_priorato,
    p.priorato_nombre
  FROM wms_prioratos p
  WHERE p.status = 1
    AND p.fk_distrito = p_fk_distrito
  ORDER BY p.priorato_nombre;
END$$

-- --------------------------------------------------------
-- Procedure: wms_capillas_listar
-- Lista las capillas activas de un priorato.
-- --------------------------------------------------------
CREATE PROCEDURE wms_capillas_listar (
  IN p_fk_priorato INT UNSIGNED
)
BEGIN
  SELECT
    c.id_capilla,
    c.capilla_nombre,
    c.capilla_municipio
  FROM wms_capillas c
  WHERE c.status = 1
    AND c.fk_priorato = p_fk_priorato
  ORDER BY c.capilla_nombre;
END$$

DELIMITER ;
