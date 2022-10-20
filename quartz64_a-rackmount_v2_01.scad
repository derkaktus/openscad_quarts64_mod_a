// quartz64_mod_A rack mount V2
// created by derkaktus

//

//LIBRARIES

use<threads-library-by-cuiso-v1.scad>


//VARIABLES

//Shortcut names for variables:
//tr tray

$fn=150; 

// tray mount variables
//If sm_out_h is greater than sm_out_h screw hole is creater, else pin knob is created. Radius 2,5mm and 1,5mm is pine default. There are currently 3 variants of the mount, se module describtion for details: Mounting pin knob (no thread), hollow tube (no thread), hollow thread tube.  

    tr_mount_out_rad=2.5;
    tr_mount_inn_rad=1.5;
    tr_mount_out_h=4;
    tr_mount_inn_h=6;
    tr_mount_thread_d=3;

// generic tray variables
// These values are the max buildsize for boards and therefor are used for full size calculations. Only the mountpoints and cutouts are board or card specific.

    tr_end_r=1;     // Sets the radius size for the round corner on the tray end
    tr_x=128;
    tr_short_x=40;  // Length of the trays for short variant 
    tr_y=80;        
    tr_h=2;

                          //Area in between these areas will be cutted out
    tr_mounting_area=12;  //Area starting at shield where mounts can be placed (x)
    tr_side_area=5;       //Area where mounts can be placed (y)
    tr_tail_area=5;       //Tail area
    tr_support_y=1.5;
    tr_support_h=30;
    
// generic shield variables 
    shield_x=2;
    shield_y=88;
    shield_h=88.40;
    

// x520 NIC tray

//    tr_x520_mounts_short = [ [tr_quartz_mount_x, tr_quartz_mount_y, tr_h-0.5],
//                          [tr_quartz_mount_x, tr_y-tr_quartz_mount_y, tr_h-0.5]//
//                          ];






//BUILD OPTIONS

  make_mount_thread=1;    //Set to 1 to put a thread into the tray mounts
  make_tray_short=1;      //Set to 1 to reduce tray_x to tray_short_x
                          //Orienation of the shield in relation to the tray (y axis). Possible values:
                          //left, center, right  
  make_shield="center";
  
  make_dual=0;
                          //Possible slot values: quartz64a,x520s,empty   
  make_slot1="quartz64a";      //Upper slot.
  make_slot2="empty";          //Lower slot.  

  
//ASSEMBLEY
    
    // Build oder for singe slot, top free 
    if(!make_dual){         
        echo("make_dual false");
        generic_tray();
        generic_shield();
        
        if(make_slot1=="quartz64a"){
            echo("slot1 quartz64a");
            translate([0,0,0])              quartz64a();
        }
        if(make_slot1=="x520s"){
            echo("slot1 x520s");
            translate([0,0,0])              x520s();
        }   
        if(make_slot1=="empty"){
            echo("slot1 empty");
            translate([0,0,0])              empty();
        }                  
    }
    
    // Build order for dual slot, generating, tray 
    if(make_dual){
        echo("make_dual true");
        translate([0,0,0])                 generic_tray();
        mirror([0,0,1])                    generic_tray();
        translate([0,0,0])                 generic_shield();
        mirror([0,0,1])                    generic_shield();
        
        // Slot one - up options     
        if(make_slot1=="quartz64a"){    
        echo("slot1 quartz64a");
        
        translate([0,0,0])                 quartz64a();
   
        }
    
        if(make_slot1=="x520s"){
        echo("slot1 x520s");
        
        translate([0,0,0])                 x520s();    
        }

        if(make_slot1=="empty"){
        echo("slot1 empty");
        
        translate([0,tr_y,0])
        translate([0,0,0])                  empty();    
        }
        
        // Slot two - low options
        if(make_slot2=="quartz64a"){
        echo("slot2 quartz64a");
        
        
        translate([0,tr_y,0])
        rotate([0,180,180])                     quartz64a();    
        }

        if(make_slot2=="x520s"){
        echo("slot2 x520s"); 
         
        rotate([0,180,180])translate([0,0,0])   x520s();    
        }
        
        if(make_slot2=="empty"){
        echo("slot2 empty");    
        
        translate([0,tr_y,0])
        rotate([0,180,180])translate([0,0,0])   empty();    
        }
} 
generic_shield();

//MODULES

module generic_tray(){
    //Generates generic tray eather short or long plus shield mount and cutout.
    //Rule of creation: The tray sets absolute x/y/z 0. Shield and other parts adjust in ASSEMBLEY section. 
    //For long variant x end corners are rounded (tr_end) - so here's all size reduction magic so end radius doesn't change hull size
    //For short variant x end merges with shield support, so no round edges    
 
    // Generates the short base tray form
    difference(){
        
        hull(){
                translate([0,0,0])                          cube([1,1,tr_h]);
                translate([0,tr_y-1,0])                     cube([1,1,tr_h]);
                translate([tr_short_x,0,0])                 cube([1,1,tr_h]);
                translate([tr_short_x,tr_y-1,0])            cube([1,1,tr_h]);   
            }

        hull(){      
                translate([tr_mounting_area+tr_end_r,tr_side_area+tr_end_r,0])  cylinder(r=tr_end_r,h=tr_h);
                translate([tr_mounting_area+tr_end_r,tr_y-tr_side_area ,0])     cylinder(r=tr_end_r,h=tr_h);      
                translate([tr_short_x-tr_tail_area,tr_side_area+tr_end_r,0])    cylinder(r=tr_end_r,h=tr_h);
                translate([tr_short_x-tr_tail_area,tr_y-tr_side_area,0])        cylinder(r=tr_end_r,h=tr_h);             
        }
    }
    
    // Adding shield support structure without teeth connectors
        
    hull(){
                translate([0,-tr_support_y,0])              cube([1,tr_support_y,tr_h]);
                translate([tr_short_x,-tr_support_y,0])     cube([1,tr_support_y,tr_h]);
                translate([0,-tr_support_y,tr_support_h])   cube([1,tr_support_y,1]);               
    }
    hull(){
                translate([0,tr_y,0])              cube([1,tr_support_y,tr_h]);
                translate([tr_short_x,tr_y,0])     cube([1,tr_support_y,tr_h]);
                translate([0,tr_y,tr_support_h])   cube([1,tr_support_y,1]);               
    }
    
    // Adds long part of the base tray
    if(!make_tray_short){
    difference(){
            
        hull(){
                translate([tr_short_x,0,0])                          cube([tr_end_r,tr_end_r,tr_h]);
                translate([tr_short_x,tr_y-tr_end_r,0])              cube([tr_end_r,tr_end_r,tr_h]);
                translate([tr_x-tr_end_r,tr_end_r,0])                cylinder(r=tr_end_r,h=tr_h);
                translate([tr_x-tr_end_r,tr_y-tr_end_r,0])           cylinder(r=tr_end_r,h=tr_h);
        }
        hull(){      
                translate([tr_short_x+2*tr_end_r,tr_side_area+tr_end_r,0])  cylinder(r=tr_end_r,h=tr_h);
                translate([tr_short_x+2*tr_end_r,tr_y-tr_side_area ,0])     cylinder(r=tr_end_r,h=tr_h);      
                translate([tr_x-tr_tail_area,tr_side_area+tr_end_r,0])      cylinder(r=tr_end_r,h=tr_h);
                translate([tr_x-tr_tail_area,tr_y-tr_side_area,0])          cylinder(r=tr_end_r,h=tr_h); 
        }        
    }
    }
}

module generic_shield(){
    //This creats the shield part around the tray cover/s (io,nic,empty...)

    shield_offset_h=-12; 

    //Somehow its easier to reuse the frame rather create and translate the differenced object
    module generic_shield_cut(){
    if(!make_dual){
        difference(){
            translate([0,0,+shield_offset_h])                                 cube([shield_x,shield_y,shield_h]);
            translate([0,(shield_y-tr_y)/2,tr_h])                             cube([shield_x,tr_y,tr_support_h]);
            
            translate([0,shield_y/4,4+2+shield_offset_h])
                rotate([0,90,0])                                              cylinder(h=shield_x,r=2);
            translate([0,shield_y-shield_y/4,4+2+shield_offset_h])
                rotate([0,90,0])                                              cylinder(h=shield_x,r=2);
            translate([0,shield_y/4,shield_h-4-2+shield_offset_h])
                rotate([0,90,0])                                              cylinder(h=shield_x,r=2);
            translate([0,shield_y-shield_y/4,shield_h-4-2+shield_offset_h])
                rotate([0,90,0])                                              cylinder(h=shield_x,r=2);
        }
    }
    
     if(make_dual){   
        difference(){
            cube([shield_x,shield_y,shield_h/2]);
            translate([0,(shield_y-tr_y)/2,tr_h])                               cube([shield_x,tr_y,tr_support_h]);
            translate([0,shield_y/4,shield_h/2-4-2])rotate([0,90,0])           cylinder(h=shield_x,r=2);
            translate([0,shield_y-shield_y/4,shield_h/2-4-2])rotate([0,90,0])  cylinder(h=shield_x,r=2);
        }
    }
    }    

    if(make_shield=="left"){
        echo("shield left");
        translate([-shield_x,-tr_support_y,0])                      generic_shield_cut();    
    }
    if(make_shield=="center"){
        echo("shield center");
        
        translate([-shield_x,-((shield_y-tr_y)/2),0])               generic_shield_cut();        
    }
    if(make_shield=="right"){
        echo("shield right");
        
        translate([-shield_x, -(shield_y-tr_y-tr_support_y),0])     generic_shield_cut();
    }
}

module quartz64a(){
    // Generates the mounts and io tray part of the shield
    
//I decided to put module specific variables here, as they are not ment to be changed
soc_mount_x=4.6;
soc_mount_y=4.6;   
soc_mount_long =  [ [soc_mount_x, soc_mount_y, tr_h-0.5],
                    [tr_x-soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_mount_x, tr_y-soc_mount_y, tr_h-0.5],
                    [tr_x-soc_mount_x, tr_y-soc_mount_y, tr_h-0.5]
                  ];
soc_mount_short = [ [soc_mount_x, soc_mount_y, tr_h-0.5],
                    [soc_mount_x, tr_y-soc_mount_y, tr_h-0.5]
                  ];

    //Creating the screw mounts here
    
    if(make_tray_short){
        for(create_soc=soc_mount_short)translate(create_soc)        screw_mount();
    }
    else{
        for(create_soc=soc_mount_long)translate(create_soc)         screw_mount();
            translate([tr_x-soc_mount_x, soc_mount_y, 0])           cylinder(r=tr_mount_out_rad+1,h=tr_h);
            translate([tr_x-soc_mount_x, tr_y-soc_mount_y, 0])      cylinder(r=tr_mount_out_rad+1,h=tr_h);    
    }    

    //Part for the soc IO ports.
    //Translation -shield_x is requires as x distance for mount is absolute to 0. As creation is combined with shield, this extra distance is needed - shield is -x area as tray starts at 0 nod shield nor suport.  
    
    translate([-shield_x,-tr_support_y,0])
    difference(){    
        cube([shield_x, 2*tr_support_y+tr_y, tr_support_h+tr_h]);
        // Power jack
        translate([0, tr_support_y+12.2,tr_h-0.5+tr_mount_out_h+1.3])cube([shield_x, 10.0,8.2]);
        // NIC
        translate([0, tr_support_y+12.2+10.0+8.5,tr_h-0.5+tr_mount_out_h+1.3]) cube([shield_x, 19.8,15.4]);
        // HDMI
        translate([0, tr_support_y+12.2+10.0+8.5+19.8+2.9,tr_h-0.5+tr_mount_out_h+1.3])cube([shield_x, 16.1, 7.2]);     
    }
    translate([-shield_x,-tr_support_y,0])
    //NIC housing
    hull(){
        translate([0, tr_support_y+12.2+10.8+7.7, tr_h-0.5+tr_mount_out_h+1.3])cube([shield_x,1.5,1.5]);
        translate([0, tr_support_y+12.2+10.8+7.7,tr_h-0.5+tr_mount_out_h+13.9+1.3])cube([10,1.5,1.5]);
        translate([0, tr_support_y+12.2+10.8+7.7,tr_h-0.5+tr_mount_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
    }
    translate([-shield_x,-tr_support_y,0])
    //NIC housing
    hull(){
        translate([0, tr_support_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+tr_mount_out_h+1.3])cube([shield_x,1.5,1.5]);
        translate([0, tr_support_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+tr_mount_out_h+13.9+1.3])cube([10,1.5,1.5]);
        translate([0, tr_support_y+12.2+10.8+7.7+1.5+16.8, tr_h-0.5+tr_mount_out_h+13.9+1.3])cube([shield_x,1.5,1.5]);
    }
    translate([-shield_x,-tr_support_y,0])
    //NIC housing roof
    translate([0, tr_support_y+12.2+10.8+7.7,tr_h-0.5+tr_mount_out_h+13.9+1.3])cube([10,19.8,1.5]);

}

module empty(){
    // Generates empty space and closed tray part of the shield
    
    //Translation -shield_x is requires as x distance for mount is absolute to 0. As creation is combined with shield, this extra distance is needed - shield is -x area as tray starts at 0 nod shield nor suport.
    translate([-shield_x,-tr_support_y,0])  cube([shield_x, 2*tr_support_y+tr_y, tr_support_h+tr_h]);
   
   //Creating the base under the screw mounts for long version
   if(!make_tray_short){
       translate([tr_x-4.6, 4.6, 0])           cylinder(r=tr_mount_out_rad+1,h=tr_h);
       translate([tr_x-4.6, tr_y-4.6, 0])      cylinder(r=tr_mount_out_rad+1,h=tr_h);   
   }
}

module screw_mount(){
    // This module creates a mount for the board. 
    // Four variants of the mount are possible:
    //    Flat surface - Set sm_out_h == sm_inn_h    
    //    Mounting pin knob (no thread) - Set sm_inn_h > sm_out_h so it creats the knob
    //    Hollow tube (no thread) - Set sm_out_h > sm_inn_h so difference function will cut a tube
    //    Hollow with thread tube - Set make_thread so sm_inn tube will be ignored and sm_thread_d used for thread size.   

    // In this version, the lower angle of the base foot cannot be changed by variables    

    if(make_mount_thread){
        // Doing thread - so we ignore inner cylinder
        difference(){
            cylinder(r=tr_mount_out_rad,h=tr_mount_out_h);
            translate([0,0,-1])thread_for_nut(diameter=tr_mount_thread_d, length=tr_mount_out_h+2);
        }  
    }
    else{
        if(tr_mount_out_h<tr_mount_inn_h){
            //In this case we trigger mounting pin knob
            cylinder(r=tr_mount_out_rad,h=tr_mount_out_h);
            cylinder(r=tr_mount_inn_rad,h=tr_mount_inn_h);
        }
        else if(tr_mount_out_h==tr_mount_inn_h){
            //In this case we trigger flat surface without anything else
            cylinder(r=tr_mount_out_rad,h=tr_mount_out_h);
        }    
        else {
            //In this case we trigger hollow tube. So we cut inner cylinder, with outer cylinder hight out
            difference(){
                cylinder(r=tr_mount_out_rad,h=tr_mount_out_h);
                cylinder(r=tr_mount_inn_rad,h=tr_mount_out_h);
            }
        }
    }
    
    // Creating base foot
    rotate_extrude(convexity=10)
        translate([tr_mount_out_rad-0.5,0,0]) {
            intersection() {
                square(5);
                difference() {
                square(3, center=true);
                translate([1.5,1.5]) circle (1);
                }
            }
        }
}
