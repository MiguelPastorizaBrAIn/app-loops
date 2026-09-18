# Scripts - App Loops

## Scripts Disponibles

### task-manager.sh
Script principal para la gestión de tareas, proyectos y Loops.

#### Uso
```bash
./scripts/task-manager.sh [comando] [opciones]
```

#### Comandos

##### Crear Tarea
```bash
./scripts/task-manager.sh create-task "Nombre de la Tarea"
```

##### Crear Proyecto
```bash
./scripts/task-manager.sh create-project "Nombre del Proyecto"
```

##### Crear Loop
```bash
./scripts/task-manager.sh create-loop "Nombre del Loop"
```

##### Listar Tareas
```bash
./scripts/task-manager.sh list-tasks
```

##### Listar Proyectos
```bash
./scripts/task-manager.sh list-projects
```

##### Listar Loops
```bash
./scripts/task-manager.sh list-loops
```

##### Mostrar Estado
```bash
./scripts/task-manager.sh status
```

##### Validar JSON
```bash
./scripts/task-manager.sh validate
```

##### Ayuda
```bash
./scripts/task-manager.sh help
```

## Instalación

1. Hacer el script ejecutable:
```bash
chmod +x scripts/task-manager.sh
```

2. Opcionalmente, agregar al PATH:
```bash
export PATH=$PATH:$(pwd)/scripts
```

## Ejemplos de Uso

### Flujo Completo
```bash
# Crear un proyecto
./scripts/task-manager.sh create-project "Mi Proyecto"

# Crear tareas para el proyecto
./scripts/task-manager.sh create-task "Tarea 1"
./scripts/task-manager.sh create-task "Tarea 2"

# Crear un Loop
./scripts/task-manager.sh create-loop "Sprint 1"

# Ver estado
./scripts/task-manager.sh status

# Listar todo
./scripts/task-manager.sh list-tasks
./scripts/task-manager.sh list-projects
./scripts/task-manager.sh list-loops

# Validar archivos
./scripts/task-manager.sh validate
```

## Notas

- Los scripts están en `/scripts/`
- Asegúrese de tener permisos de ejecución
- Requiere `bash` y `python3` para validación JSON