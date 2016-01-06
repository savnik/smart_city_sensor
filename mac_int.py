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
		try:
			Wireless(interface).setMode('Monitor')
			Wireless(interface).setFrequency(freq)
		except ValueError:
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

				print "%s \t %s \t %s" % (t, mac, rssi)

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
		row = [[time,mac,siglevel]]
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
		

	# perodic updating dt
	def perodic(self):
		# remove duplets in dt time interval
		mac_list_dt = []
		print self.mac_list
		for mac in self.mac_list:
			if mac: 	# Remove empty entities
				
				# if one or more elements in list check for duplet
				is_duplet = sum(x.count(mac[1]) for x in mac_list_dt)
				# check time stamp
				print mac
				time_mac = datetime.datetime.strptime(mac[0],"%Y-%m-%d %H:%M:%S")
				time_now = datetime.datetime.now()
				delta_t = time_now + datetime.timedelta(minutes = -self.dt)
				print delta_t
				if time_mac >= delta_t: print "OK"

				if is_duplet < 1 and time_mac >= delta_t:
					mac_list_dt.append(mac)
					print "Added!"	
		
		count_unique_macs = len(mac_list_dt)
		self.unique_macs_dt = count_unique_macs
		print "Count of Unique MACs: %d" % (count_unique_macs)
		self.display()
			


	# visualise
	def display(self):
		sense = SenseHat()
		sense.show_message(str(self.unique_macs_dt), text_colour=[255,0,2])

		
mac_int = Mac_int()

