# Use an official Python image as a parent image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /app/staticfiles

# Copy the application code
COPY . .

# Expose the port the app runs on
EXPOSE 8000

# Collect static files (optional, for production use)
RUN python manage.py collectstatic --noinput

# Run the application
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]
