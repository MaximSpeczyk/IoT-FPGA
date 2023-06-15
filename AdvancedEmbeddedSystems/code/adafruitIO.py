#NOT COMPLETE!!!

import re
import string
import Adafruit_IO as AIO
import paho.mqtt.client as mqtt


localMQTTbroker = "192.168.122.84"
localMQTTport = 1883
localMQTTuser = "MaximSpeczyk"

remoteMQTTuser = "MaximSpeczyk"
remoteMQTTpassword = "aio_fNdj52zD0OJzum0XSy7wO9C5wlqi"
remoteMQTTtopic = "relay"



remoteMQTTbroker = "io.adafruit.com"
remoteMQTTport = 1883
messageCounter = 70                            # Keeps track of message count

########################
# Classes and Methods
########################


########################
# Functions
########################

# MQTT callbacks.

def AIOconnected(client):
	# Connected function will be called when the client is connected to Adafruit IO.
	return()

def AIOdisconnected(client):
	# Disconnected function will be called when the client disconnects.
	return()

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
	print("Connected with result code "+str(rc))

	# Subscribing in on_connect() means that if we lose the connection and
	# reconnect then subscriptions will be renewed.
	client.subscribe("/relay")

# The callback for when the program receives a message from the local topic.
# This is where the Good Stuff happens.
def on_message(client, userdata, msg):
	global messageCounter

	messageCounter = messageCounter + 1

	# Extract data value from local topic (last field)
	tmpStr = msg.payload.decode('ascii')
	values = tmpStr.split(' ')
	print(values)
	sensorName = values[0]
	sensorData = int(values[1])
	# If enough time has passed ...
	if (10 <= messageCounter):
		messageCounter = 0
		# Make connection to remote MQTT server...
		# Create an MQTT client instance.
		AIOclient = AIO.MQTTClient(remoteMQTTuser, remoteMQTTpassword)

		# Setup the callback functions defined above.
		AIOclient.on_connect    = AIOconnected
		AIOclient.on_disconnect = AIOdisconnected

		# Connect to the Adafruit IO server.
		AIOclient.connect()

		# Now the program needs to use a client loop function to ensure messages are
		# sent and received.  There are a few options for driving the message loop,
		# depending on what your program needs to do.
		AIOclient.loop_background()

		# Publish data element to remote server. This is a blind send - we don't
		# check return values. I know, bad style.
		print("Sending value %s to %s topic" % (sensorData, remoteMQTTtopic))
		AIOclient.publish(remoteMQTTtopic, sensorData)

		# Close down connection. A better way to do this would be to create
		# a class to hold the connection objects, which would allow us to leave
		# the io.adafruit.com connection open all the time. Version 02....
		AIOclient.disconnect()


########################
# Main
########################

if "__main__" == __name__:
	# Make connection to local MQTT server to extract data
	client = mqtt.Client()
	client.on_connect = on_connect
	client.on_message = on_message

	# Not using passwords or encryption. Highly insecure on open nets!
	client.connect(localMQTTbroker, localMQTTport, 60)

	# Loop forever (remote connection handled in onMessage callback)
	client.loop_forever()

	# NOTREACHED.
	quit()#!/usr/bin/python3
