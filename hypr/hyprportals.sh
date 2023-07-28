#!/bin/bash
#had to change the name bc the scrpt was killall-ing iteself
set +x

sleep 1 
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
systemctl --user start xdg-desktop-portal-hyprland.service
sleep 2
systemctl --user start xdg-desktop-portal.service
