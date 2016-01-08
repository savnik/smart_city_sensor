##### mac_int.py #####
#
# 5/1-2015
# By Peter Savnik
#
######################

from scapy.all import sniff, Dot11
from pythonwifi.iwlibs import Wireless, Iwrange
import csv
import time
import datetime
import os.path
from sense_hat import SenseHat
import hashlib
import os

class Mac_int:

	# 1 Collect Mac ADDR Probe Request
	# 2 MAC Filter
	# 3 Integrals
	# 4 Files
	# 5 Visualise

	def __init__(self):
		# Parameters
		interface = 'mon0'
		freq = '2442 MHz' # Mhz (channel 7)
		
		#Shared Variables
		self.mac_list = [[]] 	# [time, mac addr, signal level]
		self.white_list = []	# whitelist of mac addr
		self.dt = 1 		# sample time in minutes

		# Init wifi
		print "Init wifi..."
		while(1):
			try:
				Wireless(interface).setMode('Monitor')
				Wireless(interface).setFrequency(freq)
				break
			except:
				os.system("sh wifi_setup.sh")
				return "Wifi Initialisation failed!"
		
		self.loadWhiteList()		

		# Init interrupt
		sniff(iface=interface, prn=self.handler, store=0)

	# Handler for the running loop
	def handler(self,packet):
		
		# Check if packet is wifi
		if packet.haslayer(Dot11):
			# packet.type==0 is management type
			# packet.subtype==4 is probe request
			if packet.type == 0 and packet.subtype == 4:
					
				# For later use
				# if signal level is -256 ==> Error
				rssi = self.siglevel(packet) if self.siglevel(packet)!=-256 else -100
				mac = packet.addr2
				t = time.strftime("%Y-%m-%d %H:%M:%S",time.gmtime())

				# Put in list			
				self.mac_list.append([t,mac,rssi])

				#print "%s \t %s \t %s" % (t, mac, rssi)

				self.saveRawMacAddr2file()
				self.perodic()

				# data logging
				self.log_data_append(t, mac, rssi)
	
	# converts binary signal level to integer
	def siglevel(self, packet):
		return -(256-ord(packet.notdecoded[-4:-3]))

	
	#save raw mac addr to files
	def saveRawMacAddr2file(self):
		with open('raw_mac_addr.txt', 'wb') as f:
			writer = csv.writer(f)
			writer.writerows(self.mac_list)

	# Add row with observation to log
	def log_data_append(self, time, mac, siglevel):
		row = [[time,self.whitelist_filter(mac),siglevel]]
		with open('mac_log.txt', 'a') as f:
			writer = csv.writer(f)
			writer.writerows(row)


	# load or reload whitelist
	def loadWhiteList(self):
		file = 'white_list.txt'
		print "Loading white list..."
		if os.path.isfile(file):
			try:
				with open(file, 'rb') as f:
					reader = csv.reader(f)
					for row in reader:
						self.white_list.append(row)
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
	
	# hash all non white list mac addr
	def whitelist_filter(self, mac):
		print 
		if self.white_list.count(mac) > 0:
			return mac
		else:
			hash_object = hashlib.sha256(b'mac') 	# creates a hash object
			hash_hex = hash_object.hexdigest()	# takes the hash and outputs it in hex
			return hash_hex
	

	# perodic updating dt
	def perodic(self):
		#update mac_list
		self.update_mac_list()
		# remove duplets in dt time interval
		mac_list_dt = []
		#print self.mac_list
		for mac in self.mac_list:
			if mac: 	# Remove empty entities
				
				# if one or more elements in list check for duplet
				is_duplet = sum(x.count(mac[1]) for x in mac_list_dt)
				# check time stamp
				#print mac
				time_mac = datetime.datetime.strptime(mac[0],"%Y-%m-%d %H:%M:%S")
				time_now = datetime.datetime.now()
				delta_t = time_now + datetime.timedelta(minutes = -self.dt)
				#print delta_t
				#if time_mac >= delta_t: print "OK"

				if is_duplet < 1 and time_mac >= delta_t:
					mac_list_dt.append(mac)
					#print "Added!"	
		
		count_unique_macs = len(mac_list_dt)
		self.unique_macs_dt = count_unique_macs
		print "Count of Unique MACs: %d" % (count_unique_macs)
		
		self.mac_list_dt = mac_list_dt
		self.display2()
	

	# remove old entities in mac_list stack	
	def update_mac_list(self):
		# copy list to local
		mac_list = self.mac_list

		#set point in time
		time_now = datetime.datetime.now()
		delta_t = time_now + datetime.timedelta(minutes = -self.dt)

		#Loop
		done = False
		while done == False:
			i = 0 # index var (dummy)
			for mac in mac_list:
				# from str to datimetime
				print mac
				time_mac = datetime.datetime.strptime(mac[0],"%Y-%m-%d %H:%M:%S")
				# if out of time dt
				if time_mac < delta_t:
					print i
					mac_list.remove(i)
					break
				# add 1 to index var i
				i = i+1

		# update 
		self.mac_list = mac_list			

		# Print result for debug
		print len(mac_list)

	# visualise with scrolling text
	def display(self):
		sense = SenseHat()
		sense.show_message(str(self.unique_macs_dt), text_colour=[255,0,2])

	
	# virtualise graphical
	def display2(self):
		# Levels of dist
		d1 = self.int2rgb(self.siglevel_dt(-20,0))
		d2 = self.int2rgb(self.siglevel_dt(-40,-21))
		d3 = self.int2rgb(self.siglevel_dt(-60,-41))
		d4 = self.int2rgb(self.siglevel_dt(-100,-61))
		
		#print self.siglevel_dt(-50,0)	

		sense = SenseHat()
		pixels = [
		d4,d4,d4,d4,d4,d4,d4,d4,
		d4,d3,d3,d3,d3,d3,d3,d4,
		d4,d3,d2,d2,d2,d2,d3,d4,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d4,d3,d2,d1,d1,d2,d3,d4,
		d4,d3,d2,d2,d2,d2,d3,d4,
		d4,d3,d3,d3,d3,d3,d3,d4,
		d4,d4,d4,d4,d4,d4,d4,d4]
		
		sense.set_pixels(pixels)

	 
	def int2rgb(self,value):
		if value < 1:	# White
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
			if mac[2] >= low and mac[2] <= high:
				count = count+1
		return count



mac_int = Mac_int()

