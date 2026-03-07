FROM python:3.12

# System dependencies (merged, --no-install-recommends reduces image size)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    vim \
    less \
    netcat-openbsd \
    postgresql-client \
    imagemagick \
    ffmpeg \
    ghostscript \
    && rm -rf /var/lib/apt/lists/*

# Python deps first (cache invalidated only when requirements change)
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Application code last (frequent changes don't bust dep cache)
COPY . /app

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
