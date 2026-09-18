.PHONY: help create-task create-project list-tasks list-projects

help:
	@echo "Comandos disponibles:"
	@echo "  make create-task    - Crear una nueva tarea"
	@echo "  make create-project - Crear un nuevo proyecto"
	@echo "  make list-tasks     - Listar todas las tareas"
	@echo "  make list-projects  - Listar todos los proyectos"
	@echo "  make validate       - Validar archivos JSON"

create-task:
	@echo "Para crear una tarea, copia templates/task-template.json a tasks/ y renómbralo"

create-project:
	@echo "Para crear un proyecto, copia templates/project-template.json a projects/ y renómbralo"

list-tasks:
	@ls -la tasks/

list-projects:
	@ls -la projects/

validate:
	@echo "Validando archivos JSON..."
	@for file in tasks/*.json projects/*.json config/*.json templates/*.json; do \
		if [ -f "$$file" ]; then \
			echo "Validando $$file..."; \
			python3 -m json.tool $$file > /dev/null || echo "Error en $$file"; \
		fi \
	done
	@echo "Validación completada"

clean:
	@echo "Limpiando archivos temporales..."
	@find . -name "*.tmp" -delete
	@find . -name "*.temp" -delete
	@echo "Limpieza completada"