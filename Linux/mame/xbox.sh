#!/bin/bash

#xbox 360 controller driver setup
sudo apt-add-repository -y ppa:rael-gc/ubuntu-xboxdrv
sudo apt-get update
sudo apt-get install ubuntu-xboxdrv
# Note: joystick calibration

# key binding for controller and mame (no layout provided)
sudo apt-get install qjoypad
# Run: qjoypad "<layout name>" --notray

