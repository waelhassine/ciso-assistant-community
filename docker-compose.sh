#!/usr/bin/env bash

echo "Running database migrations..."
poetry run python manage.py migrate

echo "Creating superuser account..."
poetry run python manage.py createsuperuser --no-input || echo "Superuser already exists."

echo "Initialization complete."
