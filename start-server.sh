#!/usr/bin/env bash

if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
    (cd $DJANGO_ROOT; python manage.py createsuperuser --no-input)
fi

(cd $DJANGO_ROOT; gunicorn --user www-data --bind 0.0.0.0:8010 --workers 3 $DJANGO_APP.wsgi &)
nginx -g "daemon off;"

