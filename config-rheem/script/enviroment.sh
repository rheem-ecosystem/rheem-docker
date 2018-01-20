#!/usr/bin/env bash

#the class for execution is not define is imposible execute the script
if [ -z "${CLASS}" ]; then
    echo "the class is not define"
    exit 1
fi

#if not define BASEDIR
if [ -z "${BASEDIR}" ]; then
    BASEDIR=${RHEEM_HOME}
fi

# Bootstrap the classpath.
RHEEM_CLASSPATH="${BASEDIR}/conf:${BASEDIR}/rheem/*"

#if nof define SPARK_HOME
if [ -z "${SPARK_HOME}" ]; then
    echo "the Spark Home is not define"
    exit 1
fi
RHEEM_CLASSPATH="${RHEEM_CLASSPATH}:${SPARK_HOME}/lib/*"

#if not define HADOOP_HOME
if [ -z "${HADOOP_HOME}" ]; then
    echo "the Hadoop Home is not define"
    exit 1
fi
RHEEM_CLASSPATH="${RHEEM_CLASSPATH}:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/common/lib/*"

#if not define FLINK_HOME
if [ -z "${FLINK_HOME}" ]; then
    echo "the Flink Home is not define"
    exit 1
fi
RHEEM_CLASSPATH="${RHEEM_CLASSPATH}:${FLINK_HOME}/lib/*"

FLAGS=""
if [ "${FLAG_AKKA}" = "true" ]; then
	FLAGS="${FLAGS} -Dakka.remote.netty.tcp.hostname=rheem-master"
fi

if [ "${FLAG_LOG}" = "true" ]; then
	FLAGS="${FLAGS} -Dlog4j.configuration=file://${BASEDIR}/conf/log4j.properties"
fi

if [ "${FLAG_RHEEM}" = "true" ]; then
	FLAGS="${FLAGS} -Drheem.configuration=file://${BASEDIR}/conf/rheem.properties"
fi

if [ "${FLAG_FLINK}" = "true" ]; then
	FLAGS="${FLAGS} -Dinput=file://${BASEDIR}/conf/flink.properties"
fi

if [ -n "${OTHER_FLAGS}" ]; then
	FLAGS="${FLAGS} ${OTHER_FLAGS}"
fi

CONTEXT="true"




