######################
#
# RTC functions 
# 11/1-2016
#
# 30571 Smart sensor city
#
# Setup i2c
# https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c 
#
# Documentation:
# https://www.campusnet.dtu.dk/cnnet/filesharing/SADownload.aspx?FileId=4058690&FolderId=967158&ElementId=506485
#
#####################


import time
import datetime
import SDL_DS1307


ds1307 = SDL_DS1307.SDL_DS1307(1, 0x68)
ds1307.write_now()

# Main Loop - sleeps 10 seconds, then reads and prints values of all clocks


while True:


 print ""
 print "Raspberry Pi=\t" + time.strftime("%Y-%m-%d %H:%M:%S")

 print "DS1307=\t\t%s" % ds1307.read_datetime()

 time.sleep(10.0)
