-- ============================================================
-- MODULO: Donaciones - Boletos de Rifa
-- Archivo ADITIVO: requiere que wms_donaciones_proyectos, wms_donaciones_fichas_pago
-- (wms_donaciones_pagos.tables.sql) y wms_donaciones_pagos_stripe
-- (wms_donaciones_pagos_stripe.tables.sql) ya existan.
--
-- Diseño: tabla DISPERSA (sparse), no una fila por cada numero posible del rango de la rifa
-- (rifa_rango_inicio..rifa_rango_fin, que puede ser de decenas de miles). Un numero de boleto
-- solo tiene fila aqui cuando alguien lo aparto/compro -- "disponible" simplemente significa
-- "no existe fila para ese numero". Esto evita pre-poblar 25,000+ filas por rifa y escala igual
-- sin importar el tamaño del rango.
--
-- Un boleto queda ligado a UNA orden de pago (QR o Stripe), nunca a ambas -- por eso
-- fk_ficha_pago/fk_pago_stripe son mutuamente excluyentes (ver chk_boleto_metodo_pago). Los
-- datos del donante NO se duplican aqui: se consultan via JOIN a la ficha/pago correspondiente.
--
-- Ciclo de vida de estatus:
--   'apartado' = la orden de pago se creo (ficha QR o PaymentIntent de Stripe) pero aun no se
--                confirma el pago. El numero ya NO esta disponible para nadie mas.
--   'vendido'  = el pago se confirmo (QR: wms_donaciones_ficha_pago_actualizar_estatus a
--                'pagado'; Stripe: webhook payment_intent.succeeded).
-- Si un pago con Stripe falla/se cancela, sus filas se BORRAN (no hay estado "liberado": no
-- tiene caso guardar historial de numeros que nunca se llegaron a vender) para regresar esos
-- numeros al pool de disponibles -- ver wms_donaciones_rifa_boletos_liberar_por_pago.
--
-- Expiracion de 'apartado' (reserva de 10 minutos): carrito_token identifica el INTENTO de
-- compra (se genera en el navegador la primera vez que el donante le da "Pagar", sin importar
-- el metodo elegido, y viaja a ambos flujos de generacion de pago). fecha_registro es el inicio
-- real del conteo de 10 minutos -- se PRESERVA (nunca se reinicia) aunque el donante cambie de
-- metodo de pago a medio camino (ver Donaciones::reservarBoletosRifa()/prepararReservaCarrito()).
-- Un 'apartado' con fecha_registro de mas de 10 minutos se trata como libre/expirado: se excluye
-- de wms_donaciones_rifa_boletos_ocupados y se borra perezosamente (justo antes de que alguien
-- mas lo quiera) en wms_donaciones_rifa_boleto_insertar -- sin necesidad de un cron de limpieza.
-- ============================================================

DROP TABLE IF EXISTS wms_donaciones_rifa_boletos;

-- --------------------------------------------------------
-- Tabla: wms_donaciones_rifa_boletos
-- Una fila = un numero de boleto ya apartado o vendido para una rifa.
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_rifa_boletos (
  id_boleto        INT UNSIGNED NOT NULL AUTO_INCREMENT,

  fk_proyecto      INT UNSIGNED NOT NULL,
  numero_boleto    INT UNSIGNED NOT NULL,

  -- 'manual' = el donante tecleo el numero exacto ("Ingresar número deseado").
  -- 'azar'   = se le asigno con "Selección rápida al azar" (+1/+3/+5 boletos).
  tipo_seleccion   ENUM('manual','azar') NOT NULL DEFAULT 'manual',

  -- Mismo discriminador que wms_donaciones_pagos_listar_por_proyecto: exactamente uno de
  -- fk_ficha_pago / fk_pago_stripe va lleno segun metodo_pago (ver chk_boleto_metodo_pago).
  metodo_pago      ENUM('qr','stripe') NOT NULL,
  fk_ficha_pago    INT UNSIGNED NULL,
  fk_pago_stripe   INT UNSIGNED NULL,

  estatus          ENUM('apartado','vendido') NOT NULL DEFAULT 'apartado',

  -- Identifica el intento de compra (se genera en el navegador, no en el servidor) -- el mismo
  -- token viaja sin importar cuantas veces el donante cambie de metodo de pago antes de pagar,
  -- para poder reconocer "esto sigue siendo la misma reserva" y no reiniciar su conteo de 10 min.
  carrito_token    VARCHAR(40) NULL,

  fecha_registro   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id_boleto),
  -- Es la que de verdad evita que dos ordenes se queden con el mismo numero (ultima linea de
  -- defensa ante una condicion de carrera; la validacion de disponibilidad en PHP es la primera).
  UNIQUE KEY uq_boleto_proyecto_numero (fk_proyecto, numero_boleto),
  KEY idx_boleto_ficha (fk_ficha_pago),
  KEY idx_boleto_stripe (fk_pago_stripe),
  KEY idx_boleto_carrito (fk_proyecto, carrito_token),
  CONSTRAINT fk_rifa_boletos_proyecto
    FOREIGN KEY (fk_proyecto) REFERENCES wms_donaciones_proyectos (id_proyecto),
  CONSTRAINT fk_rifa_boletos_ficha
    FOREIGN KEY (fk_ficha_pago) REFERENCES wms_donaciones_fichas_pago (id_ficha_pago) ON DELETE CASCADE,
  CONSTRAINT fk_rifa_boletos_stripe
    FOREIGN KEY (fk_pago_stripe) REFERENCES wms_donaciones_pagos_stripe (id_pago_stripe) ON DELETE CASCADE,
  CONSTRAINT chk_boleto_metodo_pago CHECK (
    (metodo_pago = 'qr'     AND fk_ficha_pago  IS NOT NULL AND fk_pago_stripe IS NULL) OR
    (metodo_pago = 'stripe' AND fk_pago_stripe IS NOT NULL AND fk_ficha_pago  IS NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
