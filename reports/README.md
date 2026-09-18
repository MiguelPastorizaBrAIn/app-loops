# Reportes - App Loops

## Tipos de Reportes

### Reportes de Progreso
- `progress-report-YYYY-MM-DD.md` - Reporte diario de progreso
- `weekly-report-YYYY-MM-DD.md` - Reporte semanal
- `monthly-report-YYYY-MM.md` - Reporte mensual

### Reportes de Proyecto
- `project-status-PROJECT_ID.md` - Estado de un proyecto específico
- `task-summary.md` - Resumen de todas las tareas

### Reportes de Loops
- `loop-review-LOOP_ID.md` - Revisión de un Loop específico
- `loop-metrics.md` - Métricas de todos los Loops

## Cómo Crear un Reporte

### Usando el Script
```bash
# Crear reporte de progreso diario
./scripts/task-manager.sh create-report progress

# Crear reporte semanal
./scripts/task-manager.sh create-report weekly
```

### Manualmente
1. Copiar una plantilla de reporte existente
2. Renombrar con la fecha actual
3. Actualizar los datos

## Estructura de un Reporte

### Reporte de Progreso
```markdown
# Reporte de Progreso - YYYY-MM-DD

## Resumen
- Tareas completadas: X
- Tareas en progreso: X
- Horas trabajadas: X

## Logros
- [Lista de logros]

## Próximos Pasos
- [Lista de próximos pasos]

## Bloqueos
- [Lista de bloqueos si los hay]
```

### Reporte de Loop
```markdown
# Revisión del Loop LOOP_ID

## Resumen del Loop
- Nombre: X
- Tipo: X
- Estado: X

## Métricas
- Horas estimadas: X
- Horas reales: X
- Completado: X%

## Lecciones Aprendidas
- [Lista de lecciones]

## Recomendaciones
- [Lista de recomendaciones]
```

## Archivos de Reportes

### Ejemplos
- `progress-report-2026-09-18.md` - Reporte de hoy

## Automatización

### Reportes Automáticos
Puedes configurar reportes automáticos usando cron:

```bash
# Agregar al crontab
crontab -e

# Ejecutar reporte diario a las 18:00
0 18 * * * /ruta/a/app-loops/scripts/task-manager.sh create-report progress
```

## Análisis de Reportes

### Métricas Clave
1. **Productividad**: Tareas completadas por día/semana
2. **Eficiencia**: Horas estimadas vs reales
3. **Calidad**: Porcentaje de tareas sin errores
4. **Velocidad**: Tiempo promedio por tarea

### Gráficos Recomendados
- Gráfico de barras: Tareas por estado
- Gráfico de línea: Progreso en el tiempo
- Gráfico circular: Distribución de prioridades