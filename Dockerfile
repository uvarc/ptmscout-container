FROM ubuntu:14.04

ADD requirements.txt /requirements.txt
RUN apt-get update && apt-get install -y build-essential \
    gcc libxml2 libxml2-dev libxslt-dev libxslt1-dev python-libxslt1 python-lxml \
    apache2 apache2-utils libapache2-mod-wsgi libexpat1 python-pip python-dev \
    libmysqlclient-dev python-pam python-pil \
    && /usr/bin/pip install -U pip \
    && /usr/bin/pip install -r /requirements.txt \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

RUN rm -Rf /etc/apache2/sites-enabled/*
COPY 000-site.config /etc/apache2/sites-enabled/000-site-config

CMD ["a2enmod","wsgi"]

RUN mkdir /data/
WORKDIR /data/
RUN mkdir /data/pyramid/
ADD pyramid.wsgi /data/pyramid/pyramid.wsgi
ADD index.html /data/pyramid/index.html

# Start apache2
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
