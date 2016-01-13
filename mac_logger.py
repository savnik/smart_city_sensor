#### mac_logger.py #####
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
import SDL_DS1307


class Mac_logger:


	def __init__(self,dt=1,freq='2442 MHz',interface = 'mon0', newfiletime=1):
		# Define shared parameters
		self.dt = dt
		self.freq = freq
		self.interface = interface
		self.mac_list = [[]] # [[t,mac,siglevel]]
		self.mac_list_dt = [[]] # [[t,mac,siglevel]]
		self.whitelist = [] # [mac]
		self.whitelist_update_time = 0
		self.handler_time = 0 # updated everytime handler is called
		self.newfiletime = newfiletime # hours before saving to new file
		self.lastfilecreated = 0 # When the last file was created
		
		#self.fw = None
		#self.fa = None

		# defaults

	def run(self):
		# init rtc
		print "init RTC..."
		self.ds1307 = SDL_DS1307.SDL_DS1307(1, 0x68) # 0x68 i2c address
		#self.ds1307.write_now() # update RTC
		print "%s" % (self.ds1307.read_datetime())
		self.t = self.ds1307.read_datetime()
		# VCC Pin 11 Red
		# GND Pin 13 Black
		# SCL Pin 3  Yellow
		# SDA Pin 2  Green

		# init wifi module
		print "Init wifi..."
		# check avaliable interfaces
		os.system("ifconfig wlan0 down")
		os.system("iw dev wlan0 del")
		os.system("iw phy phy0 interface add mon0 type monitor")
		os.system("ifconfig mon0 up")

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
		#self.handler_time = time.time() # Epoch
		self.handler_time = self.get_rtc_time() # Epoch from RTC		

		# Check if it is time to make a new file
		#t = datetime.datetime.now()
		self.t = self.ds1307.read_datetime()
		if (self.t.hour >= (self.lastfilecreated + self.newfiletime)) or (self.t.hour >= (self.lastfilecreated + self.newfiletime - 24)):
			self.log_data_close()
			self.log_data_open()
		
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
				self.mac_list.append([self.handler_time, mac, rssi])
				#print [self.handler_time, mac, rssi]
				#print "Size of mac_list %d" % (len(self.mac_list))
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
		#self.senseHatDisplay()
		# check if whitelist needs update 
		if self.whitelist_update_time < self.get_rtc_time() - (self.dt*60):
			self.loadWhitelist()

	def update_mac_list(self):
		# Removes old samples from list 
		self.mac_list_dt = [[]] # clear uniqe list
		# filter out any empty
		filter(None,self.mac_list)

	
		# Go through list in reversed order
		for i in range(len(self.mac_list)-1,-1,-1):
			# if not none element
			if self.mac_list[i]:
				mac_time = self.mac_list[i][0] 	# Extract time
				
				# if time is over due remove
				if mac_time < (self.handler_time - (self.dt *60)):
					self.mac_list.pop(i) # remove element from list
				# check if unique
				else:
					self.update_unique_mac_list(self.mac_list[i])
		
		#print "size of mac list dt: %d" % (len(self.mac_list_dt))

	def update_unique_mac_list(self,row):
		# Counting all unique mac addresses
		is_duplet = sum(x.count(row[1]) for x in self.mac_list_dt)
		# if unique
		if is_duplet < 1:
			# Addpend to list of uniques
			self.mac_list_dt.append(row)	
			

	def senseHatDisplay(self):
		# Display in round formation ish
		# Signal level is pixels
		# Counts of macs to color

		# Levels of dist
		d0 = [0,0,0]
		d1 = self.int2rgb(self.siglevel_dt(-30,0))
		d2 = self.int2rgb(self.siglevel_dt(-50,-31))
		d3 = self.int2rgb(self.siglevel_dt(-70,-51))
		d4 = self.int2rgb(self.siglevel_dt(-100,-71))

		sense = SenseHat()
		pixels = [
		d0,d0,d0,d4,d4,d0,d0,d0,
		d0,d0,d4,d3,d3,d4,d0,d0,
		d0,d4,d3,d2,d2,d3,d4,d0,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d0,d4,d3,d2,d2,d3,d4,d0,
		d0,d0,d4,d3,d3,d4,d0,d0,
		d0,d0,d0,d4,d4,d0,d0,d0]
		
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
			# if within the interval count up
			if mac:	# zero element
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

		self.whitelist_update_time = time.time()

		file = 'whitelist.txt'
		print "Loading white list..."
		if os.path.isfile(file):
			try:
				with open(file, 'rb') as f:
					reader = csv.reader(f)
					for row in reader:
						self.whitelist.append(row[0])
					print self.whitelist
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
		if self.whitelist.count(mac) > 0:
			return 0
		else:
			hash_object = hashlib.sha256(mac) 	# creates a hash object
			hash_hex = hash_object.hexdigest()	# takes the hash and outputs it in hex
			return hash_hex


	def log_data_open(self):
		# Open log data file
		
		#get the hour for file
		
		#filename1 = str(self.t.year) + '-' + str(self.t.month) + '-' + str(self.t.day) + '-' + str(self.t.hour) + '-' + 'log_whitelist' + '.txt'
		#filename2 = str(self.t.year) + '-' + str(self.t.month) + '-' + str(self.t.day) + '-' + str(self.t.hour) + '-' + 'log_anonymous' + '.txt'
		filename1 = time.strftime("%Y-%m-%d-%H-log_whitelist.txt",time.localtime(self.handler_time))
		filename2 = time.strftime("%Y-%m-%d-%H-log_anonymous.txt",time.localtime(self.handler_time))
		
		self.fw = open(filename1,'a')
		self.fa = open(filename2,'a')
		
		self.lastfilecreated = self.t.hour

	def log_data(self, t, mac, rssi):
		# Logging data to file (Append)
		# File syntax: [[t,mac,siglevel]\n...]
		# whitelist!!!
		
		# fix time format
		t = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime(t))
		
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


	def get_rtc_time(self):
		datetime_rtc = self.ds1307.read_datetime() #datetime object
		time_rtc = datetime_rtc.strftime('%s')# epoch
		return float(time_rtc)



mac_logger = Mac_logger() # init only
mac_logger.run() 



