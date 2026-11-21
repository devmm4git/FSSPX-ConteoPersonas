-- ============================================================
-- MODULO: Donaciones (Gestion de Donaciones)
-- Requiere que wms_distritos ya exista (ver wms_horarios_misa.tables.sql), por el
-- FK de wms_donaciones_proyectos.fk_distrito.
-- Jerarquia: wms_donaciones_proyectos (1) --- (N) wms_donaciones_montos_sugeridos
--
-- Nota de diseño sobre los "Montos Sugeridos":
-- Un proyecto puede tener 0..N montos sugeridos, y el administrador puede
-- agregarlos/eliminarlos/actualizarlos libremente desde el formulario. Guardarlos
-- como una sola columna (CSV o JSON) en wms_donaciones_proyectos violaria 1FN y
-- haria muy incomodo agregar/eliminar/editar un monto individual (habria que
-- reescribir la columna completa cada vez, sin poder usar AUTO_INCREMENT/PK por
-- monto, ni indexarlos, ni validar duplicados con una UNIQUE KEY).
-- Por eso se modela como tabla hija 1-N: wms_donaciones_montos_sugeridos,
-- igual que wms_horarios_misa cuelga de wms_capillas.
-- ============================================================

-- --------------------------------------------------------
-- Limpieza previa (permite re-ejecutar este archivo sin errores)
-- Orden inverso a las dependencias de FK
-- --------------------------------------------------------
DROP TABLE IF EXISTS wms_donaciones_montos_sugeridos;
DROP TABLE IF EXISTS wms_donaciones_proyectos;


-- --------------------------------------------------------
-- Tabla: wms_donaciones_proyectos
-- Un proyecto/campaña de recaudación (o donación libre, ver tipo_proyecto).
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_proyectos (
  id_proyecto            INT UNSIGNED NOT NULL AUTO_INCREMENT,

  -- Distrito dueño del proyecto (jerarquia wms_distritos, ver wms_horarios_misa.tables.sql).
  -- Por ahora el frontend manda un valor fijo (1) hasta que exista el selector real de distrito.
  fk_distrito            INT UNSIGNED NOT NULL,

  proyecto_titulo        VARCHAR(150)   NOT NULL,
  proyecto_descripcion   TEXT           NOT NULL,
  proyecto_imagen        VARCHAR(255)   NULL,

  -- Persona de contacto del proyecto (ej. el sacerdote o encargado a cargo) -- ambos opcionales.
  -- responsable_telefono se usa tal cual para armar la liga "https://wa.me/{telefono}" en la app
  -- móvil (ver mobile.dash.donaciones.detalle.js), así que debe capturarse con código de país
  -- (ej. 521XXXXXXXXXX), sin espacios/guiones -- eso se valida/limpia en el frontend al guardar.
  responsable_nombre     VARCHAR(150)   NULL,
  responsable_telefono   VARCHAR(20)    NULL,

  -- 'proyecto'  = campaña con meta de recaudación (ej. Restauración del Altar Mayor)
  -- 'donacion'  = donación abierta, sin meta obligatoria (ej. Renovación de Ornamentos)
  -- 'deposito'  = cuota fija a depositar por evento (ej. costo fijo de un retiro). Reusa
  --               proyecto_meta como "Monto a Depositar"; no usa montos sugeridos.
  -- 'rifa'      = rifa con boletos digitales. Reusa proyecto_meta como meta de recaudación
  --               y usa rifa_total_boletos; solo admite 1 monto sugerido (precio del boleto).
  tipo_proyecto           ENUM('proyecto','donacion','deposito','rifa') NOT NULL DEFAULT 'proyecto',

  -- Estado del ciclo de vida del proyecto dentro del dashboard
  proyecto_estado         ENUM('borrador','activo','pausado','finalizado') NOT NULL DEFAULT 'borrador',

  -- Moneda de referencia del proyecto (minusculas, mismo formato que Stripe espera en su
  -- parametro `currency`: 'usd', 'mxn'). Define en que moneda se muestran los montos de este
  -- proyecto (meta, montos sugeridos) en el frontend y en que moneda se le pide a Stripe que
  -- cobre al generar un PaymentIntent (ver Donaciones::valideParms2GenerarPagoStripe()).
  moneda                  CHAR(3)        NOT NULL DEFAULT 'usd',

  -- Controlan, de forma independiente, si la app móvil (mob/proyectos) le muestra al donante la
  -- meta y/o el total recaudado de este proyecto (ej. una donación libre donde la parroquia no
  -- quiere exponer cifras). DEFAULT 1 en ambas para no cambiar el comportamiento de proyectos ya
  -- existentes ni el de por default en el formulario "Nuevo proyecto".
  mostrar_meta            TINYINT(1)     NOT NULL DEFAULT 1,
  mostrar_totalrecaudado  TINYINT(1)     NOT NULL DEFAULT 1,

  -- Cuenta de Stripe (ver wms_donaciones_stripe_cuentas.tables.sql, archivo ADITIVO que agrega
  -- la FK real via ALTER TABLE -- esa tabla se crea despues de esta, no se puede referenciar
  -- aqui mismo) que se usa al cobrar un PaymentIntent para este proyecto. NULL = usa la cuenta
  -- marcada como default (ver StripeCuentas::obtenerCuentaParaProyecto()).
  fk_stripe_cuenta        INT UNSIGNED   NULL,

  -- Activan/desactivan cada método de pago de forma independiente, por proyecto (ver panel
  -- "Configuración Métodos de Pago" del formulario "Nuevo proyecto" y su reflejo en
  -- mobile.dash.donaciones.detalle.js). DEFAULT 1 en los 4 para no esconder ningún método de los
  -- proyectos ya existentes ni cambiar el comportamiento por default al crear uno nuevo.
  habilitar_stripe        TINYINT(1)     NOT NULL DEFAULT 1,
  habilitar_deposito      TINYINT(1)     NOT NULL DEFAULT 1,
  habilitar_paypal        TINYINT(1)     NOT NULL DEFAULT 1,
  habilitar_libreria      TINYINT(1)     NOT NULL DEFAULT 1,

  proyecto_meta           DECIMAL(12,2)  NULL,      -- NULL cuando el proyecto no maneja meta fija
  -- EN DESUSO: ningun procedure la lee ni la escribe. proyecto_recaudado se calcula EN VIVO
  -- (SUM de wms_donaciones_fichas_pago con estatus_pago='pagado') en wms_donaciones.procedures.sql
  -- cada vez que se consulta un proyecto. Se deja la columna por compatibilidad, sin usarla.
  proyecto_recaudado      DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
  proyecto_fecha_limite   DATE           NULL,

  -- Solo aplican cuando tipo_proyecto = 'rifa'; NULL para el resto de los tipos.
  -- rifa_rango_inicio/fin: serie numerica de los boletos DIGITALES (ej. 5000-6000), separada
  -- a proposito del rango de los boletos FISICOS impresos (que se administran fuera de este
  -- modulo). Usar un rango exclusivo evita el riesgo de confundir/empatar, por ejemplo, el
  -- boleto digital "A1" con el boleto fisico "1" si en su lugar se usara un prefijo de letra.
  -- rifa_total_boletos se calcula en el backend a partir del rango (rango_fin - rango_inicio + 1)
  -- y se guarda para no tener que recalcularlo cada vez que se lista/muestra el proyecto.
  rifa_rango_inicio       INT UNSIGNED   NULL,
  rifa_rango_fin          INT UNSIGNED   NULL,
  rifa_total_boletos      INT UNSIGNED   NULL,

  status                  TINYINT(1)     NOT NULL DEFAULT 1,
  fecha_registro          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion     DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id_proyecto),
  KEY idx_proyectos_estado (proyecto_estado),
  KEY idx_proyectos_tipo (tipo_proyecto),
  KEY idx_proyectos_titulo (proyecto_titulo),
  KEY idx_proyectos_distrito (fk_distrito),
  CONSTRAINT fk_proyectos_distrito
    FOREIGN KEY (fk_distrito) REFERENCES wms_distritos (id_distrito),
  CONSTRAINT chk_rifa_rango
    CHECK (rifa_rango_inicio IS NULL OR rifa_rango_fin IS NULL OR rifa_rango_fin >= rifa_rango_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------
-- Tabla: wms_donaciones_montos_sugeridos
-- Montos "rápidos" que el donante puede elegir con un clic (ej. $100, $250, $500).
-- Un proyecto puede tener 0..N; monto_orden respeta el orden en que el
-- administrador los fue agregando en el formulario.
-- --------------------------------------------------------
CREATE TABLE wms_donaciones_montos_sugeridos (
  id_monto_sugerido   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  fk_proyecto         INT UNSIGNED  NOT NULL,
  monto_sugerido      DECIMAL(10,2) NOT NULL,
  monto_orden         TINYINT UNSIGNED NOT NULL DEFAULT 0,

  status               TINYINT(1)   NOT NULL DEFAULT 1,
  fecha_registro        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id_monto_sugerido),
  UNIQUE KEY uq_monto_proyecto_valor (fk_proyecto, monto_sugerido),
  KEY idx_montos_proyecto (fk_proyecto),
  CONSTRAINT fk_montos_sugeridos_proyecto
    FOREIGN KEY (fk_proyecto) REFERENCES wms_donaciones_proyectos (id_proyecto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
