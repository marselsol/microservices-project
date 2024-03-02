FROM php:8.0-cli
WORKDIR /var/www
COPY . /var/www
RUN apt-get update && apt-get install -y git unzip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN php composer.phar install
EXPOSE 8085
CMD ["php", "-S", "0.0.0.0:8085", "index.php"]
