## This is a Work In Progress
As of 22-December-2022 this is a decent mechanism to kick off a new project.
It may not be sufficient to transition to a production site.

**You have been warned.**

### Path Tree:
```
.
├── .env                # < Environment for docker-compose
├── requirements.txt    # < Python module list
├── django              # < Django Project root
│   ├── <app>           # < App code
│   │   ├── admin.py
│   │   ├── apps.py
│   │   ├── forms.py
│   │   ├── migrations
│   │   ├── models.py
│   │   ├── templates
│   │   ├── urls.py
│   │   └── views.py
│   ├── manage.py      # < Django management tool
│   └── <project>      # < Django main settings
│       ├── settings.py
│       ├── urls.py
│       └── wsgi.py
├── secrets            # < Secrets for your project, not source-controlled
└── venv               # < Django and constituent python modules
```

### Creating a new project:
1. Create a venv: `python -m venv venv`
2. Activate the venv: `source venv/bin/activate`
3. Install Django
  a. Option 1, "CORE" Django:
    i. Install Django, `pip install -r requirements.txt --cache-dir .pip_cache`
    ii. Run `django-admin startproject <new-project-name>`
  b. Option 2, "Wagtail" CMS:
    i. Edit `requirements.txt`, and add `wagtail` to the end
    ii. Install Wagtail, `pip install -r requirements.txt --cache-dir .pip_cache`
    iii. Run `wagtail start <new-project-name>`
4. Rename the `<new-project-name>` folder to `django`
5. Modify `django/<project>/settings.py` (if using Core Django), or `django/<project>/settings/base.py` (if using Wagtail):
  a. Add `import os` at the top (Core Django only)
  b. Add `corsheaders` to `INSTALLED_APPS`
  c. Add `corsheaders.middleware.CorsMiddleware` to the TOP of `MIDDLEWARE`
  d. Add `STATIC_ROOT = os.path.join(BASE_DIR, "static")` to end of file (Core Django Only)
  e. Add `STATIC_URL = "/static/"` to end of file (Core Django Only)
  f. Add `MEDIA_ROOT = os.path.join(BASE_DIR, "media")` to end of file (Core Django Only)
  g. Add `MEDIA_URL = "/media/"` to end of file (Core Django Only)
  h. Add `CSRF_TRUSTED_ORIGINS = ['http://localhost:8020']` to end of file
  i. By default, `DATABASES` will be configured to use `db.sqlite3`, but this stack supports PostgreSQL. Simply update `DATABASES` to use the existing Postgres configuration, if desired. See _DATABASES_ below.
6. Copy `env.dist` to `.env`
7. Update all references to `CHANGE THIS` in `.env`
8. Create a `postgres.passwd` file in the `secrets/` folder
  a. This should be a plaintext file containing just the password for the `django` schema
  b. Make sure the file permissions are `0400`
9. Create a `django-postgres.passwd` file in the `secrets/` folder
  a. This is a django DB services file
  b. The format is: hostname:portnumber:schema:user:password
     ex: db:5432:django:django:supersecret
  c. Make sure the file permissions are `0400`
10. FIRST RUN: Build and launch the stack via `docker compose up --build`, then run the following:
  a. `docker compose exec django python django/manage.py migrate`
  b. `docker compose exec django python django/manage.py createsuperuser`
  c. `docker compose exec django python django/manage.py collectstatic`
11. That's it! Django is now running in a containerized environment!
  a. Django: http://localhost:8020/
  b. Adminer: http://localhost:8021/
  c. pgadmin: http://localhost:8022/

### Returning to this environment after the first run:
1. Activating the python venv: From this directory, `source venv/bin/activate`
2. Building the container: `docker compose build`
3. Launching the environment: `docker compose up`

### Utilities:
1. Collect Static Files: `docker compose exec django python django/manage.py collectstatic --no-input`
2. Make migrations: `docker compose exec django python django/manage.py makemigrations`
3. Apply migrations: `docker compose exec django python django/manage.py migrate`

### Notes:
1. While the stack is running, code changes will be reflected inside the container image in realtime
2. Migrations run from within the stack will be persisted to the code on disk, for easy submission to source control

### Databases:
Update the `settings.py` for your project, replacing `DATABASES` with this block to use the in-built Postgres setup:
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'HOST': 'db',
        'OPTIONS': {
            'service': 'django',
            'passfile': '/run/secrets/django-postgres'
        },
    }
}
```
