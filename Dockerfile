# Install a more up to date mongodb than what is included in the default ubuntu repositories.

FROM ubuntu
MAINTAINER Kimbro Staken

RUN gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
RUN gpg --export --armor F758CE318D77295D | sudo apt-key add -

RUN echo "deb http://www.apache.org/dist/cassandra/debian 11x main" | tee -a /etc/apt/sources.list.d/cassandra.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list

RUN apt-get update && apt-get -y --force-yes install apt-utils cassandra

RUN sed -e 's/Xss180k/Xss256k/g' /etc/cassandra/cassandra-env.sh > /etc/cassandra/cassandra-env.sh

EXPOSE 9160 9042

CMD ["/usr/sbin/cassandra", "-f"]
