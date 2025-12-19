# dell-fan-control-service
## Description
This project provides a custom fan control service for Dell PowerEdge servers. It enforces a custom fan speed curve based on CPU temperature, reducing noise when the server is not under heavy load. The service uses `ipmitool` to communicate with the iDRAC interface and adjust fan speeds accordingly.

The script runs 4 loops with 15s delay between each loop (45 seconds total) and can be executed via `systemd` or `cron`.

## Features

- Custom fan speed curve based on CPU temperature.
- Dynamic control enable/disable based on temperature threshold.
- Compatible with `systemd` and `cron`.
- Easy installation via `.deb` package.

## Requirements

- Dell PowerEdge server with iDRAC (tested on iDRAC 7 and 8).
- Your server must have only one CPU installed since the second CPU temperature will not be checked. You can fork and improve the script if this is important to you.
- ```ipmitool``` installed (auto installed when using .deb).

## Build package (script runs with systemd service)
- Clone this repository and go the the root directory
- Build package using ```bash dpkg-deb --build --root-owner-group dell-fan-control-service```
- Install package using ```dpkg -i``` or ```apt```

## Manual install (script runs with cron)
- Download only dell-fan-control-service.sh and place it where you want, usually /opt for manual installs.
- Allow execution with ```chmod +x /opt/dell-fan-control-service.sh``` (replace path if necessary)
- Edit your root crontab with ```sudo crontab -e``` ( if you want to run the script rootless, you user need to have access to the ipmi interface located at /dev/ipmi0, /dev/ipmi/0 or /dev/ipmidev/0 )
- Insert this line ```* * * * * /opt/dell-fan-control-service.sh``` (replace path if necessary)

## Credits
The core of the script is based on the work of brezlord, you can check his repo : https://github.com/brezlord/iDRAC7_fan_control/blob/master/fan_control.sh
Modifications are a slighly different fan curve, runtime optimization by removing unused instructions, adjustment for the minimum cron trigger time using 4 loops of 15s, and debian package build with auto systemd service installation