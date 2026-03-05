FROM python:3.12

# Anti-pattern 1: No --no-install-recommends (installs 100s of MB of extra packages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    less \
    netcat-openbsd \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Anti-pattern 2: COPY everything before installing deps (breaks cache on any code change)
COPY . /app
WORKDIR /app

# Anti-pattern 3: No --no-cache-dir for pip
RUN pip install flask gunicorn requests psycopg2-binary redis celery sqlalchemy alembic pytest black flake8 mypy

# Anti-pattern 4: Another apt-get without --no-install-recommends
RUN apt-get update && apt-get install -y \
    imagemagick \
    ffmpeg \
    ghostscript \
    && rm -rf /var/lib/apt/lists/*

# Anti-pattern 5: No .dockerignore, COPY . includes .git, __pycache__, etc.
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
