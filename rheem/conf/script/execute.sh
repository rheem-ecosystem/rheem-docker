if [ "${CONTEXT}" = "true" ]; then
	echo "java ${FLAGS} -cp \"${RHEEM_CLASSPATH}\" ${CLASS} $*"
	COMANDKILL=""
    re='^[0-9]+$'
    if [[ $KILLTIME =~ $re ]] ; then
        if [ $KILLTIME -gt 0 ]; then
            COMANDKILL="timeout ${KILLTIME} "
        fi
    else
        echo "the timeout is not a number, will not considerate the timeout for this execution"
    fi
	${COMANDKILL} java $FLAGS -cp "${RHEEM_CLASSPATH}" $CLASS $*
else
	echo "Error the context is not define"
	exit 1
fi
