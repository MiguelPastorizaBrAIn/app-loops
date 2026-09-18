# Configurar GitHub Project

## Prerrequisitos

1. **GitHub Token con permisos `project` y `repo`**
   - Ve a https://github.com/settings/tokens
   - Haz clic en "Generate new token (classic)"
   - Selecciona los scopes: `project`, `repo`
   - Copia el token

2. **jq instalado** (para procesar JSON)
   ```bash
   # macOS
   brew install jq
   
   # Ubuntu/Debian
   sudo apt-get install jq
   
   # Windows (con chocolatey)
   choco install jq
   ```

## Ejecutar el Script

```bash
# Hacer el script ejecutable
chmod +x scripts/create-project.sh

# Ejecutar con tu token
./scripts/create-project.sh TU_TOKEN_AQUI
```

## Ejemplo

```bash
./scripts/create-project.sh ghp_xxxxxxxxxxxxxxxxxxxx
```

## Qué Hace el Script

1. ✅ Crea el proyecto "App Loops Development"
2. ✅ Agrega los 5 issues al proyecto
3. ✅ Muestra la URL del proyecto creado

## Próximos Pasos (después de ejecutar el script)

1. Ve a la URL del proyecto que se muestra
2. Haz clic en **"+ Add view"**
3. Selecciona **"Board"**
4. Crea las columnas:
   - Backlog
   - To Do
   - In Progress
   - Review
   - Done
5. Arrastra los issues a las columnas correspondientes

## Solución de Problemas

### Error " unauthorized"
- Verifica que tu token tenga el scope `project`

### Error "not found"
- Verifica que el token tenga el scope `repo`

### Error con jq
- Asegúrate de tener `jq` instalado correctamente