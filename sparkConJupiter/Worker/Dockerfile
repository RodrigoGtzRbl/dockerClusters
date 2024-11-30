# Usar la imagen base con Spark
FROM kamehouse0/spark-and-jupyter-base:latest
MAINTAINER dev <rodrigogutierrez@rogudev.com>

# Definir variables de entorno
ENV SPARK_VERSION=3.3.1
ENV BASE_DIR=/opt/bd
ENV SPARK_HOME=${BASE_DIR}/spark
ENV VENV_DIR=/opt/venv

# Crear directorio para los logs
RUN mkdir -p ${SPARK_HOME}/logs

# Copiar el script de inicio para los workers
COPY Config-files/start-daemons-worker.sh ${BASE_DIR}/start-daemons-worker.sh

# Establecer permisos
RUN chmod +x ${BASE_DIR}/start-daemons-worker.sh && \
    chown -R hdadmin:spark ${BASE_DIR}

# Instalar python3-venv para entorno virtual
RUN apt-get update && \
    apt-get install -y python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear entorno virtual y asegurar la instalación de Jupyter y findspark
RUN python3 -m venv ${VENV_DIR} && \
    ${VENV_DIR}/bin/pip install --upgrade pip && \
    ${VENV_DIR}/bin/pip install jupyter findspark

# Exponer puertos necesarios
EXPOSE 9866 9864 8888

# Cambiar al usuario no root (hdadmin)
USER hdadmin

CMD ["/opt/bd/start-daemons-worker.sh"]

