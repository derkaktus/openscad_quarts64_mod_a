// created by derkaktus
//---------------------
// This file is seperated into the following areas for better understanding: 
//variables - description in the line above each
//assembly - mounting all parts aka modules together
//modules - splitting for reuse
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
tr_h=1.5;

    // Sets the radius size for the round corner on the tray end
tr_end_r=1;


    // Uses the x and y value above to populate soc_mount. If you need a different mount layout f.e. hole layout changes, eather change x and y or use absolute values in soc_mount array. The -0.5 on z is hard coded due to base socket of screwmount - so it melts into tray surface
soc_mount_x=4.6;
soc_mount_y=4.6;
soc_mount = [   [soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_x-soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_mount_x, soc_y-soc_mount_y, tr_h-0.5],
                    [soc_x-soc_mount_x, soc_y-soc_mount_y, tr_h-0.5]
                ];


// Screwmount
    //If sm_out_h is greater than sm_out_h screw hole is creater, else pin knob is created. Radius 2,5mm and 1,5mm is pine default.
sm_out_rad=2.5;
sm_inn_rad=1.5;
sm_out_h=2;
sm_inn_h=4;

    // Helpder variable. Don't change values her, rather change the initial variables 
soc_start_h=tr_h-0.5+sm_out_h;
echo(soc_start_h);

// Tray cutout
    //I used Distance of srew mounts +1 so we don't cut into the base foot mount
trc_arm_x=soc_mount_x+sm_out_rad+1;
trc_arm_y=soc_mount_y+sm_out_rad+1;
trc_front_x=30;

trc_block = [   [soc_mount_x+sm_out_rad+1, soc_mount_y+sm_out_rad+1, 0],
                [soc_x-soc_mount_x-sm_out_rad-1, soc_mount_y+sm_out_rad+1, 0],
                [soc_mount_x+sm_out_rad+1, soc_y-soc_mount_y-sm_out_rad-1, 0],
                [soc_x-soc_mount_x-sm_out_rad-1, soc_y-soc_mount_y-sm_out_rad-1, 0]
              ];
              
//shield_mount
shm_x=40;
shm_y=1.5;
shm_h=30;

//shield
// Used shield_ rather than sh_ as I confused with shm to often
//shield_x cannot be < 0.5 or thooth break surface
shield_x=1.5;
shield_y=89.5;
shield_h=88.90;



//---------------------------------------------------------------------------------------
//Assembly
//---------------------------------------------------------------------------------------

    //Shield mount -1 so it melts into shield
translate([shield_x-1,0,0])shield_mount();
translate([shield_x,shm_y,0]) difference(){
    tray();
    tray_outcut();
   
}
color("green")shield();


//---------------------------------------------------------------------------------------




//---------------------------------------------------------------------------------------
//Modules
//---------------------------------------------------------------------------------------

module shield(){
//Creates the shield cover, devided in module for IO and the rack mount around it. For easier printing, you can change the assambley above for shild only STL file. I added connection teeth for post process glueing. 
    
    shield_io();
        //Moving the shield for maximum space on PCIx side. The -12 space is what I need to mount into my rack frame.abs
    translate([0,-shield_y+tr_y+2*shm_y,-12])shield_rack();
    
    module shield_io(){
        //Part for the soc IO ports - or the space between the shield mounts ;)
        
        cube([shield_x,2*shm_y+tr_y,shm_h+tr_h]);
    
        translate([0.5,0,5])cube([shield_x,shm_y,5]);
        translate([0.5,0,15])cube([shield_x,shm_y,5]);
        translate([0.5,0,25])cube([shield_x,shm_y,5]);
    
        translate([0.5, tr_y+shm_y, 5])cube([shield_x,shm_y,5]);
        translate([0.5, tr_y+shm_y, 15])cube([shield_x,shm_y,5]);
        translate([0.5, tr_y+shm_y, 25])cube([shield_x,shm_y,5]);
    };
    
    module shield_rack(){
        difference(){
            cube([shield_x, shield_y, shield_h]);
            translate([0,shield_y/2,4+2])rotate([0,90,0])cylinder(h=shield_x,r=2);
            translate([0,shield_y/2,shield_h-4+-2])rotate([0,90,0])cylinder(h=shield_x,r=2);
        };
    };    
};

module shield_mount(){
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
// Creats the tray on which the rest is mounted. 


    hull(){
    //All size reduction magic in hull function is done so end radius doesn't change hull size
        translate([0,0,0])cube([tr_end_r,tr_end_r,tr_h]);
        translate([0,tr_y-tr_end_r,0])cube([tr_end_r,tr_end_r,tr_h]);

        translate([tr_x-tr_end_r,tr_end_r,0])cylinder(r=tr_end_r,h=tr_h);
        translate([tr_x-tr_end_r,tr_y-tr_end_r,0])cylinder(r=tr_end_r,h=tr_h);
    }

for(create_soc=soc_mount)translate(create_soc)screw_mount();
}


module tray_outcut(){
// I leave this optional as everbody loves his own cutout. So variabes for this section are inside the module
    hull(){
        for(create_trc=trc_block)translate(create_trc)cube([1,1,tr_h]);
    }    
// Area shield side I don t want to be cutted

   
    };
   
module screw_mount() {
// This module creates a mount for the board. If you want to screw down your board use a smaller hight for the inner cylinder than for the outer (sm_[out|inn]_h) one. Else you get a pin knob (default)
// In this version, the lower angle of the base foot cannot be changed by variables    
    
    if(sm_out_h<sm_inn_h){
        cylinder(r=sm_out_rad,h=sm_out_h);
        cylinder(r=sm_inn_rad,h=sm_inn_h);
    }
    else {
        difference(){
            cylinder(r=sm_out_rad,h=sm_out_h);
            cylinder(r=sm_inn_rad,h=sm_inn_h);
        }
    }
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