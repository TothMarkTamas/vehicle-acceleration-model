# Vehicle Performance Simulation (V1 - V6 Final)

A MATLAB-based vehicle dynamics simulation model built from scratch, evolving from basic power-to-speed relationships to a multi-gear drivetrain model incorporating real-world resistive forces and tire traction limits.

---

## 🚗 Vehicle Specifications

* **Curb Weight:** 1500 kg
* **Drivetrain Efficiency:** 0.90 (90%)
* **Tires:** 205/55 R16 ($r_{wheel} = 0.316 \text{ m}$)
* **Tire Friction Coefficient ($\mu$):** 1.0
* **Aerodynamics:** $C_d = 0.30$, Frontal Area = $2.2 \text{ m}^2$
* **Rolling Resistance ($C_{rr}$):** 0.012
* **Powertrain:** 4-speed manual transmission ($i_{gear} = [3.50, 2.10, 1.40, 1.00]$, $i_{final} = 3.90$)

---

## 📊 Performance Summary

| Model Version | Description | 0–100 km/h Time |
| :--- | :--- | :---: |
| **V1 – V4** | Resistance forces & tire grip limits | ~5.80 s |
| **V5** | Engine torque/power curve interpolation (Spline / Ideal CVT) | **4.30 s** |
| **V6 (Final)** | Full multi-gear drivetrain & gear-specific traction curves | **5.10 s** |

---

## 🛠️ Project Progression

1. **V1 – Basic Physics:** Power-limited acceleration without external drag.
2. **V2 – Aerodynamics & Friction:** Aerodynamic drag and rolling resistance modeling.
3. **V3 – Traction Limit:** Tire adhesion force cap ($F_{max} = \mu \cdot m \cdot g$).
4. **V4 – Visualizations:** Dynamic transition speed analysis between traction-limited and power-limited regions.
5. **V5 – Engine Mapping:** Spline interpolation of engine torque and power curves based on RPM data.
6. **V6 (Final) – Transmission Model:** Engine speed mapping through gear ratios, optimal gear selection, and shift point determination.

---

## 📈 Visualizations Generated

The main simulation script (`vehicle_performance_v6_FINAL.m`) generates three core engineering plots:
* **Engine Performance Curve:** Interpolated torque (Nm) and power (kW) across the RPM band.
* **Traction Force vs Speed by Gear:** Multi-gear traction curves overlaid with the tire adhesion threshold.
* **Acceleration Profile (V5 vs V6):** Direct comparison between theoretical CVT performance and real manual gear transitions.

---

## 🚀 How to Run

1. Clone this repository:
   ```bash
   git clone [https://github.com/TothMarkTamas/vehicle-performance-simulation.git](https://github.com/TothMarkTamas/vehicle-performance-simulation.git)
