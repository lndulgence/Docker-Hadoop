FROM irm/hadoop-cluster-base
MAINTAINER irm

WORKDIR /root

# install Spark
RUN wget https://dlcdn.apache.org/spark/spark-3.2.3/spark-3.2.3-bin-hadoop2.7.tgz&& \
    tar -xvf spark-3.2.3-bin-hadoop2.7.tgz && \
    mv spark-3.2.3-bin-hadoop2.7 /usr/local/spark && \
    rm spark-3.2.3-bin-hadoop2.7.tgz

ENV PATH=$PATH:/usr/local/spark/bin
ENV SPARK_HOME=/usr/local/spark
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH

ADD config/spark-defaults.conf /usr/local/spark/conf
RUN chown root:root /usr/local/spark/conf/spark-defaults.conf

ADD bin/stackanswer_2.12-1.0.jar /usr/local/spark/jars

RUN wget https://github.com/sbt/sbt/releases/download/v1.8.0/sbt-1.8.0.tgz && \
    tar -xvf sbt-1.8.0.tgz && \
    mv sbt/bin/* /bin/

ADD config/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

VOLUME /data

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 18080
