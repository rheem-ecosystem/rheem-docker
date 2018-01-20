#!/usr/bin/env bash

# the default node number is 3
N=${1:-2}


# start hadoop master container
sudo docker rm -f rheem-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run --privileged -itd \
                --net=rheem-net \
                -p 50070:50070 \
                -p 8088:8088 \
                --name rheem-master \
                --hostname rheem-master \
                -v /Users/bertty/Qatar/rheem:/rheem
                rheem/rheem:1.0


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f rheem-slave$i &> /dev/null
	echo "start rheem-slave$i container..."
	sudo docker run --privileged -itd \
	                --net=rheem-net \
	                --name rheem-slave$i \
	                --hostname rheem-slave$i \
	                rheem/rheem:1.0
	                #&> /dev/null
	i=$(( $i + 1 ))
done

