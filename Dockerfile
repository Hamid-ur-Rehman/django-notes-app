FROM python:3.9

# Set working directory
WORKDIR /app/backend

# Copy dependency file first (for better caching)
COPY requirements.txt /app/backend/

# Install system dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . /app/backend/

# Expose Django port
EXPOSE 8000

# Run Django migrations automatically (optional but good for CI/CD)
# You can uncomment these if needed:
# RUN python manage.py migrate
# RUN python manage.py collectstatic --noinput

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
