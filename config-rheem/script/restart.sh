#!/usr/bin/env bash

PLATFORM=$1
CLEAN_CLUSTER=$2
EXPERIMENT=$3
KILL=$4
#if not define SPARK_HOME
if [ -z "${SPARK_HOME}" ]; then
# 	SPARK_HOME=/opt/spark-1.6.0-compiled-hadoop2.6-with-ganglia
       SPARK_HOME=/opt/spark-1.6.0-bin-hadoop2.6/spark-1.6.0-bin-hadoop2.6
fi

#if not define HADOOP_HOME
if [ -z "${HADOOP_HOME}" ]; then
	HADOOP_HOME=/opt/cloudera/parcels/CDH-5.9.1-1.cdh5.9.1.p0.4/lib/hadoop
fi

#if not define FLINK_HOME
if [ -z "${FLINK_HOME}" ]; then
	FLINK_HOME=/usr/etc/flink-1.3.2_2.10
fi

ssh 10.2.5.232 "hadoop fs -rm -R /user/data/output_*"
ssh 10.2.5.232 "hadoop fs -rm -R /user/root/.Trash/*"

if [ "${KILL}" = "KILL" ]; then
   current_path=$(pwd)
   cd $SPARK_HOME
   . $SPARK_HOME/sbin/stop-all.sh
   cd $FLINK_HOME/bin
   . $FLINK_HOME/bin/stop-cluster.sh
   cd $current_path

else
#restart spark
result=$(echo ${PLATFORM} | grep "spark")
if [ -n "${result}" ]; then
   echo "restart spark"
   current_path=$(pwd)
   cd $SPARK_HOME
   . $SPARK_HOME/sbin/stop-all.sh
   . $SPARK_HOME/sbin/start-all.sh
   cd $current_path
fi

#restart flink
result=$(echo ${PLATFORM} | grep "flink")
if [ -n "${result}" ]; then
   echo "restart flink"
   current_path=$(pwd)
   cd $FLINK_HOME/bin
   . $FLINK_HOME/bin/stop-cluster.sh
   . $FLINK_HOME/bin/start-cluster.sh
   cd $current_path
fi

#restart java
result=$(echo ${PLATFORM} | grep "java")
if [ -n "${result}" ]; then
   echo "restart java" 
   sync; echo 3 > /proc/sys/vm/drop_caches
fi


if [ "${CLEAN_CLUSTER}" = "all" ]; then
   sync; echo 3 > /proc/sys/vm/drop_caches
   ssh 10.2.5.232 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.233 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.234 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.235 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.236 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.237 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.238 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.239 "sync; echo 3 > /proc/sys/vm/drop_caches"
   ssh 10.2.5.240 "sync; echo 3 > /proc/sys/vm/drop_caches"
fi


#fi of if KILL
fi
