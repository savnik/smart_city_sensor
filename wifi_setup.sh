#!/bin/bash
echo Setting up wifi for mac_int on Raspberry Pi...
echo Take wlan0 down
ifconfig wlan0 down
echo Delete wlan0
iw dev wlan0 del
echo Create mon0 in monitor mode
iw phy phy0 interface add mon0 type monitor
echo Take mon0 up
ifconfig mon0 up
echo Done...
