#!/bin/bash

SPARK_HOME=/opt/bd/spark
VENV_DIR=/opt/venv
LOG_FILE=/opt/bd/jupyter.log

# Espera a que el Spark Master esté disponible
echo "Esperando a que el Spark Master esté disponible..."
while ! nc -z spark-master 7077; do
  echo "Esperando a Spark Master..."
  sleep 2
done

# Activar el entorno virtual
echo "Activando el entorno virtual..."
source ${VENV_DIR}/bin/activate

# Iniciar Spark Worker y conectarlo al Spark Master
echo "Iniciando Spark Worker..."
${SPARK_HOME}/sbin/start-worker.sh spark://spark-master:7077

# Iniciar Jupyter Notebook en segundo plano
echo "Iniciando Jupyter Notebook..."
nohup bash -c "source ${VENV_DIR}/bin/activate && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --port=8888" > ${LOG_FILE} 2>&1 &

# Mantener el contenedor activo mientras el Spark Worker esté en ejecución
tail -f /dev/null

