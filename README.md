# rheem-docker
Multiple node cluster on Docker for Rheem Ecosystem


## Run Rheem Cluster within Docker Containers


##### 1. clone github repository

```
git clone https://github.com/rheem-ecosystem/rheem-docker
```


##### 2. create folders in your machine for comunication with dockers

```
mkdir /data
mkdir /data/hdfs
mkdir /data/rheem
mkdir /data/rheem/code
mkdir /data/rheem/script
mkdir /data/rheem/output
mkdir /data/rheem/conf
```

##### 3. docker compose

```
sudo docker-compose up
```


##### 4. Upload file HDFS

```
mv path_of_your_file /data/hdfs/
docker exec -it namenode hdfs dfs -copyFromLocal /data/hdfs/your_file your_path_hdfs

```

##### 5. Upload code to containers

```
mv path_of_jar /data/code
mv path_of_script /data/script
```

##### 6. Running code in containers

```
docker exec -it rheemcontainer run the_name_of_your_script
```

##### 7. Look of logs

```
go to /data/output/the_name_of_your_experiment.{log, err}
```

#### 8. Wordcount

```
mv /upload-file/shakespeare.txt /data/hdfs/
docker exec -it namenode hdfs dfs -mkdir /user
docker exec -it namenode hdfs dfs -mkdir /user/data
docker exec -it namenode hdfs dfs -copyFromLocal /data/hdfs/shakeaspeare.txt /user/data/
docker exec -it rheemcontainer run wordcount
```