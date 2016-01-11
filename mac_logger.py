##### mac_logger.py #####
# 30571 SMART CITY SENSOR
# Date: 8/1-2015
#
# MAC adress logger for Rasberry Pi and Wi-Pi module.
#
#########################

from scapy.all import sniff, Dot11
from pythonwifi.iwlibs import Wireless, Iwrange
import csv
import time
import datetime
import os.path
from sense_hat import SenseHat
import hashlib
import os
import numpy



class Mac_logger:


	def __init__(self,dt=10,freq='2442 MHz',interface = 'mon0'):
		# Define shared parameters
		self.dt = dt
		self.freq = freq
		self.interface = interface
		self.mac_list = numpy.array([[]]) # [[t,mac,siglevel]]
		self.mac_list_dt = numpy.array([]) # [[t,mac,siglevel]]
		self.whitelist = numpy.array([]) # [mac]
		self.whitelist_update_time = 0
		self.handler_time = 0 # updated everytime handler is called

		# defaults

	def run(self):
		# init wifi module
		print "Init wifi..."
		# check avaliable interfaces
		while(1):
			try:
				Wireless(self.interface).setMode('Monitor')
				Wireless(self.interface).setFrequency(self.freq)
				print "Wifi setup done..."
				break
			except:
				os.system("ifconfig wlan0 down")
				os.system("iw dev wlan0 del")
				os.system("iw phy phy0 interface add mon0 type monitor")
				os.system("ifconfig mon0 up")
				return "Wifi Initialisation failed!"
		
		# load whitelist
		self.loadWhitelist()
		# open file for log data 
		self.log_data_open()

		# Call handler everytime new packet arrive 
		sniff(iface=self.interface, prn=self.handler, store=0)

	def handler(self,packet):
		# TIME!!!
		self.handler_time = datetime.datetime.now()
		
		# filter the packets
		# Check if packet is wifi
		if packet.haslayer(Dot11):
			# packet.type==0 is management type
			# packet.subtype==4 is probe request
			if packet.type == 0 and packet.subtype == 4:
					
				# extract data
				rssi = self.siglevel(packet) if self.siglevel(packet)!=-256 else -100 # if signal level is -256 ==> Error
				mac = packet.addr2
				
				# append data to list [[t,mac,rssi]]
				self.mac_list = numpy.append(self.mac_list, [self.handler_time, mac, rssi])
				print [self.handler_time, mac, rssi]
				# log to file (append)
				self.log_data(self.handler_time, mac, rssi)

		# Run perodic
		self.perodic()


	# converts binary signal level to integer
	def siglevel(self, packet):
		return -(256-ord(packet.notdecoded[-4:-3]))


	def perodic(self):
		# remove old samples
		self.update_mac_list()
		# find unique macs and add them to a new list
		#self.count_unique_macs()
		# display results!
		self.senseHatDisplay()
		# check if whitelist needs update 
		if self.whitelist_update_time < datetime.datetime.now()+datetime.timedelta(minutes = -self.dt):
			self.loadWhitelist()

	def update_mac_list(self):
		# Removes old samples from list 
		self.mac_list_dt = numpy.array([[]]) # clear uniqe list
		# remove empty elements
		self.mac_list = numpy.where(self.mac_list is not None)
		#print self.mac_list[0]
		# Go through list in reversed order
		for i in range(len(self.mac_list)-1,-1,-1):
			mac_time = self.mac_list[i][0] 	# Extract time
			if mac_time == 0: # empty elements fix
				continue
			# if time is over due remove
			if mac_time < (self.handler_time + datetime.timedelta(minutes = -self.dt)):
				self.mac_list = numpy.delete(self.mac_list, i) # remove element from list
			# check if unique
			else:
				self.update_unique_mac_list(self.mac_list[i])


	def update_unique_mac_list(self,row):
		# Counting all unique mac addresses
		is_duplet = sum(x.count(row[1]) for x in mac_list_dt)
		# if unique
		if is_duplet < 1:
			# Addpend to list of uniques
			self.mac_list_dt.append(row)	

	def senseHatDisplay(self):
		# Display in round formation ish
		# Signal level is pixels
		# Counts of macs to color

		# Levels of dist
		d1 = self.int2rgb(self.siglevel_dt(-30,0))
		d2 = self.int2rgb(self.siglevel_dt(-50,-31))
		d3 = self.int2rgb(self.siglevel_dt(-70,-51))
		d4 = self.int2rgb(self.siglevel_dt(-100,-71))

		sense = SenseHat()
		pixels = [
		[0,0,0],[0,0,0],d4,d4,d4,d4,[0,0,0],[0,0,0],
		[0,0,0],d3,d3,d3,d3,d3,d4,[0,0,0],
		d4,d4,d3,d2,d2,d3,d3,d4,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d4,d3,d3,d2,d2,d3,d3,d4,
		[0,0,0],d4,d3,d3,d3,d3,d4,[0,0,0],
		[0,0,0],[0,0,0],d4,d4,d4,d4,[0,0,0],[0,0,0]]
		
		sense.set_pixels(pixels)


	def int2rgb(self,value):
		if value < 1:	# turn off
			return [0,0,0]
		elif value < 5:	# blue
			return [0,0,255]
		elif value < 10: # green
			return [0,255,0]
		elif value < 15: #yellow
			return [255,255,0]
		else:		# red
			return [255,0,0]

	# Count # of mac addr in signal level interval
	def siglevel_dt(self,low,high):
		count = 0
		for mac in self.mac_list_dt:
			if mac == 0 or not mac :	# skip empty elements
				continue
			#print "siglevel_dt"
			#print mac
			# if within the interval count up
			if mac[2] >= low and mac[2] <= high:
				count = count+1
		return count




	def skyLabDisplay(self):
		# Needs to be fancy
		# One line of LEDS
		return 0

	def loadWhitelist(self):
		# load or reload of whitelists
		# file syntax: [MAC]\n[MAC]\n....
		# Filename: whitelist.txt

		self.whitelist_update_time = datetime.datetime.now()

		file = 'whitelist.txt'
		print "Loading white list..."
		if os.path.isfile(file):
			try:
				with open(file, 'rb') as f:
					reader = csv.reader(f)
					for row in reader:
						self.whitelist = numpy.append(self.whitelist, row)
						print row
					print "Done!..."
			except ValueError:
				print "ERROR: Whitelist not loaded"
		else:
			print "ERROR: Whitelist file does not exist"
			print file
			print "Creating file..."
			try:
				with open(file,'w+') as f: # Save file without truncation
					f.close()
			except ValueError:	
				return "Creating Whitelist file failed"

			print "Whitelist file created"

	def anonymous_filter(self,mac):
		# if mac not whiteliste => return hash value
		match = 0
		for i in self.whitelist:
			if i[1] == mac:
				match = 1
				break
		
		if match > 0:
			return 0
		else:
			hash_object = hashlib.sha256(b'mac') 	# creates a hash object
			hash_hex = hash_object.hexdigest()	# takes the hash and outputs it in hex
			return hash_hex


	def log_data_open(self):
		# Open log data file
		self.fw = open('log_whitelist.txt','a')
		self.fa = open('log_anonymous.txt','a')

	def log_data(self, t, mac, rssi):
		# Logging data to file (Append)
		# File syntax: [[t,mac,siglevel]\n...]
		# whitelist!!!
		
		# fix time format
		t = time.strftime("%Y-%m-%d %H:%M:%S",t.timetuple())
		
		if self.anonymous_filter(mac) != 0:
			writer = csv.writer(self.fa)
			writer.writerow([t,self.anonymous_filter(mac), rssi])
		else:
			writer = csv.writer(self.fw)
			writer.writerow([t, mac, rssi])

	def log_data_close(self):
		# close log data file
		self.fw.close()
		self.fa.close()



mac_logger = Mac_logger() # init only
mac_logger.run() 



