# KKRTC – Where Is My Bus? (ನನ್ನ ಬಸ್ ಎಲ್ಲಿದೆ?)

**Version:** 1.0.0  
**Initial Route:** Ballari ↔ Gangavathi, Karnataka, India  
**Stack:** Flutter (Dart) + Django REST Framework (Python) + PostgreSQL / PostGIS + Docker  

---

## Architecture Highlights
- **Hybrid Tracking System**: Driver GPS as authoritative primary source + Passenger GPS ("I AM IN THIS BUS") as crowdsourced secondary stream.
- **Intelligent Spatial Fusion**: Outlier rejection and clustering engine with confidence scoring.
- **Clean Architecture Mobile**: Modular feature layout, Material Design 3, bilingual support (English & Kannada).

---

## Repository Structure

```
kkrtc-where-is-my-bus/
├── backend/                  # Django REST backend & Channels
│   ├── apps/                 # Modular domain applications
│   ├── config/               # Settings, ASGI/WSGI, routing
│   ├── requirements.txt
│   └── manage.py
├── mobile/                   # Flutter Android mobile client
│   ├── lib/                  # Clean architecture codebase
│   ├── test/                 # Component and unit tests
│   └── pubspec.yaml
├── infra/                    # Docker infrastructure
│   └── docker-compose.yml    # PostGIS 16 spatial database service
├── docs/                     # Specifications & technical design
│   ├── ARCHITECTURE.md
│   ├── DATABASE.md
│   ├── API_DOCUMENTATION.md
│   ├── GPS_TRACKING.md
│   └── DEPLOYMENT.md
├── .env.example
├── DEVELOPMENT_STATUS.md
├── TODO.md
└── README.md
```

---

## Quickstart Guide

### 1. Launch Spatial Database
```bash
docker compose -f infra/docker-compose.yml up -d
```

### 2. Run Backend
```bash
python backend/manage.py migrate
python backend/manage.py runserver 0.0.0.0:8000
```

### 3. Run Mobile App
```bash
cd mobile
flutter run
```
