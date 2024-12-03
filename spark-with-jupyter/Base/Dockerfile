# Para ejecutar este Dockerfile, posicionate en consola en el directorio donde tengas este arvhivo y lanza
# este comando: docker build -t spark-base-image .
# Me conecto al Hub de Docker para bajarme una imagen de Ubuntu Server, sencilla y la última versión.
FROM ubuntu:latest 
MAINTAINER Dev <rodrigogutierrez@rogudev.com>

###############################################################################################################
# Con la imagen ya bajada voy a indicar una serie de cambios/configuraciones sobre esta imagen de ubuntu server
###############################################################################################################


# Defino variables de entorno
ENV SPARK_VERSION 3.5.3
ENV BASE_DIR /opt/bd
ENV SPARK_HOME ${BASE_DIR}/spark
ENV VENV_DIR /opt/venv

USER root

# PASO 1: Actualiza el S.O, instalo Java, python3, curl, iputils y limpio y borro.
RUN echo "$LOG_TAG Actualizando e instalando paquetes básicos" && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre python3 curl locales iputils-ping nano sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists
    
# Genera locales, para que trabajemos con teclado español
RUN echo "$LOG_TAG Creando locales" && \
    locale-gen es_ES.UTF-8 && update-locale LANG=es_ES.UTF-8

# Crea directorio para Spark
RUN mkdir -p ${BASE_DIR}

# Cambio a directorio /opt/bd 
WORKDIR ${BASE_DIR}
    
# Descargar e instalar Spark
RUN echo "Descargando e instalando Spark" && \
    curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | \
    tar -xz -C ${BASE_DIR} && \
    mv ${BASE_DIR}/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME}

# Crea un grupo spark y un usuario hdadmin
# Cambia el propietario del directorio de spark 
RUN groupadd -r spark && \
    useradd -r -g spark -d ${BASE_DIR} -s /bin/bash hdadmin

# Establece Spark como variable de entorno
ENV PATH="${SPARK_HOME}/bin:${PATH}"

