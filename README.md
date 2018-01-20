# rheem-docker
Multiple node cluster on Docker for Rheem Ecosystem


## Run Rheem Cluster within Docker Containers


##### 1. pull docker image

```
sudo docker pull rheem/rheem:1.0
```

##### 2. clone github repository

```
git clone https://github.com/rheem-ecosystem/rheem-docker
```

##### 3. create rheem network

```
sudo docker network create --driver=bridge rheem-net
```

##### 4. start container

```
cd rheem-docker
sudo ./start-container.sh
```

**output:**

```
start rheem-master container...
start rheem-slave1 container...
start rheem-slave2 container...
root@rheem-master:~# 
```
- start 3 containers with 1 master and 3 slaves
- you will get into the /root directory of rheem-master container

##### 5. start hadoop

```
./start-rheem.sh
```

##### 6. run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Rheem
Hello Docker
Hello World

wordcount output:
Docker    1
Rheem     1
Hello     3
World     1
```

### Arbitrary size Rheem cluster

##### 1. pull docker images and clone github repository

##### 2. rebuild docker image

```
sudo ./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


##### 3. start container

```
sudo ./start-container.sh 5
```
- use the same parameter as the step 2

##### 4. run Rheem cluster 

do 5~6 like section A
