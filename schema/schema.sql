CREATE DATABASE topaz_prueba;
GO
 
USE topaz_prueba;
GO


CREATE TABLE saldos (
    idsaldo  INT          PRIMARY KEY,
    cuenta   VARCHAR(20)  NOT NULL,
    producto VARCHAR(50)  NOT NULL,
    saldo    DECIMAL(10, 2) NOT NULL
);
GO

CREATE TABLE asientos (
    idasiento INT          PRIMARY KEY,
    sucursal  VARCHAR(50)  NOT NULL,
    fecha     DATE         NOT NULL,
    monto     DECIMAL(10, 2) NOT NULL
);
GO

CREATE TABLE movimientos (
    idmovimiento   INT          PRIMARY KEY,
    idasiento      INT          NOT NULL,
    sucursal       VARCHAR(50)  NOT NULL,
    fecha          DATE         NOT NULL,
    tipomovimiento VARCHAR(10)  NOT NULL,
    monto          DECIMAL(10, 2) NOT NULL,
    idsaldo        INT          NOT NULL,
    CONSTRAINT FK_movimientos_asientos FOREIGN KEY (idasiento) REFERENCES asientos(idasiento),
    CONSTRAINT FK_movimientos_saldos   FOREIGN KEY (idsaldo)   REFERENCES saldos(idsaldo)
);
GO
