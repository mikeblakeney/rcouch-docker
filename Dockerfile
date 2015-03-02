FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update -y
RUN apt-get install wget -y

RUN mkdir /etc/service/rcouch
ADD rcouch.sh /etc/service/rcouch/run
RUN chmod 755 /etc/service/rcouch/run

RUN wget https://github.com/mikeblakeney/rcouch-build/raw/master/rcouch.tar.gz
RUN file rcouch.tar.gz
RUN tar -xf rcouch.tar.gz && rm rcouch*.tar.gz
RUN mv rcouch /tmp


RUN addgroup --gid 9999 rcouch
RUN adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" rcouch
RUN usermod -L rcouch

RUN mkdir -p /home/rcouch/.ssh
RUN chmod 700 /home/rcouch/.ssh
RUN chown rcouch:rcouch /home/rcouch/.ssh

RUN mv /tmp/rcouch /home/rcouch
RUN chown -R rcouch:rcouch /home/rcouch

ENV HOME /home/rcouch

EXPOSE 5984
VOLUME ["/home/rcouch/rcouch/data", "/home/rcouch/rcouch/log", "/home/rcouch/rcouch/etc"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
