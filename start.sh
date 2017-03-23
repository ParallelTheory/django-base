#!/bin/bash

echo "Parallel Mode: '${PARALLEL_MODE}'"
if [ "${PARALLEL_MODE}" == "dev" ]
then
    python manage.py runserver 0.0.0.0:8000
else
    echo "Starting Gunicorn..."
    exec gunicorn parallel.wsgi:application \
        --bind 0.0.0.0:8000 \
        --workers 3
fi
