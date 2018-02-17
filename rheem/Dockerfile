FROM ubuntu:16.04

MAINTAINER Rheem <rheem@hbku.edu.qa>

WORKDIR /root

ENV USER=root

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                  VERSIONS OF PLATFORMS AND DEPENDENCIES                  #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# Java language
ENV java_ver '8'

# Scala language
ENV scala_ver '2.11.8'
ENV scala_compact_ver '2.11'

# Hadoop Platform
ENV hadoop_ver='2.6.0'
ENV hadoop_compact_ver='2.6'
ENV hadoop_without_dot_ver='26'

# Spark Platform
ENV spark_ver='1.6.0'

# Flink Platform
ENV flink_ver='1.3.2'

# Ignite Platform
ENV ignite_ver='2.3.0'

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################            INSTALATION OF THE PLATFORMS AND DEPENDENCIES                 #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# install openssh-server and wget
RUN apt-get update && \
    apt-get install -y openssh-server  wget

#RUN service ssh start

# install java (Open JDK)
RUN apt-get install -y openjdk-${java_ver}-jdk

# install git
RUN apt-get install -y git

# install maven
RUN apt-get install -y maven

# install timeout
RUN apt-get install timeout

# install scala lenguage
RUN apt-get remove -y scala-library scala && \
    wget www.scala-lang.org/files/archive/scala-${scala_ver}.deb && \
    dpkg -i scala-${scala_ver}.deb && \
    rm scala-${scala_ver}.deb

# install SBT for scala
#RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
#    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
#    apt-get update && \
#    apt-get install -y sbt

RUN ls -lah /usr/local && mkdir /usr/local/rheem

# download Rheem
RUN git clone https://github.com/rheem-ecosystem/rheem.git /usr/local/rheem
RUN mkdir /usr/local/rheem/lib/

RUN mkdir /rheem
RUN mkdir /rheem/code
RUN mkdir /rheem/script
RUN mkdir /rheem/output
RUN mkdir /rheem/conf
RUN mkdir /rheem/hadoop
RUN mkdir /rheem/spark

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF ENVIROMENT                           #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-${java_ver}-openjdk-amd64
ENV MAVEN_HOME /usr/share/maven
ENV HADOOP_HOME=/rheem/hadoop
ENV SPARK_HOME=/rheem/spark

ENV RHEEM_HOME=/usr/local/rheem
ENV RHEEM_SCRIPT=/rheem/script
ENV RHEEM_CODE=/rheem/code
ENV RHEEM_OUTPUT=/rheem/output
ENV RHEEM_CONF=/rheem/conf

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF RHEEM                                #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

# load configuration of Rheem
COPY conf/* /tmp/

RUN mv /tmp/rheem-entrypoint.sh /usr/local/rheem/rheem-entrypoint.sh

RUN cd $RHEEM_HOME/ && \
    mvn clean && \
    mvn clean install -Pdistro -DskipTests

## TODO: after the this step mover all the jar to Rheem_HOME/lib/*
RUN mv

RUN chmod +x $RHEEM_HOME/rheem-entrypoint.sh

RUN mkdir /usr/local/rheem/script

RUN mv /tmp/script/* /usr/local/rheem/script/


## TODO: upload the jars of HADOOP and SPARK
COPY jars/hadoop/* ${HADOOP_HOME}/
COPY jars/spark/* ${SPARK_HOME}/


ENTRYPOINT ["/usr/local/rheem/rheem-entrypoint.sh"]

EXPOSE 22

CMD [ "sh", "-c", "service ssh start; bash"]