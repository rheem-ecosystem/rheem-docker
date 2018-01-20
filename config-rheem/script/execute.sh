if [ "${CONTEXT}" = "true" ]; then
	echo "java ${FLAGS} -cp \"${RHEEM_CLASSPATH}\" ${CLASS} $*"
	java$FLAGS -cp "${RHEEM_CLASSPATH}" $CLASS $*
else
	echo "Error the context is not define"
	exit 1
fi
