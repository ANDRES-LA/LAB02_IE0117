#!/bin/bash

# Verificar que se reciba al menos un argumento
if [ $# -lt 1 ]; then
    echo "Uso: $0 <comando>"
    exit 1
fi

# Crear archivo de log
LOG_FILE="monitor_log.csv"
> "$LOG_FILE"
echo "timestamp,cpu,mem" >> "$LOG_FILE"

# Ejecutar el comando como proceso en segundo plano
"$@" &
PID=$!
echo "📌 Proceso iniciado (PID: $PID)... Monitoreando uso de CPU y memoria."

# Monitoreo periódico mientras el proceso esté vivo
while ps -p $PID > /dev/null; do
    timestamp=$(date +%H:%M:%S)
    # Obtener uso de CPU y memoria del proceso
    stats=$(ps -p $PID -o %cpu,%mem --no-headers)
    cpu=$(echo $stats | awk '{print $1}')
    mem=$(echo $stats | awk '{print $2}')
    echo "$timestamp,$cpu,$mem" >> "$LOG_FILE"
    sleep 1
done

echo "✅ El proceso ha finalizado."
echo "📈 Generando gráfica..."

# Crear archivo de script para gnuplot
PLOT_FILE="grafica.gnuplot"
cat <<EOF > $PLOT_FILE
set datafile separator ","
set terminal png size 1000,600
set output "grafico.png"
set title "Uso de CPU y Memoria en el tiempo"
set xlabel "Tiempo (HH:MM:SS)"
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set ylabel "Porcentaje (%)"
set grid
plot "$LOG_FILE" using 1:2 with lines title "CPU (%)", \
     "$LOG_FILE" using 1:3 with lines title "Memoria (%)"
EOF

# Ejecutar gnuplot
gnuplot $PLOT_FILE

echo "📁 Gráfica generada: grafico.png"
