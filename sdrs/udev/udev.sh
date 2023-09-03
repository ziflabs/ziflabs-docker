#!/bin/bash

sudo cp usrp.rules /etc/udev/rules.d/
sudo cp sighound.rules /etc/udev/rules.d/
sudo cp sdrplay.rules /etc/udev/rules.d/
sudo cp rtlsdr.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
