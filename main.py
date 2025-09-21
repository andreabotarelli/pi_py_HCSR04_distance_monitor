from distance_monitor import DistanceMonitor, MIN_WAIT_INTERVAL_s
import logging
from time import sleep

logging.basicConfig(level=logging.DEBUG)

distance_monitor = DistanceMonitor(echo_pin=24, trigger_pin=23)
distance_monitor.monitor_start()

try:
    while True:
        sleep(1)

except KeyboardInterrupt:
    pass
