# QUARTZ64 Model A - rackmount

Welcome to my openSCAD project. When I started using PINE64 model A boards I stumbled over the issue that there is no mounting option to a standard 19" rack. If you can live with 4GB RAM and prefer the available Raspberry Pie rackmounts (check https://www.thingiverse.com/) buy the mode B board and leave this place ;) else go on.

![Front](https://github.com/derkaktus/openscad_quarts64_mod_a/blob/cf24e792cbb92464ba7cc287c550886e375a4679/pictures/single_long_front.png)


The goal of this project is to give you a versatile baseline with implemented adjustments (see variants below) to fit your basic needs or add some custom designs and share it back.

- [x] Ready to use in 2 HE rack frame
- [x] Short version for resin printers
- [x] Dual boad setup
- [x] Mounting options (know, screw ...)
- [ ] PCIx addon card rather than second board
- [ ] Cooling options
- [ ] Board adjustment clamp (between unused screw holes) for short dual varant
- [x] Shield design

Dokumentation backlog:
- [ ] Describe modules  
- [ ] Describe shield design include
- [ ] Describe addon cards

Used libraries:
- [threads-library-by-cuiso-v1](https://www.thingiverse.com/thing:3131126) You saved me some work here, thx 

## Variants
I added some variables in the **Buildoption variables** section for some quick adjustments.
  
***make_thread=[0|1]***
Depending on the printer you have access to and it's quality you can tell scad to cut a thred into the board mounts or not. The thread size is controlled by **sm_thread_d** (default is 3mm). If you dont want threads but still want to screw it, make use of **sm_out_h** and **sm_inn_h**

  Due to request: 
  
- Flat surface - Set sm_out_h == sm_inn_h.    
- Mounting pin knob (no thread) - Set sm_inn_h > sm_out_h so it creats the knob.
- Hollow tube (no thread) - Set sm_out_h > sm_inn_h so difference function will cut a tube.
- Hollow with thread tube - Set make_thread so sm_inn tube will be ignored and sm_thread_d used for thread size.  
  
  
***make_short=[0|1]***
Damn the board is to so long and the printer buildplate so short (or the patience) - this shrinks the board to a 2 mount point slim option. If you saw the picture below with the colored main parts, the red part marks the finish line.    
  
  
***make_dual=[0|1]*** 
Since we cannot mount the model A vertical, lets make the most out of the available space. With this option you can mount two boards per shield. You may wonder why I mirrored the second tray (z axis) rather than just adding one on top with same orientation, so try to reach the screw points while the mounts are blocked by the above ones ;)

Options can be combined as needed, else consulte the comment sections. 



## Part, modules and how it works
So as commented in the file, variable definition first, assembley section where the magic happens and the rest are the modules.

![main parts](https://github.com/derkaktus/openscad_quarts64_mod_a/blob/cf24e792cbb92464ba7cc287c550886e375a4679/pictures/main_parts_color.png)

On the picture you can see the three main parts: the shield (blue), the tray(green) and the support structure (red). 


