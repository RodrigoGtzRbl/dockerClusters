#!/bin/bash

HADOOP_HOME=/opt/bd/hadoop/
SERVICE=${HADOOP_HOME}/bin/hdfs
DAEMON=namenode
VENV_DIR=/opt/venv

# Formateamos el NameNode en modo no interactivo
# si existen datos, no se reformatea
$HADOOP_HOME/bin/hdfs namenode -format -nonInteractive 2> /dev/null

# Iniciamos el demonio del namenode y chequeamos si ha arrancado
${SERVICE} --daemon start ${DAEMON}
status=$?
if [ $status -ne 0 ]; then
  echo "No pudo inicializar el servicio ${DAEMON}: $status"
  exit $status
fi

# Esperamos a que el demonio este iniciado
while ! ps aux | grep ${DAEMON} | grep -q -v grep
do 
    sleep 1 
done

# Espera un poco mas antes de crear directorios
sleep 5

# Inicia directorios en HDFS
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/hdadmin &&\
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /tmp/hadoop-yarn/staging &&\
$HADOOP_HOME/bin/hdfs dfs -chmod -R 1777 /tmp

# Activación del entorno virtual más inicio de Jupyter Notebook en segundo plano
echo "Activando el entorno virtual..."
nohup bash -c "source ${VENV_DIR}/bin/activate && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --port=8888" > ${LOG_FILE} 2>&1 &

# Mientras el demonio esté vivo, el contenedor sigue activo
while true
do 
  sleep 10
  if ! ps aux | grep ${DAEMON} | grep -q -v grep
  then
      echo "El demonio ${DAEMON}  ha fallado"
      exit 1
  fi
done
