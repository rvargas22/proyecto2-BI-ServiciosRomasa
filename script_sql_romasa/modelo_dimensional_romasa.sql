-- =========================================
-- MODELO DIMENSIONAL - SERVICIOS ROMASA
-- Proyecto BI
-- =========================================

CREATE SCHEMA IF NOT EXISTS dw_romasa;
SET search_path TO dw_romasa;

-- =========================================
-- DIMENSIONES
-- =========================================

-- Esta tabla crea la dimensión de tiempo, utilizada para analizar ventas,
-- movimientos de inventario y fórmulas por día, mes, trimestre y año.
CREATE TABLE dim_tiempo (
    tiempo_key INTEGER PRIMARY KEY,
    fecha_completa DATE NOT NULL UNIQUE,
    dia SMALLINT,
    nombre_dia VARCHAR(20),
    semana SMALLINT,
    mes SMALLINT,
    nombre_mes VARCHAR(20),
    trimestre SMALLINT,
    anio INTEGER,
    semestre SMALLINT
);

-- Esta tabla crea la dimensión de producto, utilizada para analizar materias primas,
-- productos terminados y productos vendidos.
CREATE TABLE dim_producto (
    producto_key SERIAL PRIMARY KEY,
    id_producto_origen INTEGER UNIQUE,
    codigo_producto VARCHAR(50),
    nombre_producto VARCHAR(150),
    tipo_producto VARCHAR(100),
    unidad_medida VARCHAR(50),
    abreviatura_unidad VARCHAR(20),
    requiere_inventario BOOLEAN,
    activo_producto BOOLEAN,
    observaciones_producto TEXT
);

-- Esta tabla crea la dimensión de cliente, utilizada para analizar ventas
-- según tipo de cliente y comportamiento de compra.
CREATE TABLE dim_cliente (
    cliente_key SERIAL PRIMARY KEY,
    id_cliente_origen INTEGER UNIQUE,
    cedula_cliente VARCHAR(50),
    nombre_cliente VARCHAR(200),
    tipo_cliente VARCHAR(100),
    activo_cliente BOOLEAN,
    fecha_creacion DATE
);

-- Esta tabla crea la dimensión de tipo de movimiento, utilizada para clasificar
-- entradas, salidas, consumos, ajustes u otros movimientos de inventario.
CREATE TABLE dim_tipo_movimiento (
    tipo_movimiento_key SERIAL PRIMARY KEY,
    id_tipo_movimiento_origen INTEGER UNIQUE,
    nombre_movimiento VARCHAR(100),
    efecto VARCHAR(20),
    descripcion_movimiento TEXT
);

-- Esta tabla crea la dimensión de fórmula, utilizada para analizar las fórmulas
-- de alimento y su relación con productos terminados.
CREATE TABLE dim_formula (
    formula_key SERIAL PRIMARY KEY,
    id_formula_origen INTEGER UNIQUE,
    id_producto_terminado_origen INTEGER,
    nombre_formula VARCHAR(150),
    version_formula VARCHAR(50),
    producto_terminado VARCHAR(150),
    activa_formula BOOLEAN,
    observaciones_formula TEXT,
    fecha_creacion DATE
);

-- =========================================
-- TABLAS DE HECHOS
-- =========================================

-- Esta tabla crea la tabla de hechos de ventas.
-- Su granularidad es una fila por producto vendido dentro de una factura.
CREATE TABLE fact_ventas (
    venta_key BIGSERIAL PRIMARY KEY,
    tiempo_key INTEGER NOT NULL,
    cliente_key INTEGER,
    producto_key INTEGER NOT NULL,

    id_factura_origen INTEGER,
    id_detalle_factura_origen INTEGER UNIQUE,
    consecutivo_factura VARCHAR(100),

    cantidad_vendida NUMERIC(14,4),
    precio_unitario NUMERIC(14,4),
    subtotal NUMERIC(14,4),
    impuesto NUMERIC(14,4),
    tarifa_impuesto NUMERIC(8,4),
    total NUMERIC(14,4),

    CONSTRAINT fk_fact_ventas_tiempo
        FOREIGN KEY (tiempo_key) REFERENCES dim_tiempo(tiempo_key),

    CONSTRAINT fk_fact_ventas_cliente
        FOREIGN KEY (cliente_key) REFERENCES dim_cliente(cliente_key),

    CONSTRAINT fk_fact_ventas_producto
        FOREIGN KEY (producto_key) REFERENCES dim_producto(producto_key)
);

-- Esta tabla crea la tabla de hechos de movimientos de inventario.
-- Su granularidad es una fila por movimiento de inventario realizado sobre un producto en una fecha.
CREATE TABLE fact_inventario_movimientos (
    inventario_movimiento_key BIGSERIAL PRIMARY KEY,
    tiempo_key INTEGER NOT NULL,
    producto_key INTEGER NOT NULL,
    tipo_movimiento_key INTEGER NOT NULL,

    id_movimiento_origen INTEGER UNIQUE,
    id_factura_origen INTEGER,
    cantidad_movimiento NUMERIC(14,4),

    CONSTRAINT fk_fact_inv_mov_tiempo
        FOREIGN KEY (tiempo_key) REFERENCES dim_tiempo(tiempo_key),

    CONSTRAINT fk_fact_inv_mov_producto
        FOREIGN KEY (producto_key) REFERENCES dim_producto(producto_key),

    CONSTRAINT fk_fact_inv_mov_tipo_movimiento
        FOREIGN KEY (tipo_movimiento_key) REFERENCES dim_tipo_movimiento(tipo_movimiento_key)
);

-- Esta tabla crea la tabla de hechos de consumo por fórmula.
-- Su granularidad es una fila por materia prima incluida dentro de una fórmula de alimento.
CREATE TABLE fact_formula_consumo (
    formula_consumo_key BIGSERIAL PRIMARY KEY,
    formula_key INTEGER NOT NULL,
    producto_terminado_key INTEGER NOT NULL,
    materia_prima_key INTEGER NOT NULL,

    porcentaje_inclusion NUMERIC(8,4),

    CONSTRAINT fk_fact_formula_formula
        FOREIGN KEY (formula_key) REFERENCES dim_formula(formula_key),

    CONSTRAINT fk_fact_formula_producto_terminado
        FOREIGN KEY (producto_terminado_key) REFERENCES dim_producto(producto_key),

    CONSTRAINT fk_fact_formula_materia_prima
        FOREIGN KEY (materia_prima_key) REFERENCES dim_producto(producto_key)
);

-- =========================================
-- ÍNDICES PARA CONSULTAS Y ETL
-- =========================================

CREATE INDEX idx_fact_ventas_tiempo ON fact_ventas(tiempo_key);
CREATE INDEX idx_fact_ventas_cliente ON fact_ventas(cliente_key);
CREATE INDEX idx_fact_ventas_producto ON fact_ventas(producto_key);

CREATE INDEX idx_fact_inv_mov_tiempo ON fact_inventario_movimientos(tiempo_key);
CREATE INDEX idx_fact_inv_mov_producto ON fact_inventario_movimientos(producto_key);
CREATE INDEX idx_fact_inv_mov_tipo ON fact_inventario_movimientos(tipo_movimiento_key);

CREATE INDEX idx_fact_formula_formula ON fact_formula_consumo(formula_key);
CREATE INDEX idx_fact_formula_producto_terminado ON fact_formula_consumo(producto_terminado_key);
CREATE INDEX idx_fact_formula_materia_prima ON fact_formula_consumo(materia_prima_key);
