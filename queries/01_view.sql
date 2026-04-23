USE topaz_prueba;
GO


-- ============================================
-- Creación de la vista
-- Consolida asientos, movimientos y saldos
-- para filtrar por cuenta y rango de fechas
-- ============================================

CREATE VIEW vista_montos_por_cuenta AS
SELECT
    s.cuenta,
    a.fecha,
    m.tipomovimiento,
    m.monto          AS monto_movimiento,
    a.monto          AS monto_total_asiento,
    m.sucursal
FROM movimientos m
JOIN asientos a ON m.idasiento = a.idasiento
JOIN saldos   s ON m.idsaldo   = s.idsaldo;
GO
 
-- ============================================
-- Uso de la vista
-- Filtramos por cuenta y rango de fechas
-- ============================================

SELECT
    cuenta,
    fecha,
    tipomovimiento,
    monto_movimiento,
    monto_total_asiento,
    sucursal
FROM vista_montos_por_cuenta
WHERE cuenta = '0011223344'
  AND fecha BETWEEN '2024-01-01' AND '2024-01-31';
GO
 
