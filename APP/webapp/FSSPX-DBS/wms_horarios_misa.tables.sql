-- ============================================================
-- MODULO: Horarios de Misa
-- Jerarquia: wms_distritos (1) --- (N) wms_prioratos (1) --- (N) wms_capillas (1) --- (N) wms_horarios_misa
-- Catalogo de apoyo: wms_horarios_tipos_actividad
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- Orden inverso a las dependencias de FK
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_horarios_misa;
DROP TABLE IF EXISTS wms_horarios_tipos_actividad;
DROP TABLE IF EXISTS wms_capillas;
DROP TABLE IF EXISTS wms_prioratos;
DROP TABLE IF EXISTS wms_distritos;


-- --------------------------------------------------------
-- Tabla: wms_distritos
-- Unico dato propio: el pais.
-- --------------------------------------------------------
CREATE TABLE wms_distritos (
  id_distrito      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  distrito_pais    VARCHAR(100) NOT NULL,
  status           TINYINT(1)   NOT NULL DEFAULT 1,
  fecha_registro   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_distrito),
  UNIQUE KEY uq_distrito_pais (distrito_pais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------
-- Tabla: wms_prioratos
-- Un distrito tiene varios prioratos.
-- --------------------------------------------------------
CREATE TABLE wms_prioratos (
  id_priorato      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_distrito      INT UNSIGNED NOT NULL,
  priorato_nombre  VARCHAR(150) NOT NULL,
  status           TINYINT(1)   NOT NULL DEFAULT 1,
  fecha_registro   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_priorato),
  UNIQUE KEY uq_priorato_distrito_nombre (fk_distrito, priorato_nombre),
  CONSTRAINT fk_prioratos_distrito
    FOREIGN KEY (fk_distrito) REFERENCES wms_distritos (id_distrito)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------
-- Tabla: wms_capillas
-- Un priorato tiene varias capillas. Incluye domicilio completo.
-- --------------------------------------------------------
CREATE TABLE wms_capillas (
  id_capilla               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_priorato              INT UNSIGNED NOT NULL,
  capilla_nombre           VARCHAR(150) NOT NULL,

  -- Domicilio
  capilla_pais             VARCHAR(100) NOT NULL DEFAULT 'México',
  capilla_estado           VARCHAR(100) NOT NULL,
  capilla_municipio        VARCHAR(100) NOT NULL,
  capilla_colonia          VARCHAR(150) NOT NULL,
  capilla_calle            VARCHAR(150) NOT NULL,
  capilla_numero_exterior  VARCHAR(20)  NOT NULL,
  capilla_numero_interior  VARCHAR(20)  NULL,
  capilla_cp               VARCHAR(10)  NOT NULL,
  capilla_telefono         VARCHAR(20)  NULL,

  status                   TINYINT(1)   NOT NULL DEFAULT 1,
  fecha_registro           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_capilla),
  UNIQUE KEY uq_capilla_priorato_nombre (fk_priorato, capilla_nombre),
  CONSTRAINT fk_capillas_priorato
    FOREIGN KEY (fk_priorato) REFERENCES wms_prioratos (id_priorato)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------
-- Tabla: wms_horarios_tipos_actividad
-- Catalogo de actividades. Separado de wms_horarios_misa porque el
-- nombre y la variante de estilo dependen del tipo, no de cada horario (3FN).
-- --------------------------------------------------------
CREATE TABLE wms_horarios_tipos_actividad (
  id_tipo_actividad       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tipo_actividad_nombre   VARCHAR(100) NOT NULL,
  tipo_actividad_variante ENUM('normal','solido','atenuado') NOT NULL DEFAULT 'normal',
  status                  TINYINT(1)   NOT NULL DEFAULT 1,
  PRIMARY KEY (id_tipo_actividad),
  UNIQUE KEY uq_tipo_actividad_nombre (tipo_actividad_nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Catalogo base (coincide con el <select> de dash.horarios_misa.php: value 1-5)
-- mas las 3 actividades agregadas al sembrar datos reales (id 6-8).
INSERT INTO wms_horarios_tipos_actividad (tipo_actividad_nombre, tipo_actividad_variante) VALUES
  ('Misa Rezada',             'normal'),   -- id 1
  ('Misa Cantada',            'normal'),   -- id 2
  ('Santo Rosario',           'normal'),   -- id 3
  ('Hora Santa',              'solido'),   -- id 4
  ('Confesiones',             'atenuado'), -- id 5
  ('Catecismo',               'normal'),   -- id 6
  ('Misa Cantada Gregoriana', 'normal'),   -- id 7
  ('Misa Rezada con Cantos',  'normal');   -- id 8


-- --------------------------------------------------------
-- Tabla: wms_horarios_misa
-- Una capilla puede tener de 1 a muchos horarios por dia de la semana.
-- horario_dia_semana: 1=Lunes ... 7=Domingo.
-- --------------------------------------------------------
CREATE TABLE wms_horarios_misa (
  id_horario           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_capilla           INT UNSIGNED NOT NULL,
  fk_tipo_actividad    INT UNSIGNED NOT NULL,
  horario_dia_semana   TINYINT UNSIGNED NOT NULL,
  horario_hora         TIME NOT NULL,
  status               TINYINT(1) NOT NULL DEFAULT 1,
  fecha_registro       DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion  DATETIME   NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_horario),
  UNIQUE KEY uq_horario_capilla_dia_hora (fk_capilla, horario_dia_semana, horario_hora),
  KEY idx_horarios_capilla_dia (fk_capilla, horario_dia_semana),
  CONSTRAINT fk_horarios_capilla
    FOREIGN KEY (fk_capilla) REFERENCES wms_capillas (id_capilla),
  CONSTRAINT fk_horarios_tipo_actividad
    FOREIGN KEY (fk_tipo_actividad) REFERENCES wms_horarios_tipos_actividad (id_tipo_actividad),
  CONSTRAINT chk_horario_dia_semana
    CHECK (horario_dia_semana BETWEEN 1 AND 7)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;