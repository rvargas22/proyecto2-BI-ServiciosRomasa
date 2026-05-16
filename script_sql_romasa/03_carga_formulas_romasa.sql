-- ============================================================
-- BLOQUE 3: CARGA REAL DE FORMULAS ACTIVAS
-- Servicios Romasa - Fuente operacional transaccional
-- Ejecutar despues de 02_carga_minimos_romasa.sql
-- ============================================================

SET search_path TO operacional;

-- ============================================================
-- 3.1 CARGAR PRODUCTOS NECESARIOS PARA FORMULAS
-- ============================================================

INSERT INTO producto
(codigo_producto, nombre_producto, id_tipo_producto, id_unidad_medida, requiere_inventario, activo, observaciones)
SELECT
    v.codigo_producto,
    v.nombre_producto,
    tp.id_tipo_producto,
    um.id_unidad_medida,
    TRUE,
    TRUE,
    'Producto cargado desde documento real de formulas activas.'
FROM (
    VALUES
    (NULL, 'ATP Premix', 'PRODUCTO_INTERMEDIO', 'kg'),
    (NULL, 'Nucleo ATP (Leche)', 'PRODUCTO_INTERMEDIO', 'kg'),
    (NULL, 'ATP Lechería Especializada', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP Desarrollo de Novillas 9-16', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP Ternera 3-9', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP Caprinus', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP PREPARTO HG Dani 4,5k', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'Vacas de Cria 1K mante', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'Engorde NORÉ', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP Lechería Enrique Valverde', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP Lechería LOS GÓMEZ', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'ATP PREPARTO AF 5K', 'PRODUCTO_TERMINADO', 'kg'),
    (NULL, 'MONENSNA SODICA 20%', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Oxido de Magnesio', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Oxido de Mg', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Núcleo Jensen', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Carbonato de Calcio 39%', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Fosfato Mono-Dicalcico21,3%', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Maiz', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Soya', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'DDGS', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Sal Blanca', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Acid Buff', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Melaza de Caña > 87 Brix', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Bovigold Ternero', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Levadura levucel', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Bovigold Preparto OVN Tortuga', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Sulfato de magnesio', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Energy Feed', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Altura Mix', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Levucel', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Zooalium', 'MATERIA_PRIMA', 'kg'),
    (NULL, 'Monensina 20%', 'MATERIA_PRIMA', 'kg')
) AS v(codigo_producto, nombre_producto, tipo_producto, unidad)
INNER JOIN tipo_producto tp
    ON tp.nombre_tipo = v.tipo_producto
INNER JOIN unidad_medida um
    ON um.abreviatura = v.unidad
ON CONFLICT (nombre_producto) DO UPDATE
SET
    id_tipo_producto = EXCLUDED.id_tipo_producto,
    id_unidad_medida = EXCLUDED.id_unidad_medida,
    requiere_inventario = TRUE,
    activo = TRUE,
    observaciones = EXCLUDED.observaciones;

-- ============================================================
-- 3.2 ALIAS DE PRODUCTOS
-- ============================================================

INSERT INTO producto_alias
(id_producto, alias_producto, origen)
SELECT
    p.id_producto,
    v.alias_producto,
    'Documento de formulas activas'
FROM (
    VALUES
    ('Oxido de Magnesio', 'OXIDO DE MAGNESIO'),
    ('Oxido de Magnesio', 'Oxido Magnesio'),
    ('Oxido de Magnesio', 'Oxido de Magnesio'),
    ('Oxido de Mg', 'Oxido de Mg'),
    ('Energy Feed', 'Energy feed'),
    ('Sulfato de magnesio', 'Sulfato de magnesio'),
    ('Levadura levucel', 'Levadura levucel'),
    ('Maiz', 'Maiz'),
    ('MONENSNA SODICA 20%', 'MONENSNA SODICA 20%')
) AS v(nombre_producto, alias_producto)
INNER JOIN producto p
    ON p.nombre_producto = v.nombre_producto
ON CONFLICT (id_producto, alias_producto) DO NOTHING;

-- ============================================================
-- 3.3 INVENTARIO INICIAL EN CERO PARA PRODUCTOS DE FORMULAS
-- ============================================================

INSERT INTO inventario_actual
(id_producto, cantidad_actual, observaciones)
SELECT
    p.id_producto,
    0,
    'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.'
FROM producto p
WHERE p.requiere_inventario = TRUE
ON CONFLICT (id_producto) DO UPDATE
SET
    cantidad_actual = 0,
    fecha_actualizacion = CURRENT_TIMESTAMP,
    observaciones = 'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.';

-- ============================================================
-- 3.4 CARGAR ENCABEZADOS DE FORMULAS ACTIVAS
-- ============================================================

INSERT INTO formula_alimento
(id_producto_terminado, nombre_formula, version_formula, activa, observaciones)
SELECT p.id_producto, v.nombre_formula, '1.0', TRUE, 'Formula cargada desde documento real de formulas activas.'
FROM (
    VALUES
    ('ATP Premix', 'ATP Premix'),
    ('Nucleo ATP (Leche)', 'Nucleo ATP (Leche)'),
    ('ATP Lechería Especializada', 'ATP Lechería Especializada'),
    ('ATP Desarrollo de Novillas 9-16', 'ATP Desarrollo de Novillas 9-16'),
    ('ATP Ternera 3-9', 'ATP Ternera 3-9'),
    ('ATP Caprinus', 'ATP Caprinus'),
    ('ATP PREPARTO HG Dani 4,5k', 'ATP PREPARTO HG Dani 4,5k'),
    ('Vacas de Cria 1K mante', 'Vacas de Cria 1K mante'),
    ('Engorde NORÉ', 'Engorde NORÉ'),
    ('ATP Lechería Enrique Valverde', 'ATP Lechería Enrique Valverde'),
    ('ATP Lechería LOS GÓMEZ', 'ATP Lechería LOS GÓMEZ'),
    ('ATP PREPARTO AF 5K', 'ATP PREPARTO AF 5K')
) AS v(nombre_producto_terminado, nombre_formula)
INNER JOIN producto p
    ON p.nombre_producto = v.nombre_producto_terminado
ON CONFLICT (nombre_formula) DO UPDATE
SET
    id_producto_terminado = EXCLUDED.id_producto_terminado,
    version_formula = EXCLUDED.version_formula,
    activa = TRUE,
    observaciones = EXCLUDED.observaciones;

-- ============================================================
-- 3.5 CARGAR DETALLE REAL DE FORMULAS ACTIVAS
-- ============================================================

INSERT INTO detalle_formula_alimento
(id_formula, id_materia_prima, porcentaje_inclusion)
SELECT
    f.id_formula,
    p.id_producto,
    v.porcentaje_inclusion
FROM (
    VALUES
    ('ATP Premix', 'MONENSNA SODICA 20%', 4.3500),
    ('ATP Premix', 'Oxido de Magnesio', 43.6500),
    ('ATP Premix', 'Núcleo Jensen', 52.0000),
    ('Nucleo ATP (Leche)', 'Carbonato de Calcio 39%', 10.0000),
    ('Nucleo ATP (Leche)', 'Fosfato Mono-Dicalcico21,3%', 35.0000),
    ('Nucleo ATP (Leche)', 'ATP Premix', 55.0000),
    ('ATP Lechería Especializada', 'Maiz', 55.2800),
    ('ATP Lechería Especializada', 'Soya', 13.5700),
    ('ATP Lechería Especializada', 'DDGS', 21.5800),
    ('ATP Lechería Especializada', 'Sal Blanca', 1.0800),
    ('ATP Lechería Especializada', 'ATP Premix', 0.6200),
    ('ATP Lechería Especializada', 'Carbonato de Calcio 39%', 1.0800),
    ('ATP Lechería Especializada', 'Fosfato Mono-Dicalcico21,3%', 1.2000),
    ('ATP Lechería Especializada', 'Acid Buff', 0.6500),
    ('ATP Lechería Especializada', 'Melaza de Caña > 87 Brix', 4.9500),
    ('ATP Desarrollo de Novillas 9-16', 'Maiz', 75.0000),
    ('ATP Desarrollo de Novillas 9-16', 'Soya', 16.0000),
    ('ATP Desarrollo de Novillas 9-16', 'Bovigold Ternero', 1.5000),
    ('ATP Desarrollo de Novillas 9-16', 'Núcleo Jensen', 0.0200),
    ('ATP Desarrollo de Novillas 9-16', 'Carbonato de Calcio 39%', 1.4800),
    ('ATP Desarrollo de Novillas 9-16', 'Acid Buff', 1.0000),
    ('ATP Desarrollo de Novillas 9-16', 'Melaza de Caña > 87 Brix', 5.0000),
    ('ATP Ternera 3-9', 'Maiz', 61.0000),
    ('ATP Ternera 3-9', 'Soya', 11.3000),
    ('ATP Ternera 3-9', 'DDGS', 20.0000),
    ('ATP Ternera 3-9', 'Bovigold Ternero', 2.0000),
    ('ATP Ternera 3-9', 'Sal Blanca', 0.7000),
    ('ATP Ternera 3-9', 'Melaza de Caña > 87 Brix', 5.0000),
    ('ATP Caprinus', 'Maiz', 49.5500),
    ('ATP Caprinus', 'Soya', 22.0000),
    ('ATP Caprinus', 'DDGS', 25.0000),
    ('ATP Caprinus', 'Sal Blanca', 0.7500),
    ('ATP Caprinus', 'Levadura levucel', 0.0350),
    ('ATP Caprinus', 'Carbonato de Calcio 39%', 1.6600),
    ('ATP Caprinus', 'Melaza de Caña > 87 Brix', 1.0000),
    ('ATP PREPARTO HG Dani 4,5k', 'Maiz', 57.8500),
    ('ATP PREPARTO HG Dani 4,5k', 'Soya', 5.1400),
    ('ATP PREPARTO HG Dani 4,5k', 'DDGS', 20.6000),
    ('ATP PREPARTO HG Dani 4,5k', 'Bovigold Preparto OVN Tortuga', 10.3000),
    ('ATP PREPARTO HG Dani 4,5k', 'Núcleo Jensen', 0.3000),
    ('ATP PREPARTO HG Dani 4,5k', 'Acid Buff', 1.7000),
    ('ATP PREPARTO HG Dani 4,5k', 'Sulfato de magnesio', 1.4000),
    ('ATP PREPARTO HG Dani 4,5k', 'Oxido de Mg', 0.7000),
    ('ATP PREPARTO HG Dani 4,5k', 'Energy Feed', 2.0000),
    ('Vacas de Cria 1K mante', 'Maiz', 74.5000),
    ('Vacas de Cria 1K mante', 'Soya', 9.0000),
    ('Vacas de Cria 1K mante', 'DDGS', 9.0000),
    ('Vacas de Cria 1K mante', 'Altura Mix', 1.5000),
    ('Vacas de Cria 1K mante', 'Levucel', 0.0400),
    ('Vacas de Cria 1K mante', 'Melaza de Caña > 87 Brix', 6.0000),
    ('Engorde NORÉ', 'Maiz', 74.5000),
    ('Engorde NORÉ', 'Soya', 9.0000),
    ('Engorde NORÉ', 'DDGS', 9.0000),
    ('Engorde NORÉ', 'Levucel', 0.0400),
    ('Engorde NORÉ', 'Altura Mix', 1.5000),
    ('Engorde NORÉ', 'Melaza de Caña > 87 Brix', 5.9600),
    ('ATP Lechería Enrique Valverde', 'Maiz', 58.0000),
    ('ATP Lechería Enrique Valverde', 'Soya', 16.0000),
    ('ATP Lechería Enrique Valverde', 'DDGS', 16.0000),
    ('ATP Lechería Enrique Valverde', 'Sal Blanca', 0.7600),
    ('ATP Lechería Enrique Valverde', 'ATP Premix', 0.6000),
    ('ATP Lechería Enrique Valverde', 'Carbonato de Calcio 39%', 0.9400),
    ('ATP Lechería Enrique Valverde', 'Fosfato Mono-Dicalcico21,3%', 0.7800),
    ('ATP Lechería Enrique Valverde', 'Acid Buff', 0.2100),
    ('ATP Lechería Enrique Valverde', 'Oxido de Magnesio', 0.6000),
    ('ATP Lechería Enrique Valverde', 'Zooalium', 0.1000),
    ('ATP Lechería Enrique Valverde', 'Levucel', 0.0145),
    ('ATP Lechería Enrique Valverde', 'Melaza de Caña > 87 Brix', 6.0000),
    ('ATP Lechería LOS GÓMEZ', 'Maiz', 73.0000),
    ('ATP Lechería LOS GÓMEZ', 'Soya', 12.1800),
    ('ATP Lechería LOS GÓMEZ', 'DDGS', 6.0000),
    ('ATP Lechería LOS GÓMEZ', 'Sal Blanca', 0.8500),
    ('ATP Lechería LOS GÓMEZ', 'Monensina 20%', 0.0000),
    ('ATP Lechería LOS GÓMEZ', 'Carbonato de Calcio 39%', 1.0000),
    ('ATP Lechería LOS GÓMEZ', 'Fosfato Mono-Dicalcico21,3%', 0.3600),
    ('ATP Lechería LOS GÓMEZ', 'Oxido de Magnesio', 0.6000),
    ('ATP Lechería LOS GÓMEZ', 'Acid Buff', 1.0000),
    ('ATP Lechería LOS GÓMEZ', 'Melaza de Caña > 87 Brix', 4.9800),
    ('ATP PREPARTO AF 5K', 'Maiz', 74.4400),
    ('ATP PREPARTO AF 5K', 'Soya', 11.1100),
    ('ATP PREPARTO AF 5K', 'DDGS', 2.2200),
    ('ATP PREPARTO AF 5K', 'Bovigold Preparto OVN Tortuga', 8.9000),
    ('ATP PREPARTO AF 5K', 'Acid Buff', 0.4500),
    ('ATP PREPARTO AF 5K', 'Sulfato de magnesio', 1.5500),
    ('ATP PREPARTO AF 5K', 'Energy Feed', 1.3300)
) AS v(nombre_formula, nombre_materia_prima, porcentaje_inclusion)
INNER JOIN formula_alimento f
    ON f.nombre_formula = v.nombre_formula
INNER JOIN producto p
    ON p.nombre_producto = v.nombre_materia_prima
ON CONFLICT (id_formula, id_materia_prima) DO UPDATE
SET porcentaje_inclusion = EXCLUDED.porcentaje_inclusion;

-- ============================================================
-- VALIDACIONES DEL BLOQUE 3
-- ============================================================

SELECT COUNT(*) AS total_formulas
FROM formula_alimento;

SELECT COUNT(*) AS total_detalles_formula
FROM detalle_formula_alimento;

SELECT
    f.nombre_formula,
    ROUND(SUM(dfa.porcentaje_inclusion), 4) AS total_porcentaje
FROM formula_alimento f
INNER JOIN detalle_formula_alimento dfa
    ON dfa.id_formula = f.id_formula
GROUP BY f.nombre_formula
ORDER BY f.nombre_formula;

SELECT
    nombre_formula,
    producto_terminado,
    materia_prima,
    porcentaje_inclusion
FROM vista_formula_detallada
ORDER BY nombre_formula, materia_prima;
