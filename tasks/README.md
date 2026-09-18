# Tareas - App Loops

## Índice de Tareas

### Tareas Activas
- [example-task.json](example-task.json) - Ejemplo de tarea

## Cómo Crear una Nueva Tarea

### Usando la Plantilla
1. Copiar `templates/task-template.json`
2. Renombrar con el ID de la tarea (ej: `task-002.json`)
3. Actualizar los campos según la tarea
4. Guardar en este directorio

### Campos de una Tarea

#### Información Básica
- `id`: Identificador único de la tarea
- `title`: Título de la tarea
- `description`: Descripción detallada
- `status`: Estado de la tarea
- `priority`: Prioridad de la tarea

#### Metadatos
- `assignee`: Persona asignada
- `created_at`: Fecha de creación
- `updated_at`: Fecha de última actualización
- `tags`: Etiquetas para categorizar
- `loop_type`: Tipo de Loop asociado

#### Gestión
- `subtasks`: Subtareas dependientes
- `dependencies`: Tareas dependientes
- `estimated_hours`: Horas estimadas
- `actual_hours`: Horas reales

## Estados de las Tareas

- `pending`: Tarea pendiente de iniciar
- `in_progress`: Tarea en progreso
- `completed`: Tarea completada
- `blocked`: Tarea bloqueada

## Prioridades

- `low`: Baja prioridad
- `medium`: Prioridad media
- `high`: Alta prioridad
- `critical`: Prioridad crítica

## Ejemplo de Uso

```json
{
  "id": "task-002",
  "title": "Configurar base de datos",
  "description": "Configurar la base de datos para el proyecto",
  "status": "in_progress",
  "priority": "high",
  "assignee": "MiguelPastorizaBrAIn",
  "created_at": "2026-09-18T10:00:00Z",
  "updated_at": "2026-09-18T10:00:00Z",
  "tags": ["configuración", "base-de-datos"],
  "loop_type": "Task Loop",
  "subtasks": [],
  "dependencies": [],
  "estimated_hours": 8,
  "actual_hours": 0
}
```

## Comandos Útiles

### Listar Todas las Tareas
```bash
ls -la tasks/
```

### Validar Archivos JSON
```bash
make validate
```

### Buscar Tareas por Estado
```bash
grep -r '"status": "pending"' tasks/
```