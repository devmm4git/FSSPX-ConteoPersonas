-- ============================================================
-- MODULO: Accounts Mobile (usuarios de la APP Mobile)
--
-- Equivalente a users / user_login / user_session (que son SOLO para los administradores
-- del Dashboard), pero para los fieles que se registran desde la APP Mobile.
-- Las tablas están separadas a propósito: un usuario mobile NUNCA debe poder entrar al Dashboard.
--
-- Campos que recibe el registro desde la APP (pantalla "Regístrate con tu correo"):
--   - Nombre completo
--   - Correo electrónico
--   - Contraseña (mínimo 8 caracteres)
--
-- Se usa CREATE TABLE IF NOT EXISTS (y NO DROP TABLE) para que re-ejecutar este archivo
-- NO borre las cuentas ya registradas.
-- ============================================================

-- --------------------------------------------------------
-- Tabla: mob_users
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS mob_users (
  pk_mob_user       INT UNSIGNED  NOT NULL AUTO_INCREMENT,

  name              VARCHAR(150)  NOT NULL                COMMENT 'Nombre completo',
  email             VARCHAR(200)  NOT NULL,
  status            TINYINT       NOT NULL DEFAULT 0      COMMENT '1 = cuenta activa | 0 = pendiente de verificar correo | 2 = bloqueada',

  activation_token  VARCHAR(45)   DEFAULT NULL            COMMENT 'Token del correo de verificación; NULL una vez activada',
  activation_day    DATETIME      DEFAULT NULL,
  activation_ip     VARCHAR(45)   DEFAULT NULL,
  recover_token     VARCHAR(45)   DEFAULT NULL,

  created_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (pk_mob_user),
  UNIQUE KEY uq_mob_users_email (email),
  KEY idx_mob_users_activation_token (activation_token),
  KEY idx_mob_users_recover_token (recover_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Tabla: mob_user_login (credenciales)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS mob_user_login (
  pk_mob_user_login INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  fk_mob_user       INT UNSIGNED  NOT NULL,
  email             VARCHAR(200)  NOT NULL,
  pass              VARCHAR(255)  NOT NULL                COMMENT 'Hash bcrypt (password_hash)',

  PRIMARY KEY (pk_mob_user_login),
  UNIQUE KEY uq_mob_user_login_fk_user (fk_mob_user),
  CONSTRAINT fk_mob_user_login_user FOREIGN KEY (fk_mob_user)
    REFERENCES mob_users (pk_mob_user) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Tabla: mob_user_session (una fila por cada login desde un dispositivo)
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS mob_user_session (
  pk_mob_user_session INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fk_mob_user         INT UNSIGNED NOT NULL,
  token_session_front VARCHAR(500) DEFAULT NULL            COMMENT 'JWT entregado a la APP',
  token_session_back  VARCHAR(500) DEFAULT NULL            COMMENT 'Refresh token',
  login_datetime      DATETIME     DEFAULT NULL,
  logout_datetime     DATETIME     DEFAULT NULL            COMMENT 'NULL = sesión activa',
  user_agent          VARCHAR(300) DEFAULT NULL,
  ip                  VARCHAR(45)  DEFAULT NULL,

  PRIMARY KEY (pk_mob_user_session),
  KEY idx_mob_user_session_user (fk_mob_user),
  CONSTRAINT fk_mob_user_session_user FOREIGN KEY (fk_mob_user)
    REFERENCES mob_users (pk_mob_user) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
