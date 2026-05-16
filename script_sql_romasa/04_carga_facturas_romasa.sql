-- ============================================================
-- BLOQUE 4: CARGA REAL DE FACTURAS DE VENTAS DE ABRIL
-- Servicios Romasa - Fuente operacional transaccional
-- Ejecutar despues de 03_carga_formulas_romasa.sql
--
-- Regla de carga:
-- Una factura se define por cada valor unico de la columna Consecutivo.
-- Los productos vendidos bajo el mismo consecutivo forman parte de una sola factura.
-- ============================================================

SET search_path TO operacional;

-- ============================================================
-- 4.0 LIMPIAR UNICAMENTE LA CARGA DE VENTAS ANTERIOR
-- No toca minimos ni formulas.
-- ============================================================

DELETE FROM movimiento_inventario;
DELETE FROM detalle_factura_venta;
DELETE FROM factura_venta;

DROP TABLE IF EXISTS venta_abril_src;

CREATE TEMP TABLE venta_abril_src (
    codigo_producto VARCHAR(50),
    cabys VARCHAR(50),
    detalle VARCHAR(300),
    cedula_receptor VARCHAR(50),
    nombre_receptor VARCHAR(250),
    cantidad NUMERIC(18,4),
    consecutivo VARCHAR(100),
    fecha_emision DATE,
    subtotal NUMERIC(18,2),
    impuesto NUMERIC(18,2),
    tarifa_impuesto NUMERIC(8,4),
    total NUMERIC(18,2)
) ON COMMIT PRESERVE ROWS;

-- ============================================================
-- 4.1 CARGAR LAS 100 LINEAS REALES DEL EXCEL
-- ============================================================

INSERT INTO venta_abril_src
(codigo_producto, cabys, detalle, cedula_receptor, nombre_receptor, cantidad, consecutivo, fecha_emision, subtotal, impuesto, tarifa_impuesto, total)
VALUES
    ('T2', '6511900000100', 'Fletes - Hacienda La Lima S.A.', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000570', DATE '2026-04-27', 105800.00, 1058.00, 1.0000, 106858.00),
    ('T2', '6511900000100', 'Fletes - Sociedad Agricola Coto Monge', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000570', DATE '2026-04-27', 88320.00, 883.20, 1.0000, 89203.20),
    ('T2', '6511900000100', 'Fletes - Hacienda Alta Cresta', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000570', DATE '2026-04-27', 146970.00, 1469.70, 1.0000, 148439.70),
    ('P45', '2331999000000', 'ATP Finca Las Lajas', '302490922', 'Noré Alberto Gómez Corrales', 4554.0000, '10100101010000000569', DATE '2026-04-25', 987307.20, 9873.10, 1.0000, 997180.30),
    ('P6', '2331999000000', 'ATP Engorde Final', '302490922', 'Noré Alberto Gómez Corrales', 237.0000, '10100101010000000569', DATE '2026-04-25', 54510.00, 545.10, 1.0000, 55055.10),
    ('P13', '2331999000000', 'Maíz', '302490922', 'Noré Alberto Gómez Corrales', 138.0000, '10100101010000000569', DATE '2026-04-25', 23998.20, 240.00, 1.0000, 24238.20),
    ('P55', '2331999000000', 'ATP Preparto Top', '3101030140', 'Hacienda Chicua Sociedad Anónima', 184.0000, '10100101010000000568', DATE '2026-04-25', 73416.00, 734.20, 1.0000, 74150.20),
    ('P11', '2331999000000', 'Energy Feed', '3101030140', 'Hacienda Chicua Sociedad Anónima', 25.0000, '10100101010000000568', DATE '2026-04-25', 55500.00, 555.00, 1.0000, 56055.00),
    ('P4', '2331999000000', 'ATP Caprinus', '203350746', 'Manuel Ramirez La Estancia', 460.0000, '10100101010000000567', DATE '2026-04-25', 153640.00, 1536.40, 1.0000, 155176.40),
    ('P12', '2331999000000', 'Harina de Soya', '301920315', 'Xinia Gómez Corrales', 1380.0000, '10100101010000000566', DATE '2026-04-25', 372600.00, 3726.00, 1.0000, 376326.00),
    ('P19', '2331999000000', 'Destilado', '301920315', 'Xinia Gómez Corrales', 874.0000, '10100101010000000566', DATE '2026-04-25', 157145.20, 1571.50, 1.0000, 158716.70),
    ('P61', '2331999000000', 'Vaca Lechera BP', '3105909035', 'VALPAC VEINTICUATRO SRL', 460.0000, '10100101010000000565', DATE '2026-04-25', 113528.00, 1135.30, 1.0000, 114663.30),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304240722', 'Christiam Araya Alvarez', 1012.0000, '10100101010000000564', DATE '2026-04-25', 224664.00, 2246.60, 1.0000, 226910.60),
    ('P33', '2331999000000', 'Fase 1', '304240722', 'Christiam Araya Alvarez', 276.0000, '10100101010000000564', DATE '2026-04-25', 57877.20, 578.80, 1.0000, 58456.00),
    ('P13', '2331999000000', 'Maíz', '304240722', 'Christiam Araya Alvarez', 138.0000, '10100101010000000564', DATE '2026-04-25', 27048.00, 270.50, 1.0000, 27318.50),
    ('P22', '2331999000000', 'Soya', '304240722', 'Christiam Araya Alvarez', 92.0000, '10100101010000000564', DATE '2026-04-25', 24840.00, 248.40, 1.0000, 25088.40),
    ('P5', '2331999000000', 'ATP Desarrollo', '3102042436', 'Ten Fe Limitada', 368.0000, '10100102010000000290', DATE '2026-04-24', 96011.20, 960.10, 1.0000, 96971.30),
    ('P8', '2331999000000', 'ATP Preparto', '203790432', 'Jose Arturo Fernández Ardón', 368.0000, '10100102010000000289', DATE '2026-04-24', 148524.80, 1485.20, 1.0000, 150010.00),
    ('P4', '2331999000000', 'ATP Caprinus', '303850123', 'Hubert Aurelio Serrano Mata', 368.0000, '10100102010000000288', DATE '2026-04-24', 110878.40, 1108.80, 1.0000, 111987.20),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '108800566', 'Elias Gamboa Mata', 92.0000, '10100101010000000563', DATE '2026-04-22', 22632.00, 226.30, 1.0000, 22858.30),
    ('P5', '2331999000000', 'ATP Desarrollo', '108800566', 'Elias Gamboa Mata', 92.0000, '10100101010000000563', DATE '2026-04-22', 25760.00, 257.60, 1.0000, 26017.60),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '900920878', 'Rafael Mauricio Mendez Ulloa', 1012.0000, '10100101010000000562', DATE '2026-04-22', 279818.00, 2798.20, 1.0000, 282616.20),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '302980648', 'Gustavo Rojas Monge', 138.0000, '10100101010000000561', DATE '2026-04-22', 31464.00, 314.60, 1.0000, 31778.60),
    ('P33', '2331999000000', 'Fase 1', '302980648', 'Gustavo Rojas Monge', 92.0000, '10100101010000000561', DATE '2026-04-22', 19228.00, 192.30, 1.0000, 19420.30),
    ('P11', '2331999000000', 'Energy Feed', '3101276527', 'Agroveterinaria La Finca Santa Cruz', 125.0000, '10100101010000000560', DATE '2026-04-22', 250000.00, 2500.00, 1.0000, 252500.00),
    ('P34', '2331999000000', 'ATP Caprino RV', '3101014239', 'HACIENDA SANTA PAULA SOCIEDAD ANONIMA', 60.0000, '10100102010000000287', DATE '2026-04-21', 66000.00, 660.00, 1.0000, 66660.00),
    ('P1', '2331999000000', 'Acid Buff', '3101014239', 'HACIENDA SANTA PAULA SOCIEDAD ANONIMA', 75.0000, '10100102010000000287', DATE '2026-04-21', 67500.00, 675.00, 1.0000, 68175.00),
    ('P11', '2331999000000', 'Energy Feed', '3101014239', 'HACIENDA SANTA PAULA SOCIEDAD ANONIMA', 25.0000, '10100102010000000287', DATE '2026-04-21', 46500.00, 465.00, 1.0000, 46965.00),
    ('T2', '6511900000100', 'Fletes - Hacienda la lima S.A', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000559', DATE '2026-04-20', 106950.00, 1069.50, 1.0000, 108019.50),
    ('T2', '6511900000100', 'Fletes - Naida S.A', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000559', DATE '2026-04-20', 98670.00, 986.70, 1.0000, 99656.70),
    ('T2', '6511900000100', 'Fletes - Hacienda Alta Cresta', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000559', DATE '2026-04-20', 149090.00, 1490.90, 1.0000, 150580.90),
    ('P13', '2331999000000', 'Maíz', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 690.0000, '10100101010000000558', DATE '2026-04-20', 129720.00, 1297.20, 1.0000, 131017.20),
    ('P22', '2331999000000', 'Soya', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 276.0000, '10100101010000000558', DATE '2026-04-20', 74520.00, 745.20, 1.0000, 75265.20),
    ('P19', '2331999000000', 'Destilado', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 138.0000, '10100101010000000558', DATE '2026-04-20', 27186.00, 271.90, 1.0000, 27457.90),
    ('P14', '2331999000000', 'Núcleo ATP', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 20.0000, '10100101010000000558', DATE '2026-04-20', 24000.00, 240.00, 1.0000, 24240.00),
    ('P23', '2331999000000', 'Acemite', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 138.0000, '10100101010000000558', DATE '2026-04-20', 31188.00, 311.90, 1.0000, 31499.90),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304240722', 'Christiam Araya Alvarez', 1196.0000, '10100101010000000557', DATE '2026-04-20', 265512.00, 2655.10, 1.0000, 268167.10),
    ('P33', '2331999000000', 'Fase 1', '304240722', 'Christiam Araya Alvarez', 230.0000, '10100101010000000557', DATE '2026-04-20', 48231.00, 482.30, 1.0000, 48713.30),
    ('P13', '2331999000000', 'Maíz', '304240722', 'Christiam Araya Alvarez', 276.0000, '10100101010000000557', DATE '2026-04-20', 54096.00, 541.00, 1.0000, 54637.00),
    ('P22', '2331999000000', 'Soya', '304240722', 'Christiam Araya Alvarez', 138.0000, '10100101010000000557', DATE '2026-04-20', 37260.00, 372.60, 1.0000, 37632.60),
    ('P12', '2331999000000', 'Harina de Soya', '3102937364', '3-102-937364', 1380.0000, '10100101010000000556', DATE '2026-04-20', 376740.00, 3767.40, 1.0000, 380507.40),
    ('P45', '2331999000000', 'ATP Finca Las Lajas', '302490922', 'Noré Alberto Gómez Corrales', 4830.0000, '10100101010000000555', DATE '2026-04-20', 1047144.00, 10471.40, 1.0000, 1057615.40),
    ('P5', '2331999000000', 'ATP Desarrollo', '402450809', 'Daniela Ugalde Vargas', 460.0000, '10100101010000000554', DATE '2026-04-16', 113390.00, 1133.90, 1.0000, 114523.90),
    ('P13', '2331999000000', 'Maíz', '402450809', 'Daniela Ugalde Vargas', 184.0000, '10100101010000000554', DATE '2026-04-16', 33432.80, 334.30, 1.0000, 33767.10),
    ('P19', '2331999000000', 'Destilado', '402450809', 'Daniela Ugalde Vargas', 184.0000, '10100101010000000554', DATE '2026-04-16', 35519.40, 355.20, 1.0000, 35874.60),
    ('P4', '2331999000000', 'ATP Caprinus', '303850123', 'Hubert Aurelio Serrano Mata', 368.0000, '10100102010000000286', DATE '2026-04-15', 110878.40, 1108.80, 1.0000, 111987.20),
    ('P51', '2331999000000', 'ATP Vacas de cría', '3102007455', 'Somasol Del Risco LTDA', 460.0000, '10100102010000000285', DATE '2026-04-15', 116656.00, 1166.60, 1.0000, 117822.60),
    ('P61', '2331999000000', 'Vaca Lechera BP', '3105909035', 'VALPAC VEINTICUATRO SRL', 368.0000, '10100101010000000553', DATE '2026-04-15', 90557.40, 905.60, 1.0000, 91463.00),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304130528', 'OSCAR RAMIREZ', 1150.0000, '10100101010000000552', DATE '2026-04-15', 263925.00, 2639.30, 1.0000, 266564.30),
    ('P5', '2331999000000', 'ATP Desarrollo', '304130528', 'OSCAR RAMIREZ', 92.0000, '10100101010000000552', DATE '2026-04-15', 21528.00, 215.30, 1.0000, 21743.30),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '900920878', 'Rafael Mauricio Mendez Ulloa', 1012.0000, '10100101010000000551', DATE '2026-04-15', 279818.00, 2798.20, 1.0000, 282616.20),
    ('P22', '2331999000000', 'Soya', '301920315', 'Xinia Gómez Corrales', 1380.0000, '10100101010000000550', DATE '2026-04-15', 372600.00, 3726.00, 1.0000, 376326.00),
    ('P19', '2331999000000', 'Destilado', '301920315', 'Xinia Gómez Corrales', 736.0000, '10100101010000000550', DATE '2026-04-15', 132332.80, 1323.30, 1.0000, 133656.10),
    ('T2', '6511900000100', 'Fletes - Hacienda La Lima S.A', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000549', DATE '2026-04-13', 104650.00, 1046.50, 1.0000, 105696.50),
    ('T2', '6511900000100', 'Fletes - Sociedad Coto Monge', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000549', DATE '2026-04-13', 88000.00, 880.00, 1.0000, 88880.00),
    ('T2', '6511900000100', 'Fletes - Hacienda Alta Cresta', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000549', DATE '2026-04-13', 146970.00, 1469.70, 1.0000, 148439.70),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304130528', 'OSCAR RAMIREZ', 690.0000, '10100101010000000548', DATE '2026-04-13', 158355.00, 1583.60, 1.0000, 159938.60),
    ('P5', '2331999000000', 'ATP Desarrollo', '304130528', 'OSCAR RAMIREZ', 92.0000, '10100101010000000548', DATE '2026-04-13', 21528.00, 215.30, 1.0000, 21743.30),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304240722', 'Christiam Araya Alvarez', 1196.0000, '10100101010000000547', DATE '2026-04-13', 265512.00, 2655.10, 1.0000, 268167.10),
    ('P33', '2331999000000', 'Fase 1', '304240722', 'Christiam Araya Alvarez', 230.0000, '10100101010000000547', DATE '2026-04-13', 48231.00, 482.30, 1.0000, 48713.30),
    ('P13', '2331999000000', 'Maíz', '304240722', 'Christiam Araya Alvarez', 276.0000, '10100101010000000547', DATE '2026-04-13', 54096.00, 541.00, 1.0000, 54637.00),
    ('P22', '2331999000000', 'Soya', '304240722', 'Christiam Araya Alvarez', 138.0000, '10100101010000000547', DATE '2026-04-13', 37260.00, 372.60, 1.0000, 37632.60),
    ('P45', '2331999000000', 'ATP Finca Las Lajas', '302490922', 'Noré Alberto Gómez Corrales', 4600.0000, '10100101010000000546', DATE '2026-04-13', 977960.00, 9779.60, 1.0000, 987739.60),
    ('P11', '2331999000000', 'Energy Feed', '3101030140', 'Hacienda Chicua Sociedad Anónima', 50.0000, '10100102010000000284', DATE '2026-04-10', 110000.00, 1100.00, 1.0000, 111100.00),
    ('P22', '2331999000000', 'Soya', '301920315', 'Xinia Gómez Corrales', 1380.0000, '10100102010000000283', DATE '2026-04-10', 372600.00, 3726.00, 1.0000, 376326.00),
    ('P10', '2331999000000', 'DDGS', '301920315', 'Xinia Gómez Corrales', 782.0000, '10100102010000000283', DATE '2026-04-10', 140603.60, 1406.00, 1.0000, 142009.60),
    ('P11', '2331999000000', 'Energy Feed', '3101048150', 'RIO BIRRIS SA', 125.0000, '10100102010000000282', DATE '2026-04-10', 262500.00, 2625.00, 1.0000, 265125.00),
    ('P3', '2331999000000', 'ATP Caprino Repro Vital', '108870606', 'Ronny Morera', 20.0000, '10100101010000000545', DATE '2026-04-09', 24750.00, 247.50, 1.0000, 24997.50),
    ('P5', '2331999000000', 'ATP Desarrollo', '103911491', 'ORLANDO CHANTO', 46.0000, '10100102010000000281', DATE '2026-04-09', 13500.10, 135.00, 1.0000, 13635.10),
    ('P8', '2331999000000', 'ATP Preparto', '203790432', 'Jose Arturo Fernández Ardón', 552.0000, '10100102010000000280', DATE '2026-04-09', 222787.20, 2227.90, 1.0000, 225015.10),
    ('P5', '2331999000000', 'ATP Desarrollo', '3102042436', 'Ten Fe Limitada', 368.0000, '10100102010000000279', DATE '2026-04-09', 96011.20, 960.10, 1.0000, 96971.30),
    ('P4', '2331999000000', 'ATP Caprinus', '303850123', 'Hubert Aurelio Serrano Mata', 368.0000, '10100102010000000278', DATE '2026-04-09', 110878.40, 1108.80, 1.0000, 111987.20),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '302980648', 'Gustavo Rojas Monge', 138.0000, '10100101010000000544', DATE '2026-04-08', 31464.00, 314.60, 1.0000, 31778.60),
    ('P33', '2331999000000', 'Fase 1', '302980648', 'Gustavo Rojas Monge', 92.0000, '10100101010000000544', DATE '2026-04-08', 19228.00, 192.30, 1.0000, 19420.30),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '900920878', 'Rafael Mauricio Mendez Ulloa', 1012.0000, '10100101010000000543', DATE '2026-04-08', 279818.00, 2798.20, 1.0000, 282616.20),
    ('P4', '2331999000000', 'ATP Caprinus', '203350746', 'Manuel Ramirez La Estancia', 460.0000, '10100101010000000542', DATE '2026-04-08', 153640.00, 1536.40, 1.0000, 155176.40),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '108800566', 'Elias Gamboa Mata', 92.0000, '10100101010000000541', DATE '2026-04-08', 22632.00, 226.30, 1.0000, 22858.30),
    ('P5', '2331999000000', 'Desarrollo', '108800566', 'Elias Gamboa Mata', 92.0000, '10100101010000000541', DATE '2026-04-08', 25760.00, 257.60, 1.0000, 26017.60),
    ('P2', '2331999000000', 'ATP', '3101026562', 'Agrocentro Tropical S.A.', 138.0000, '10100101010000000540', DATE '2026-04-08', 37798.20, 378.00, 1.0000, 38176.20),
    ('1', '8393900000000', 'Servicios Profesionales Zona Franca OC- 4502375011', '3101831028', 'DSM Costarricense Zona Franca', 1.0000, '10100102010000000277', DATE '2026-04-08', 929731.00, 0.00, 0.0000, 929731.00),
    ('P11', '2331999000000', 'Energy Feed', '3101276527', 'Agroveterinaria La Finca Santa Cruz', 200.0000, '10100102010000000276', DATE '2026-04-08', 400000.00, 4000.00, 1.0000, 404000.00),
    ('T2', '6511900000100', 'Hacienda La Lima S.A', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000539', DATE '2026-04-08', 102350.00, 1023.50, 1.0000, 103373.50),
    ('T2', '6511900000100', 'Naida S.A', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000539', DATE '2026-04-08', 98670.00, 986.70, 1.0000, 99656.70),
    ('T2', '6511900000100', 'Hacienda Alta Cresta', '3101233465', 'CONCENTRADOS GASTÓN FERNÁNDEZ MORA S.A.', 1.0000, '10100101010000000539', DATE '2026-04-08', 149040.00, 1490.40, 1.0000, 150530.40),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '302980648', 'Gustavo Rojas Monge', 138.0000, '10100101010000000538', DATE '2026-04-01', 31464.00, 314.60, 1.0000, 31778.60),
    ('P33', '2331999000000', 'Fase 1', '302980648', 'Gustavo Rojas Monge', 92.0000, '10100101010000000538', DATE '2026-04-01', 19228.00, 192.30, 1.0000, 19420.30),
    ('P12', '2331999000000', 'Harina de Soya', NULL, 'Tiquete Electrónico', 92.0000, '10100101040000000073', DATE '2026-04-01', 25300.00, 253.00, 1.0000, 25553.00),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '900920878', 'Rafael Mauricio Mendez Ulloa', 1012.0000, '10100101010000000537', DATE '2026-04-01', 279818.00, 2798.20, 1.0000, 282616.20),
    ('P12', '2331999000000', 'Harina de Soya', '3102937364', '3-102-937364', 920.0000, '10100101010000000536', DATE '2026-04-01', 251160.00, 2511.60, 1.0000, 253671.60),
    ('P13', '2331999000000', 'Maíz', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 690.0000, '10100101010000000535', DATE '2026-04-01', 129720.00, 1297.20, 1.0000, 131017.20),
    ('P22', '2331999000000', 'Soya', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 276.0000, '10100101010000000535', DATE '2026-04-01', 74520.00, 745.20, 1.0000, 75265.20),
    ('P19', '2331999000000', 'Destilado', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 138.0000, '10100101010000000535', DATE '2026-04-01', 27186.00, 271.90, 1.0000, 27457.90),
    ('P23', '2331999000000', 'Acemite', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 138.0000, '10100101010000000535', DATE '2026-04-01', 31188.00, 311.90, 1.0000, 31499.90),
    ('P27', '2331999000000', 'Núcleo', '302380701', 'MARCOS URBINO DE CARMEN ROJAS SERRANO', 20.0000, '10100101010000000535', DATE '2026-04-01', 24000.00, 240.00, 1.0000, 24240.00),
    ('P7', '2331999000000', 'ATP Lecheria Especializada', '304240722', 'Christiam Araya Alvarez', 1104.0000, '10100101010000000534', DATE '2026-04-01', 245088.00, 2450.90, 1.0000, 247538.90),
    ('P33', '2331999000000', 'Fase 1', '304240722', 'Christiam Araya Alvarez', 276.0000, '10100101010000000534', DATE '2026-04-01', 57877.20, 578.80, 1.0000, 58456.00),
    ('P13', '2331999000000', 'Maíz', '304240722', 'Christiam Araya Alvarez', 184.0000, '10100101010000000534', DATE '2026-04-01', 36064.00, 360.60, 1.0000, 36424.60),
    ('P22', '2331999000000', 'Soya', '304240722', 'Christiam Araya Alvarez', 92.0000, '10100101010000000534', DATE '2026-04-01', 24840.00, 248.40, 1.0000, 25088.40),
    ('P11', '2331999000000', 'Energy Feed', '109150380', 'Jose Miguel Sanabria Gonzalez', 25.0000, '10100101010000000533', DATE '2026-04-01', 55475.00, 554.80, 1.0000, 56029.80),
    ('P45', '2331999000000', 'ATP Finca Las Lajas', '302490922', 'Noré Alberto Gómez Corrales', 4370.0000, '10100101010000000532', DATE '2026-04-01', 929062.00, 9290.60, 1.0000, 938352.60);

-- ============================================================
-- 4.2 CARGAR PRODUCTOS VENDIDOS EXACTAMENTE COMO APARECEN EN EL DETALLE
-- ============================================================

INSERT INTO producto
(codigo_producto, nombre_producto, id_tipo_producto, id_unidad_medida, requiere_inventario, activo, observaciones)
SELECT DISTINCT
    s.codigo_producto,
    s.detalle,
    tp.id_tipo_producto,
    um.id_unidad_medida,
    CASE
        WHEN s.codigo_producto IN ('T2', '1') THEN FALSE
        ELSE TRUE
    END AS requiere_inventario,
    TRUE,
    'Producto cargado desde reporte detallado real de ventas de abril.'
FROM venta_abril_src s
JOIN tipo_producto tp
    ON tp.nombre_tipo = CASE
        WHEN s.codigo_producto IN ('T2', '1') THEN 'SERVICIO'
        WHEN s.detalle IN ('Maíz', 'Maiz', 'Soya', 'Destilado', 'Harina de Soya', 'Energy Feed', 'Acid Buff', 'Acemite', 'DDGS') THEN 'MATERIA_PRIMA'
        WHEN s.detalle IN ('Núcleo ATP', 'Nucleo ATP', 'Núcleo', 'Nucleo') THEN 'PRODUCTO_INTERMEDIO'
        ELSE 'PRODUCTO_TERMINADO'
    END
JOIN unidad_medida um
    ON um.abreviatura = CASE
        WHEN s.codigo_producto IN ('T2', '1') THEN 'und'
        ELSE 'kg'
    END
ON CONFLICT (nombre_producto) DO UPDATE
SET
    codigo_producto = EXCLUDED.codigo_producto,
    id_tipo_producto = EXCLUDED.id_tipo_producto,
    id_unidad_medida = EXCLUDED.id_unidad_medida,
    requiere_inventario = EXCLUDED.requiere_inventario,
    activo = TRUE,
    observaciones = EXCLUDED.observaciones;

-- ============================================================
-- 4.3 MANTENER INVENTARIO INICIAL EN CERO PARA PRODUCTOS DE VENTA
-- ============================================================

INSERT INTO inventario_actual (id_producto, cantidad_actual, observaciones)
SELECT p.id_producto, 0, 'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.'
FROM producto p
WHERE p.requiere_inventario = TRUE
ON CONFLICT (id_producto) DO UPDATE
SET
    cantidad_actual = 0,
    fecha_actualizacion = CURRENT_TIMESTAMP,
    observaciones = 'Inventario inicial en cero segun situacion actual reportada por Servicios Romasa.';

-- ============================================================
-- 4.4 CARGAR CLIENTES EXACTAMENTE COMO APARECEN EN EL REPORTE
-- ============================================================

INSERT INTO cliente (cedula_cliente, nombre_cliente, tipo_cliente, activo)
SELECT DISTINCT
    s.cedula_receptor,
    s.nombre_receptor,
    'No clasificado',
    TRUE
FROM venta_abril_src s
WHERE NOT EXISTS (
    SELECT 1
    FROM cliente c
    WHERE (c.cedula_cliente = s.cedula_receptor)
       OR (c.cedula_cliente IS NULL AND s.cedula_receptor IS NULL AND c.nombre_cliente = s.nombre_receptor)
)
ON CONFLICT (cedula_cliente) DO UPDATE
SET
    nombre_cliente = EXCLUDED.nombre_cliente,
    activo = TRUE;

-- ============================================================
-- 4.5 CARGAR ENCABEZADOS DE FACTURA AGRUPADOS POR CONSECUTIVO
-- ============================================================

INSERT INTO factura_venta
(consecutivo_factura, fecha_emision, id_cliente, subtotal_factura, impuesto_factura, total_factura)
SELECT
    x.consecutivo,
    x.fecha_emision,
    c.id_cliente,
    x.subtotal_factura,
    x.impuesto_factura,
    x.total_factura
FROM (
    SELECT
        consecutivo,
        fecha_emision,
        cedula_receptor,
        nombre_receptor,
        SUM(subtotal) AS subtotal_factura,
        SUM(impuesto) AS impuesto_factura,
        SUM(total) AS total_factura
    FROM venta_abril_src
    GROUP BY consecutivo, fecha_emision, cedula_receptor, nombre_receptor
) x
JOIN cliente c
    ON (c.cedula_cliente = x.cedula_receptor)
    OR (c.cedula_cliente IS NULL AND x.cedula_receptor IS NULL AND c.nombre_cliente = x.nombre_receptor)
ON CONFLICT (consecutivo_factura) DO UPDATE
SET
    fecha_emision = EXCLUDED.fecha_emision,
    id_cliente = EXCLUDED.id_cliente,
    subtotal_factura = EXCLUDED.subtotal_factura,
    impuesto_factura = EXCLUDED.impuesto_factura,
    total_factura = EXCLUDED.total_factura;

-- ============================================================
-- 4.6 CARGAR DETALLE COMPLETO DE VENTAS
-- ============================================================

INSERT INTO detalle_factura_venta
(id_factura, id_producto, cabys, detalle_original, cantidad, precio_unitario, subtotal, impuesto, tarifa_impuesto, total)
SELECT
    fv.id_factura,
    p.id_producto,
    s.cabys,
    s.detalle,
    s.cantidad,
    CASE WHEN s.cantidad > 0 THEN ROUND(s.subtotal / s.cantidad, 4) ELSE NULL END AS precio_unitario,
    s.subtotal,
    s.impuesto,
    s.tarifa_impuesto,
    s.total
FROM venta_abril_src s
JOIN factura_venta fv
    ON fv.consecutivo_factura = s.consecutivo
JOIN producto p
    ON p.nombre_producto = s.detalle;

-- ============================================================
-- 4.7 GENERAR MOVIMIENTOS DE INVENTARIO POR VENTAS, EXCLUYENDO SERVICIOS
-- ============================================================

INSERT INTO movimiento_inventario
(id_producto, id_tipo_movimiento, id_factura, fecha_movimiento, cantidad, observaciones)
SELECT
    dfv.id_producto,
    tm.id_tipo_movimiento,
    fv.id_factura,
    fv.fecha_emision,
    dfv.cantidad,
    'Salida generada desde factura real de ventas de abril.'
FROM detalle_factura_venta dfv
JOIN factura_venta fv
    ON fv.id_factura = dfv.id_factura
JOIN producto p
    ON p.id_producto = dfv.id_producto
JOIN tipo_movimiento_inventario tm
    ON tm.nombre_movimiento = 'VENTA_DIRECTA'
WHERE p.requiere_inventario = TRUE;

-- ============================================================
-- 4.8 VALIDACIONES DE CARGA
-- ============================================================

SELECT COUNT(*) AS total_lineas_fuente
FROM venta_abril_src;

SELECT COUNT(DISTINCT consecutivo) AS total_consecutivos_fuente
FROM venta_abril_src;

SELECT COUNT(*) AS total_facturas_cargadas
FROM factura_venta;

SELECT COUNT(*) AS total_lineas_factura_cargadas
FROM detalle_factura_venta;

SELECT
    fv.consecutivo_factura,
    fv.fecha_emision,
    c.nombre_cliente,
    COUNT(dfv.id_detalle_factura) AS lineas_factura,
    fv.subtotal_factura,
    fv.impuesto_factura,
    fv.total_factura
FROM factura_venta fv
JOIN cliente c
    ON c.id_cliente = fv.id_cliente
JOIN detalle_factura_venta dfv
    ON dfv.id_factura = fv.id_factura
GROUP BY
    fv.consecutivo_factura,
    fv.fecha_emision,
    c.nombre_cliente,
    fv.subtotal_factura,
    fv.impuesto_factura,
    fv.total_factura
ORDER BY fv.fecha_emision, fv.consecutivo_factura;

SELECT
    SUM(subtotal) AS subtotal_abril,
    SUM(impuesto) AS impuesto_abril,
    SUM(total) AS total_abril
FROM detalle_factura_venta;

SELECT
    p.nombre_producto,
    SUM(dfv.cantidad) AS cantidad_total_vendida,
    SUM(dfv.total) AS total_vendido
FROM detalle_factura_venta dfv
JOIN producto p
    ON p.id_producto = dfv.id_producto
GROUP BY p.nombre_producto
ORDER BY total_vendido DESC;

-- Validacion adicional: no debe devolver registros.
SELECT 
    fv.consecutivo_factura,
    fv.fecha_emision,
    c.nombre_cliente,
    COUNT(dfv.id_detalle_factura) AS cantidad_lineas
FROM factura_venta fv
INNER JOIN cliente c
    ON c.id_cliente = fv.id_cliente
LEFT JOIN detalle_factura_venta dfv
    ON dfv.id_factura = fv.id_factura
GROUP BY 
    fv.consecutivo_factura,
    fv.fecha_emision,
    c.nombre_cliente
HAVING COUNT(dfv.id_detalle_factura) = 0
ORDER BY fv.consecutivo_factura;
