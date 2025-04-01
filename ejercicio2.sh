#!/bin/bash

# Ruta al directorio a monitorear
DIRECTORIO="/home/andres/directorio_monitoreado"


# Archivo de log
LOG="/home/andres/monitoreo.log"


# Asegurarse de que el directorio exista
mkdir -p "$DIRECTORIO"

# Requiere inotify-tools
command -v inotifywait >/dev/null 2>&1 || { echo "❌ inotifywait no está instalado."; exit 1; }

echo "🕵️ Monitoreando el directorio: $DIRECTORIO" >> "$LOG"

# Monitoreo infinito
while true; do
    evento=$(inotifywait -q -e create -e modify -e delete --format '%T %w %e %f' --timefmt '%F %T' "$DIRECTORIO")
    echo "📅 Evento detectado: $evento" >> "$LOG"
done

