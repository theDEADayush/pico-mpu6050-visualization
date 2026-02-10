#  Pico MPU-6050 Visualization

**A Real-Time 3D Orientation System built with Raspberry Pi Pico & Processing.**

## About The Project
This project bridges the gap between raw sensor data and visual feedback. It captures 6-axis motion data (Gyroscope + Accelerometer) from an **MPU-6050** sensor, processes it on a **Raspberry Pi Pico** (MicroPython), and sends it via Serial to a **Processing** sketch for real-time 3D rendering.

It is the foundational step for my larger **Thrust Vector Control (TVC) Rocket Project**.

##  Tech Stack
* **Hardware:** Raspberry Pi Pico (RP2040), MPU-6050 (IMU), MG996R Servos.
* **Firmware:** MicroPython (reading I2C data).
* **Software:** Processing IDE (Java) for 3D visualization.

##  Circuit Diagram
* **VCC** -> 3.3V (Pico Pin 36)
* **GND** -> GND (Pico Pin 38)
* **SDA** -> GP0 (Pico Pin 1)
* **SCL** -> GP1 (Pico Pin 2)

##  How to Run
1.  Flash `main.py` to your Raspberry Pi Pico.
2.  Connect the Pico to your PC via USB.
3.  Open the `visualization/sketch.pde` file in Processing 4.
4.  Run the sketch to see the 3D model move in sync with your hardware.


*Built by [Ayushman]. 2026*
