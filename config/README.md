# Configuración - App Loops

## Archivos de Configuración

### Configuración Principal
- [loops-config.json](loops-config.json) - Configuración del sistema de Loops

## Estructura de Configuración

### loops-config.json

#### Sección del Proyecto
```json
{
  "project": {
    "name": "App Loops",
    "description": "Sistema de gestión de tareas y proyectos basado en Loops",
    "version": "1.0.0"
  }
}
```

#### Sección de Loops
```json
{
  "loops": {
    "definition": "Un Loop es un ciclo de trabajo que se repite hasta completar un objetivo",
    "types": [
      {
        "name": "Task Loop",
        "description": "Ciclo enfocado en completar tareas individuales"
      },
      {
        "name": "Project Loop",
        "description": "Ciclo para gestionar proyectos completos con múltiples tareas"
      },
      {
        "name": "Review Loop",
        "description": "Ciclo de revisión y mejora continua"
      }
    ]
  }
}
```

#### Sección de Tareas
```json
{
  "tasks": {
    "states": ["pending", "in_progress", "completed", "blocked"],
    "priorities": ["low", "medium", "high", "critical"]
  }
}
```

#### Sección de Proyectos
```json
{
  "projects": {
    "states": ["planning", "active", "on_hold", "completed"],
    "templates": [
      {
        "name": "Standard Project",
        "description": "Plantilla estándar para proyectos"
      }
    ]
  }
}
```

## Personalización

Para personalizar la configuración:

1. Editar `loops-config.json`
2. Actualizar los campos según las necesidades del proyecto
3. Mantener la estructura JSON válida
4. Documentar los cambios en el Changelog

## Valores por Defecto

### Estados de Tareas
- `pending`: Estado inicial
- `in_progress`: Trabajo en progreso
- `completed`: Trabajo completado
- `blocked`: Trabajo bloqueado

### Prioridades de Tareas
- `low`: Baja prioridad
- `medium`: Prioridad media (por defecto)
- `high`: Alta prioridad
- `critical`: Prioridad crítica

### Estados de Proyectos
- `planning`: En planificación
- `active`: Proyecto activo
- `on_hold`: En pausa
- `completed`: Completado