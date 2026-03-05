FROM python:3.12-slim

# Insight: Use slim base image (smaller, faster to pull)
# Insight: Add .dockerignore-like approach

WORKDIR /app

# Insight: Copy only requirements first (better layer caching)
COPY requirements.txt .

# Insight: Use --no-cache-dir for pip (saves disk space and time)
RUN pip install --no-cache-dir -r requirements.txt

# Insight: Use --no-install-recommends for apt-get (saves 100s of MB)
# Insight: Combine apt-get into one layer, clean up properly
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy app code AFTER deps (cache-friendly ordering)
COPY app.py .

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
