FROM ubuntu:latest
MAINTAINER dev <rodrigogutierrez@rogudev.com>

# Instalar dependencias básicas
USER root
RUN apt-get update && \
    apt-get install -y openjdk-11-jre python3 python3-venv curl gnupg2 netcat-traditional && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Definir variables de entorno
ENV SPARK_VERSION 3.5.3
ENV BASE_DIR /opt/bd
ENV SPARK_HOME ${BASE_DIR}/spark
ENV VENV_DIR /opt/venv
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Crear directorio base para Spark
RUN mkdir -p ${BASE_DIR}

# Descargar e instalar Spark
RUN curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | \
    tar -xz -C ${BASE_DIR} && \
    mv ${BASE_DIR}/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME}

# Instalar el entorno virtual y dependencias de Python (Jupyter, findspark)
RUN python3 -m venv ${VENV_DIR} && \
    ${VENV_DIR}/bin/pip install --upgrade pip && \
    ${VENV_DIR}/bin/pip install jupyter findspark

# Configurar directorios y permisos
RUN mkdir -p ${SPARK_HOME}/logs && \
    useradd -r -g root -d ${BASE_DIR} -s /bin/bash spark-user && \
    chown -R spark-user:root ${BASE_DIR} && \
    chmod -R 777 ${SPARK_HOME}

# Copiar archivos de configuración (si es necesario)
COPY Config-files/start-daemons-resourcemanager.sh ${BASE_DIR}/start-daemons-resourcemanager.sh
RUN chmod +x ${BASE_DIR}/start-daemons-resourcemanager.sh

# Exponer puertos necesarios para Spark y Jupyter
EXPOSE 7077 8080 4040 8888

# Cambiar al usuario no privilegiado
USER spark-user

# Comando para ejecutar el Spark Master y Jupyter
CMD ["/opt/bd/start-daemons-resourcemanager.sh"]

