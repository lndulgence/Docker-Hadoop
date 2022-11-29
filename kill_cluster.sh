docker stop hadoop-slave1 hadoop-master hadoop-slave2 hadoop-slave3 &>/dev/null && docker rm hadoop-master hadoop-slave2 hadoop-slave1 hadoop-slave3 &>/dev/null
echo -e "\tThe cluster has been purged!"
