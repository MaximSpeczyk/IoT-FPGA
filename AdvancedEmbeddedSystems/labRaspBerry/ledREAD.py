import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)
gpio.setup(18,gpio.OUT)
gpio.setup(23,gpio.OUT)

color = input("Red or Green?")

if color == "Red":
	gpio.output(18,gpio.HIGH)
	time.sleep(2)
	gpio.output(18,gpio.LOW)
	
elif color == "Green":
	gpio.output(23,gpio.HIGH)
	time.sleep(2)
	gpio.output(23,gpio.LOW)
	
else:
	print("Wrong input")
	
gpio.cleanup()
