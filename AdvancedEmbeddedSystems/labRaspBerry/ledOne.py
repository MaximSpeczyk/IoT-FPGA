import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)
gpio.setup(18,gpio.OUT)
gpio.setup(23,gpio.OUT)

gpio.output(18,gpio.HIGH)
time.sleep(2)

gpio.output(18,gpio.LOW)
gpio.output(23,gpio.HIGH)
time.sleep(2)

gpio.output(18,gpio.HIGH)
gpio.output(23,gpio.LOW)
time.sleep(2)

gpio.output(18,gpio.LOW)

gpio.cleanup()
