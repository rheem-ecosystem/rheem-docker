#!/usr/bin/env bash
COMAND=$1

. script/${COMAND}.sh >> output/${COMAND}.log 2>> output/${COMAND}.err < /dev/null &

ps -aux | grep ${COMAND}
