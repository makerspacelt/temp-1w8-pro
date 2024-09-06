<a href="LICENSE"><img src="https://badgen.net/badge/Open Source/Hardware" /></a>
<a href="https://www.kicad.org/"><img src="https://badgen.net/badge/Made with/KiCAD" /></a>
---
![PCB 3d main](gen/img_pcb_3d_main.png)


This device is meant for temperature monitoring with up to 8 thermometers.

NOTE: This is only a prototype now, so things might not work and everything might change 

Basic target features:

* 8x 1-wire interfaces for DS18b20 using 2.5mm 4p audio jack connectors
* 2x user programmable buttons (can be used to wake up from deep sleep)
* 128x64 OLED display
* Powered via USB-C
* Compatibility with esphome and Home Assistant



Dev NOTE: before commit, run `./kibot.sh` to regenerate documentation, bom, gerbers and other assets.

* [schematics.pdf](gen/schematics.pdf)
* [pcb.pdf with dimensions](gen/pcb.pdf)
* [ibom.html](gen/single/ibom.html)


<img src="gen/img_pcb_2d_front_bare.jpg" width="19%" align="left" />
<img src="gen/img_pcb_2d_back_bare.jpg" width="19%" align="left" />
<img src="gen/img_pcb_3d_front.png" width="19%" align="left" />


---




