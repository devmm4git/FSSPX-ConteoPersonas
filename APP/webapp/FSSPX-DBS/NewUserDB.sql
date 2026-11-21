CREATE USER 'fsspx_usr_pro'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'Q6bfg#120K';
CREATE USER 'fsspx_usr_pro'@'%'         IDENTIFIED WITH caching_sha2_password BY 'Q6bfg#120K';

GRANT SELECT, INSERT, UPDATE, EXECUTE ON `fsspx_pro`.* TO 'fsspx_usr_pro'@'localhost';
GRANT SELECT, INSERT, UPDATE, EXECUTE ON `fsspx_pro`.* TO 'fsspx_usr_pro'@'%';
