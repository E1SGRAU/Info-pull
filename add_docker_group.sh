#!/bin/bash 
read -p "Print name user: " name
sudo usermod -aG docker $name
sudo service docker restart
reboot
