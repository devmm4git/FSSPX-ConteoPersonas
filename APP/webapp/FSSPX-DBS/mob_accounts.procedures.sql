-- ============================================================
-- MODULO: Accounts Mobile - Procedures
-- Requiere que las tablas de mob_accounts.tables.sql ya existan.
-- Usados por FSSPX-Login/sandbox/accounts/php/class/Accounts.Mobile.class.php
-- ============================================================

DROP PROCEDURE IF EXISTS mob_accounts_validateIFExistUser;
DROP PROCEDURE IF EXISTS mob_accounts_addNewUser;
DROP PROCEDURE IF EXISTS mob_accounts_activenewaccount;
DROP PROCEDURE IF EXISTS mob_accounts_validatePassword;
DROP PROCEDURE IF EXISTS mob_session_registry_new_session;
DROP PROCEDURE IF EXISTS mob_session_update_user_session;
DROP PROCEDURE IF EXISTS mob_session_validate;
DROP PROCEDURE IF EXISTS mob_session_close;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: mob_accounts_validateIFExistUser
-- Regresa siempre 1 fila: existe = 0 | 1
-- --------------------------------------------------------
CREATE PROCEDURE mob_accounts_validateIFExistUser (
  IN p_email VARCHAR(200)
)
BEGIN
  DECLARE v_id_user   INT DEFAULT 0;
  DECLARE v_status    INT DEFAULT 0;
  DECLARE v_name_user VARCHAR(150) DEFAULT '';

  SELECT pk_mob_user, status, name
    INTO v_id_user, v_status, v_name_user
    FROM mob_users
   WHERE email = p_email
   LIMIT 1;

  SELECT
    v_id_user                     AS id_user,
    IF(v_id_user > 0, 1, 0)       AS existe,
    v_status                      AS status,
    v_name_user                   AS name_user;
END $$

-- --------------------------------------------------------
-- Procedure: mob_accounts_addNewUser
-- Inserta en mob_users + mob_user_login en una sola transacción.
-- --------------------------------------------------------
CREATE PROCEDURE mob_accounts_addNewUser (
  IN p_name             VARCHAR(150),
  IN p_email            VARCHAR(200),
  IN p_pass_hash        VARCHAR(255),
  IN p_activation_token VARCHAR(45)
)
BEGIN
  DECLARE v_new_pk INT DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SELECT 0 AS newPkUser;
  END;

  START TRANSACTION;

  INSERT INTO mob_users (name, email, status, activation_token)
  VALUES (p_name, p_email, 0, p_activation_token);

  SET v_new_pk = LAST_INSERT_ID();

  INSERT INTO mob_user_login (fk_mob_user, email, pass)
  VALUES (v_new_pk, p_email, p_pass_hash);

  COMMIT;

  SELECT v_new_pk AS newPkUser;
END $$

-- --------------------------------------------------------
-- Procedure: mob_accounts_activenewaccount
-- Activa la cuenta por token. El token se pone en NULL al activarse, y un token
-- vacío nunca hace match (evita activar cuentas con binder = '').
-- --------------------------------------------------------
CREATE PROCEDURE mob_accounts_activenewaccount (
  IN p_binder   VARCHAR(45),
  IN p_ip       VARCHAR(45),
  IN p_datetime DATETIME
)
BEGIN
  DECLARE v_pk_user   INT DEFAULT 0;
  DECLARE v_name_user VARCHAR(150) DEFAULT '';

  IF p_binder IS NOT NULL AND p_binder <> '' THEN
    SELECT pk_mob_user, name
      INTO v_pk_user, v_name_user
      FROM mob_users
     WHERE activation_token = p_binder
       AND status = 0
     LIMIT 1;

    IF v_pk_user > 0 THEN
      UPDATE mob_users
         SET status           = 1,
             activation_token = NULL,
             activation_day   = p_datetime,
             activation_ip    = p_ip
       WHERE pk_mob_user = v_pk_user;
    END IF;
  END IF;

  SELECT v_pk_user AS pk_user, v_name_user AS name_user;
END $$

-- --------------------------------------------------------
-- Procedure: mob_accounts_validatePassword
-- --------------------------------------------------------
CREATE PROCEDURE mob_accounts_validatePassword (
  IN p_user_id INT
)
BEGIN
  SELECT pass AS password_hash
    FROM mob_user_login
   WHERE fk_mob_user = p_user_id
   LIMIT 1;
END $$

-- --------------------------------------------------------
-- Procedure: mob_session_registry_new_session
-- --------------------------------------------------------
CREATE PROCEDURE mob_session_registry_new_session (
  IN p_fk_user        INT,
  IN p_login_datetime DATETIME,
  IN p_user_agent     VARCHAR(300),
  IN p_ip             VARCHAR(45)
)
BEGIN
  INSERT INTO mob_user_session (fk_mob_user, login_datetime, user_agent, ip)
  VALUES (p_fk_user, p_login_datetime, p_user_agent, p_ip);

  SELECT LAST_INSERT_ID() AS pk_user_session;
END $$

-- --------------------------------------------------------
-- Procedure: mob_session_update_user_session
-- Guarda el JWT y el refresh token generados para la sesión.
-- --------------------------------------------------------
CREATE PROCEDURE mob_session_update_user_session (
  IN p_session_id   INT,
  IN p_token_front  VARCHAR(500),
  IN p_token_back   VARCHAR(500)
)
BEGIN
  UPDATE mob_user_session
     SET token_session_front = p_token_front,
         token_session_back  = p_token_back
   WHERE pk_mob_user_session = p_session_id;

  SELECT IF(ROW_COUNT() > 0, TRUE, FALSE) AS update_successful;
END $$

-- --------------------------------------------------------
-- Procedure: mob_session_validate
-- active = 1 si la sesión existe, pertenece al usuario y no se ha cerrado.
-- --------------------------------------------------------
CREATE PROCEDURE mob_session_validate (
  IN p_session_id INT,
  IN p_user_id    INT
)
BEGIN
  SELECT COUNT(*) AS active
    FROM mob_user_session s
    JOIN mob_users u ON u.pk_mob_user = s.fk_mob_user
   WHERE s.pk_mob_user_session = p_session_id
     AND s.fk_mob_user = p_user_id
     AND s.logout_datetime IS NULL
     AND u.status = 1;
END $$

-- --------------------------------------------------------
-- Procedure: mob_session_close (logout)
-- --------------------------------------------------------
CREATE PROCEDURE mob_session_close (
  IN p_session_id      INT,
  IN p_user_id         INT,
  IN p_logout_datetime DATETIME
)
BEGIN
  UPDATE mob_user_session
     SET logout_datetime     = p_logout_datetime,
         token_session_front = NULL,
         token_session_back  = NULL
   WHERE pk_mob_user_session = p_session_id
     AND fk_mob_user = p_user_id
     AND logout_datetime IS NULL;

  SELECT IF(ROW_COUNT() > 0, TRUE, FALSE) AS closed;
END $$

DELIMITER ;
