#!/bin/bash

#xbox 360 controller driver setup
# add xboxdrv to group of user running:  http://pingus.seul.org/~grumbel/xboxdrv/xboxdrv.html
# Configure:
# sudo visudo
# kiosk ALL=(ALL) NOPASSWD: /usr/bin/xboxdrv
sudo apt-add-repository -y ppa:rael-gc/ubuntu-xboxdrv
sudo apt-get update
sudo apt-get install ubuntu-xboxdrv
# Note: joystick calibration

# key binding for controller and mame (no layout provided)
sudo apt-get install qjoypad
# Run: qjoypad "<layout name>" --notray

