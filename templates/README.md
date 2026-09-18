# Plantillas - App Loops

## Índice de Plantillas

### Plantillas de Tareas
- [task-template.json](task-template.json) - Plantilla para crear nuevas tareas

### Plantillas de Proyectos
- [project-template.json](project-template.json) - Plantilla para crear nuevos proyectos

### Plantillas de Loops
- [loop-template.json](loop-template.json) - Plantilla para crear nuevos loops

## Cómo Usar las Plantillas

### Para Crear una Nueva Tarea
1. Copiar `task-template.json`
2. Renombrar con el ID de la tarea (ej: `task-002.json`)
3. Actualizar los campos según la tarea
4. Guardar en el directorio `tasks/`

### Para Crear un Nuevo Proyecto
1. Copiar `project-template.json`
2. Renombrar con el ID del proyecto (ej: `project-002.json`)
3. Actualizar los campos según el proyecto
4. Guardar en el directorio `projects/`

### Para Crear un Nuevo Loop
1. Copiar `loop-template.json`
2. Renombrar con el ID del loop (ej: `loop-002.json`)
3. Actualizar los campos según el loop
4. Guardar en el directorio `loops/`

## Campos Comunes

### ID
- Formato: `tipo-XXX` (ej: `task-001`, `project-001`, `loop-001`)
- Debe ser único en todo el proyecto

### Fechas
- Formato: `YYYY-MM-DDTHH:MM:SSZ` para timestamps
- Formato: `YYYY-MM-DD` para fechas simples

### Estados
- **Tareas**: `pending`, `in_progress`, `completed`, `blocked`
- **Proyectos**: `planning`, `active`, `on_hold`, `completed`
- **Loops**: `planning`, `in_progress`, `completed`, `cancelled`

### Prioridades (solo tareas)
- `low`, `medium`, `high`, `critical`