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

# Esperar a que el Spark Master esté activo
while ! nc -z localhost 7077
do 
    sleep 1 
done

# Activar el entorno virtual
echo "Activando el entorno virtual..."
source ${VENV_DIR}/bin/activate

# Iniciar Jupyter Notebook en segundo plano
echo "Iniciando Jupyter Notebook..."
nohup jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --port=8888 > ${LOG_FILE} 2>&1 &

# Mantener el contenedor activo mientras el Spark Master esté activo
while true
do 
  sleep 10
  if ! ps aux | grep -q "[s]park.master"
  then
      echo "El servicio Spark Master ha fallado."
      exit 1
  fi
done

