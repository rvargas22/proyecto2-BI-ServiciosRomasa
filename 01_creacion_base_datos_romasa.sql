-- ============================================================
-- BLOQUE 0 Y BLOQUE 1: CREACION / REINICIO DE BASE OPERACIONAL
-- Servicios Romasa - Fuente transaccional PostgreSQL
-- ============================================================

-- IMPORTANTE:
-- Si la base romasa_operacional no existe, ejecutar primero esta linea
-- desde una conexion a postgres u otra base administrativa:
CREATE DATABASE romasa_operacional;
-- Luego conectarse a romasa_operacional y ejecutar el resto del archivo.

DROP SCHEMA IF EXISTS operacional CASCADE;
CREATE SCHEMA operacional;
SET search_path TO operacional;

-- ============================================================
-- 1. UNIDADES DE MEDIDA
-- ============================================================

CREATE TABLE unidad_medida (
    id_unidad_medida SERIAL PRIMARY KEY,
    nombre_unidad VARCHAR(50) NOT NULL UNIQUE,
    abreviatura VARCHAR(20) NOT NULL UNIQUE,
    descripcion TEXT
);

-- ============================================================
-- 2. TIPOS DE PRODUCTO
-- ============================================================

CREATE TABLE tipo_producto (
    id_tipo_producto SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- ============================================================
-- 3. PRODUCTOS
-- ============================================================

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    codigo_producto VARCHAR(50),
    nombre_producto VARCHAR(250) NOT NULL UNIQUE,
    id_tipo_producto INT NOT NULL,
    id_unidad_medida INT NOT NULL,
    requiere_inventario BOOLEAN NOT NULL DEFAULT TRUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    observaciones TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_producto_tipo
        FOREIGN KEY (id_tipo_producto)
        REFERENCES tipo_producto(id_tipo_producto),

    CONSTRAINT fk_producto_unidad
        FOREIGN KEY (id_unidad_medida)
        REFERENCES unidad_medida(id_unidad_medida)
);

-- ============================================================
-- 4. ALIAS DE PRODUCTOS
-- ============================================================

CREATE TABLE producto_alias (
    id_alias SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    alias_producto VARCHAR(250) NOT NULL,
    origen VARCHAR(100),

    CONSTRAINT fk_alias_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
        ON DELETE CASCADE,

    CONSTRAINT uq_alias_producto
        UNIQUE (id_producto, alias_producto)
);

-- ============================================================
-- 5. CLIENTES
-- ============================================================

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    cedula_cliente VARCHAR(50),
    nombre_cliente VARCHAR(250) NOT NULL,
    tipo_cliente VARCHAR(50) DEFAULT 'No clasificado',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_cliente_cedula
        UNIQUE (cedula_cliente)
);

-- ============================================================
-- 6. FACTURA DE VENTA
-- ============================================================

CREATE TABLE factura_venta (
    id_factura SERIAL PRIMARY KEY,
    consecutivo_factura VARCHAR(100) NOT NULL UNIQUE,
    fecha_emision DATE NOT NULL,
    id_cliente INT NOT NULL,
    subtotal_factura NUMERIC(18,2) NOT NULL DEFAULT 0,
    impuesto_factura NUMERIC(18,2) NOT NULL DEFAULT 0,
    total_factura NUMERIC(18,2) NOT NULL DEFAULT 0,
    fecha_carga TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_factura_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);

-- ============================================================
-- 7. DETALLE DE FACTURA DE VENTA
-- ============================================================

CREATE TABLE detalle_factura_venta (
    id_detalle_factura SERIAL PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cabys VARCHAR(50),
    detalle_original VARCHAR(300),
    cantidad NUMERIC(18,4) NOT NULL,
    precio_unitario NUMERIC(18,4),
    subtotal NUMERIC(18,2) NOT NULL DEFAULT 0,
    impuesto NUMERIC(18,2) NOT NULL DEFAULT 0,
    tarifa_impuesto NUMERIC(8,4),
    total NUMERIC(18,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_detalle_factura
        FOREIGN KEY (id_factura)
        REFERENCES factura_venta(id_factura)
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    CONSTRAINT ck_detalle_cantidad
        CHECK (cantidad >= 0),

    CONSTRAINT ck_detalle_montos
        CHECK (
            subtotal >= 0
            AND impuesto >= 0
            AND total >= 0
            AND (precio_unitario IS NULL OR precio_unitario >= 0)
        )
);

-- ============================================================
-- 8. FORMULA DE ALIMENTO
-- ============================================================

CREATE TABLE formula_alimento (
    id_formula SERIAL PRIMARY KEY,
    id_producto_terminado INT NOT NULL,
    nombre_formula VARCHAR(250) NOT NULL UNIQUE,
    version_formula VARCHAR(30) NOT NULL DEFAULT '1.0',
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    observaciones TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_formula_producto_terminado
        FOREIGN KEY (id_producto_terminado)
        REFERENCES producto(id_producto)
);

-- ============================================================
-- 9. DETALLE DE FORMULA DE ALIMENTO
-- ============================================================

CREATE TABLE detalle_formula_alimento (
    id_detalle_formula SERIAL PRIMARY KEY,
    id_formula INT NOT NULL,
    id_materia_prima INT NOT NULL,
    porcentaje_inclusion NUMERIC(10,4) NOT NULL,

    CONSTRAINT fk_detalle_formula
        FOREIGN KEY (id_formula)
        REFERENCES formula_alimento(id_formula)
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_formula_producto
        FOREIGN KEY (id_materia_prima)
        REFERENCES producto(id_producto),

    CONSTRAINT ck_porcentaje_inclusion
        CHECK (porcentaje_inclusion >= 0 AND porcentaje_inclusion <= 100),

    CONSTRAINT uq_formula_materia_prima
        UNIQUE (id_formula, id_materia_prima)
);

-- ============================================================
-- 10. MINIMOS DE SEGURIDAD POR PRODUCTO
-- ============================================================

CREATE TABLE minimo_seguridad_producto (
    id_minimo SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad_minima NUMERIC(18,4) NOT NULL,
    id_unidad_medida INT NOT NULL,
    fecha_vigencia DATE NOT NULL DEFAULT CURRENT_DATE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    observaciones TEXT,

    CONSTRAINT fk_minimo_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    CONSTRAINT fk_minimo_unidad
        FOREIGN KEY (id_unidad_medida)
        REFERENCES unidad_medida(id_unidad_medida),

    CONSTRAINT ck_cantidad_minima
        CHECK (cantidad_minima >= 0),

    CONSTRAINT uq_minimo_producto_vigencia
        UNIQUE (id_producto, fecha_vigencia)
);

-- ============================================================
-- 11. INVENTARIO ACTUAL
-- ============================================================

CREATE TABLE inventario_actual (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INT NOT NULL UNIQUE,
    cantidad_actual NUMERIC(18,4) NOT NULL DEFAULT 0,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    CONSTRAINT ck_cantidad_actual
        CHECK (cantidad_actual >= 0)
);

-- ============================================================
-- 12. TIPOS DE MOVIMIENTO DE INVENTARIO
-- ============================================================

CREATE TABLE tipo_movimiento_inventario (
    id_tipo_movimiento SERIAL PRIMARY KEY,
    nombre_movimiento VARCHAR(100) NOT NULL UNIQUE,
    efecto CHAR(1) NOT NULL,
    descripcion TEXT,

    CONSTRAINT ck_efecto_movimiento
        CHECK (efecto IN ('E', 'S'))
);

-- ============================================================
-- 13. MOVIMIENTOS DE INVENTARIO
-- ============================================================

CREATE TABLE movimiento_inventario (
    id_movimiento SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    id_tipo_movimiento INT NOT NULL,
    id_factura INT,
    fecha_movimiento DATE NOT NULL,
    cantidad NUMERIC(18,4) NOT NULL,
    observaciones TEXT,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_movimiento_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    CONSTRAINT fk_movimiento_tipo
        FOREIGN KEY (id_tipo_movimiento)
        REFERENCES tipo_movimiento_inventario(id_tipo_movimiento),

    CONSTRAINT fk_movimiento_factura
        FOREIGN KEY (id_factura)
        REFERENCES factura_venta(id_factura),

    CONSTRAINT ck_movimiento_cantidad
        CHECK (cantidad > 0)
);

-- ============================================================
-- CATALOGOS BASE
-- ============================================================

INSERT INTO unidad_medida 
(nombre_unidad, abreviatura, descripcion)
VALUES
('Kilogramo', 'kg', 'Unidad base para registrar materias primas y productos por peso.'),
('Unidad', 'und', 'Unidad generica para servicios o conceptos no medidos por peso.'),
('Saco', 'saco', 'Presentacion comercial utilizada para minimos de seguridad.'),
('Porcentaje', '%', 'Unidad utilizada para representar inclusion en formulas.')
ON CONFLICT (nombre_unidad) DO NOTHING;

INSERT INTO tipo_producto
(nombre_tipo, descripcion)
VALUES
('MATERIA_PRIMA', 'Insumo utilizado para elaborar alimento terminado.'),
('PRODUCTO_TERMINADO', 'Producto vendido o elaborado mediante una formula de alimento.'),
('PRODUCTO_INTERMEDIO', 'Mezcla o nucleo que puede elaborarse y usarse dentro de otra formula.'),
('SERVICIO', 'Concepto facturado que no afecta inventario.'),
('OTRO', 'Concepto no clasificado dentro de las categorias principales.')
ON CONFLICT (nombre_tipo) DO NOTHING;

INSERT INTO tipo_movimiento_inventario
(nombre_movimiento, efecto, descripcion)
VALUES
('VENTA_DIRECTA', 'S', 'Salida de inventario por venta facturada.'),
('CONSUMO_PRODUCCION', 'S', 'Salida por consumo de materia prima en produccion.'),
('PRODUCCION_TERMINADA', 'E', 'Entrada de producto terminado por produccion.'),
('AJUSTE_ENTRADA', 'E', 'Ajuste positivo de inventario.'),
('AJUSTE_SALIDA', 'S', 'Ajuste negativo de inventario.')
ON CONFLICT (nombre_movimiento) DO NOTHING;

-- ============================================================
-- VISTAS DE VALIDACION
-- ============================================================

CREATE OR REPLACE VIEW vista_inventario_minimos AS
SELECT 
    p.id_producto,
    p.codigo_producto,
    p.nombre_producto,
    tp.nombre_tipo,
    COALESCE(ia.cantidad_actual, 0) AS cantidad_actual,
    COALESCE(ms.cantidad_minima, 0) AS cantidad_minima,
    COALESCE(um.abreviatura, '') AS unidad_minimo,
    CASE 
        WHEN COALESCE(ia.cantidad_actual, 0) < COALESCE(ms.cantidad_minima, 0)
            THEN 'POR DEBAJO DEL MINIMO'
        WHEN COALESCE(ia.cantidad_actual, 0) = COALESCE(ms.cantidad_minima, 0)
            THEN 'EN EL MINIMO'
        ELSE 'SOBRE EL MINIMO'
    END AS estado_inventario
FROM producto p
INNER JOIN tipo_producto tp
    ON tp.id_tipo_producto = p.id_tipo_producto
LEFT JOIN inventario_actual ia
    ON ia.id_producto = p.id_producto
LEFT JOIN minimo_seguridad_producto ms
    ON ms.id_producto = p.id_producto
    AND ms.activo = TRUE
LEFT JOIN unidad_medida um
    ON um.id_unidad_medida = ms.id_unidad_medida
WHERE p.requiere_inventario = TRUE;

CREATE OR REPLACE VIEW vista_formula_detallada AS
SELECT
    f.id_formula,
    f.nombre_formula,
    f.version_formula,
    pt.nombre_producto AS producto_terminado,
    mp.nombre_producto AS materia_prima,
    dfa.porcentaje_inclusion
FROM formula_alimento f
INNER JOIN producto pt
    ON pt.id_producto = f.id_producto_terminado
INNER JOIN detalle_formula_alimento dfa
    ON dfa.id_formula = f.id_formula
INNER JOIN producto mp
    ON mp.id_producto = dfa.id_materia_prima
WHERE f.activa = TRUE;

CREATE OR REPLACE VIEW vista_ventas_detalladas AS
SELECT
    fv.id_factura,
    fv.consecutivo_factura,
    fv.fecha_emision,
    c.cedula_cliente,
    c.nombre_cliente,
    p.codigo_producto,
    p.nombre_producto,
    tp.nombre_tipo,
    dfv.detalle_original,
    dfv.cantidad,
    dfv.precio_unitario,
    dfv.subtotal,
    dfv.impuesto,
    dfv.tarifa_impuesto,
    dfv.total
FROM factura_venta fv
INNER JOIN cliente c
    ON c.id_cliente = fv.id_cliente
INNER JOIN detalle_factura_venta dfv
    ON dfv.id_factura = fv.id_factura
INNER JOIN producto p
    ON p.id_producto = dfv.id_producto
INNER JOIN tipo_producto tp
    ON tp.id_tipo_producto = p.id_tipo_producto;

-- ============================================================
-- VALIDACION DE ESTRUCTURA
-- ============================================================

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'operacional'
ORDER BY table_name;
