FROM kamehouse0/hadoop-base:latest
MAINTAINER rogudev <rogudev.com>


# Dockerfile para el NameNode
# Switch to root user
USER root

# Define valores de entorno
ENV HADOOP_VERSION 3.3.6
ENV LOG_TAG "[NameNode Hadoop_${HADOOP_VERSION}]:"
ENV BASE_DIR /opt/bd
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/
ENV DATA_DIR /var/data/hadoop/hdfs
ENV VENV_DIR /opt/venv


# Crea directorios para los datos de HDFS del NameNode y haz que sean propiedad del usuario hdadmin. 
# En un sistema real, deberíamos crear varios directorios en particiones separadas con suficiente espacio libre.
RUN echo "$LOG_TAG Crea directorios para los datos de HDFS del NameNode y haz que sean propiedad del usuario hdadmin" && \
    mkdir -p ${DATA_DIR}/nn && chown -R hdadmin:hadoop ${DATA_DIR}

# Crea directorio para los ficheros de log
RUN echo "$LOG_TAG Crea directorio para los ficheros de log" && \
    mkdir ${HADOOP_HOME}/logs

# Copia los ficheros de configuracion
RUN echo "$LOG_TAG Copia los ficheros de configuracion y el script de inicio"
COPY Config-files/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
COPY Config-files/hdfs-site-namenode.xml ${HADOOP_CONF_DIR}/hdfs-site.xml

# Script de inicio 
COPY Config-files/start-daemons-namenode.sh ${BASE_DIR}/start-daemons.sh

# Establece permisos
RUN chmod +x ${BASE_DIR}/start-daemons.sh && \
    chown -R hdadmin:hadoop ${BASE_DIR}
    
# Actualiza el sistema y asegura que python3-venv esté instalado
RUN apt-get update && \
    apt-get install -y python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verifica la instalación de Python3
RUN python3 --version

# Crea el entorno virtual en /opt/venv
RUN python3 -m venv ${VENV_DIR} && \
    ${VENV_DIR}/bin/pip install --upgrade pip

# Instalar Jupyter dentro del entorno virtual
RUN ${VENV_DIR}/bin/pip install jupyter

# Establece permisos en el entorno virtual
RUN chown -R hdadmin:hadoop ${VENV_DIR}

# Expose ports
EXPOSE 8020 9820 9870 9871 8888

# Cambia al usuario hdadmin
USER hdadmin

# Define valores de entorno
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/
ENV PATH ${PATH}:${HADOOP_HOME}/bin/:${HADOOP_HOME}/sbin/

WORKDIR ${HADOOP_HOME}

RUN echo "$LOG_TAG Iniciando demonios"
CMD ["/opt/bd/start-daemons.sh"]
