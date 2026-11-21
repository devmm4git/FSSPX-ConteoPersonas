-- ============================================================
-- MODULO: Donaciones - Boletos de Rifa - Procedures
-- Requiere que la tabla de wms_donaciones_rifa_boletos.tables.sql ya exista.
-- ============================================================

DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boletos_ocupados;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boleto_insertar;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boletos_liberar_por_pago;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boletos_liberar_por_carrito;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_carrito_consultar;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boletos_marcar_vendidos;
DROP PROCEDURE IF EXISTS wms_donaciones_rifa_boletos_consultar_por_pago;

DELIMITER $$

-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boletos_ocupados
-- Regresa los numeros ya apartados/vendidos de una rifa (tabla dispersa: un numero que no
-- aparece aqui esta disponible). El frontend (mobile.dash.donaciones.detalle.js) usa esta misma
-- lista para pintar la cuadricula por millar, calcular "Libres" y elegir al azar -- todo eso se
-- resuelve del lado del cliente contra este único listado, sin otro endpoint mas.
--
-- Un 'apartado' con mas de 10 minutos desde fecha_registro se trata como expirado/libre (el
-- donante abandono el pago sin completarlo ni fallarlo) -- NO aparece aqui, aunque la fila siga
-- en la tabla hasta que alguien la reutilice (ver wms_donaciones_rifa_boleto_insertar, que la
-- borra perezosamente justo antes de insertar la nueva reserva de ese numero).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boletos_ocupados (
  IN p_fk_proyecto INT UNSIGNED
)
BEGIN
  SELECT
    numero_boleto,
    estatus
  FROM wms_donaciones_rifa_boletos
  WHERE fk_proyecto = p_fk_proyecto
    AND (estatus = 'vendido' OR (estatus = 'apartado' AND fecha_registro >= (NOW() - INTERVAL 10 MINUTE)))
  ORDER BY numero_boleto;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boleto_insertar
-- Aparta UN numero de boleto para una orden de pago ya creada (QR o Stripe). El controller la
-- llama una vez por cada numero del carrito, dentro de Donaciones::reservarBoletosRifa() --
-- mismo patron que insertMontosSugeridos() inserta un monto sugerido a la vez.
--
-- p_carrito_token identifica el intento de compra (viaja igual sin importar el metodo de pago
-- elegido). p_fecha_registro es opcional: si el controller ya sabe que este carrito_token viene
-- de un intento anterior (el donante cambio de metodo de pago), manda la fecha_registro ORIGINAL
-- para que el conteo de 10 minutos no se reinicie; si es NULL (primer intento) se usa NOW().
--
-- Antes de insertar, se borra cualquier fila 'apartado' de ESTE MISMO numero que ya haya
-- expirado (>10 min) -- limpieza perezosa: como no hay cron, este es el momento natural en que
-- un numero abandonado por otro donante se libera de verdad para poder volver a apartarse.
--
-- La UNIQUE KEY (fk_proyecto, numero_boleto) es quien de verdad evita un doble-apartado en una
-- condicion de carrera: si el numero se ocupo entre la validacion de disponibilidad en PHP y
-- este INSERT, MySQL rechaza el INSERT con un error de llave duplicada, que PHP captura para
-- deshacer (con wms_donaciones_rifa_boletos_liberar_por_pago) los numeros que sí se alcanzaron
-- a insertar en esa misma orden.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boleto_insertar (
  IN p_fk_proyecto    INT UNSIGNED,
  IN p_numero_boleto  INT UNSIGNED,
  IN p_tipo_seleccion ENUM('manual','azar'),
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED,
  IN p_estatus        ENUM('apartado','vendido'),
  IN p_carrito_token  VARCHAR(40),
  IN p_fecha_registro DATETIME
)
BEGIN
  DELETE FROM wms_donaciones_rifa_boletos
  WHERE fk_proyecto = p_fk_proyecto
    AND numero_boleto = p_numero_boleto
    AND estatus = 'apartado'
    AND fecha_registro < (NOW() - INTERVAL 10 MINUTE);

  INSERT INTO wms_donaciones_rifa_boletos (
    fk_proyecto, numero_boleto, tipo_seleccion, metodo_pago,
    fk_ficha_pago, fk_pago_stripe, estatus, carrito_token, fecha_registro
  ) VALUES (
    p_fk_proyecto, p_numero_boleto, p_tipo_seleccion, p_metodo_pago,
    p_fk_ficha_pago, p_fk_pago_stripe, p_estatus, p_carrito_token,
    COALESCE(p_fecha_registro, NOW())
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
    carrito_token,
    fecha_registro
  FROM wms_donaciones_rifa_boletos
  WHERE id_boleto = LAST_INSERT_ID();
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boletos_liberar_por_pago
-- Borra (hard delete) todos los boletos ligados a una orden de pago, regresando esos numeros
-- al pool de disponibles. Dos usos:
--  1) Rollback: una reserva parcial fallo a medio carrito (ver wms_donaciones_rifa_boleto_insertar)
--     y hay que deshacer los numeros que sí se alcanzaron a insertar en esa misma orden.
--  2) Un pago con Stripe termina en 'fallido'/'cancelado' (ver Donaciones::actualizarEstatusPagoStripe()).
-- Exactamente uno de p_fk_ficha_pago / p_fk_pago_stripe va lleno segun p_metodo_pago (el otro NULL).
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boletos_liberar_por_pago (
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  DELETE FROM wms_donaciones_rifa_boletos
  WHERE (p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
     OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe);
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boletos_liberar_por_carrito
-- Borra (hard delete) todos los boletos 'apartado' de un carrito_token, SIN importar bajo cual
-- metodo de pago quedaron reservados -- usado cuando el donante cambia de metodo de pago
-- (ver Donaciones::prepararReservaCarrito()): se libera la orden vieja (ej. el PaymentIntent de
-- Stripe que no completo) justo antes de volver a reservar los mismos numeros bajo el nuevo
-- metodo, conservando la fecha_registro original para no reiniciar el conteo de 10 minutos.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boletos_liberar_por_carrito (
  IN p_carrito_token VARCHAR(40)
)
BEGIN
  DELETE FROM wms_donaciones_rifa_boletos
  WHERE carrito_token = p_carrito_token
    AND estatus = 'apartado';
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_carrito_consultar
-- Trae los numeros 'apartado' (no vencidos, <10 min) de un carrito_token -- usado por
-- mobile.dash.donaciones.detalle.js para restaurar el carrito del donante cuando regresa a esta
-- pantalla (ej. le dio "atrás" en la pantalla de pago para cambiar de método) sin haber
-- completado el pago: el conteo de 10 minutos se calcula en PHP a partir del MIN(fecha_registro)
-- de estas filas.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_carrito_consultar (
  IN p_fk_proyecto   INT UNSIGNED,
  IN p_carrito_token VARCHAR(40)
)
BEGIN
  SELECT
    numero_boleto,
    tipo_seleccion,
    fecha_registro
  FROM wms_donaciones_rifa_boletos
  WHERE fk_proyecto = p_fk_proyecto
    AND carrito_token = p_carrito_token
    AND estatus = 'apartado'
    AND fecha_registro >= (NOW() - INTERVAL 10 MINUTE)
  ORDER BY numero_boleto;
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boletos_marcar_vendidos
-- Pasa a 'vendido' todos los boletos de una orden de pago ya confirmada (QR: personal de la
-- libreria confirma el pago; Stripe: webhook payment_intent.succeeded). Es un UPDATE inofensivo
-- (0 filas afectadas) para proyectos que no son rifa, asi que se puede llamar sin condicionar
-- primero por tipo_proyecto.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boletos_marcar_vendidos (
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  UPDATE wms_donaciones_rifa_boletos
  SET estatus = 'vendido'
  WHERE ((p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
      OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe));
END$$


-- --------------------------------------------------------
-- Procedure: wms_donaciones_rifa_boletos_consultar_por_pago
-- Lista los numeros de boleto de UNA orden de pago (QR o Stripe) -- usado para mostrarle al
-- donante "Tus boletos: 05890, 12404" en la pantalla del QR y en la respuesta del checkout.
-- --------------------------------------------------------
CREATE PROCEDURE wms_donaciones_rifa_boletos_consultar_por_pago (
  IN p_metodo_pago    ENUM('qr','stripe'),
  IN p_fk_ficha_pago  INT UNSIGNED,
  IN p_fk_pago_stripe INT UNSIGNED
)
BEGIN
  SELECT
    numero_boleto,
    tipo_seleccion,
    estatus,
    fecha_registro
  FROM wms_donaciones_rifa_boletos
  WHERE ((p_metodo_pago = 'qr'     AND fk_ficha_pago  = p_fk_ficha_pago)
      OR (p_metodo_pago = 'stripe' AND fk_pago_stripe = p_fk_pago_stripe))
  ORDER BY numero_boleto;
END$$

DELIMITER ;
