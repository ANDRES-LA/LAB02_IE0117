#!/bin/bash

# Verificar si el script es ejecutado como root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse como root." >&2
    exit 1
fi

# Verificar que se hayan recibido exactamente 3 parámetros
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 usuario grupo /ruta/al/archivo"
    exit 1
fi

USUARIO="$1"
GRUPO="$2"
ARCHIVO="$3"

echo "------------------------------"
echo "Parámetros recibidos:"
echo "Usuario: $USUARIO"
echo "Grupo: $GRUPO"
echo "Archivo: $ARCHIVO"
echo "------------------------------"

# Verificar si el archivo existe
if [ ! -f "$ARCHIVO" ]; then
    echo "Error: El archivo '$ARCHIVO' no existe. Terminando ejecución."
    exit 1
fi

# Verificar si el grupo existe, si no, crearlo
if getent group "$GRUPO" > /dev/null; then
    echo "El grupo '$GRUPO' ya existe."
else
    echo "Creando grupo '$GRUPO'..."
    groupadd "$GRUPO"
fi
#!/bin/bash

# Verificar si el script es ejecutado como root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse como root." >&2
    exit 1
fi

# Verificar que se hayan recibido exactamente 3 parámetros
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 usuario grupo /ruta/al/archivo"
    exit 1
fi

USUARIO="$1"
GRUPO="$2"
ARCHIVO="$3"

echo "------------------------------"
echo "Parámetros recibidos:"
echo "Usuario: $USUARIO"
echo "Grupo: $GRUPO"
echo "Archivo: $ARCHIVO"
echo "------------------------------"

# Verificar si el archivo existe
if [ ! -f "$ARCHIVO" ]; then
    echo "Error: El archivo '$ARCHIVO' no existe. Terminando ejecución."
    exit 1
fi

# Verificar si el grupo existe, si no, crearlo
if getent group "$GRUPO" > /dev/null; then
    echo "El grupo '$GRUPO' ya existe."
else
    echo "Creando grupo '$GRUPO'..."
    groupadd "$GRUPO"
fi
# Verificar si el usuario existe, si no, crearlo
if id "$USUARIO" &>/dev/null; then
    echo "El usuario '$USUARIO' ya existe."
else
    echo "Creando usuario '$USUARIO'..."
    useradd -m -g "$GRUPO" "$USUARIO"
fi

# Agregar usuario al grupo (por si ya existía)
usermod -aG "$GRUPO" "$USUARIO"
echo "✔ Usuario '$USUARIO' agregado al grupo '$GRUPO'."

# Cambiar la propiedad del archivo
chown "$USUARIO:$GRUPO" "$ARCHIVO"

# Cambiar los permisos: usuario = rwx, grupo = r--, otros = ---
chmod 740 "$ARCHIVO"

echo "------------------------------"
echo "Propietario del archivo actualizado: $USUARIO:$GRUPO"
echo "Permisos modificados: rwx para usuario, r para grupo, sin acceso para otros."
ls -l "$ARCHIVO"
echo "------------------------------"
echo "Ejecución completada."

