sudo cp uhd-usrp.rules /etc/udev/rules.d/
sudo cp sh_usb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
