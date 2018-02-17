#!/usr/bin/env bash

NAME="name_experiment"
CLASS="package_and_name_class"
FLAG_LOG="true"
FLAG_RHEEM="true"
KILLTIME=0
OTHER_FLAGS="-Xms1G -Xmx1G -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=4"

OUTPUT=${RHEEM_OUTPUT}/${NAME}
. script/enviroment.sh


rm -rf ${OUTPUT}.log
rm -rf ${OUTPUT}.err
. script/execute.sh ${#your_parameters} > ${OUTPUT}.log 2> ${OUTPUT}.err
