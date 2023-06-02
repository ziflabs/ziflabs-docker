sudo cp uhd-usrp.rules /etc/udev/rules.d/ # USRP
sudo cp sh_usb.rules /etc/udev/rules.d/ # Signal Hound
sudo cp sh_usb.rules /etc/udev/rules.d/ # SDRplay
sudo udevadm control --reload-rules
sudo udevadm trigger
