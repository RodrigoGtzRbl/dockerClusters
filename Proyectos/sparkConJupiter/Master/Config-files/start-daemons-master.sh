#!/bin/bash

SPARK_HOME=/opt/bd/spark
VENV_DIR=/opt/venv
LOG_FILE=/opt/bd/jupyter.log

# Iniciar Spark Master
echo "Iniciando Spark Master..."
${SPARK_HOME}/sbin/start-master.sh
status=$?
if [ $status -ne 0 ]; then
  echo "No se pudo iniciar Spark Master: $status"
  exit $status
fi

# Espera a que el Spark Master esté activo (usando el nombre del contenedor)
while ! nc -z spark-master 7077; do 
    echo "Esperando a que Spark Master esté disponible..."
    sleep 2
done

# Activar el entorno virtual y jupyter notebook
echo "Activando el entorno virtual..."
nohup bash -c "source ${VENV_DIR}/bin/activate && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --port=8888" > ${LOG_FILE} 2>&1 &

# Mantener el contenedor activo mientras el Spark Master esté en ejecución
tail -f /dev/null

