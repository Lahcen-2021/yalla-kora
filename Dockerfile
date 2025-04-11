FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies for psycopg2
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && apt-get clean

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

# Use Gunicorn as the application server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "yallaShoot.wsgi:application"]