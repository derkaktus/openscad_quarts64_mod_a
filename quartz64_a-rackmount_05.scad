// created by derkaktus
//---------------------
// This file is seperated into the following areas for better understanding: 
//variables - description in the line above each
//assembly - mounting all parts aka modules together
//modules - splitting for reuse

use<threads.scad>

$fn=150; 

//Variables 
//---------
//
// Size of the quartz circuit board.
soc_x=128;
soc_y=80;
soc_h=1;

// Tray
// Default size of tray is ment to be size of soc.
tr_x=128;
tr_y=80;
tr_h=2;

    // Sets the radius size for the round corner on the tray end
tr_end_r=1;


    // Uses the x and y value above to populate soc_mount. If you need a different mount layout f.e. hole layout changes, eather change x and y or use absolute values in soc_mount array. The -0.5 on z is hard coded due to base socket of screwmount - so it melts into tray surface
soc_mount_x=4.6;
soc_mount_y=4.6;
soc_mount_long =  [ [soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_x-soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_mount_x, soc_y-soc_mount_y, tr_h-0.5],
                    [soc_x-soc_mount_x, soc_y-soc_mount_y, tr_h-0.5]
                  ];
soc_mount_short = [ [soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_mount_x, soc_y-soc_mount_y, tr_h-0.5]
                  ];


// Screwmount
    //If sm_out_h is greater than sm_out_h screw hole is creater, else pin knob is created. Radius 2,5mm and 1,5mm is pine default. There are currently 3 variants of the mount, se module describtion for details: Mounting pin knob (no thread), hollow tube (no thread), hollow thread tube.  
sm_out_rad=2.5;
sm_inn_rad=1.5;
sm_out_h=2;
sm_inn_h=4;
sm_thread_d=3;

// Tray cutout
    //I used Distance of srew mounts +1 so we don't cut into the base foot mount
trc_arm_x=soc_mount_x+sm_out_rad+1;
trc_arm_y=soc_mount_y+sm_out_rad+1;
trc_front_x=30;

//shield_mount, flanking postion of the tray
shm_x=40;
shm_y=1.5;
shm_h=30;

trc_block_long  = [ [soc_mount_x+sm_out_rad+1, soc_mount_y+sm_out_rad+1, 0],
                    [soc_x-soc_mount_x-sm_out_rad-1, soc_mount_y+sm_out_rad+1, 0],
                    [soc_mount_x+sm_out_rad+1, soc_y-soc_mount_y-sm_out_rad-1, 0],
                    [soc_x-soc_mount_x-sm_out_rad-1, soc_y-soc_mount_y-sm_out_rad-1, 0]
                  ];
trc_block_short = [ [soc_mount_x+sm_out_rad+1, soc_mount_y+sm_out_rad+1, 0],
                    [shm_x-trc_arm_x+1, soc_mount_y+sm_out_rad+1, 0],
                    [soc_mount_x+sm_out_rad+1, soc_y-soc_mount_y-sm_out_rad-1, 0],
                    [shm_x-trc_arm_x+1, soc_y-soc_mount_y-sm_out_rad-1, 0]
                  ];               
              

//shield
// Used shield_ rather than sh_ as I confused with shm to often
//shield_x cannot be < 0.5 or thooth break surface
shield_x=2;
shield_y=89.5;
shield_h=88.90;
//Shield offset values to move the extra space around tray. y=0 means no space on the PCIx side of the board.
shield_offset_y=0;
//Space below the tray on the shield f.e. space for a mount frame
shield_offset_h=-12;
//Sice for the soc shield and the pcix shield. Rule: shield_h > 2*shield_addons_h -(2*shield_offset_h) minus because offset_h is negativ ;)
shield_addons_h=30;
//shield_h+shield_offset

// Helpder variable. Don't change values her, rather change the initial variables
 
    //Value at which the soc starts from shield perspective. Important for cutouts on the shield 
soc_start_h=tr_h-0.5+sm_out_h-shield_offset_h;
echo(soc_start_h);

//Buildoption variables
//---------------------
  //Set to 0 if you don't want thread cuttings for screws  
make_thread=1;
  //Set to 1 if you need a short version (f.e. to print on resin printer). Tray ends behind shield support. Default 0 (long version)
make_short=1;


//---------------------------------------------------------------------------------------
//Assembly
//---------------------------------------------------------------------------------------
// Assembly works as follow: 
// x axis: shield_x for shield, -1 so teeth and shield mound blent into each other, tray
// y axis; shm_y for shield mount, tr_y tray, shm_y shield mount


    // Adding tray with offset of the shield mount(y) and shield(x)
//translate([shield_x,shm_y,0])tray();

    // Adding shield mounts with offset shield (x) - 1 to melt propperly
//translate([shield_x-1,0,0])shield_mount();


//translate([0,-shield_y+tr_y+2*shm_y,-shield_offset_h])
shield();


    //debug_shield();

//translate([shield_x,0,0])debug_shield_old();

//---------------------------------------------------------------------------------------
//Modules
//---------------------------------------------------------------------------------------
 

module shield(){
//Creates the shield cover. For easier printing, you can change the assambley above for shield only STL file. I added connection teeth for post process glueing. 
// For putting all in assambly together, only the shield is moving, connectors a.s.o. are fixed to the tray, support.
// Main shield has two slots - one for the soc IO (shield_soc) one for the extra pcix card (shield_pcix).    
    
    shield_main();
    shield_soc();
    shield_connector();
    shield_pcix(); 
}

module shield_main(){
    //Creates the main shield with thte rack screw holes 

difference(){
    translate([0,shield_offset_y,shield_offset_h])    
    difference(){
        cube([shield_x, shield_y, shield_h]);
        translate([0,shield_y/2,4+2])rotate([0,90,0])cylinder(h=shield_x,r=2);
        translate([0,shield_y/2,shield_h-4+-2])rotate([0,90,0])cylinder(h=shield_x,r=2);
    }
        //soc io shield cutout
    cube([shield_x, 2*shm_y+tr_y, shield_addons_h+tr_h]);
        //pcix io shield cutout
    translate([0,0,shield_addons_h+tr_h])cube([shield_x, 2*shm_y+tr_y, shield_addons_h+tr_h]);
}
}

module shield_soc(){
    //Part for the soc IO ports - or the space between the shield mounts ;)
    // NIC housing
    
    difference(){    
        cube([shield_x, 2*shm_y+tr_y, shm_h+tr_h]);
        // Power jack
        translate([0, shm_y+12.2,tr_h-0.5+sm_out_h+1.3])cube([shield_x, 10.8,8.2]);
        // NIC
        translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+1.3]) cube([shield_x, 19.8,15.4]);
        // HDMI
        translate([0, shm_y+12.2+10.8+7.7+19.8+3,tr_h-0.5+sm_out_h+1.3])cube([shield_x, 17, 7.2]);     
    }
    
    hull(){
        translate([0, shm_y+12.2+10.8+7.7, tr_h-0.5+sm_out_h+1.3])cube([shield_x,1.5,1.5]);
        translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([10,1.5,1.5]);
        translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
    }
    hull(){
        translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+1.3])cube([shield_x,1.5,1.5]);
        translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+13.9+1.3])cube([10,1.5,1.5]);
        translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
    }
    translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([10,19.8,1.5]);
};

module shield_pcix(){
    translate([0,0,shield_addons_h+tr_h]) cube([shield_x, 2*shm_y+tr_y, shm_h+tr_h]);
}
    
module shield_connector(){
    // Creats the teeth connectors for the shield
    translate([0.5,0,5])cube([shield_x,shm_y,5]);
    translate([0.5,0,15])cube([shield_x,shm_y,5]);
    translate([0.5,0,25])cube([shield_x,shm_y,5]);
    
    translate([0.5, tr_y+shm_y, 5])cube([shield_x,shm_y,5]);
    translate([0.5, tr_y+shm_y, 15])cube([shield_x,shm_y,5]);
    translate([0.5, tr_y+shm_y, 25])cube([shield_x,shm_y,5]);
    };    


module shield_mount(){
// Support structure on the side of the tray. For full y length without shield, two times this + tr_y 
    difference(){
        hull(){
            translate([0,0,0])cube([1,shm_y,tr_h]);
            translate([shm_x,0,0])cube([1,shm_y,tr_h]);
            translate([0,0,shm_h])cube([1,shm_y,tr_h]);
        }
        //connector "tooth" for for shield
        translate([0,0,5])cube([shield_x-0.5,shm_y,5]);
        translate([0,0,15])cube([shield_x-0.5,shm_y,5]);
        translate([0,0,25])cube([shield_x-0.5,shm_y,5]);
    }

    difference(){
        hull(){
            translate([0,tr_y+shm_y,0])cube([1,shm_y,tr_h]);
            translate([shm_x,tr_y+shm_y,0])cube([1,shm_y,tr_h]);
            translate([0,tr_y+shm_y,shm_h])cube([1,shm_y,tr_h]);
        } 
        //connector "tooth" for for shield
        translate([0, tr_y+shm_y, 5])cube([shield_x-0.5,shm_y,5]);
        translate([0, tr_y+shm_y, 15])cube([shield_x-0.5,shm_y,5]);
        translate([0, tr_y+shm_y, 25])cube([shield_x-0.5,shm_y,5]);
    } 
    
    translate([shm_x-trc_arm_x+1,0,0])cube([trc_arm_x,shm_y*2+tr_y,tr_h]);

};
    

module tray(){;
// Creats the tray on which the rest is mounted. Normal variant has 4 screw mounts, short only two and length is reduced to shield mount x length.

    difference(){
        hull(){
        //For long variant x end corners are rounded (tr_end) - so here's all size reduction magic so end radius doesn't change hull size
        //For short variant x end merges with shield support, so no round edges
            if(make_short){
                translate([0,0,0])cube([1,1,tr_h]);
                translate([0,tr_y,0])cube([1,1,tr_h]);

            translate([shm_x-1,0,0])cube([1,1,tr_h]);
            translate([shm_x-1,tr_y,0])cube([1,1,tr_h]);   
            }
            else{
                translate([0,0,0])cube([tr_end_r,tr_end_r,tr_h]);
                translate([0,tr_y-tr_end_r,0])cube([tr_end_r,tr_end_r,tr_h]);

                translate([tr_x-tr_end_r,tr_end_r,0])cylinder(r=tr_end_r,h=tr_h);
                translate([tr_x-tr_end_r,tr_y-tr_end_r,0])cylinder(r=tr_end_r,h=tr_h);
            }
        }
        tray_outcut();
    }
        //Adding short version magic to screw mount creation
    if(make_short){
    for(create_soc=soc_mount_short)translate(create_soc)screw_mount();
    }
    else{
        for(create_soc=soc_mount_long)translate(create_soc)screw_mount();
    }

}

module tray_outcut(){
    // If you want some fancy cutouts to the tray, edit this module. 
    hull(){
        if(make_short){
            for(create_trc=trc_block_short)translate(create_trc)cube([1,1,tr_h]);
        }
        else{
            for(create_trc=trc_block_long)translate(create_trc)cube([1,1,tr_h]);
        }
    }    
    
};
   
module screw_mount(){
// This module creates a mount for the board. 
// Four variants of the mount are possible:
//    Flat surface - Set sm_out_h == sm_inn_h    
//    Mounting pin knob (no thread) - Set sm_inn_h > sm_out_h so it creats the knob
//    Hollow tube (no thread) - Set sm_out_h > sm_inn_h so difference function will cut a tube
//    Hollow with thread tube - Set make_thread so sm_inn tube will be ignored and sm_thread_d used for thread size.   

// In this version, the lower angle of the base foot cannot be changed by variables    

    if(make_thread){
        // Doing thread - so we ignore inner cylinder
        difference(){
            cylinder(r=sm_out_rad,h=sm_out_h);
            translate([0,0,-1])thread_for_nut(diameter=sm_thread_d, length=sm_out_h+2);
        }  
    }
    else{
        if(sm_out_h<sm_inn_h){
            //In this case we trigger mounting pin knob
            cylinder(r=sm_out_rad,h=sm_out_h);
            cylinder(r=sm_inn_rad,h=sm_inn_h);
        }
        else if(sm_out_h==sm_inn_h){
            //In this case we trigger flat surface without anything else
            cylinder(r=sm_out_rad,h=sm_out_h);
        }    
        else {
            //In this case we trigger hollow tube. So we cut inner cylinder, with outer cylinder hight out
            difference(){
                cylinder(r=sm_out_rad,h=sm_out_h);
                cylinder(r=sm_inn_rad,h=sm_out_h);
            }
        }
    }
    
    // Creating base foot
    rotate_extrude(convexity=10)
        translate([sm_out_rad-0.5,0,0]) {
            intersection() {
                square(5);
                difference() {
                square(3, center=true);
                translate([1.5,1.5]) circle (1);
                }
            }
        }
}

module screw_mount_pcix_card(){
// This module creats a screw point for the extra pcix card
difference(){
    union(){
        difference(){
            translate([0,0,0])sphere(r=3.5,$fn=100);
            translate([-3.5,-3.5,0])cube([7,7,3.5]);
        }
        translate([-3.5,-3.5,0])hull(){
            translate([0,0,0])cube(1);
            translate([0,6,0])cube(1);
            translate([3.5,3.5,0])cylinder(r=3.5,h=1,$fn=100);    
            };
        }
    if(make_thread){translate([0,0,-3.5])thread_for_nut(diameter=3, length=4.5);}
    }

}

// Modules down here are for differend add on cards with there unique shield and mount positions

module pcix_x520_single(){
// Intel single GBIC port NIC x520
   module x520_shield(){
    
    difference(){
        cube([shield_x,61,15]);
            //NIC opening
        translate([0,38.7,2])cube([shield_x,15.3,10.3]);
            //status LED Action 2,9x1,9
        translate([0,35.7,2])cube([shield_x,1.9,2.9]);
        translate([1,36.8,12])rotate([0,90,180])linear_extrude(1)text("Act/Link",size=1);
            //status LED 10G 2,9x1,9
        translate([0,32.7,2])cube([shield_x,1.9,2.9]); 
        translate([0,34,12])rotate([0,90,180])linear_extrude(1)text("GRN:10G",size=1);
    }
}

module x520_connector(){
    cube([3,61,1]);
    translate([3,0,0])cube([2,7,1]);
    translate([8.5,3.5,0])nic_nob();
    translate([3,54,0])cube([2,7,1]);
    translate([8.5,57.5,0])nic_nob();
    }
}

module nic_nob(){
    difference(){
        union(){
            difference(){
                translate([0,0,0])sphere(r=3.5,$fn=100);
                translate([-3.5,-3.5,0])cube([7,7,3.5]);
            }
            translate([-3.5,-3.5,0])hull(){
                translate([0,0,0])cube(1);
                translate([0,6,0])cube(1);
                translate([3.5,3.5,0])cylinder(r=3.5,h=1,$fn=100);    
            }
            }
        translate([0,0,-3.5])thread_for_nut(diameter=3, length=4.5);
    }
}   

module debug_shield(){

                // Creats the teeth connectors for the shield
        translate([0.5,0,5])cube([shield_x,shm_y,5]);
        translate([0.5,0,15])cube([shield_x,shm_y,5]);
        translate([0.5,0,25])cube([shield_x,shm_y,5]);
    
        translate([0.5, tr_y+shm_y, 5])cube([shield_x,shm_y,5]);
        translate([0.5, tr_y+shm_y, 15])cube([shield_x,shm_y,5]);
        translate([0.5, tr_y+shm_y, 25])cube([shield_x,shm_y,5]);

    difference(){    
        cube([shield_x, 2*shm_y+tr_y, shm_h+tr_h]);
        // Power jack
        translate([0, shm_y+12.2,tr_h-0.5+sm_out_h+1.3])cube([shield_x, 10.8,8.2]);
        // NIC
        translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+1.3]) cube([shield_x, 19.8,15.4]);
        // HDMI
        translate([0, shm_y+12.2+10.8+7.7+19.8+3,tr_h-0.5+sm_out_h+1.3])cube([shield_x, 17, 7.2]);     
            }
        // NIC housing
        hull(){
            translate([0, shm_y+12.2+10.8+7.7, tr_h-0.5+sm_out_h+1.3])cube([shield_x,1.5,1.5]);
            translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([10,1.5,1.5]);
            translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
        }
        hull(){
            translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+1.3])cube([shield_x,1.5,1.5]);
            translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+13.9+1.3])cube([10,1.5,1.5]);
            translate([0, shm_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+sm_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
        }
        
        //translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+1.3])cube([4,1.5,15.4]);  
        
        //translate([0, shm_y+12.2+10.8+7.7+1.5+16.8,tr_h-0.5+sm_out_h+1.3])cube([4,1.5,15.4]);
        translate([0, shm_y+12.2+10.8+7.7,tr_h-0.5+sm_out_h+13.9+1.3])cube([10,19.8,1.5]);    
} 