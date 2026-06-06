# Proyecto 2 - Inteligencia de Negocios: Servicios Romasa

## Descripción general

Este repositorio contiene el desarrollo del Proyecto 2 del curso TI6900 Inteligencia de Negocios del Tecnológico de Costa Rica. El proyecto consiste en el diseño e implementación de una solución de Inteligencia de Negocios para la empresa Servicios Romasa, una PYME dedicada a la reventa de productos, asesoría y confección de alimentos para animales.

La solución permite analizar ventas, productos, clientes, mínimos de seguridad, fórmulas activas de alimento, movimientos de inventario y brechas contra stock mínimo. El caso se enfoca en apoyar la toma de decisiones relacionadas con control de inventario, reposición mínima, comportamiento comercial y consumo estimado de materias primas según las fórmulas utilizadas por la empresa.

## Problema de negocio

Servicios Romasa enfrenta dificultades para determinar con precisión cuánto inventario posee realmente, cuánto consumen sus procesos productivos y qué productos requieren atención para evitar faltantes. La empresa trabaja con materias primas como maíz, soya, DDGS, destilado, acid buff y otros insumos que se combinan en diferentes porcentajes para elaborar alimentos dirigidos principalmente al ganado lechero.

El problema se vuelve más relevante porque el inventario actual fue reportado en cero, existen mínimos de seguridad por producto y las ventas de abril muestran movimientos importantes tanto de productos terminados como de materias primas. La ausencia de una solución analítica limita la capacidad de la empresa para visualizar productos críticos, clientes relevantes, productos con mayor peso en ventas y brechas contra los mínimos definidos.

## Objetivo general

Diseñar e implementar una solución integral de Inteligencia de Negocios para Servicios Romasa, mediante la construcción de una base de datos transaccional en PostgreSQL, un modelo dimensional, un proceso ETL en Pentaho Data Integration y un dashboard analítico orientado a ventas, clientes, productos, fórmulas e inventario mínimo.

## Preguntas de negocio

1. ¿Cómo se comportaron las ventas de Servicios Romasa durante el periodo analizado y qué semanas presentaron mayor o menor facturación?
2. ¿Cuáles productos generaron mayor monto vendido y cuáles deben considerarse prioritarios por su impacto económico?
3. ¿Cuáles clientes concentran la mayor facturación y qué nivel de dependencia comercial existe respecto a ellos?
4. ¿Qué productos presentan mayor brecha contra el stock mínimo, considerando que el inventario actual reportado es cero?
5. ¿Qué materias primas tienen mayor participación dentro de las fórmulas activas y cómo se relacionan con los productos terminados vendidos?

## KPIs principales

- Ventas totales por semana.
- Ventas totales por producto.
- Ventas totales por cliente.
- Brecha contra stock mínimo.
- Cantidad mínima de seguridad por producto.
- Porcentaje de inclusión de materias primas por fórmula.
- Movimientos de inventario generados por ventas.

## Arquitectura de la solución

La solución está organizada en cuatro capas principales:

1. **Fuente operacional / OLTP**  
   Base de datos transaccional diseñada en PostgreSQL bajo el esquema `operacional`, utilizada para almacenar la información base de Servicios Romasa, incluyendo productos, clientes, facturas, detalle de ventas, mínimos de seguridad, fórmulas activas, inventario actual y movimientos de inventario.

2. **Modelo dimensional / DW**  
   Modelo analítico implementado en PostgreSQL bajo el esquema `dw_romasa`, compuesto por dimensiones y tablas de hechos orientadas al análisis de ventas, clientes, productos, fórmulas y movimientos de inventario.

3. **Proceso ETL**  
   Proceso desarrollado en Pentaho Data Integration para extraer datos desde la fuente operacional, transformarlos mediante reglas de limpieza, homologación y relación entre entidades, y cargarlos hacia el modelo dimensional `dw_romasa`.

4. **Dashboard Tableau**  
   Dashboard implementado para visualizar indicadores clave y responder las preguntas de negocio planteadas, incluyendo resumen ejecutivo, ventas por semana, top productos por ventas, top clientes por ventas y brecha contra stock mínimo.

## Herramientas utilizadas

| Herramienta | Uso dentro del proyecto |
|---|---|
| PostgreSQL | Gestión de la base de datos transaccional y del modelo dimensional |
| pgAdmin 4 | Administración, ejecución de scripts SQL, restauración de backups y validación de datos |
| Pentaho Data Integration | Desarrollo y ejecución del proceso ETL |
| Metabase / herramienta de visualización | Construcción del dashboard analítico |
| GitHub | Control de versiones y almacenamiento de archivos del proyecto |

## Integrantes del grupo

| Integrante | Carné |
|---|---|
| Brandon Badilla Rodríguez | 2023047817 |
| David A. Ramírez Vargas | 2023087580 |
| Emanuel Alves Mata | 2023111119 |
| Michelle Reyes Flores | 2023281947 |
| Caleb Segura Rodríguez | 2024105617 |


## Dashboard analítico

El dashboard final incluye visualizaciones diseñadas para apoyar la toma de decisiones de Servicios Romasa. Las principales pantallas y gráficos son:


## Validaciones principales

Para comprobar que la fuente operacional fue cargada correctamente, se realizaron validaciones de conteo, integridad y consistencia sobre las tablas principales. Entre las validaciones se revisó:

- Cantidad de productos cargados.
- Cantidad de mínimos de seguridad.
- Cantidad de fórmulas activas.
- Cantidad de líneas de detalle de fórmula.
- Cantidad de facturas cargadas.
- Cantidad de líneas de detalle de ventas.
- Existencia de facturas sin detalle.
- Coincidencia entre totales de encabezado y detalle de factura.
- Estado de productos contra mínimos de seguridad.
- Suma de porcentajes por fórmula.

## Consideraciones del proyecto

El inventario actual se registró en cero porque esta fue la condición reportada para el caso de Servicios Romasa. Por esa razón, la visualización de brecha contra stock mínimo no representa una orden definitiva de compra, sino una alerta operativa que muestra cuánto falta para alcanzar el mínimo de seguridad definido para cada producto.

La información disponible corresponde principalmente a ventas de abril, mínimos de seguridad y fórmulas activas. Por tanto, el análisis permite responder preguntas del periodo estudiado y generar evidencia para la toma de decisiones, pero no constituye una proyección histórica avanzada por temporada lluviosa o seca.

## Estado del proyecto

El proyecto se encuentra finalizado y contiene los componentes principales requeridos para una solución de Inteligencia de Negocios: fuente operacional transaccional, modelo dimensional, proceso ETL, dashboard analítico, documentación de apoyo y evidencias de validación.
