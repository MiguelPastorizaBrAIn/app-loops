# Loops - App Loops

## Índice de Loops

### Loops Activos
- [example-loop.json](example-loop.json) - Ejemplo de Loop

## Cómo Crear un Nuevo Loop

### Usando la Plantilla
1. Copiar `templates/loop-template.json`
2. Renombrar con el ID del Loop (ej: `loop-002.json`)
3. Actualizar los campos según el Loop
4. Guardar en este directorio

### Campos de un Loop

#### Información Básica
- `loop_id`: Identificador único del Loop
- `type`: Tipo de Loop (Task Loop, Project Loop, Review Loop)
- `name`: Nombre del Loop
- `description`: Descripción detallada
- `start_date`: Fecha de inicio
- `end_date`: Fecha de fin
- `objective`: Objetivo específico del Loop

#### Gestión
- `tasks`: Lista de tareas asociadas
- `status`: Estado del Loop
- `created_at`: Fecha de creación
- `updated_at`: Fecha de última actualización
- `owner`: Propietario del Loop

#### Métricas
- `planned_hours`: Horas planificadas
- `actual_hours`: Horas reales
- `completion_percentage`: Porcentaje de completado

## Tipos de Loops

### Task Loop
- **Duración**: 1-5 días
- **Enfoque**: Completar una tarea específica
- **Resultado**: Tarea completada

### Project Loop
- **Duración**: 1-4 semanas
- **Enfoque**: Avanzar en un proyecto completo
- **Resultado**: Hito o fase del proyecto completada

### Review Loop
- **Duración**: 1 día
- **Enfoque**: Revisar y ajustar el trabajo
- **Resultado**: Optimización y mejora continua

## Estados de los Loops

- `planning`: En fase de planificación
- `in_progress`: Loop en progreso
- `completed`: Loop completado
- `cancelled`: Loop cancelado

## Ejemplo de Uso

```json
{
  "loop_id": "loop-002",
  "type": "Project Loop",
  "name": "Desarrollo de Funcionalidad",
  "description": "Loop para desarrollar una funcionalidad específica",
  "start_date": "2026-09-18",
  "end_date": "2026-09-25",
  "objective": "Completar el desarrollo de la funcionalidad X",
  "tasks": ["task-002", "task-003"],
  "status": "in_progress",
  "created_at": "2026-09-18T10:00:00Z",
  "updated_at": "2026-09-18T10:00:00Z",
  "owner": "MiguelPastorizaBrAIn",
  "metrics": {
    "planned_hours": 40,
    "actual_hours": 16,
    "completion_percentage": 40
  },
  "notes": "Segundo Loop del proyecto"
}
```

## Comandos Útiles

### Listar Todos los Loops
```bash
ls -la loops/
```

### Validar Archivos JSON
```bash
make validate
```

### Buscar Loops por Estado
```bash
grep -r '"status": "in_progress"' loops/
```