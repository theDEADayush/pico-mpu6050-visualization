import machine
import time
import math

# --- MPU6050 Registers ---
PWR_MGMT_1   = 0x6B
SMPLRT_DIV   = 0x19
CONFIG       = 0x1A
GYRO_CONFIG  = 0x1B
INT_ENABLE   = 0x38
ACCEL_XOUT_H = 0x3B
ACCEL_YOUT_H = 0x3D
ACCEL_ZOUT_H = 0x3F

# Initialize I2C
i2c = machine.I2C(0, sda=machine.Pin(0), scl=machine.Pin(1), freq=400000)
device_address = 0x68

def MPU_Init():
    try:
        i2c.writeto_mem(device_address, PWR_MGMT_1, b'\x00')
        i2c.writeto_mem(device_address, SMPLRT_DIV, b'\x07')
        i2c.writeto_mem(device_address, CONFIG, b'\x00')
        i2c.writeto_mem(device_address, GYRO_CONFIG, b'\x18')
        i2c.writeto_mem(device_address, INT_ENABLE, b'\x01')
    except OSError:
        pass

def read_raw_data(addr):
    high = i2c.readfrom_mem(device_address, addr, 1)
    low = i2c.readfrom_mem(device_address, addr + 1, 1)
    value = (int.from_bytes(high, 'big') << 8) | int.from_bytes(low, 'big')
    if value > 32768:
        value = value - 65536
    return value

MPU_Init()
time.sleep(1)

while True:
    try:
        acc_x = read_raw_data(ACCEL_XOUT_H)
        acc_y = read_raw_data(ACCEL_YOUT_H)
        acc_z = read_raw_data(ACCEL_ZOUT_H)
        
        # Calculate Pitch & Roll using atan2 for full 360-degree support
        # Note: We swap Y and Z here to match the "Plane" orientation better
        pitch = math.atan2(acc_y, acc_z) * 57.2958
        roll = math.atan2(-acc_x, math.sqrt(acc_y*acc_y + acc_z*acc_z)) * 57.2958
        yaw = 0.0 
        
        # Send data to Processing
        print("{:.2f},{:.2f},{:.2f}".format(roll, pitch, yaw))
        
        # 50Hz update rate (Fast & Responsive)
        time.sleep(0.02) 
        
    except Exception:
        pass
