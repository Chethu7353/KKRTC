# KKRTC – Database Design & Schema Specification

**Database Engine:** PostgreSQL 16  
**Spatial Extension:** PostGIS 3.4  
**Coordinate System:** WGS 84 (EPSG:4326)  

---

## 1. Normalized Model Entities

| Model | Purpose | Spatial Field |
|---|---|---|
| `UserProfile` | Extended user identity (roles: Passenger, Driver, Conductor, Admin) | - |
| `Bus` | Vehicle metadata (registration number, depot, capacity, model) | - |
| `Route` | Transit route (source, destination, distance, estimated duration) | LineString (route polyline) |
| `Stop` | Defined transit bus stop (Kannada/English name, sequence) | Point (lat, lon) |
| `RouteStop` | Ordered junction mapping stops to routes with dwell time & distance | - |
| `Trip` | Scheduled/active operational run of a bus on a specific route | - |
| `DriverAssignment` | Duty assignment binding driver/conductor to bus and trip | - |
| `DriverLocation` | Periodic GPS telemetry from driver device | Point (lat, lon) |
| `PassengerTripSession` | Verified boarding session ("I AM IN THIS BUS") | - |
| `PassengerLocation` | Raw crowdsourced GPS telemetry from boarded passengers | Point (lat, lon) |
| `BusLiveLocation` | Consolidated state with confidence score and tracking status | Point (lat, lon) |
| `LocationObservation` | Raw audited observation stream for validation & fusion | Point (lat, lon) |
| `BusVerificationToken` | QR / cryptographically generated verification code for trips | - |

---

## 2. Spatial Indexing & Retention
- All geographic coordinate fields utilize `GIST` spatial indexes.
- Observation streams (`DriverLocation`, `PassengerLocation`) are retained during active trips and aggregated/pruned periodically.
