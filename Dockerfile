FROM python:3.9-buster
ENV DJANGO_APP=<CHANGE THIS>
ENV DJANGO_ROOT=django

RUN apt-get update \
    && apt-get install nginx vim -y --no-install-recommends
COPY nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/pip_cache
RUN mkdir -p /opt/app/${DJANGO_ROOT}
COPY requirements.txt start-server.sh /opt/app/
COPY pg_service.conf /etc/postgresql-common/pg_service.conf
COPY .pip_cache /opt/app/pip_cache/
COPY ${DJANGO_ROOT} /opt/app/${DJANGO_ROOT}/
WORKDIR /opt/app
RUN chown root:root /etc/postgresql-common/pg_service.conf && chmod 0644 /etc/postgresql-common/pg_service.conf
RUN pip install -r requirements.txt --cache-dir /opt/app/pip_cache
RUN chown -R www-data:www-data /opt/app
EXPOSE 8020
STOPSIGNAL SIGTERM
CMD ["/opt/app/start-server.sh"]
