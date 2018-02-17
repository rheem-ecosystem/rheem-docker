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
RHEEM_CLASSPATH="${RHEEM_CONF}:${RHEEM_CODE}/*:${RHEEM_HOME}/lib/*"

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


FLAGS=""
if [ "${FLAG_LOG}" = "true" ]; then
	FLAGS="${FLAGS} -Dlog4j.configuration=file://${RHEEM_CONF}/log4j.properties"
fi

if [ "${FLAG_RHEEM}" = "true" ]; then
	FLAGS="${FLAGS} -Drheem.configuration=file://${RHEEM_CONF}/rheem.properties"
fi

if [ -n "${OTHER_FLAGS}" ]; then
	FLAGS="${FLAGS} ${OTHER_FLAGS}"
fi

CONTEXT="true"




