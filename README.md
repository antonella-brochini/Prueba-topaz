# Prueba Técnica SQL — Topaz for Evolution

Resolución completa de la prueba técnica SQL sobre un sistema bancario simplificado.

**Motor:** Microsoft SQL Server
**Entorno:** SQL Server Management Studio (SSMS)

---

## 📁 Estructura del Proyecto

```
topaz-sql-prueba/
│
├── README.md                       ← Este archivo
├── Documentation.docx           ← Documento completo con análisis técnico
│
├── schema/
│   ├── schema.sql        ← Creación de la base de datos y tablas
│   └── seed.sql          ← Carga de datos de ejemplo
│
└── queries/
    ├── 01_view.sql                ← Ejercicio 1: VIEW
    ├── 02_funtion.sql              ← Ejercicio 2: Función (TVF)
    ├── 03_movements_sum.sql     ← Ejercicio 3: Consulta con LEFT JOIN + ISNULL
    └── 04_mutitable_query.sql  ← Ejercicio 4: Consulta multitabla
```

---

## 🚀 Orden de Ejecución

Abrir SQL Server Management Studio
Conectarse al servidor local (.\SQLEXPRESS)
Ejecutar los scripts en el siguiente orden:

1. `schema/schema.sql` — Crea la base de datos `topaz_prueba` y las tres tablas.
2. `schema/seed.sql` — Inserta los datos de ejemplo provistos por el enunciado.
3. `queries/01_view.sql` — Crea y consulta la vista del ejercicio 1.
4. `queries/02_funtion.sql` — Crea y prueba la función del ejercicio 2.
5. `queries/03_movements_sum.sql` — Ejecuta la consulta del ejercicio 3.
6. `queries/04_mutitable_query.sql` — Ejecuta la consulta del ejercicio 4.

---

## 🏦 Descripción del Sistema

El sistema modela un banco simplificado con tres tablas:

- **saldos** — Saldos actuales de cada cuenta bancaria y su producto financiero (cuenta corriente, ahorros, etc.).
- **asientos** — Transacciones contables generales (ej: pago total de una factura).
- **movimientos** — Detalle individual de cada asiento (débitos y créditos sobre cuentas específicas).

### Relaciones
- `asientos` → `movimientos`: **1 : N** (un asiento puede tener múltiples movimientos).
- `saldos` → `movimientos`: **1 : N** (una cuenta acumula muchos movimientos a lo largo del tiempo).

---

## Decisiones Técnicas

- Se utilizó **LEFT JOIN** en el Ejercicio 3 para incluir cuentas sin movimientos en el período consultado.
- Se aplicó **ISNULL** para convertir valores NULL en 0 en las agregaciones (SUM sobre conjuntos vacíos).
- Se separó la lógica en **VIEWS** (Ejercicio 1) y **FUNCTIONS** (Ejercicio 2) para favorecer la reutilización y encapsulación.
- Se priorizó el uso de **INNER JOIN** cuando la integridad referencial garantiza que existen registros en todas las tablas (Ejercicios 1, 2 y 4).
- Las consultas utilizan **alias descriptivos** (`fecha_asiento`, `monto_movimiento`, `saldo_actual`) para favorecer la legibilidad y mantenimiento.
- Los filtros de fecha en LEFT JOIN se colocan en la cláusula **ON** (no en el WHERE) para preservar la semántica del outer join.

## 📝 Resolución de los Ejercicios

### Ejercicio 1 — Creación de Vista Básica

**Qué pide:** Crear una `VIEW` que devuelva el total de montos pagados para una cuenta específica dentro de un rango de fechas, permitiendo filtrar por número de cuenta y fechas.

**Qué resuelve:** Encapsula el JOIN triple entre las tres tablas en un objeto reutilizable. El filtrado por cuenta y fechas se aplica al consultar la vista, aprovechando el *predicate push-down* del optimizador de SQL Server.

**Técnica clave:** `CREATE VIEW` con INNER JOIN triple. El filtrado se delega al `WHERE` del consumidor.

**Archivo:** `queries/01_vista.sql`

---

### Ejercicio 2 — Función para Consultar Movimientos

**Qué pide:** Crear una función SQL que reciba el número de cuenta y un rango de fechas, y devuelva todos los movimientos (débito y crédito) del período. Debe retornar: fecha, tipo de movimiento, monto y sucursal.

**Qué resuelve:** Permite parametrizar la consulta (lo que una VIEW no puede hacer). Se implementa como **Inline Table-Valued Function (TVF)** porque el optimizador puede inlinear su plan de ejecución sin overhead adicional.

**Técnica clave:** `CREATE FUNCTION ... RETURNS TABLE AS RETURN (...)`. Parámetros con prefijo `@p_` para distinguirlos de las columnas.

**Archivo:** `queries/02_funcion.sql`

---

### Ejercicio 3 — Consulta de Suma de Movimientos

**Qué pide:** Escribir una consulta que devuelva el total de montos de movimientos de una cuenta en un rango de fechas, asegurando que si la cuenta no tiene movimientos en ese período el resultado sea **0** (no NULL).

**Qué resuelve:** Combina dos técnicas sutiles pero fundamentales en reporting financiero:
1. **LEFT JOIN** (en vez de INNER JOIN) para que la cuenta aparezca siempre en el resultado, aunque no tenga movimientos.
2. **ISNULL(SUM(...), 0)** para convertir el NULL que devuelve `SUM` sobre un conjunto vacío en el valor `0` que espera el consumidor.

**Detalle crítico:** El filtro de fechas va en el `ON` del JOIN, **no en el WHERE**. Si estuviese en el WHERE, filtraría las filas con `m.fecha = NULL` (las que vienen del LEFT JOIN sin match) y el comportamiento degeneraría al de un INNER JOIN.

**Técnica clave:** `LEFT JOIN` con filtro en `ON` + `ISNULL(SUM(...), 0)`.

**Archivo:** `queries/03_suma_movimientos.sql`

---

### Ejercicio 4 — Consulta Multitabla con Saldo Actual

**Qué pide:** Escribir una consulta que devuelva todos los movimientos de un asiento específico, junto con el número de cuenta y el saldo actual. Debe combinar las tres tablas y retornar: número de cuenta, fecha del asiento, monto total del asiento, tipo de movimiento, monto del movimiento y saldo actual.

**Qué resuelve:** Es el caso clásico de consulta multitabla "de auditoría": permite ver el contexto contable completo de una transacción (asiento + movimientos + estado de cuentas afectadas). Es el tipo de vista que usaría un operador de back-office para revisar una operación.

**Técnica clave:** `INNER JOIN` triple con alias descriptivos (`fecha_asiento`, `monto_total_asiento`, `monto_movimiento`, `saldo_actual`) para que el resultado sea autoexplicativo. Se incluye `ORDER BY` para garantizar orden determinístico.

**Archivo:** `queries/04_consulta_multitabla.sql`

---

## 📄 Documento Complementario

El archivo **`documentation.pdf`** contiene el análisis técnico completo:

- Diagrama Entidad-Relación
- Fundamentos conceptuales (tipos de JOIN, manejo de NULL, VIEW vs TVF vs SP)
- Decisiones técnicas con alternativas consideradas
- Verificación empírica con capturas de SSMS
- Análisis de performance e índices recomendados
- Consideraciones de escalabilidad para entornos productivos bancarios

---

## 🛠 Requisitos

- Microsoft SQL Server (Express Edition o superior)
- SQL Server Management Studio (SSMS) o Azure Data Studio
- Autenticación Windows o SQL Server Authentication
