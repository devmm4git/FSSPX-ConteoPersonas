CREATE DATABASE  IF NOT EXISTS `fsspx_pro` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `fsspx_pro`;

-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 198.71.63.235    Database: fsspx_pro
-- ------------------------------------------------------
-- Server version	8.0.33-0ubuntu0.20.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `business`
--

DROP TABLE IF EXISTS `business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business` (
  `idbusiness` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `logo` varchar(45) DEFAULT NULL,
  `fecha_alta` date DEFAULT NULL,
  PRIMARY KEY (`idbusiness`),
  UNIQUE KEY `idbusiness_UNIQUE` (`idbusiness`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catalogo_ip`
--

DROP TABLE IF EXISTS `catalogo_ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogo_ip` (
  `pk_catalogo_ip` int NOT NULL AUTO_INCREMENT,
  `ipacc` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `descripcion` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`pk_catalogo_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catalogo_pantallas`
--

DROP TABLE IF EXISTS `catalogo_pantallas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogo_pantallas` (
  `pk_catalogopantallas` int NOT NULL AUTO_INCREMENT,
  `id_pantalla` int DEFAULT NULL COMMENT 'número de pantalla',
  `descpantalla` varchar(99) DEFAULT NULL COMMENT 'Descripcion de Pantalla\n',
  PRIMARY KEY (`pk_catalogopantallas`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `catalogo_roles`
--

DROP TABLE IF EXISTS `catalogo_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalogo_roles` (
  `pk_catalogoroles` int NOT NULL AUTO_INCREMENT,
  `descrol` varchar(45) DEFAULT NULL COMMENT 'Descripcion del rol \n\nAlmacenista \nJefe de Bodega\nJefe de Piso\nAdministrador\n',
  `auth` int DEFAULT NULL COMMENT '1 = Acceso a todas las pantallas\n2 = Restringido\n',
  `redirecpath` varchar(45) DEFAULT NULL COMMENT 'url default de redireccionamiento \n\n[admin\n piso\n bodega]',
  PRIMARY KEY (`pk_catalogoroles`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login`
--

DROP TABLE IF EXISTS `user_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login` (
  `pk_user_login` int NOT NULL AUTO_INCREMENT,
  `fk_user` int DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `pass` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`pk_user_login`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_session`
--

DROP TABLE IF EXISTS `user_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_session` (
  `pk_user_session` int NOT NULL AUTO_INCREMENT,
  `fk_user` int DEFAULT NULL,
  `token_session_front` varchar(500) DEFAULT NULL COMMENT 'tiene el ID de la sesion activa',
  `token_session_back` varchar(500) DEFAULT NULL,
  `login_datetime` datetime DEFAULT NULL,
  `user_agent` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`pk_user_session`)
) ENGINE=InnoDB AUTO_INCREMENT=897 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `pk_user` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `status` int DEFAULT NULL COMMENT '1 = true = active\\\\n0 = fals e = confirmation account',
  `activation_token` varchar(45) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `activation_day` datetime DEFAULT NULL,
  `activation_ip` varchar(20) DEFAULT NULL,
  `recover_token` varchar(45) DEFAULT NULL,
  `fk_business` int DEFAULT NULL,
  PRIMARY KEY (`pk_user`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios_permisos`
--

DROP TABLE IF EXISTS `usuarios_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_permisos` (
  `pk_usuariospermisos` int NOT NULL AUTO_INCREMENT,
  `fk_catalogopantallas` int NOT NULL,
  `acceso` int DEFAULT NULL COMMENT '1 = Acceso Permitido\n2 = Acceso Denegado',
  `fk_cuentas` int NOT NULL,
  PRIMARY KEY (`pk_usuariospermisos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_capillas`
--

DROP TABLE IF EXISTS `wms_capillas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_capillas` (
  `id_capilla` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_priorato` int unsigned NOT NULL,
  `capilla_nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_pais` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'México',
  `capilla_estado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_municipio` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_colonia` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_calle` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_numero_exterior` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_numero_interior` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capilla_cp` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `capilla_telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_capilla`),
  UNIQUE KEY `uq_capilla_priorato_nombre` (`fk_priorato`,`capilla_nombre`),
  CONSTRAINT `fk_capillas_priorato` FOREIGN KEY (`fk_priorato`) REFERENCES `wms_prioratos` (`id_priorato`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_distritos`
--

DROP TABLE IF EXISTS `wms_distritos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_distritos` (
  `id_distrito` int unsigned NOT NULL AUTO_INCREMENT,
  `distrito_pais` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_distrito`),
  UNIQUE KEY `uq_distrito_pais` (`distrito_pais`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_fichas_pago`
--

DROP TABLE IF EXISTS `wms_donaciones_fichas_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_fichas_pago` (
  `id_ficha_pago` int unsigned NOT NULL AUTO_INCREMENT,
  `folio_qr` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_proyecto` int unsigned NOT NULL,
  `donante_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_correo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `moneda` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'usd',
  `estatus_pago` enum('pendiente','pagado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_pago` datetime DEFAULT NULL,
  PRIMARY KEY (`id_ficha_pago`),
  UNIQUE KEY `uq_ficha_pago_folio` (`folio_qr`),
  KEY `idx_ficha_pago_proyecto` (`fk_proyecto`),
  KEY `idx_ficha_pago_estatus` (`estatus_pago`),
  CONSTRAINT `fk_ficha_pago_proyecto` FOREIGN KEY (`fk_proyecto`) REFERENCES `wms_donaciones_proyectos` (`id_proyecto`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_montos_sugeridos`
--

DROP TABLE IF EXISTS `wms_donaciones_montos_sugeridos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_montos_sugeridos` (
  `id_monto_sugerido` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_proyecto` int unsigned NOT NULL,
  `monto_sugerido` decimal(10,2) NOT NULL,
  `monto_orden` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_monto_sugerido`),
  UNIQUE KEY `uq_monto_proyecto_valor` (`fk_proyecto`,`monto_sugerido`),
  KEY `idx_montos_proyecto` (`fk_proyecto`),
  CONSTRAINT `fk_montos_sugeridos_proyecto` FOREIGN KEY (`fk_proyecto`) REFERENCES `wms_donaciones_proyectos` (`id_proyecto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_pagos_stripe`
--

DROP TABLE IF EXISTS `wms_donaciones_pagos_stripe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_pagos_stripe` (
  `id_pago_stripe` int unsigned NOT NULL AUTO_INCREMENT,
  `folio_stripe` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_proyecto` int unsigned NOT NULL,
  `donante_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_correo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `donante_telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `moneda` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'usd',
  `stripe_payment_intent_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estatus_pago` enum('pendiente','pagado','fallido','cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_pago` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pago_stripe`),
  UNIQUE KEY `uq_pago_stripe_folio` (`folio_stripe`),
  UNIQUE KEY `uq_pago_stripe_payment_intent` (`stripe_payment_intent_id`),
  KEY `idx_pago_stripe_proyecto` (`fk_proyecto`),
  KEY `idx_pago_stripe_estatus` (`estatus_pago`),
  CONSTRAINT `fk_pago_stripe_proyecto` FOREIGN KEY (`fk_proyecto`) REFERENCES `wms_donaciones_proyectos` (`id_proyecto`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_proyectos`
--

DROP TABLE IF EXISTS `wms_donaciones_proyectos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_proyectos` (
  `id_proyecto` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_distrito` int unsigned NOT NULL,
  `proyecto_titulo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `proyecto_descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `proyecto_imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_proyecto` enum('proyecto','donacion','deposito','rifa') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'proyecto',
  `proyecto_estado` enum('borrador','activo','pausado','finalizado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'borrador',
  `moneda` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'usd',
  `mostrar_meta` tinyint(1) NOT NULL DEFAULT '1',
  `mostrar_totalrecaudado` tinyint(1) NOT NULL DEFAULT '1',
  `proyecto_meta` decimal(12,2) DEFAULT NULL,
  `proyecto_recaudado` decimal(12,2) NOT NULL DEFAULT '0.00',
  `proyecto_fecha_limite` date DEFAULT NULL,
  `rifa_rango_inicio` int unsigned DEFAULT NULL,
  `rifa_rango_fin` int unsigned DEFAULT NULL,
  `rifa_total_boletos` int unsigned DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `fk_stripe_cuenta` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id_proyecto`),
  KEY `idx_proyectos_estado` (`proyecto_estado`),
  KEY `idx_proyectos_tipo` (`tipo_proyecto`),
  KEY `idx_proyectos_titulo` (`proyecto_titulo`),
  KEY `idx_proyectos_distrito` (`fk_distrito`),
  CONSTRAINT `fk_proyectos_distrito` FOREIGN KEY (`fk_distrito`) REFERENCES `wms_distritos` (`id_distrito`),
  CONSTRAINT `chk_rifa_rango` CHECK (((`rifa_rango_inicio` is null) or (`rifa_rango_fin` is null) or (`rifa_rango_fin` >= `rifa_rango_inicio`)))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_rifa_boletos`
--

DROP TABLE IF EXISTS `wms_donaciones_rifa_boletos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_rifa_boletos` (
  `id_boleto` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_proyecto` int unsigned NOT NULL,
  `numero_boleto` int unsigned NOT NULL,
  `tipo_seleccion` enum('manual','azar') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `metodo_pago` enum('qr','stripe') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_ficha_pago` int unsigned DEFAULT NULL,
  `fk_pago_stripe` int unsigned DEFAULT NULL,
  `estatus` enum('apartado','vendido') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'apartado',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_boleto`),
  UNIQUE KEY `uq_boleto_proyecto_numero` (`fk_proyecto`,`numero_boleto`),
  KEY `idx_boleto_ficha` (`fk_ficha_pago`),
  KEY `idx_boleto_stripe` (`fk_pago_stripe`),
  CONSTRAINT `fk_rifa_boletos_ficha` FOREIGN KEY (`fk_ficha_pago`) REFERENCES `wms_donaciones_fichas_pago` (`id_ficha_pago`) ON DELETE CASCADE,
  CONSTRAINT `fk_rifa_boletos_proyecto` FOREIGN KEY (`fk_proyecto`) REFERENCES `wms_donaciones_proyectos` (`id_proyecto`),
  CONSTRAINT `fk_rifa_boletos_stripe` FOREIGN KEY (`fk_pago_stripe`) REFERENCES `wms_donaciones_pagos_stripe` (`id_pago_stripe`) ON DELETE CASCADE,
  CONSTRAINT `chk_boleto_metodo_pago` CHECK ((((`metodo_pago` = _utf8mb4'qr') and (`fk_ficha_pago` is not null) and (`fk_pago_stripe` is null)) or ((`metodo_pago` = _utf8mb4'stripe') and (`fk_pago_stripe` is not null) and (`fk_ficha_pago` is null))))
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_donaciones_stripe_cuentas`
--

DROP TABLE IF EXISTS `wms_donaciones_stripe_cuentas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_donaciones_stripe_cuentas` (
  `id_cuenta_stripe` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_distrito` int unsigned NOT NULL,
  `nombre_cuenta` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `modo_activo` enum('live','test') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'test',
  `es_default` tinyint(1) NOT NULL DEFAULT '0',
  `live_publishable_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `live_secret_key_cifrado` text COLLATE utf8mb4_unicode_ci,
  `live_webhook_secret_cifrado` text COLLATE utf8mb4_unicode_ci,
  `test_publishable_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `test_secret_key_cifrado` text COLLATE utf8mb4_unicode_ci,
  `test_webhook_secret_cifrado` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cuenta_stripe`),
  KEY `idx_stripe_cuentas_distrito` (`fk_distrito`),
  CONSTRAINT `fk_stripe_cuentas_distrito` FOREIGN KEY (`fk_distrito`) REFERENCES `wms_distritos` (`id_distrito`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_history`
--

DROP TABLE IF EXISTS `wms_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_history` (
  `idwms_history` int NOT NULL AUTO_INCREMENT,
  `fk_business` int DEFAULT NULL,
  `fk_usuario` int DEFAULT NULL COMMENT 'fk_usuario que realizo la accion',
  `event_type` int DEFAULT NULL COMMENT 'tipo de evento que ejecuto\n1= Agrar\n2= Actualizar\n3= Eliminar\n',
  `fk_catalogo_pantallas` int DEFAULT NULL COMMENT 'pantalla donde ocurrio la accion ver tabla catalogo_pantallas\n',
  `proceso` varchar(100) DEFAULT NULL,
  `proceso_descripcion` varchar(100) DEFAULT NULL,
  `datetime_reg` datetime DEFAULT NULL,
  PRIMARY KEY (`idwms_history`),
  UNIQUE KEY `idwms_history_UNIQUE` (`idwms_history`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_horarios_misa`
--

DROP TABLE IF EXISTS `wms_horarios_misa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_horarios_misa` (
  `id_horario` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_capilla` int unsigned NOT NULL,
  `fk_tipo_actividad` int unsigned NOT NULL,
  `horario_dia_semana` tinyint unsigned NOT NULL,
  `horario_hora` time NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_horario`),
  UNIQUE KEY `uq_horario_capilla_dia_hora` (`fk_capilla`,`horario_dia_semana`,`horario_hora`),
  KEY `idx_horarios_capilla_dia` (`fk_capilla`,`horario_dia_semana`),
  KEY `fk_horarios_tipo_actividad` (`fk_tipo_actividad`),
  CONSTRAINT `fk_horarios_capilla` FOREIGN KEY (`fk_capilla`) REFERENCES `wms_capillas` (`id_capilla`),
  CONSTRAINT `fk_horarios_tipo_actividad` FOREIGN KEY (`fk_tipo_actividad`) REFERENCES `wms_horarios_tipos_actividad` (`id_tipo_actividad`),
  CONSTRAINT `chk_horario_dia_semana` CHECK ((`horario_dia_semana` between 1 and 7))
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_horarios_tipos_actividad`
--

DROP TABLE IF EXISTS `wms_horarios_tipos_actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_horarios_tipos_actividad` (
  `id_tipo_actividad` int unsigned NOT NULL AUTO_INCREMENT,
  `tipo_actividad_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_actividad_variante` enum('normal','solido','atenuado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'normal',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_tipo_actividad`),
  UNIQUE KEY `uq_tipo_actividad_nombre` (`tipo_actividad_nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wms_prioratos`
--

DROP TABLE IF EXISTS `wms_prioratos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_prioratos` (
  `id_priorato` int unsigned NOT NULL AUTO_INCREMENT,
  `fk_distrito` int unsigned NOT NULL,
  `priorato_nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_priorato`),
  UNIQUE KEY `uq_priorato_distrito_nombre` (`fk_distrito`,`priorato_nombre`),
  CONSTRAINT `fk_prioratos_distrito` FOREIGN KEY (`fk_distrito`) REFERENCES `wms_distritos` (`id_distrito`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'fsspx_dev'
--

--
-- Dumping routines for database 'fsspx_dev'
--
/*!50003 DROP PROCEDURE IF EXISTS `accounts_activenewaccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_activenewaccount`(
    IN binder VARCHAR(200),
    IN birthday DATE,
    IN ip VARCHAR(45),           -- Agregado: dirección IP
    IN dateTime DATETIME         -- Agregado: fecha y hora
)
BEGIN
    DECLARE found_pk_user INT;
    DECLARE name_user VARCHAR(200);

    -- Busca el pk_user usando el activation_token proporcionado
    SELECT pk_user, name
	INTO found_pk_user , name_user
    FROM users
    WHERE activation_token = binder;

    -- Si el pk_user existe, realiza la actualización
    IF found_pk_user IS NOT NULL THEN
        UPDATE users
        SET status = 1,
            activation_token = '',
            birthday = IF(birthday IS NOT NULL, birthday, birthday), -- Actualiza solo si no es NULL
            activation_day = dateTime,  -- Actualiza el campo activate_day con dateTime
            activation_ip = ip                    -- Actualiza el campo ip
        WHERE pk_user = found_pk_user;
    END IF;

    -- Retorna el pk_user (o NULL si no se encontró el registro)
    SELECT found_pk_user AS pk_user, name_user;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_addNewUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_addNewUser`(
    IN userName VARCHAR(100),
    IN userLastName VARCHAR(100),
    IN userEmail VARCHAR(200),
    IN userPassword VARCHAR(100),
    IN activationToken VARCHAR(200),
    IN fk_business INT
)
BEGIN
    DECLARE newPkUser INT;  -- Variable para almacenar el nuevo pk_user

    -- Insertar el nuevo usuario en la tabla users
    INSERT INTO users (name, last_name, email, status,activation_token,fk_business)
    VALUES (userName, userLastName, userEmail, 0,activationToken,fk_business);

    -- Obtener el nuevo pk_user
    SET newPkUser = LAST_INSERT_ID();  -- Guardar el ID del nuevo registro

    -- Insertar el nuevo usuario en la tabla user_login
    INSERT INTO user_login (fk_user, email, pass)
    VALUES (newPkUser, userEmail, userPassword);

    -- Seleccionar el nuevo pk_user
    SELECT newPkUser AS newPkUser;  -- Regresar el ID del nuevo registro
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_getActivationTokenByEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_getActivationTokenByEmail`(IN input_email VARCHAR(200))
BEGIN
    DECLARE found_token VARCHAR(255);

    -- Busca el activation_token para la cuenta inactiva con el email proporcionado
    SELECT activation_token INTO found_token
    FROM users
    WHERE email = input_email AND status = 0;

    -- Retorna el token encontrado o NULL si no cumple las condiciones
    SELECT found_token AS activationToken;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_getUserEmailByPK` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_getUserEmailByPK`(
    IN p_pk_user_login INT
)
BEGIN
    SELECT email
    FROM users
    WHERE pk_user = p_pk_user_login;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_inserNewUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_inserNewUser`(IN userName VARCHAR(100), IN userLastName VARCHAR(100), IN userEmail VARCHAR(200))
BEGIN
    INSERT INTO users (name, last_name, email, status)
    VALUES (userName, userLastName, userEmail, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_resetUpdatePasswordByUserID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_resetUpdatePasswordByUserID`(
    IN in_fk_user INT,        -- El ID del usuario (Primary Key)
    IN in_passHash VARCHAR(100) -- El nuevo hash del password
)
BEGIN
    DECLARE success BOOLEAN DEFAULT FALSE;

    -- Intentamos actualizar directamente la tabla de credenciales
    UPDATE user_login
    SET pass = in_passHash
    WHERE fk_user = in_fk_user;

    -- ROW_COUNT() devuelve cuántas filas fueron afectadas por el UPDATE
    IF ROW_COUNT() > 0 THEN
        SET success = TRUE;
        
        -- Opcional: En un WMS, por seguridad, aquí podrías limpiar el token de recuperación
        -- UPDATE users SET recover_token = NULL WHERE pk_user = in_fk_user;
    END IF;

    -- Retorna el estatus de la operación
    SELECT success AS password_updated;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_validateAccountAndSetTokenToRecoverPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_validateAccountAndSetTokenToRecoverPassword`(
    IN email_input VARCHAR(200),
    IN recoverTokenID VARCHAR(45)
)
BEGIN
    DECLARE found_pk_user INT DEFAULT 0;

    -- Busca el pk_user usando el email proporcionado
    SELECT pk_user INTO found_pk_user
    FROM users
    WHERE email = email_input
    LIMIT 1;

    -- Si el pk_user existe, realiza la actualización
    IF found_pk_user IS NOT NULL THEN
        UPDATE users
        SET recover_token = recoverTokenID
        WHERE pk_user = found_pk_user;

        -- Verifica si la actualización fue exitosa
        IF ROW_COUNT() > 0 THEN
            -- Retorna el pk_user del registro actualizado
            SELECT found_pk_user AS pk_user;
        ELSE
            -- Si no se actualizó, retorna 0
            SELECT 0 AS pk_user;
        END IF;
    ELSE
        -- Si no existe el email, retorna 0
        SELECT 0 AS pk_user;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_validateIFExistUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_validateIFExistUser`(IN p_email VARCHAR(255))
BEGIN
    -- 1. Declarar TODAS las variables necesarias
    DECLARE total_records INT DEFAULT 0;
    DECLARE user_status INT DEFAULT 0;
    DECLARE id_user INT DEFAULT 0;
    DECLARE name_user VARCHAR(200) DEFAULT '';
    DECLARE v_business_id INT DEFAULT 0; -- Variable que faltaba

    -- 2. Obtener datos (Asegurar que el orden de SELECT coincida con el de INTO)
    SELECT 
        COUNT(*), 
        status, 
        pk_user, 
        name, 
        fk_business
    INTO 
        total_records, 
        user_status, 
        id_user, 
        name_user, 
        v_business_id -- Mapeo correcto 1:1
    FROM 
        users
    WHERE 
        email = p_email OR pk_user = p_email
    LIMIT 1; -- Buena práctica cuando usas INTO

    -- 3. Retornar los resultados usando las variables locales
    SELECT 
        id_user, 
        total_records AS existe, 
        user_status AS status, 
        name_user, 
        v_business_id AS business_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accounts_validatePassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `accounts_validatePassword`(IN p_user_id INT)
BEGIN
    SELECT pass AS password_hash 
    FROM user_login 
    WHERE fk_user = p_user_id; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAllUserRecords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `deleteAllUserRecords`()
BEGIN
    -- Deshabilitar las verificaciones de claves foráneas temporalmente
    SET FOREIGN_KEY_CHECKS = 0;
    SET SQL_SAFE_UPDATES = 0;
    
    -- Borrar registros en orden, comenzando por las tablas que dependen de otras
    DELETE FROM user_login;  -- Tabla que depende de `users`
    DELETE FROM user_session;   -- Otra tabla que depende de `users`
    DELETE FROM users;       -- Tabla principal

    -- Volver a habilitar las verificaciones de claves foráneas
    SET FOREIGN_KEY_CHECKS = 1;
    SET SQL_SAFE_UPDATES = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `session_getLoginDatetime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `session_getLoginDatetime`(
    IN pk_user_session_id VARCHAR(45),            -- Clave primaria de la sesión de usuario
    IN fk_user_id VARCHAR(45),                    -- Clave foránea del usuario
    IN token_session_back_id VARCHAR(255)  -- Token de sesión trasera
)
BEGIN
    -- Consulta para obtener el login_datetime
    SELECT login_datetime
    FROM user_session
    WHERE pk_user_session = pk_user_session_id
      AND fk_user = fk_user_id
      AND token_session_back = token_session_back_id
    LIMIT 1;  -- Limita la consulta a un solo resultado, por si existen registros duplicados
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `session_registry_new_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `session_registry_new_session`(
    IN fk_user INT,              -- Clave foránea del usuario
    IN login_datetime DATETIME,    -- Fecha y hora de inicio de sesión
    IN user_agent VARCHAR(250)	  -- User-Agent 
)
BEGIN
    DECLARE new_pk_user_session INT;

    -- Inserta una nueva sesión de usuario
    INSERT INTO user_session (fk_user, token_session_front, login_datetime, token_session_back,user_agent)
    VALUES (fk_user, UUID(), login_datetime, UUID(),user_agent);  -- Suponiendo que token_session_front y token_session_back son UUIDs

    -- Obtiene el pk_user_session generado por la inserción
    SET new_pk_user_session = LAST_INSERT_ID();

    -- Retorna el pk_user_session generado
    SELECT new_pk_user_session AS pk_user_session;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `session_update_user_session` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `session_update_user_session`(
    IN session_id INT,          -- Clave primaria de la sesión de usuario
    IN token_session_front VARCHAR(255),  -- Nuevo token de sesión frontal
    IN token_session_back VARCHAR(255)   -- Nuevo token de sesión trasera
)
BEGIN
    DECLARE updated_rows INT DEFAULT 0;  -- Variable para contar filas actualizadas

    -- Actualiza los tokens de sesión en la tabla user_session
    UPDATE user_session
    SET token_session_front = token_session_front,
        token_session_back = token_session_back
    WHERE pk_user_session = session_id;

    -- Obtiene el número de filas afectadas
    SET updated_rows = ROW_COUNT();

    -- Retorna TRUE si se actualizó al menos una fila, de lo contrario FALSE
    IF updated_rows > 0 THEN
        SELECT TRUE AS update_successful;  -- Indica que la actualización fue exitosa
    ELSE
        SELECT FALSE AS update_successful;  -- Indica que no se actualizó ninguna fila
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_capillas_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_capillas_listar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_distritos_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_distritos_listar`()
BEGIN
  SELECT
    d.id_distrito,
    d.distrito_pais
  FROM wms_distritos d
  WHERE d.status = 1
  ORDER BY d.distrito_pais;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_fichas_pago_listar_por_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_fichas_pago_listar_por_proyecto`(
  IN p_fk_proyecto INT UNSIGNED,
  IN p_limit       INT UNSIGNED,
  IN p_offset      INT UNSIGNED
)
BEGIN
  SET @fp_fk_proyecto = p_fk_proyecto;
  SET @fp_limit = p_limit;
  SET @fp_offset = p_offset;

  PREPARE stmt FROM
    'SELECT
      id_ficha_pago,
      folio_qr,
      fk_proyecto,
      donante_nombre,
      donante_apellidos,
      donante_correo,
      donante_telefono,
      monto,
      estatus_pago,
      fecha_registro,
      fecha_pago,
      COUNT(*) OVER() AS total_donaciones
    FROM wms_donaciones_fichas_pago
    WHERE fk_proyecto = ?
      AND estatus_pago = ''pagado''
      AND status = 1
    ORDER BY fecha_pago ASC
    LIMIT ? OFFSET ?';

  EXECUTE stmt USING @fp_fk_proyecto, @fp_limit, @fp_offset;
  DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_ficha_pago_actualizar_estatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_ficha_pago_actualizar_estatus`(
  IN p_folio_qr    VARCHAR(40),
  IN p_estatus_pago ENUM('pendiente','pagado')
)
BEGIN
  UPDATE wms_donaciones_fichas_pago
  SET
    estatus_pago = p_estatus_pago,
    fecha_pago   = CASE WHEN p_estatus_pago = 'pagado' THEN NOW() ELSE fecha_pago END
  WHERE folio_qr = p_folio_qr
    AND status = 1;

  SELECT
    id_ficha_pago,
    folio_qr,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_fichas_pago
  WHERE folio_qr = p_folio_qr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_ficha_pago_consultar_por_folio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_ficha_pago_consultar_por_folio`(
  IN p_folio_qr VARCHAR(40)
)
BEGIN
  SELECT
    fp.id_ficha_pago,
    fp.folio_qr,
    fp.fk_proyecto,
    fp.donante_nombre,
    fp.donante_apellidos,
    fp.donante_correo,
    fp.donante_telefono,
    fp.monto,
    fp.moneda,
    fp.estatus_pago,
    fp.fecha_registro,
    fp.fecha_pago,
    p.proyecto_titulo,
    p.proyecto_imagen,
    p.tipo_proyecto
  FROM wms_donaciones_fichas_pago fp
  INNER JOIN wms_donaciones_proyectos p ON p.id_proyecto = fp.fk_proyecto
  WHERE fp.folio_qr = p_folio_qr
    AND fp.status = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_ficha_pago_eliminar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_ficha_pago_eliminar`(
  IN p_id_ficha_pago INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_fichas_pago
  WHERE id_ficha_pago = p_id_ficha_pago;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_ficha_pago_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_ficha_pago_insertar`(
  IN p_folio_qr          VARCHAR(40),
  IN p_fk_proyecto       INT UNSIGNED,
  IN p_donante_nombre    VARCHAR(100),
  IN p_donante_apellidos VARCHAR(100),
  IN p_donante_correo    VARCHAR(150),
  IN p_donante_telefono  VARCHAR(20),
  IN p_monto             DECIMAL(12,2),
  IN p_moneda            CHAR(3)
)
BEGIN
  INSERT INTO wms_donaciones_fichas_pago (
    folio_qr, fk_proyecto,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda
  ) VALUES (
    p_folio_qr, p_fk_proyecto,
    p_donante_nombre, p_donante_apellidos, p_donante_correo, p_donante_telefono,
    p_monto, p_moneda
  );

  SELECT
    id_ficha_pago,
    folio_qr,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_fichas_pago
  WHERE id_ficha_pago = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_montos_sugeridos_consultar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_montos_sugeridos_consultar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_montos_sugeridos_eliminar_por_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_montos_sugeridos_eliminar_por_proyecto`(
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_montos_sugeridos
  WHERE fk_proyecto = p_fk_proyecto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_monto_sugerido_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_monto_sugerido_insertar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pagos_listar_por_proyecto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pagos_listar_por_proyecto`(
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
    ) AS combinado
    ORDER BY combinado.fecha_pago ASC
    LIMIT ? OFFSET ?';

  EXECUTE stmt USING @dp_fk_proyecto, @dp_fk_proyecto, @dp_limit, @dp_offset;
  DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pago_stripe_actualizar_estatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pago_stripe_actualizar_estatus`(
  IN p_stripe_payment_intent_id VARCHAR(100),
  IN p_estatus_pago ENUM('pendiente','pagado','fallido','cancelado')
)
BEGIN
  UPDATE wms_donaciones_pagos_stripe
  SET
    estatus_pago = p_estatus_pago,
    fecha_pago   = CASE WHEN p_estatus_pago = 'pagado' THEN NOW() ELSE fecha_pago END
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id
    AND status = 1;

  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pago_stripe_consultar_por_folio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pago_stripe_consultar_por_folio`(
  IN p_folio_stripe VARCHAR(40)
)
BEGIN
  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE folio_stripe = p_folio_stripe
    AND status = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pago_stripe_consultar_por_payment_intent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pago_stripe_consultar_por_payment_intent`(
  IN p_stripe_payment_intent_id VARCHAR(100)
)
BEGIN
  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE stripe_payment_intent_id = p_stripe_payment_intent_id
    AND status = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pago_stripe_eliminar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pago_stripe_eliminar`(
  IN p_id_pago_stripe INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_pagos_stripe
  WHERE id_pago_stripe = p_id_pago_stripe;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_pago_stripe_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_pago_stripe_insertar`(
  IN p_folio_stripe             VARCHAR(40),
  IN p_fk_proyecto              INT UNSIGNED,
  IN p_donante_nombre           VARCHAR(100),
  IN p_donante_apellidos        VARCHAR(100),
  IN p_donante_correo           VARCHAR(150),
  IN p_donante_telefono         VARCHAR(20),
  IN p_monto                    DECIMAL(12,2),
  IN p_moneda                   CHAR(3),
  IN p_stripe_payment_intent_id VARCHAR(100)
)
BEGIN
  INSERT INTO wms_donaciones_pagos_stripe (
    folio_stripe, fk_proyecto,
    donante_nombre, donante_apellidos, donante_correo, donante_telefono,
    monto, moneda, stripe_payment_intent_id
  ) VALUES (
    p_folio_stripe, p_fk_proyecto,
    p_donante_nombre, p_donante_apellidos, p_donante_correo, p_donante_telefono,
    p_monto, p_moneda, p_stripe_payment_intent_id
  );

  SELECT
    id_pago_stripe,
    folio_stripe,
    fk_proyecto,
    donante_nombre,
    donante_apellidos,
    donante_correo,
    donante_telefono,
    monto,
    moneda,
    stripe_payment_intent_id,
    estatus_pago,
    fecha_registro,
    fecha_pago
  FROM wms_donaciones_pagos_stripe
  WHERE id_pago_stripe = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyectos_consultar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyectos_consultar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyectos_desasignar_cuenta_stripe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyectos_desasignar_cuenta_stripe`(
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET fk_stripe_cuenta = NULL
  WHERE fk_stripe_cuenta = p_id_cuenta_stripe;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyectos_listar_para_asignar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyectos_listar_para_asignar`()
BEGIN
  SELECT id_proyecto, proyecto_titulo, fk_stripe_cuenta
  FROM wms_donaciones_proyectos
  WHERE status = 1
  ORDER BY proyecto_titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyecto_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyecto_actualizar`(
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
  IN p_fk_stripe_cuenta   INT UNSIGNED
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
    fk_stripe_cuenta     = p_fk_stripe_cuenta
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
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyecto_actualizar_estado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyecto_actualizar_estado`(
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
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyecto_asignar_cuenta_stripe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyecto_asignar_cuenta_stripe`(
  IN p_id_proyecto      INT UNSIGNED,
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_proyectos
  SET fk_stripe_cuenta = p_id_cuenta_stripe
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyecto_detalle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyecto_detalle`(
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
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = p_id_proyecto
    AND status = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_proyecto_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_proyecto_insertar`(
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
  IN p_fk_stripe_cuenta   INT UNSIGNED
)
BEGIN
  INSERT INTO wms_donaciones_proyectos (
    fk_distrito,
    proyecto_titulo, proyecto_descripcion, proyecto_imagen,
    tipo_proyecto, proyecto_estado, moneda, mostrar_meta, mostrar_totalrecaudado,
    proyecto_meta, proyecto_fecha_limite,
    rifa_rango_inicio, rifa_rango_fin, rifa_total_boletos,
    fk_stripe_cuenta
  ) VALUES (
    p_fk_distrito,
    p_titulo, p_descripcion, p_imagen,
    p_tipo_proyecto, p_estado, p_moneda, p_mostrar_meta, p_mostrar_totalrecaudado,
    p_meta, p_fecha_limite,
    p_rifa_rango_inicio, p_rifa_rango_fin, p_rifa_total_boletos,
    p_fk_stripe_cuenta
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
    ) AS proyecto_recaudado,
    proyecto_fecha_limite,
    rifa_rango_inicio,
    rifa_rango_fin,
    rifa_total_boletos,
    fecha_registro
  FROM wms_donaciones_proyectos
  WHERE id_proyecto = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_rifa_boletos_consultar_por_pago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_rifa_boletos_consultar_por_pago`(
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  SELECT
    numero_boleto,
    tipo_seleccion,
    estatus
  FROM wms_donaciones_rifa_boletos
  WHERE ((p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
      OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe))
  ORDER BY numero_boleto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_rifa_boletos_liberar_por_pago` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_rifa_boletos_liberar_por_pago`(
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_rifa_boletos
  WHERE (p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
     OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_rifa_boletos_marcar_vendidos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_rifa_boletos_marcar_vendidos`(
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_rifa_boletos
  SET estatus = 'vendido'
  WHERE ((p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
      OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_rifa_boletos_ocupados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_rifa_boletos_ocupados`(
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  SELECT
    numero_boleto,
    estatus
  FROM wms_donaciones_rifa_boletos
  WHERE fk_proyecto = p_fk_proyecto
  ORDER BY numero_boleto;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_rifa_boleto_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_rifa_boleto_insertar`(
  IN p_fk_proyecto    INT UNSIGNED,
  IN p_numero_boleto  INT UNSIGNED,
  IN p_tipo_seleccion ENUM('manual','azar'),
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED,
  IN p_estatus        ENUM('apartado','vendido')
)
BEGIN
  INSERT INTO wms_donaciones_rifa_boletos (
    fk_proyecto, numero_boleto, tipo_seleccion, metodo_pago,
    fk_ficha_pago, fk_pago_stripe, estatus
  ) VALUES (
    p_fk_proyecto, p_numero_boleto, p_tipo_seleccion, p_metodo_pago,
    p_fk_ficha_pago, p_fk_pago_stripe, p_estatus
  );

  SELECT
    id_boleto,
    fk_proyecto,
    numero_boleto,
    tipo_seleccion,
    metodo_pago,
    fk_ficha_pago,
    fk_pago_stripe,
    estatus,
    fecha_registro
  FROM wms_donaciones_rifa_boletos
  WHERE id_boleto = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuentas_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuentas_listar`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuentas_listar_por_distrito` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuentas_listar_por_distrito`(
  IN p_fk_distrito INT UNSIGNED
)
BEGIN
  SELECT id_cuenta_stripe, nombre_cuenta, es_default
  FROM wms_donaciones_stripe_cuentas
  WHERE fk_distrito = p_fk_distrito
    AND status = 1
  ORDER BY es_default DESC, nombre_cuenta ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuenta_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuenta_actualizar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuenta_detalle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuenta_detalle`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuenta_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuenta_insertar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_donaciones_stripe_cuenta_proyectos_asignados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_donaciones_stripe_cuenta_proyectos_asignados`(
  IN p_id_cuenta_stripe INT UNSIGNED
)
BEGIN
  SELECT id_proyecto, proyecto_titulo
  FROM wms_donaciones_proyectos
  WHERE fk_stripe_cuenta = p_id_cuenta_stripe
    AND status = 1
  ORDER BY proyecto_titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_history_consult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_history_consult`(
    IN p_fk_business INT,
    IN p_event_type INT,            -- Puede venir NULL desde PHP
    IN p_fk_catalogo_pantallas INT, -- Puede venir NULL desde PHP
    IN p_limit INT                  -- Puede venir NULL desde PHP
)
BEGIN
    -- Si p_limit es NULL, le asignamos un valor máximo para traer todos los registros
    -- Usamos una variable local para asegurar la compatibilidad
    DECLARE v_limit BIGINT;
    SET v_limit = IFNULL(p_limit, 18446744073709551615);

    SELECT 
        h.idwms_history,
        h.fk_business,
        h.fk_usuario,
        u.name AS usuario_nombre,
        h.event_type,
        h.fk_catalogo_pantallas,
        h.proceso,
        h.proceso_descripcion,
        h.datetime_reg
    FROM wms_history h
    LEFT JOIN users u ON h.fk_usuario = u.pk_user
    WHERE h.fk_business = p_fk_business
      AND (p_event_type IS NULL OR h.event_type = p_event_type)
      AND (p_fk_catalogo_pantallas IS NULL OR h.fk_catalogo_pantallas = p_fk_catalogo_pantallas)
    ORDER BY h.datetime_reg DESC, h.idwms_history DESC
    LIMIT v_limit; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_history_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_history_insert`(
    IN p_fk_business INT,
    IN p_fk_usuario INT,
    IN p_event_type INT,
    IN p_fk_catalogo_pantallas INT,
    IN p_proceso VARCHAR(100),
    IN p_proceso_descripcion VARCHAR(100)
)
BEGIN
    INSERT INTO wms_history (
        fk_business, 
        fk_usuario, 
        event_type, 
        fk_catalogo_pantallas, 
        proceso, 
        proceso_descripcion,
        datetime_reg
    ) 
    VALUES (
        p_fk_business, 
        p_fk_usuario, 
        p_event_type, 
        p_fk_catalogo_pantallas, 
        p_proceso, 
        p_proceso_descripcion,
        NOW()
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_horarios_misa_actualizar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_horarios_misa_actualizar`(
  IN p_id_horario         INT UNSIGNED,
  IN p_fk_capilla         INT UNSIGNED,
  IN p_fk_tipo_actividad  INT UNSIGNED,
  IN p_dia_semana         TINYINT UNSIGNED,
  IN p_hora               TIME
)
BEGIN
  UPDATE wms_horarios_misa
  SET
    fk_capilla        = p_fk_capilla,
    fk_tipo_actividad = p_fk_tipo_actividad,
    horario_dia_semana = p_dia_semana,
    horario_hora      = p_hora
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_horarios_misa_consultar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_horarios_misa_consultar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_horarios_misa_eliminar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_horarios_misa_eliminar`(
  IN p_id_horario INT UNSIGNED
)
BEGIN
  UPDATE wms_horarios_misa SET status = 0 WHERE id_horario = p_id_horario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_horarios_misa_insertar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_horarios_misa_insertar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_prioratos_listar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_prioratos_listar`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_update_file_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_update_file_status`(
    IN p_archivo VARCHAR(255),
    IN p_estado INT
)
BEGIN
    UPDATE wms_files 
    SET estado = p_estado 
    WHERE id_file = p_archivo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wms_uploadfiles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`watchusr`@`%` PROCEDURE `wms_uploadfiles`(
    IN p_archivo VARCHAR(255),
    IN p_nombre_archivo VARCHAR(255),
    IN p_categoria VARCHAR(100),
    IN p_estado TINYINT,
    IN p_fk_usuario INT,
    IN p_fk_business INT
)
BEGIN
    INSERT INTO wms_files (
        archivo, 
        nombre_archivo,
        categoria, 
        fecha, 
        estado, 
        fk_usuario, 
        fk_business
    ) 
    VALUES (
        p_archivo, 
        p_nombre_archivo,
        p_categoria, 
        NOW(), 
        p_estado, 
        p_fk_usuario, 
        p_fk_business
    );
    
    -- Retornamos el ID para que tu Backend sepa qué registro actualizar luego
    SELECT LAST_INSERT_ID() AS last_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-10 13:07:27
