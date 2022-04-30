# Chromebook-Pixel-2013-Linux
A collection of scripts and other useful things to assist with running a Linux distribution natively on the Google CB001 (Codename: Link).

## Current Status
Here's what's working at the moment testing Ubuntu 22.04, Ubuntu MATE 22.04, Fedora 35:

- WiFi
- Bluetoothp using the command above
- Suspend/Hibernate
- Touchpad
- Display HDPI
- Display backlight
- Display touchscreen
- Sound
- Keyboard backlight
- Power Management 
- Fan Control (automated)

## Files
- **blacklist.sh** - Script to blacklist module *cros_ec_lpcs* and enable Linux to interract with firmware
- **chromeos_kbd** - Program to control the keyboard backlight LED's
- **keymaptable** - Reference table of default keys useful for creating bindings and shortcuts

## Prerequisites
1. A Chromebook Pixel 2013 with write protection screws removed (https://www.ifixit.com/Guide/Remove+the+Write+Protect+Screw/86362)
2. Installed latest *"Full ROM"* firmware from MrChromebox (https://mrchromebox.tech/#fwscript)
3. OS of choice installed via USB (tested only with Ubuntu Mate 22.04 LTS)

## Blacklisting the Chromeos Embedded Controller
This can be done using the **blacklist.sh** script:

1. Download file **blacklist.sh**
2. `./blacklist.sh`
3. Reboot

Or alternatively you can blacklist the module manually (example using nano text editor):

1. `sudo nano /etc/modprobe.d/blacklist.conf`
2. Add the following line to the code:
   `cros_ec_lpcs`
3. Update initramfs:
   `update iniframfs -u` 
4. Reboot the system

## Setting Keyboard LED brightness
This can be done using the **chromeos_kbd** program (you will need sudo as this appends information to the driver located at `/sys/class/leds/chromeos\:\:kbd_backlight/brightness`. <br/><br/>_NOTE: If this driver is missing from your OS you will need to install it first_

1. Download file **chromeos_kbd**
2. Copy the file to `/usr/local/bin/`
3. To display help run the program with parameter `sudo chromeos_kbd -h`
4. To set the LED to a percentage value (i.e 50%) use `sudo chromeos_kbd -s 70` 
5. To increase or decrease the LED value by 10% use `sudo chromeos_kbd -i` and `sudo chromeos_kbd -d`
6. To increase or decrease the LED value by x% use `sudo chromeos_kbd --increase x` and `sudo chromeos_kbd --decrease x`

_NOTE: For some reason the driver will not accept a value <1, so 1% brightness is the minimum allowed and you cannot turn off the LED completely in this way. For a workaround which allows for values outside of the limitations (i.e. 0% to turn the LED off) you can use:_

`sudo pkexec bash -c 'echo -n 0 > /sys/class/leds/chromeos::kbd_backlight/brightness'`

## Help and Troubleshooting

- Ubuntu MATE 22.04 Keyboard Shortcuts and Media Keys not working (or working intermittently)<br/>Run the following command: <br/><br/>`killall mate-settings-daemon && mate-settings-daemon` <br/><br/>_I dont know why this is happening (I suspect mate-settings-daemon and gnome-settings-daemon are interfering with eachother at login) but it can be fixed by reloading the settings-daemon and adding as a new startup entry_

- No Sound from Headphones: <br/><br/>Run `alsamixer` from terminal and use the `M` key to unmute the output

- Poor Battery Performance:  <br/><br/>Install `tlp` and either reboot or run `sudo tlp start`

- No Fans and High Temperature: <br/><br/>Install `lm-sensors` and run `sudo sensors-detect`. Also check that **cros_ec_lpcs** is properly blacklisted by running `lsmod | grep cros_ec_lpcs` (It should not show any output)

- High Fan Speed: <br/><br/>Firstly check output of `top` to rule out any rogue applications eating your CPU or Memory resources. Failing that it seems to be OS-specific, and depends upon whether your X session is rendering using software or the integrated GPU. You can try using using an alternative compositor or playing about with the compositor settings. It's trial and error but my system is consistently cool and stable under heavy loads using the _'Marco built-in Xpresent'_ profile. 

### Goodbye!
