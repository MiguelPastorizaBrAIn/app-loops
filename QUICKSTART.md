# Guía Rápida - App Loops

## Inicio Rápido

### 1. Clonar el Repositorio
```bash
git clone https://github.com/MiguelPastorizaBrAIn/app-loops.git
cd app-loops
```

### 2. Estructura del Proyecto
```
app-loops/
├── config/           # Configuración del sistema
├── tasks/           # Tareas individuales
├── projects/        # Proyectos completos
├── templates/       # Plantillas para crear tareas y proyectos
├── docs/           # Documentación
└── loops/          # Definición de Loops
```

### 3. Crear una Nueva Tarea
1. Copiar `templates/task-template.json`
2. Renombrar con el ID de la tarea (ej: `task-002.json`)
3. Actualizar los campos según la tarea

### 4. Crear un Nuevo Proyecto
1. Copiar `templates/project-template.json`
2. Renombrar con el ID del proyecto (ej: `project-002.json`)
3. Actualizar los campos según el proyecto

### 5. Usar Loops
- **Task Loop**: Para tareas de 1-5 días
- **Project Loop**: Para proyectos de 1-4 semanas
- **Review Loop**: Para revisiones diarias

## Comandos Útiles

### Ver Estado del Repositorio
```bash
git status
```

### Ver Historial de Commits
```bash
git log --oneline -10
```

### Crear Nueva Rama
```bash
git checkout -b feature/nueva-funcionalidad
```

## Plantillas Disponibles

- `templates/task-template.json` - Para crear nuevas tareas
- `templates/project-template.json` - Para crear nuevos proyectos

## Documentación

- `docs/loops-workflow.md` - Flujo de trabajo de Loops
- `config/loops-config.json` - Configuración del sistema