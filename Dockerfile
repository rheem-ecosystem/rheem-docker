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

# install hadoop
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz && \
    tar -xzvf hadoop-${hadoop_ver}.tar.gz && \
    mv hadoop-${hadoop_ver} /usr/local/hadoop && \
    rm -rf hadoop-${hadoop_ver}.tar.gz

# install Spark
RUN wget https://archive.apache.org/dist/spark/spark-${spark_ver}/spark-${spark_ver}-bin-without-hadoop.tgz && \
    tar -xzvf spark-${spark_ver}-bin-without-hadoop.tgz && \
    mv spark-${spark_ver}-bin-without-hadoop /usr/local/spark && \
    rm -rf spark-${spark_ver}-bin-without-hadoop.tgz

# install Flink
RUN wget http://www-us.apache.org/dist/flink/flink-${flink_ver}/flink-${flink_ver}-bin-hadoop${hadoop_without_dot_ver}-scala_${scala_compact_ver}.tgz && \
    tar -xzvf flink-${flink_ver}-bin-hadoop${hadoop_without_dot_ver}-scala_${scala_compact_ver}.tgz && \
    mv flink-${flink_ver}/ /usr/local/flink && \
    rm -rf flink-${flink_ver}-bin-hadoop${hadoop_without_dot_ver}-scala_${scala_compact_ver}.tgz

RUN apt-get install -y unzip

# install Ignite
RUN wget https://archive.apache.org/dist/ignite/${ignite_ver}/apache-ignite-fabric-${ignite_ver}-bin.zip && \
    unzip apache-ignite-fabric-${ignite_ver}-bin.zip && \
    mv apache-ignite-fabric-${ignite_ver}-bin /usr/local/ignite && \
    rm -rf apache-ignite-fabric-${ignite_ver}-bin.zip

RUN ls -lah /usr/local && mkdir /usr/local/rheem
# download Rheem
RUN git clone https://github.com/rheem-ecosystem/rheem.git /usr/local/rheem

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
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV FLINK_HOME=/usr/local/flink
ENV IGNITE_HOME=/usr/local/ignite
ENV RHEEM_HOME=/usr/local/rheem
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$FLINK_HOME/bin:$IGNITE_HOME/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF HADOOP                               #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

# create of folder for work of hadoop
RUN mkdir -p ~/hdfs/namenode && \
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# load configuration of Hadoop
COPY config-hadoop/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/upload_file.sh ~/upload_file.sh && \
    mv /tmp/mapping_upload ~/mapping_upload

EXPOSE 50075
EXPOSE 8188
EXPOSE 8042
EXPOSE 8088

# lunch Hadoop
RUN chmod +x ~/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x ~/upload_file.sh

# format namenode
RUN hdfs namenode -format

# upload the files to HDFS for working
RUN rm -rf /tmp/*
COPY upload-file/* /tmp/
#TODO: crear el upload_file para subir los archivos a hadoop
RUN ~/upload_file.sh "~/mapping_upload"

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF SPARK                                #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

# load configuration of Spark
COPY config-spark/* /tmp/

RUN mv /tmp/log4j.properties $SPARK_HOME/conf/log4j.properties && \
    mv /tmp/slaves $SPARK_HOME/conf/slaves && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh

EXPOSE 8080
EXPOSE 7077
EXPOSE 6066
EXPOSE 8081

RUN chmod +x $SPARK_HOME/conf/spark-env.sh
#TODO: crear un script after iniciar el cluster
#RUN hadoop fs -mkdir -p hdfs://rheem-master:8021/spark/log/

# lunch the spark
RUN $SPARK_HOME/sbin/start-all.sh

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF FLINK                                #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

# load configuration of Flink
COPY config-flink/* /tmp/

RUN mv /tmp/flink-conf.yaml $FLINK_HOME/conf/flink-conf.yaml && \
    mv /tmp/log4j.properties $FLINK_HOME/conf/log4j.properties && \
    mv /tmp/log4j-cli.properties $FLINK_HOME/conf/log4j-cli.properties && \
    mv /tmp/log4j-console.properties $FLINK_HOME/conf/log4j-console.properties && \
    mv /tmp/log4j-yarn-session.properties $FLINK_HOME/conf/log4j-yarn-session.properties && \
    mv /tmp/logback.xml $FLINK_HOME/conf/logback.xml && \
    mv /tmp/logback-console.xml $FLINK_HOME/conf/logback-console.xml && \
    mv /tmp/logback-yarn.xml $FLINK_HOME/conf/logback-yarn.xml && \
    mv /tmp/masters $SPARK_HOME/conf/masters && \
    mv /tmp/slaves $SPARK_HOME/conf/slaves && \
    mv /tmp/zoo.cfg $SPARK_HOME/conf/zoo.cfg

EXPOSE 2622
EXPOSE 6123

# lunch flink TODO: lo mismo que el anterio
#RUN $FLINK_HOME/bin/start-cluster.sh batch

########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF IGNITE                               #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

# load configuration of Ignite
#COPY config-ignite/* /tmp/

EXPOSE 47100
EXPOSE 48100

# lunch flink
#RUN $IGNITE_HOME/bin/ignite.sh

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
COPY config-rheem/* /tmp/

RUN mv /tmp/rheem-entrypoint.sh /usr/local/rheem/rheem-entrypoint.sh

RUN cd $RHEEM_HOME/ && \
    mvn clean && \
    mvn clean install -Pdistro -DskipTests

RUN chmod +x $RHEEM_HOME/rheem-entrypoint.sh

#ENTRYPOINT ["/usr/local/rheem/rheem-entrypoint.sh"]
########################################################################################################################
########################################################################################################################
#######################                                                                          #######################
#######################                    CONFIGURATION OF COMAND FOR DOCKER                    #######################
#######################                                                                          #######################
########################################################################################################################
########################################################################################################################

# clean the /tmp folder
RUN rm -rf /tmp/*

EXPOSE 22


CMD [ "sh", "-c", "service ssh start; bash"]