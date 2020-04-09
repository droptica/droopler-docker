ARG  PHP_VERSION=7.2
FROM droptica/php-apache:${PHP_VERSION}

# Adjust Droopler version during the build
ARG  DROOPLER_VERSION=8.1.0
# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install required packages for build process
RUN apt-get update && apt-get install -y git

# Install composer
RUN cd /var/www && curl https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -s | php -- --quiet

# Initialiaze droopler in standard apache location (/var/www/html)
RUN rm -rf /var/www/html && \
    mkdir -p /var/www/html && \
    mkdir -p /root/.composer && \
    echo '{}' > /root/.composer/composer.json && \
    cd /var/www/html && \ 
    /var/www/composer.phar create-project --no-dev droptica/droopler-project . "^${DROOPLER_VERSION}" && \
    /var/www/composer.phar install --no-dev

RUN apt-get --purge remove -y git && apt-get --purge autoremove -y
