#!/bin/bash

# nginx start
/etc/init.d/nginx start

# Klipper start
/root/klippy-env/bin/python /root/klipper/klippy/klippy.py /root/printer_data/config/printer.cfg -I /root/printer_data/comms/klippy.serial -l /root/printer_data/logs/klippy.log -a /root/printer_data/comms/klippy.sock &

# Moonraker start
/root/moonraker-env/bin/python /root/moonraker/moonraker/moonraker.py -d /root/printer_data &
