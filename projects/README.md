# Proyectos - App Loops

## Índice de Proyectos

### Proyectos Activos
- [example-project.json](example-project.json) - Ejemplo de proyecto

## Cómo Crear un Nuevo Proyecto

### Usando la Plantilla
1. Copiar `templates/project-template.json`
2. Renombrar con el ID del proyecto (ej: `project-002.json`)
3. Actualizar los campos según el proyecto
4. Guardar en este directorio

### Campos de un Proyecto

#### Información Básica
- `id`: Identificador único del proyecto
- `name`: Nombre del proyecto
- `description`: Descripción detallada
- `status`: Estado del proyecto
- `created_at`: Fecha de creación
- `updated_at`: Fecha de última actualización

#### Equipo
- `owner`: Propietario del proyecto
- `members`: Miembros del equipo

#### Gestión
- `tasks`: Lista de tareas asociadas
- `loop_type`: Tipo de Loop asociado
- `milestones`: Hitos del proyecto
- `tags`: Etiquetas para categorizar

#### Planificación
- `budget`: Presupuesto estimado y real
- `timeline`: Fecha de inicio y fin

## Estados de los Proyectos

- `planning`: En fase de planificación
- `active`: Proyecto activo
- `on_hold`: Proyecto en pausa
- `completed`: Proyecto completado

## Ejemplo de Uso

```json
{
  "id": "project-002",
  "name": "Desarrollo de API",
  "description": "Desarrollo de la API principal del sistema",
  "status": "active",
  "created_at": "2026-09-18T10:00:00Z",
  "updated_at": "2026-09-18T10:00:00Z",
  "owner": "MiguelPastorizaBrAIn",
  "members": ["MiguelPastorizaBrAIn"],
  "tasks": ["task-002", "task-003"],
  "loop_type": "Project Loop",
  "milestones": [
    {
      "id": "milestone-001",
      "title": "API Básica",
      "due_date": "2026-10-01T00:00:00Z",
      "completed": false
    }
  ],
  "tags": ["desarrollo", "api"],
  "budget": {
    "estimated": 10000,
    "actual": 0
  },
  "timeline": {
    "start_date": "2026-09-18",
    "end_date": "2026-12-31"
  }
}
```