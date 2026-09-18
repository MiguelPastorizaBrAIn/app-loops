.PHONY: help create-task create-project create-loop list-tasks list-projects list-loops status validate clean

help:
	@echo "App Loops - Comandos Disponibles:"
	@echo ""
	@echo "  make create-task     - Crear una nueva tarea"
	@echo "  make create-project  - Crear un nuevo proyecto"
	@echo "  make create-loop     - Crear un nuevo Loop"
	@echo "  make list-tasks      - Listar todas las tareas"
	@echo "  make list-projects   - Listar todos los proyectos"
	@echo "  make list-loops      - Listar todos los Loops"
	@echo "  make status          - Mostrar estado del proyecto"
	@echo "  make validate        - Validar archivos JSON"
	@echo "  make clean           - Limpiar archivos temporales"
	@echo "  make help            - Mostrar esta ayuda"
	@echo ""

create-task:
	@./scripts/task-manager.sh create-task "$(name)"

create-project:
	@./scripts/task-manager.sh create-project "$(name)"

create-loop:
	@./scripts/task-manager.sh create-loop "$(name)"

list-tasks:
	@./scripts/task-manager.sh list-tasks

list-projects:
	@./scripts/task-manager.sh list-projects

list-loops:
	@./scripts/task-manager.sh list-loops

status:
	@./scripts/task-manager.sh status

validate:
	@./scripts/task-manager.sh validate

clean:
	@echo "Limpiando archivos temporales..."
	@find . -name "*.tmp" -delete
	@find . -name "*.temp" -delete
	@find . -name "*~" -delete
	@echo "Limpieza completada"