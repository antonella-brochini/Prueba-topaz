INSERT INTO saldos (idsaldo, cuenta, producto, saldo) VALUES
(1, '0011223344', 'Cuenta Corriente',  5000.00),
(2, '0011223355', 'Cuenta de Ahorros', 3000.00);
GO


INSERT INTO asientos (idasiento, sucursal, fecha, monto) VALUES
(1, 'Sucursal A', '2024-01-15', 200.00),
(2, 'Sucursal B', '2024-01-16', 350.00);
GO


INSERT INTO movimientos (idmovimiento, idasiento, sucursal, fecha, tipomovimiento, monto, idsaldo) VALUES
(1, 1, 'Sucursal A', '2024-01-15', 'debito',  100.00, 1), -- Pago de agua
(2, 1, 'Sucursal A', '2024-01-15', 'debito',  100.00, 2), -- Pago de electricidad
(3, 2, 'Sucursal B', '2024-01-16', 'credito', 350.00, 1); -- Deposito en cuenta corriente
GO

-- ============================================
-- Verificacion de datos insertados
-- ============================================
SELECT * FROM saldos;
SELECT * FROM asientos;
SELECT * FROM movimientos;
GO
