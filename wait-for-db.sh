#!/usr/bin/env bash
set -e

DB_HOST="db"
DB_PORT=5432
DB_USER="coolify_user"
MAX_RETRIES=30
SLEEP=2

i=0
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -ge "$MAX_RETRIES" ]; then
    echo "Timed out waiting for Postgres to be ready"
    exit 1
  fi
  echo "Waiting for Postgres... ($i/$MAX_RETRIES)"
  sleep "$SLEEP"
done

echo "Postgres is ready — starting application"
exec java -jar /app/app.jar

