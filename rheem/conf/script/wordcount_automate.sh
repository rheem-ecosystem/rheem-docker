#!/usr/bin/env bash

NAME="wordcount"
CLASS="org.qcri.rheem.apps.wordcount.WordCountScala"
FLAG_LOG="true"
FLAG_RHEEM="true"
OTHER_FLAGS="-Xms10240m -Xmx19480m -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=4"
KILLTIME=0

. script/enviroment.sh

###Note: upload the file /upload-file/shakespeare.txt to hdfs in the path /user/data/
. script/execute.sh exp\(1\) "java,spark" hdfs:///user/data/shakespeare.txt
