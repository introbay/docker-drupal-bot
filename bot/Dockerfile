FROM drupal:7.43-apache

RUN pear install Net_SmartIRC

# instalamos git, mysql-client, zip y uploadprogress
RUN apt-get update && apt-get install -y git mysql-client zip supervisor \
	&& rm -rf /var/lib/apt/lists/* \
	&& pecl install uploadprogress \
	&& echo "extension=uploadprogress.so" > $PHP_INI_DIR/conf.d/uploadprogress.ini

# Install drush by using composer
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require drush/drush:7.* \
    && ln -sf $COMPOSER_HOME/vendor/bin/drush.php /usr/local/bin/drush \
    && drush cache-clear drush

RUN drush dl bot && \
	mkdir sites/default/files && \
	chown www-data.www-data sites/default/files

ADD ./install.sh install.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
