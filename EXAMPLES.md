# Ejemplos Prácticos - App Loops

## Ejemplo 1: Crear una Nueva Tarea

### Paso 1: Copiar la Plantilla
```bash
cp templates/task-template.json tasks/task-006.json
```

### Paso 2: Editar la Tarea
```json
{
  "id": "task-006",
  "title": "Implementar autenticación",
  "description": "Agregar sistema de autenticación usuarios",
  "status": "pending",
  "priority": "high",
  "assignee": "MiguelPastorizaBrAIn",
  "created_at": "2026-09-18T12:00:00Z",
  "updated_at": "2026-09-18T12:00:00Z",
  "tags": ["seguridad", "auth"],
  "loop_type": "Task Loop",
  "project_id": "project-001",
  "estimated_hours": 8,
  "actual_hours": 0
}
```

### Paso 3: Actualizar el Proyecto
Agregar `"task-006"` al array de tasks en `projects/project-001.json`

---

## Ejemplo 2: Crear un Nuevo Loop

### Paso 1: Copiar la Plantilla
```bash
cp templates/loop-template.json loops/loop-004.json
```

### Paso 2: Editar el Loop
```json
{
  "loop_id": "loop-004",
  "type": "Task Loop",
  "name": "Sprint de Desarrollo",
  "description": "Sprint de 1 semana para desarrollo de funcionalidades",
  "start_date": "2026-09-20",
  "end_date": "2026-09-27",
  "objective": "Completar 5 funcionalidades clave",
  "tasks": ["task-004", "task-005", "task-006"],
  "status": "planning",
  "created_at": "2026-09-18T12:00:00Z",
  "updated_at": "2026-09-18T12:00:00Z",
  "owner": "MiguelPastorizaBrAIn",
  "metrics": {
    "planned_hours": 40,
    "actual_hours": 0,
    "completion_percentage": 0
  }
}
```

---

## Ejemplo 3: Usar el Makefile

### Ver Comandos Disponibles
```bash
make help
```

### Listar Tareas
```bash
make list-tasks
```

### Listar Proyectos
```bash
make list-projects
```

### Validar Archivos JSON
```bash
make validate
```

### Limpiar Archivos Temporales
```bash
make clean
```

---

## Ejemplo 4: Flujo de Trabajo Completo

### 1. Planificar un Sprint
```bash
# Crear Loop de Sprint
cp templates/loop-template.json loops/loop-005.json
# Editar loops/loop-005.json con los datos del sprint
```

### 2. Crear Tareas del Sprint
```bash
# Crear cada tarea
for i in {7..10}; do
  cp templates/task-template.json tasks/task-00$i.json
done
# Editar cada tarea con sus datos específicos
```

### 3. Ejecutar el Sprint
- Trabajar en las tareas según prioridad
- Actualizar estados en los archivos JSON
- Registrar horas reales

### 4. Revisar al Final del Sprint
```bash
# Crear Loop de Revisión
cp templates/loop-template.json loops/loop-006.json
# Editar con resultados de la revisión
```

### 5. Documentar Aprendizajes
- Actualizar CHANGELOG.md
- Crear reporte en reports/
- Actualizar DASHBOARD.md

---

## Ejemplo 5: Gestión de Dependencias

### Tarea con Dependencias
```json
{
  "id": "task-010",
  "title": "Deploy a producción",
  "description": "Desplegar la aplicación en producción",
  "status": "pending",
  "priority": "critical",
  "dependencies": ["task-008", "task-009"],
  "estimated_hours": 2
}
```

### Verificar Dependencias
```bash
# Buscar tareas bloqueadas
grep -r '"status": "blocked"' tasks/

# Buscar tareas dependientes
grep -r '"task-008"' tasks/
```

---

## Ejemplo 6: Reportes Automátizados

### Crear Reporte Semanal
```bash
# Copiar plantilla de reporte
cp reports/progress-report-2026-09-18.md reports/weekly-report-$(date +%Y-%m-%d).md
# Editar con los datos de la semana
```

### Actualizar Dashboard
```bash
# Editar DASHBOARD.md con las estadísticas actuales
```

---

## Consejos

1. **Usa IDs consistentes**: `task-XXX`, `project-XXX`, `loop-XXX`
2. **Actualiza fechas**: Siempre actualiza `updated_at` al modificar
3. **Documenta cambios**: Actualiza CHANGELOG.md
4. **Revisa dependencias**: Antes de marcar tarea como completada
5. **Usa el Dashboard**: Para visión general del proyecto