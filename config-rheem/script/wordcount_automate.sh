#!/usr/bin/env bash

NAME="wordcount"
CLASS="org.qcri.rheem.apps.wordcount.WordCountScala"
FLAG_AKKA=""
FLAG_LOG="true"
#FLAG_RHEEM="true"
FLAG_RHEEM="true"
FLAG_FLINK="true"
OTHER_FLAGS="-Xms10240m -Xmx19480m -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=4"
#OTHER_FLAGS="-Drheem.configuration=file:///root/bertty/conf/words.property -Xms10240m -Xmx19480m -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=4"
FOLDER=output/${NAME}

. script/enviroment.sh

if [ ! -d "$FOLDER" ]; then
	mkdir $FOLDER
fi

for i in 1 2 3
do
    for platform in "spark"
# "flink,java,spark"
# "flink" "spark" "java" "java,spark,flink"
    do
        . script/restart.sh ${platform} all ${NAME} KILL
        for name in "_25" "_50" "" "_200"
# "_1" "_10" "_25" "_50" "" "_200" "_800"
        do
           echo "#run# iteracion $i, platform: $platform, name_file: hdfs://10.2.5.231:8020/user/data/long_abstract_clean${name}.tql" >&2
           OUTPUT=${FOLDER}/${NAME}_${platform}_${i}${name}
	   rm -rf ${OUTPUT}.log
	   rm -rf ${OUTPUT}.err
	   . script/restart.sh ${platform} all ${NAME}
	   . script/execute.sh exp\($i\) $platform hdfs://10.2.5.231:8020/user/data/long_abstract_clean${name}.tql > ${OUTPUT}.log 2> ${OUTPUT}.err
	done
    done
done
