-- ============================================================
-- RESET COMPLETO: Módulo de Donaciones (deja estructura intacta, borra TODOS los datos)
-- NO toca wms_distritos (catálogo base, no es dato de prueba de este módulo).
-- Actualizado con las tablas de "Cuentas de Depósito" / "Pago por Transferencia".
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE wms_donaciones_rifa_boletos;
TRUNCATE TABLE wms_donaciones_pagos_stripe;
TRUNCATE TABLE wms_donaciones_pagos_transferencia;
TRUNCATE TABLE wms_donaciones_fichas_pago;
TRUNCATE TABLE wms_donaciones_montos_sugeridos;
TRUNCATE TABLE wms_donaciones_proyectos;
TRUNCATE TABLE wms_donaciones_stripe_cuentas;
TRUNCATE TABLE wms_donaciones_cuentas_deposito;

SET FOREIGN_KEY_CHECKS = 1;
