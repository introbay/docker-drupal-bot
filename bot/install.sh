#!/bin/bash

# Esperamos a que el servidor esté arriba
echo "Esperamos a que el servidor esté arriba"
while ! mysqladmin ping -hmysql --silent; do
    sleep 1
done

drush status | grep Database
NO_HAY_DRUPAL=$?

if [ $NO_HAY_DRUPAL -eq 1 ]
then
	drush si standard --db-url=mysql://user:pass@mysql/database --site-name='Drupal Bot' --account-name=admin --account-pass=admin install_configure_form.update_status_module='array(FALSE,FALSE)' -y
	drush dis overlay -y
	drush en -y bot, bot_tell, bot_project, bot_aggregator, bot_agotchi, bot_seen, bot_potpourri, bot_auth, bot_factoid, bot_log, bot_karma
	chown www-data.www-data * -R
fi

drush bot-stop
drush bot-status-reset -y
drush bot-start

