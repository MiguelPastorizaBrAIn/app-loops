#!/bin/bash

# Task Manager Script for App Loops
# Uso: ./scripts/task-manager.sh [comando] [opciones]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorios
TASKS_DIR="tasks"
PROJECTS_DIR="projects"
LOOPS_DIR="loops"
TEMPLATES_DIR="templates"

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}App Loops - Task Manager${NC}"
    echo ""
    echo "Uso: $0 [comando] [opciones]"
    echo ""
    echo "Comandos:"
    echo "  create-task [nombre]     - Crear una nueva tarea"
    echo "  create-project [nombre]  - Crear un nuevo proyecto"
    echo "  create-loop [nombre]     - Crear un nuevo Loop"
    echo "  list-tasks               - Listar todas las tareas"
    echo "  list-projects            - Listar todos los proyectos"
    echo "  list-loops               - Listar todos los Loops"
    echo "  status                   - Mostrar estado del proyecto"
    echo "  validate                 - Validar archivos JSON"
    echo "  help                     - Mostrar esta ayuda"
    echo ""
}

# Función para crear tarea
create_task() {
    local task_name=$1
    local task_id="task-$(date +%s | tail -c 7)"
    
    echo -e "${YELLOW}Creando tarea: $task_name${NC}"
    
    # Copiar plantilla
    cp "$TEMPLATES_DIR/task-template.json" "$TASKS_DIR/$task_id.json"
    
    # Actualizar nombre en la plantilla
    sed -i "s/Título de la Tarea/$task_name/g" "$TASKS_DIR/$task_id.json"
    sed -i "s/task-XXX/$task_id/g" "$TASKS_DIR/$task_id.json"
    
    echo -e "${GREEN}Tarea creada: $TASKS_DIR/$task_id.json${NC}"
}

# Función para crear proyecto
create_project() {
    local project_name=$1
    local project_id="project-$(date +%s | tail -c 7)"
    
    echo -e "${YELLOW}Creando proyecto: $project_name${NC}"
    
    # Copiar plantilla
    cp "$TEMPLATES_DIR/project-template.json" "$PROJECTS_DIR/$project_id.json"
    
    # Actualizar nombre en la plantilla
    sed -i "s/Nombre del Proyecto/$project_name/g" "$PROJECTS_DIR/$project_id.json"
    sed -i "s/project-XXX/$project_id/g" "$PROJECTS_DIR/$project_id.json"
    
    echo -e "${GREEN}Proyecto creado: $PROJECTS_DIR/$project_id.json${NC}"
}

# Función para crear Loop
create_loop() {
    local loop_name=$1
    local loop_id="loop-$(date +%s | tail -c 7)"
    
    echo -e "${YELLOW}Creando Loop: $loop_name${NC}"
    
    # Copiar plantilla
    cp "$TEMPLATES_DIR/loop-template.json" "$LOOPS_DIR/$loop_id.json"
    
    # Actualizar nombre en la plantilla
    sed -i "s/Nombre del Loop/$loop_name/g" "$LOOPS_DIR/$loop_id.json"
    sed -i "s/loop-XXX/$loop_id/g" "$LOOPS_DIR/$loop_id.json"
    
    echo -e "${GREEN}Loop creado: $LOOPS_DIR/$loop_id.json${NC}"
}

# Función para listar tareas
list_tasks() {
    echo -e "${BLUE}=== Tareas ===${NC}"
    
    if [ -d "$TASKS_DIR" ]; then
        for file in "$TASKS_DIR"/*.json; do
            if [ -f "$file" ]; then
                local task_id=$(basename "$file" .json)
                local title=$(grep -o '"title": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                local status=$(grep -o '"status": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                
                case $status in
                    "completed") echo -e "  ${GREEN}✓${NC} $task_id: $title" ;;
                    "in_progress") echo -e "  ${YELLOW}⟳${NC} $task_id: $title" ;;
                    "pending") echo -e "  ${BLUE}○${NC} $task_id: $title" ;;
                    "blocked") echo -e "  ${RED}✗${NC} $task_id: $title" ;;
                    *) echo -e "  ? $task_id: $title" ;;
                esac
            fi
        done
    else
        echo "  No hay tareas"
    fi
}

# Función para listar proyectos
list_projects() {
    echo -e "${BLUE}=== Proyectos ===${NC}"
    
    if [ -d "$PROJECTS_DIR" ]; then
        for file in "$PROJECTS_DIR"/*.json; do
            if [ -f "$file" ]; then
                local project_id=$(basename "$file" .json)
                local name=$(grep -o '"name": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                local status=$(grep -o '"status": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                
                case $status in
                    "completed") echo -e "  ${GREEN}✓${NC} $project_id: $name" ;;
                    "active") echo -e "  ${YELLOW}⟳${NC} $project_id: $name" ;;
                    "planning") echo -e "  ${BLUE}○${NC} $project_id: $name" ;;
                    "on_hold") echo -e "  ${RED}✗${NC} $project_id: $name" ;;
                    *) echo -e "  ? $project_id: $name" ;;
                esac
            fi
        done
    else
        echo "  No hay proyectos"
    fi
}

# Función para listar Loops
list_loops() {
    echo -e "${BLUE}=== Loops ===${NC}"
    
    if [ -d "$LOOPS_DIR" ]; then
        for file in "$LOOPS_DIR"/*.json; do
            if [ -f "$file" ]; then
                local loop_id=$(basename "$file" .json)
                local name=$(grep -o '"name": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                local status=$(grep -o '"status": "[^"]*"' "$file" | head -1 | cut -d'"' -f4)
                
                case $status in
                    "completed") echo -e "  ${GREEN}✓${NC} $loop_id: $name" ;;
                    "in_progress") echo -e "  ${YELLOW}⟳${NC} $loop_id: $name" ;;
                    "planning") echo -e "  ${BLUE}○${NC} $loop_id: $name" ;;
                    "cancelled") echo -e "  ${RED}✗${NC} $loop_id: $name" ;;
                    *) echo -e "  ? $loop_id: $name" ;;
                esac
            fi
        done
    else
        echo "  No hay Loops"
    fi
}

# Función para mostrar estado
show_status() {
    echo -e "${BLUE}=== Estado del Proyecto ===${NC}"
    echo ""
    
    # Contar tareas
    local total_tasks=$(find "$TASKS_DIR" -name "*.json" 2>/dev/null | wc -l)
    local completed_tasks=$(grep -r '"status": "completed"' "$TASKS_DIR" 2>/dev/null | wc -l)
    local in_progress_tasks=$(grep -r '"status": "in_progress"' "$TASKS_DIR" 2>/dev/null | wc -l)
    
    echo -e "${YELLOW}Tareas:${NC}"
    echo "  Total: $total_tasks"
    echo "  Completadas: $completed_tasks"
    echo "  En progreso: $in_progress_tasks"
    echo ""
    
    # Contar proyectos
    local total_projects=$(find "$PROJECTS_DIR" -name "*.json" 2>/dev/null | wc -l)
    local active_projects=$(grep -r '"status": "active"' "$PROJECTS_DIR" 2>/dev/null | wc -l)
    
    echo -e "${YELLOW}Proyectos:${NC}"
    echo "  Total: $total_projects"
    echo "  Activos: $active_projects"
    echo ""
    
    # Contar Loops
    local total_loops=$(find "$LOOPS_DIR" -name "*.json" 2>/dev/null | wc -l)
    local completed_loops=$(grep -r '"status": "completed"' "$LOOPS_DIR" 2>/dev/null | wc -l)
    
    echo -e "${YELLOW}Loops:${NC}"
    echo "  Total: $total_loops"
    echo "  Completados: $completed_loops"
}

# Función para validar JSON
validate_json() {
    echo -e "${BLUE}=== Validando Archivos JSON ===${NC}"
    
    local errors=0
    
    for dir in "$TASKS_DIR" "$PROJECTS_DIR" "$LOOPS_DIR" "$TEMPLATES_DIR"; do
        if [ -d "$dir" ]; then
            for file in "$dir"/*.json; do
                if [ -f "$file" ]; then
                    if python3 -m json.tool "$file" > /dev/null 2>&1; then
                        echo -e "  ${GREEN}✓${NC} $file"
                    else
                        echo -e "  ${RED}✗${NC} $file"
                        errors=$((errors + 1))
                    fi
                fi
            done
        fi
    done
    
    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Todos los archivos son válidos${NC}"
    else
        echo -e "${RED}Se encontraron $errors errores${NC}"
    fi
}

# Menú principal
case "$1" in
    "create-task")
        if [ -z "$2" ]; then
            echo "Uso: $0 create-task [nombre]"
            exit 1
        fi
        create_task "$2"
        ;;
    "create-project")
        if [ -z "$2" ]; then
            echo "Uso: $0 create-project [nombre]"
            exit 1
        fi
        create_project "$2"
        ;;
    "create-loop")
        if [ -z "$2" ]; then
            echo "Uso: $0 create-loop [nombre]"
            exit 1
        fi
        create_loop "$2"
        ;;
    "list-tasks")
        list_tasks
        ;;
    "list-projects")
        list_projects
        ;;
    "list-loops")
        list_loops
        ;;
    "status")
        show_status
        ;;
    "validate")
        validate_json
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        show_help
        ;;
esac