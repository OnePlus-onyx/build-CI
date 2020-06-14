# UBports GH Actions
This repository enables images to be built from GitHub Actions.

## Building Status:  
|                 Ubuntu Touch 7.1          |                  Ubuntu Touch 5.1                    | 
|:------------:|:------------:|
| ![Build Ubport 7.1](https://github.com/OnePlus-onyx/build-CI/workflows/Build%20Ubport%207.1/badge.svg?branch=ut-7.1)  |  ![Build Ubport 5.1](https://github.com/OnePlus-onyx/build-CI/workflows/Build%20Ubport%205.1/badge.svg?branch=ut-5.1)   |
| [Download](https://github.com/ubports-onyx/ubports-ci/actions?query=branch%3Aut-7.1) | [Download](https://github.com/ubports-onyx/ubports-ci/actions?query=branch%3Aut-5.1)                    | 
| [source tree](https://github.com/CicadaOS/halium-devices/blob/halium-7.1/manifests/oneplus_onyx.xml)  |   [source tree](https://github.com/CicadaOS/halium-devices/blob/halium-5.1/manifests/oneplus_onyx.xml)   |


### What working or Missing:  
|            |      Ubuntu Touch 7.1 (stable)          |                   Ubuntu Touch 5.1 （unstable now）                    | 
|:------------:|:------------:|:------------:|
| Ril |  OK   |    OK   |
| Sound | OK    |  OK  |
| Touch | OK    | OK   |
| Wifi | OK    |  ？   |
| notification lights | OK    | OK  |
| Vibration | OK    | OK   |
| Orientation sensor | OK    | OK   |
| Bluetooth | OK    | ?   |
| Flash light |  OK    | OK   |
| MTP | **NO**   | OK  |
| apparmor | OK    | OK   |
| Light Sensor | OK    | OK   |
| Battery | OK    | OK   |
| GPS | OK    |  Unknow   |
| Anbox | OK    | OK   |
| Libertine | **NO**    | **NO**   |
| camera | **NO**    | **NO**   |
| Hotspot | OK    | Unknow   |
| more |  ...    | ...   |

Legend:  ? - Works but need via command line manually

### Note:
  1. Ubuntu Touch 5.1 REQUIRES OXYGENOS 2.1.3 FIRMWARE!
  2. Ubuntu Touch 7.1 REQUIRES OXYGENOS 3.1.3/3.1.4 FIRMWARE!
  3. Ubuntu Touch 5.1 is unstable now and Ubuntu Touch 7.1  is recommended


### Install:  
   - Prerequisites: Unlocked bootloader , PC
   - TWRP from Official Twrp site and flash it into your OneplusX
   - You need system.img , halium-boot and latest ubports-touch rootfs
   - Download system & halium-boot from [here](https://github.com/ubports-onyx/ubports-ci/actions)
   - Download [ubports-touch.rootfs-xenial-armhf.tar.gz](https://github.com/ubports-onyx/ubports-ci/releases/tag/ubports-touch.rootfs-xenial)
   - Clone or download the [halium-install repository](https://gitlab.com/JBBgameich/halium-install)
   - reboot your phone to TWRP and  wipe Data partitions and make sure partitions are ext4
   - flash halium-boot.img to boot partition using TWRP.
   - do "path/to/halium-install -p ut path/to/rootfs.tar.gz path/to/system.img" through ADB.
   - Enjoy  

More detail about install ubuntu touch in [here](http://docs.ubports.com/en/latest/porting/installing-16-04.html#installing-ubuntu-touch-16-04-images-on-halium) 
