FROM base-spark-jupyter-image:latest

# Cambia a root para ejecutar los comandos de instalación
USER root

# Definir variables de entorno para Spark
ENV SPARK_VERSION=3.3.1
ENV LOG_TAG="[Spark_${SPARK_VERSION}]:"
ENV BASE_DIR=/opt/bd
ENV SPARK_HOME=${BASE_DIR}/spark
ENV VENV_DIR=/opt/venv

# Crear directorio para los archivos de log de Spark
RUN echo "$LOG_TAG Creando directorio para los logs de Spark" && \
    mkdir -p ${SPARK_HOME}/logs

# Copiar script de inicio 
COPY Config-files/start-daemons-master.sh ${BASE_DIR}/start-daemons.sh

# Establece permisos
RUN chmod +x ${BASE_DIR}/start-daemons.sh && \
    chown -R hdadmin:spark ${BASE_DIR}
    
# Actualizar el sistema y asegurar la instalación de python3-venv para entornos virtuales
RUN apt-get update && \
    apt-get install -y python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear el entorno virtual en /opt/venv
RUN python3 -m venv ${VENV_DIR} && \
    ${VENV_DIR}/bin/pip install --upgrade pip

# Instalar Jupyter y findspark en el entorno virtual
RUN ${VENV_DIR}/bin/pip install --upgrade pip && \
    ${VENV_DIR}/bin/pip install jupyter findspark

# Establecer permisos en el entorno virtual
RUN chown -R hdadmin:spark ${VENV_DIR}

# Exponer puertos para Spark y Jupyter
EXPOSE 8080 7077 4040 8888

# Cambia al usuario no root (hdadmin)
USER hdadmin


CMD ["/opt/bd/start-daemons.sh"]


