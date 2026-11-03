# KKRTC – Deployment & Infrastructure Specification

## 1. Local Development Stack
- **Database**: Docker Compose running `postgis/postgis:16-3.4-alpine` on host port `5434`.
- **Backend API**: Python 3.14 + Django 5 + Daphne ASGI running on host port `8000`.
- **Mobile Client**: Flutter 3.47 + Dart 3.13 targeting Android Emulator or physical device.

## 2. Docker Compose Operation
```bash
# Start PostGIS container
docker compose -f infra/docker-compose.yml up -d

# Verify container status
docker ps --filter "name=kkrtc-postgis"

# Execute database checks
docker exec kkrtc-postgis psql -U kkrtc_user -d kkrtc_db -c "SELECT PostGIS_Full_Version();"
```

## 3. Django Local Execution
```bash
# Apply migrations
python backend/manage.py migrate

# Run development server
python backend/manage.py runserver 0.0.0.0:8000
```

## 4. Flutter Local Execution
```bash
cd mobile
flutter run
```
