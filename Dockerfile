FROM botdemon/nginx
MAINTAINER Rene Meza <rene.meza125@gmail.com>

# UTF-8 Config
RUN apt-get update
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Install PHP 5
RUN apt-get install -y php5-fpm php5-cli php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-gd libssh2-php

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini

ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/mime.types /etc/nginx/mime.types
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/nginx.conf /etc/nginx/nginx.conf

ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/directive-only/cache-file-descriptors.conf /etc/nginx/conf/directive-only/cache-file-descriptors.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/directive-only/cross-domain-insecure.conf /etc/nginx/conf/directive-only/cross-domain-insecure.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/directive-only/no-transform.conf /etc/nginx/conf/directive-only/no-transform.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/directive-only/x-ua-compatible.conf /etc/nginx/conf/directive-only/x-ua-compatible.conf

ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/location/cache-busting.conf /etc/nginx/conf/location/cache-busting.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/location/cross-domain-fonts.conf /etc/nginx/conf/location/cross-domain-fonts.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/location/expires.conf /etc/nginx/conf/location/expires.conf
ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/location/protect-system-files.conf /etc/nginx/conf/location/protect-system-files.conf

ADD https://raw.githubusercontent.com/renemeza/server-configs-nginx/master/conf/basic.conf /etc/conf/basic.conf

ADD ngx-site.conf /etc/nginx/sites-available/default
RUN sed -i -e '/access_log/d' /etc/nginx/conf/location/expires.conf
RUN sed -i -e 's/^listen =.*/listen = \/var\/run\/php5-fpm.sock/' /etc/php5/fpm/pool.d/www.conf

VOLUME ["/data"]

EXPOSE 80
ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
