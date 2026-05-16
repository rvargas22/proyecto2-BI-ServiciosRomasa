-- ============================================================
-- BLOQUE 2: CARGA REAL DE MINIMOS DE SEGURIDAD
-- Servicios Romasa - Fuente operacional transaccional
-- Ejecutar despues de 01_creacion_base_datos_romasa.sql
-- ============================================================

SET search_path TO operacional;

-- ============================================================
-- 2.1 CARGAR PRODUCTOS PRESENTES EN EL ARCHIVO DE MINIMOS
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
    'Producto cargado desde archivo real de minimos de seguridad.'
FROM (
    VALUES
    (NULL, 'Lechera Esp', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'ATP Las Lajas', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Harina Soya', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Desarrollo Novilla', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Desarrollo Terneras', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Fase 1', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Maiz', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'ATP Caprinus', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Enogrde ATP', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Destilado', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Acemite', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Ovinos', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Pre-Parto AF', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Pre-Parto Dani', 'PRODUCTO_TERMINADO', 'saco'),
    (NULL, 'Energy Feed', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Acid Buff', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Aragomix', 'MATERIA_PRIMA', 'saco'),
    (NULL, 'Mineral CaprinoRV', 'MATERIA_PRIMA', 'saco')
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
-- 2.2 CREAR INVENTARIO INICIAL EN CERO PARA PRODUCTOS DE MINIMOS
-- ============================================================

INSERT INTO inventario_actual
(id_producto, cantidad_actual, observaciones)
SELECT
    p.id_producto,
    0,
    'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.'
FROM producto p
WHERE p.nombre_producto IN (
    'Lechera Esp',
    'ATP Las Lajas',
    'Harina Soya',
    'Desarrollo Novilla',
    'Desarrollo Terneras',
    'Fase 1',
    'Maiz',
    'ATP Caprinus',
    'Enogrde ATP',
    'Destilado',
    'Acemite',
    'Ovinos',
    'Pre-Parto AF',
    'Pre-Parto Dani',
    'Energy Feed',
    'Acid Buff',
    'Aragomix',
    'Mineral CaprinoRV'
)
ON CONFLICT (id_producto) DO UPDATE
SET
    cantidad_actual = 0,
    fecha_actualizacion = CURRENT_TIMESTAMP,
    observaciones = 'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.';

-- ============================================================
-- 2.3 CARGAR MINIMOS REALES DE SEGURIDAD POR PRODUCTO
-- ============================================================

INSERT INTO minimo_seguridad_producto
(id_producto, cantidad_minima, id_unidad_medida, fecha_vigencia, activo, observaciones)
SELECT
    p.id_producto,
    v.cantidad_minima,
    um.id_unidad_medida,
    DATE '2026-04-01',
    TRUE,
    'Minimo cargado desde archivo real de minimos de seguridad por producto.'
FROM (
    VALUES
    ('Lechera Esp', 205.0000),
    ('ATP Las Lajas', 95.0000),
    ('Harina Soya', 53.0000),
    ('Desarrollo Novilla', 45.0000),
    ('Desarrollo Terneras', 10.0000),
    ('Fase 1', 30.0000),
    ('Maiz', 4.0000),
    ('ATP Caprinus', 20.0000),
    ('Enogrde ATP', 10.0000),
    ('Destilado', 16.0000),
    ('Acemite', 2.0000),
    ('Ovinos', 5.0000),
    ('Pre-Parto AF', 5.0000),
    ('Pre-Parto Dani', 5.0000),
    ('Energy Feed', 2.0000),
    ('Acid Buff', 10.0000),
    ('Aragomix', 6.0000),
    ('Mineral CaprinoRV', 4.0000)
) AS v(nombre_producto, cantidad_minima)
INNER JOIN producto p
    ON p.nombre_producto = v.nombre_producto
INNER JOIN unidad_medida um
    ON um.abreviatura = 'saco'
ON CONFLICT (id_producto, fecha_vigencia) DO UPDATE
SET
    cantidad_minima = EXCLUDED.cantidad_minima,
    id_unidad_medida = EXCLUDED.id_unidad_medida,
    activo = TRUE,
    observaciones = EXCLUDED.observaciones;

-- ============================================================
-- VALIDACIONES DEL BLOQUE 2
-- ============================================================

SELECT COUNT(*) AS total_productos_minimos
FROM producto
WHERE nombre_producto IN (
    'Lechera Esp','ATP Las Lajas','Harina Soya','Desarrollo Novilla','Desarrollo Terneras',
    'Fase 1','Maiz','ATP Caprinus','Enogrde ATP','Destilado','Acemite','Ovinos',
    'Pre-Parto AF','Pre-Parto Dani','Energy Feed','Acid Buff','Aragomix','Mineral CaprinoRV'
);

SELECT
    p.nombre_producto,
    m.cantidad_minima,
    um.abreviatura AS unidad,
    m.fecha_vigencia,
    m.activo
FROM minimo_seguridad_producto m
INNER JOIN producto p
    ON p.id_producto = m.id_producto
INNER JOIN unidad_medida um
    ON um.id_unidad_medida = m.id_unidad_medida
ORDER BY p.nombre_producto;

SELECT
    nombre_producto,
    cantidad_actual,
    cantidad_minima,
    unidad_minimo,
    estado_inventario
FROM vista_inventario_minimos
WHERE cantidad_minima > 0
ORDER BY nombre_producto;
