# Install Klipper, Mooneaker and Mainsail on Android Termux only

Original author: [과슈의 3D Printer](https://www.youtube.com/@gouache-3d-astro/) | The playlist was deleted.
## Requirements

1. Android phone with root permission
2. Octo4a
   - Needed for the usb port, install it before starting
3. F-Droid
   - Termux - Do not install termux from Google Play Store!
   - Termux:API
   - Termux:Boot
   - AnLinux

## Installation

1. Open Termux and change repo
   ```bash
   termux-change-repo
   ```
2. Select the first option "Rotate between mirrors" and press enter
3. Select your region, in my case Europe with space and press enter to continue
   - Wait for termux to change the mirrors
4. Make sure to update
   ```bash
   pkg update
   ```
5. Install openssh
   ```bash
   pkg install openssh ncurses-utils git tsu
   ```
<!-- 7. Clone termux-sudo and run the other commands, you can get them [here](https://gist.github.com/GabrielMMelo/0e146f32d73978bf0d0a06786bcbc96c)
   ```bash
   git clone https://gitlab.com/st42/termux-sudo
   cd termux-sudo
   cat sudo > /data/data/com.termux/files/usr/bin/sudo
   chmod 700 /data/data/com.termux/files/usr/bin/sudo
   ``` -->
8. Go to the home menu and open AnLinux
9. Select ubuntu or debian distro after clicking "choose"
   - I use Debian
10. Press copy button after selecting the distro and go back in termux
11. Paste the command from AnLinux and click enter
12. From now on you can continue with ssh from your pc. In order to connect to the phone run
    ```bash
    sshd
    ```
13. Change user password to connect with ssh
    ```bash
    passwd
    ```
    - To login from your pc use
      ```powershell
      ssh root@your_phone_ip_adress -p 8022
      ```
14. After the installation is done edit `start-debian/ubuntu.sh`
    ```bash
    nano ./start-debian.sh
    ```
15. Add `--system` to pulseaudio otherwise you get an error when running with sudo
16. Run the script
    `bash
    sudo ./start-debian/ubuntu.sh
    `

    > [!IMPORTANT]
    > Make sure to select grant "Always" in the root popup and accept

17. Once into the distro run
    ```bash
    apt update
    ```
18. Once into the distro run
    ```bash
    apt install sudo git nano
    ```
19. Clone the KIAUH script
    ```bash
    git clone https://github.com/dw-0/kiauh
    cd kiauh
    ```
20. Edit kiauh.sh and comment `check_euid`
21. Start the kiauh script
    ```bash
    ./kiauh.sh
    ```
22. Select 2 to use old kiauh
23. Select 1 to install
24. Select 1 to install klipper
    - Follow the default values and select Y to add the current user to the listed groups
25. Select 2 and install Moonraker
26. Select 3 and install Mainsail
    - Select Y to confirm the macro installation
27. Now press B and Q to exit

### Start Klipper
1. Check the content of klipper.service
    ```bash
    cat /etc/systemd/system/klipper.service
    ```
2. Copy `ExecStart` content WITHOUT `$KLIPPER_ARGS` and paste it in notepad
    In my case is `/root/klippy-env/bin/python`
3. Get the rest of the command
    ```bash
    cat ~/printer_data/systemd/klipper.env
    ```
4. Copy `KLIPPER_ARGS` content and paste it in the notepad after the command you got in the step 2. 
    - In my case is `/root/klipper/klippy/klippy.py /root/printer_data/config/printer.cfg -I /root/printer_data/comms/klippy.serial -l /root/printer_data/logs/klippy.log -a /root/printer_data/comms/klippy.sock`
5. You should have the complete command to start klipper, in my case is:
    ```bash
    /root/klippy-env/bin/python /root/klipper/klippy/klippy.py /root/printer_data/config/printer.cfg -I /root/printer_data/comms/klippy.serial -l /root/printer_data/logs/klippy.log -a /root/printer_data/comms/klippy.sock
    ```
6. Paste the command in the terminal and press `CTRL+Z` to execute it in background
    - Use the command `bg` to check the background process
7. Check the klipper logs
    ```bash
    tail -f ~/printer_data/logs/klippy.log
    ```
    - You should have many 'mcu' errors, this is normal
8. Find a printer.cfg file for your printer, and paste it in `~/printer_data/config/`
    > [!NOTE]
    > There are many in `~/klipper/configs` or online
### Start Moonraker
1. Check the content of moonraker.service
    ```bash
    cat /etc/systemd/system/moonraker.service
    ```
2. Copy `ExecStart` content WITHOUT `$MOONRAKER_ARGS` and paste it in notepad
    In my case is `/root/moonraker-env/bin/python`
3. Get the rest of the command
    ```bash
    cat ~/printer_data/systemd/moonraker.env
    ```
4. Copy `MOONRAKER_ARGS` content and paste it in the notepad after the command you got in the step 2.
    - In my case is: `/root/moonraker/moonraker/moonraker.py -d /root/printer_data`
5. You should have the complete command to start moonraker, in my case is:
    ```bash
    /root/moonraker-env/bin/python /root/moonraker/moonraker/moonraker.py -d /root/printer_data
    ```
6. Paste the command in the terminal and press `CTRL+Z` to execute it in background
    - Use the command `bg` to check the background process
7. Check the klipper logs
    ```bash
    tail -f ~/printer_data/logs/moonraker.log
    ```
### Start Mainsail (nginx)
1. Run
    ```bash
    /etc/init.d/nginx start
    ```
2. Nginx should be started you can check the webpage with one of the following steps:
    - On your phone open the browser and type on the url `localhost`
    - On your computer browser put the ip idress of your phone, es: `192.168.1.214/`
3. You should see an error like `404 Not Found`
4. Change the mainsail website configuration
    ```bash
    nano /etc/nginx/sites-enabled/mainsail
    ```
5. Edit `root /home/root/mainsail;` line with `root /root/mainsail;` and save
6. Reboot Nginx
    ```bash
    /etc/init.d/nginx restart
    ```
7. Test the website as done in step 2.

### Scripting
1. Copy `start-klipper.sh` to the distro root(home) folder
    - You can create the file and past the content in nano or use git
2. Exit debian/ubuntu, copy `start-debian.sh` in the same folder with another name like `start-debian-services`
    ```bash
    cp start-debian.sh start-debian-services.sh
    ```
3. Open `start-debian-services.sh` comment `command+=" /bin/bash --login"` and add `command+=" /bin/bash /root/start-klipper.sh"` in a new line after.
    ```bash
    nano start-debian-services.sh
    ```
    ```bash
    #command+=" /bin/bash --login"
    command+=" /bin/bash /root/start-klipper.sh"
    ```
