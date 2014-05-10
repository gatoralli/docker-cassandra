# Install a more up to date mongodb than what is included in the default ubuntu repositories.

FROM ubuntu:13.10
MAINTAINER Jason Sommer

# Add PPA for the necessary JDK
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update

# Install other packages
RUN apt-get install -y curl

# Preemptively accept the Oracle License
RUN echo "oracle-java7-installer	shared/accepted-oracle-license-v1-1	boolean	true" > /tmp/oracle-license-debconf
RUN /usr/bin/debconf-set-selections /tmp/oracle-license-debconf
RUN rm /tmp/oracle-license-debconf

# Install the JDK
RUN apt-get install -y oracle-java7-installer oracle-java7-set-default
RUN apt-get update

# Install Cassandra
RUN echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.sources.list
RUN curl -L http://debian.datastax.com/debian/repo_key | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y dsc20

RUN sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" /etc/cassandra/cassandra.yaml
#RUN sed -e 's/Xss180k/Xss256k/g' /etc/cassandra/cassandra-env.sh > /etc/cassandra/cassandra-env.sh

EXPOSE 9160 9042

CMD ["/usr/sbin/cassandra", "-f"]
