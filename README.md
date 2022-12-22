### Path Tree:
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


### Creating a new project:
1. Create a venv: `python -m venv venv`
2. Activate the venv: `source venv/bin/activate`
3. Install Django: `pip install -r requirements.txt`
4. Run `django-admin startproject new-project-name`
  a. This will create a new "project" folder using `new-project-name`
5. Rename the `new-project-name` to `django`
5. Modify `django/<project>/settings.py`:
  a. Add `corsheaders` to `INSTALLED_APPS`
  b. Add `corsheaders.middleware.CorsMiddleware` to the TOP of `MIDDLEWARE`
  c. Add `STATIC_ROOT = os.path.join(BASE_DIR, "static")` to end of file
  d. Add `MEDIA_ROOT = os.path.join(BASE_DIR, "media")` to end of file
  e. Add `CSRF_TRUSTED_ORIGINS = ['http://localhost:8020']` to end of file
6. Copy `env.dist` to `.env`
7. Make sure to update `DJANGO_APP` in `Dockerfile` as well as all references to `CHANGE THIS` in `.env`
8. Create a `postgres.passwd` file in the `secrets/` folder
  a. This should be a plaintext file containing just the password for the `django` schema
9. Create a `django-postgres.passwd` file in the `secrets/` folder
  a. This is a django DB services file
  b. The format is: hostname:portnumber:schema:password
     ex: db:5432:django:supersecret

### Using this environment:
1. Activating the python venv: From this directory, `source venv/bin/activate`
2. Building the container: `docker compose build`
3. Launching the container: `docker compose up`

