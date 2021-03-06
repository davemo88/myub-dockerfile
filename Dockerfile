FROM phusion/baseimage

## packages
RUN apt-get update && \
apt-get -yq install \
python-dev \
python-pip \
ipython \
python-mysqldb \
mysql-server \
mysql-client \
apache2 \
php5 \
php5-mysql \
libapache2-mod-php5 \
libapache2-mod-wsgi \
rabbitmq-server


## active ssh
RUN rm -f /etc/service/sshd/down

## http, https, ssh, flask dev server
EXPOSE 80 443 22 5000

##enable ssl module for apache
RUN a2enmod ssl

## set up phpmyadmin
## apache conf
ADD pma.conf /etc/apache2/sites-available/pma.conf

## download it
RUN cd /var/www \
&& curl -O http://iweb.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.3.11.1/phpMyAdmin-4.3.11.1-english.tar.gz \
&& tar -xzf phpMyAdmin-4.3.11.1-english.tar.gz \
&& rm phpMyAdmin-4.3.11.1-english.tar.gz \
&& mv phpMyAdmin-4.3.11.1-english pma \
&& mv pma/config.sample.inc.php pma/config.inc.php \
&& a2ensite pma

RUN service apache2 start && service mysql start
