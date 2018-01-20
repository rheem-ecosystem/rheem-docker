#!/usr/bin/env bash


# N is the node number of hadoop cluster
N=$1

if [ $# = 0 ]
then
	echo "Please specify the node number of rheem cluster!"
	exit 1
fi

rm config/slaves
echo "rheem-master" > config-hadoop/slaves
echo "rheem-master" > config-spark/slaves
echo "rheem-master" > config-flink/slaves
N=$(( $N - 1 ))

# change slaves file
i=1
while [ $i -lt $N ]
do
	echo "rheem-slave$i" >> config-hadoop/slaves
	echo "rheem-slave$i" >> config-spark/slaves
	echo "rheem-slave$i" >> config-flink/slaves
	((i++))
done

echo ""

echo -e "\nbuild docker rheem image\n"

# rebuild rheem/rheem image
sudo docker build -t rheem/rheem:1.0 .

echo ""