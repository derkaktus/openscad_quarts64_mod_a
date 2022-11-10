$fn=150; 

shield_x=2;
shield_y=88;
shield_h=44;

tray_x=68;
tray_y=55;
tray_h=2;

tray_mount_y=2;
tray_offset_y=(shield_y-tray_y-2*tray_mount_y)/2;
tray_offset_h=2;

board_area_connecors=0;
board_area_cm=0;
board_area_pinhead=0;

board_hole_offset_x=tray_x-10.7-33;
board_hole_offset_x_back=tray_x-10.7;
board_hole_offset_y=3.5;
board_hole_offset_y_back=tray_y-3.5;
board_hole_d=3;

// ASSEMBLEY

translate([-shield_x,-tray_offset_y-tray_mount_y,-tray_offset_h])    shield();
                                                                     tray();

// MODULES

module tray(){
    // Beside the tray, all additional copnstructions, like traymount or inner framing are part of this module, only the punchholes themselfs are part of the shield.
    offset_h=tray_h+1+3;
    
    difference(){
        group(){
            cube([board_hole_offset_x,tray_y,tray_h]);
            translate([18,-tray_mount_y,0])cube([6,2,2]);
            translate([board_hole_offset_x,board_hole_offset_y,0])
                cylinder(d=board_hole_d+4*tray_mount_y,h=tray_h);
            translate([18,tray_y,0])cube([6,2,2]);
            translate([board_hole_offset_x,board_hole_offset_y_back,0])
                cylinder(d=board_hole_d+4*tray_mount_y,h=tray_h);
        }
        translate([board_hole_offset_x,board_hole_offset_y,0])
        cylinder(d=board_hole_d,h=tray_h);
        translate([board_hole_offset_x_back,board_hole_offset_y,0])
        cylinder(d=board_hole_d,h=tray_h);
        translate([board_hole_offset_x,board_hole_offset_y_back,0])
        cylinder(d=board_hole_d,h=tray_h);
        translate([board_hole_offset_x_back,board_hole_offset_y_back,0])
        cylinder(d=board_hole_d,h=tray_h);    
    }
    translate([board_hole_offset_x,board_hole_offset_y,tray_h-0.5])   
        screw_mount();

    translate([board_hole_offset_x,board_hole_offset_y_back,tray_h-0.5])
        screw_mount();


    
    translate([0,-tray_mount_y,0]) cube([6,tray_mount_y,tray_h+3+15.5]);
    //Tray mount bottom
    translate([4,-tray_mount_y,0]) hull(){
        translate([0,0,0])    cube([tray_h,tray_h,tray_h]);
        translate([12,0,0])   cube([tray_h,tray_h,tray_h]);
        translate([0,0,12])   cube([tray_h,tray_h,tray_h]);
    }
    //Tray mount middle
    difference(){
        group(){
            translate([0,tray_y,0]) cube([6,tray_mount_y,tray_h+3+15.5]);
            translate([4,tray_y,0]) hull(){
                translate([0,0,0])    cube([tray_h,tray_h,tray_h]);
                translate([12,0,0])   cube([tray_h,tray_h,tray_h]);
                translate([0,0,12])   cube([tray_h,tray_h,tray_h]);
            }
        }
        //Side Switch cutout
        hull(){
            translate([6,tray_y+tray_h,tray_h+6]) rotate([90,90,0]) cylinder(d=2,h=tray_h);
            translate([13,tray_y+tray_h,tray_h+6]) rotate([90,90,0]) cylinder(d=2,h=tray_h);
            translate([10,tray_y+tray_h,tray_h+7.5]) rotate([90,90,0]) cylinder(d=2,h=tray_h);
        }
    }
    //Tray mount top
    translate([-shield_x,-tray_mount_y,+1+3+15.5]) hull(){
        translate([0,0,0])   cube([tray_h,tray_h,tray_h]);
        translate([6,0,0])   cube([tray_h,tray_h,tray_h]);
        translate([0,0,6])   cube([tray_h,tray_h,tray_h]);
    }
    //Tray mount top
    translate([-shield_x,tray_y,+1+3+15.5]) hull(){
        translate([0,0,0])   cube([tray_h,tray_h,tray_h]);
        translate([6,0,0])   cube([tray_h,tray_h,tray_h]);
        translate([0,0,6])   cube([tray_h,tray_h,tray_h]);
    }      
    //OLED
    translate([0,(shield_y/2)-(39),+1+3+17]) difference(){
        cube([3,41.5,14.4]);
        translate([-1,1,1]) cube([4,39.5,12.4]);
    }
/*    //SWITCH
    translate([0,tray_offset_y+tray_mount_y+2+22.5,offset_h+23.4]) difference(){
        cube([3,14,6]);
        translate([0,1,1]) cube([3,12,4]);
    }
    //SWITCH
    translate([0,tray_offset_y+tray_mount_y+2+22.5,offset_h+15]) difference(){
        cube([3,14,6]);
        translate([0,1,1]) cube([3,12,4]);
    }
*/
    //LED
    translate([0,tray_offset_y+tray_mount_y+2+30,offset_h+12.5]) difference(){
        rotate([0,90,0]) cylinder(d=4,h=shield_x);
        rotate([0,90,0]) cylinder(d=3.12,h=shield_x);
    }
    //Switch
    translate([0,tray_offset_y+tray_mount_y+2+27,offset_h+15]) difference(){
        cube([3,6,14.4]);
        translate([0,1,1]) cube([3,4,12.4]);
    }
}

module shield(){
    mount_screw_offset_y=6;
    mount_screw_d=4;
    offset_h=tray_h+4.5;
    offset_io_h=offset_h+1.75;
    
    difference(){
        cube([shield_x, shield_y, shield_h]);
        translate([0,mount_screw_offset_y,shield_h/2])              rotate([0,90,0])            cylinder(d=mount_screw_d,h=shield_x);
        translate([0,shield_y-mount_screw_offset_y,shield_h/2])     rotate([0,90,0])            cylinder(d=mount_screw_d,h=shield_x);
        
        //Dual NIC
        translate([0,tray_offset_y+tray_mount_y+2,offset_h+1]) cube([shield_x,32,15.1]);
        //USB
        translate([0,tray_offset_y+tray_mount_y+2+32+2,offset_h+1]) cube([shield_x,7.5,15.1]);
        //USB3 mini
        translate([0,tray_offset_y+tray_mount_y+2+32+2+7.5+2.5,offset_h+1]) cube([shield_x,5,10]);
        
        //OLED
        translate([0,tray_offset_y+tray_mount_y+2+10,offset_h+19]) cube([shield_x,26,9.5]);
/*        //Switch
        translate([0,tray_offset_y+tray_mount_y+2+32+2+5.5+2,offset_h+17.5]) cube([shield_x,9,4]);
        //Switch
        translate([0,tray_offset_y+tray_mount_y+2+32+2+5.5+2,offset_h+25.9]) cube([shield_x,9,4]);
        //LED
        translate([0,tray_offset_y+tray_mount_y+2+32+2+7.5+3.5,offset_h+14])rotate([0,90,0]) cylinder(d=3,h=shield_x);
        //LED
        translate([0,tray_offset_y+tray_mount_y+2+32+2+7.5+9,offset_h+14])rotate([0,90,0]) cylinder(d=3,h=shield_x);
*/    
        //Switch
        translate([0,tray_offset_y+tray_mount_y+2+32+2+5.5+5,offset_h+19]) cube([shield_x,4,9]);
        //LED
        translate([0,tray_offset_y+tray_mount_y+2+32+2+7.5+5,offset_h+14])rotate([0,90,0]) cylinder(d=3,h=shield_x);
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

    tr_mount_out_rad=2.5;
    tr_mount_inn_rad=1.5;
    tr_mount_out_h=3;
    tr_mount_inn_h=0;
    tr_mount_thread_d=3;
    
 
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