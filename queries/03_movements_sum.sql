USE topaz_prueba;
GO

-- ============================================
-- Consulta que devuelve el total de montos
-- de los movimientos de una cuenta en un
-- rango de fechas.
-- Si no hay movimientos devuelve 0 (no NULL)
-- gracias al LEFT JOIN + ISNULL
-- ============================================

SELECT
    s.cuenta,
    ISNULL(SUM(m.monto), 0) AS total_movimientos
FROM saldos s
LEFT JOIN movimientos m ON s.idsaldo = m.idsaldo
    AND m.fecha BETWEEN '2024-01-01' AND '2024-01-31'
WHERE s.cuenta = '0011223344'
GROUP BY s.cuenta;
GO
