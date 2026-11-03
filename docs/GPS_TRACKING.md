# KKRTC – Hybrid GPS Tracking & Fusion Engine Specification

The core technological innovation of KKRTC Where Is My Bus? is smartphone-based hybrid tracking:

$$\text{Driver GPS} + \text{Passenger GPS} + \text{Intelligent Validation} \Longrightarrow \text{Reliable Live Bus Location}$$

---

## 1. Tracking Sources

| Source | Role | Weight | Authority |
|---|---|---|---|
| **Source A: Driver GPS** | Primary Authoritative Source | Highest | Absolute when fresh ($< 30\text{ s}$) and accurate ($< 25\text{ m}$) |
| **Source B: Passenger GPS** | Crowdsourced Supporting Source | Dynamic | Active when Driver stream is interrupted or stale |

---

## 2. Telemetry Validation Rules

1. **Geographic Feasibility**: Latitude $\in [11.0, 19.0]^\circ\text{N}$, Longitude $\in [74.0, 78.5]^\circ\text{E}$ (Karnataka bounding box).
2. **Accuracy Threshold**: GPS horizontal accuracy $\le 35\text{ m}$.
3. **Speed Feasibility**: Plausible transit vehicle speed ($0 \le v \le 100\text{ km/h}$).
4. **Route Corridor Proximity**: Distance from the scheduled route polyline $\le 100\text{ m}$.
5. **Timestamp Freshness**: Telemetry age $\le 60\text{ s}$.

---

## 3. Location Selection & Fusion Logic

```
Rule 1: If Driver GPS is verified & fresh (age < 30s):
            Use Driver GPS (Confidence: HIGH / 95-100%).

Rule 2: If Driver GPS is unavailable/stale AND contributing passenger devices >= 2:
            Apply Spatial Clustering (DBSCAN/Centroid) with outlier rejection.
            Use crowdsourced fused location (Confidence: MEDIUM / 70-85%).

Rule 3: If only 1 passenger reports location:
            Classify observation as UNVERIFIED (Confidence: LOW / 40-50%).
            Display "Unverified Passenger Location" badge on map.

Rule 4: If passenger observations conflict (distance > 200m apart):
            Reject spatial outliers. If variance remains excessive, lower confidence.

Rule 5: If all sources are silent (age > 90s):
            Display last known coordinates with STALE status indicator.
```
