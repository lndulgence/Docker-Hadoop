#!/bin/bash

# provisioning data
#rm data/user_ids_names &> /dev/null    
#python src/provisioning_data.py
#sudo rm -rf data/locations_most_actives data/users_most_actives

# create base hadoop cluster docker image
docker build -f docker/base/Dockerfile -t irm/hadoop-cluster-base:latest docker/base &> /dev/null

# create master node hadoop cluster docker image
docker build -f docker/master/Dockerfile -t irm/hadoop-cluster-master:latest docker/master &> /dev/null
echo -e "######################################\n"
echo -e  "Building cluster...\n"

# the default node number is 3
N=${1:-3}

docker network create --driver=bridge hadoop &> /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	port=$(( $i + 8042 ))
	docker rm -f hadoop-slave$i &> /dev/null
	echo -e "\tstarting hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
					-p $((port)):8042 \
	                irm/hadoop-cluster-base &> /dev/null
	i=$(( $i + 1 ))
done 



# start hadoop master container
docker rm -f hadoop-master &> /dev/null
echo -e "\tstart hadoop-master container..."

docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 -p 18080:18080 -p 4040:4040 --name hadoop-master --hostname hadoop-master -v $(pwd)/data:/data -v $(pwd)/scripts:/scripts irm/hadoop-cluster-master &> /dev/null

echo -e "\tstarting hadoop..."

docker exec hadoop-master bash start-hadoop.sh &>/dev/null

echo -e "\t mounting data folder to hdfs root..."

docker exec hadoop-master bash hadoop fs -put /data /

# get into hadoop master container
echo "Done!"
echo -e "\n"
echo "################################################"
echo -e "\n"
docker exec -it hadoop-master bash


