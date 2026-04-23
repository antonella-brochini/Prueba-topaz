USE topaz_prueba;
GO

-- ============================================
-- Creación de la función
-- Recibe: número de cuenta, fecha inicio, fecha fin
-- Devuelve: todos los movimientos del período
-- ============================================

CREATE FUNCTION obtener_movimientos (
    @p_cuenta        VARCHAR(20),
    @p_fecha_inicio  DATE,
    @p_fecha_fin     DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        m.fecha,
        m.tipomovimiento,
        m.monto,
        m.sucursal
    FROM movimientos m
    JOIN saldos s ON m.idsaldo = s.idsaldo
    WHERE s.cuenta = @p_cuenta
      AND m.fecha BETWEEN @p_fecha_inicio AND @p_fecha_fin
);
GO
 


-- ============================================
-- Uso de la función
-- ============================================

SELECT *
FROM obtener_movimientos('0011223344', '2024-01-01', '2024-01-31');
GO
