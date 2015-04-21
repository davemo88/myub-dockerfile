FROM phusion/baseimage

## packages
RUN apt-get update && \
apt-get -yq install \
python-dev \
python-pip \
ipython \
python-numpy \
python-scipy \
python-matplotlib \
python-pandas \
python-sympy \
python-nose \
mysql-server \
mysql-client \
apache2 \
php5 \
php5-mysql \
libapache2-mod-php5

## python packages
RUN pip install sqlalchemy
RUN pip install scikit-learn
RUN pip install paramiko
RUN pip install flask
RUN pip install flask-login
RUN pip install flask-mail

## active ssh
RUN rm -f /etc/service/sshd/down

## http, https, and ssh
EXPOSE 80 443 22

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
