# Start with a base image containing Java runtime
FROM openjdk:8-jre
ARG TIMEZONE="Asia/Bangkok"
# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# Add Maintainer Info
LABEL maintainer="songsuda.w@pttdigital.com"

# Make port 8090 available to the world outside this container
EXPOSE 8090

# install tools unix
RUN apt-get update
RUN apt-get install telnet -y
RUN apt-get install sudo
RUN apt-get install nano

# Inserting certificates into Java keystore
ENV JAVA_HOME=/usr/local/openjdk-8

# New folder for keep log file         
RUN mkdir -p /data 

### Setup user for build execution and application runtime
ENV APP_ROOT=/data
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}

RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

# Add a volume pointing to /data
#VOLUME /data


### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
# Run the war file 
ENTRYPOINT ["/bin/sh","-c","date; echo Hello be-telnet"]
