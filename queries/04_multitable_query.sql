USE topaz_prueba;
GO
 
-- ============================================
-- Consulta que devuelve todos los movimientos
-- de un asiento específico junto con el número
-- de cuenta y el saldo actual.
-- Combina las 3 tablas: asientos, movimientos
-- y saldos.
-- ============================================

SELECT
    s.cuenta,
    a.fecha              AS fecha_asiento,
    a.monto              AS monto_total_asiento,
    m.tipomovimiento,
    m.monto              AS monto_movimiento,
    s.saldo              AS saldo_actual
FROM asientos a
JOIN movimientos m ON a.idasiento = m.idasiento
JOIN saldos      s ON m.idsaldo   = s.idsaldo
WHERE a.idasiento = 1
ORDER BY m.idmovimiento;
GO
 
