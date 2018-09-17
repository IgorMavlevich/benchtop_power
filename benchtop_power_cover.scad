include <benchtop_power_common.scad>

tolerance=0.7;
bolt_diam=3;
bolt_head_height=2.8;
bolt_head_r=5.6/2;
cover_clearance = 10.5;
cover_thickness = 2;
led_window_thickness = 0.1;//set to 0 to make a hole
switch_body=[12,6,6.5];
switch_lever=[6,3.1,5];
            
module standoff(D_o=bolt_diam/2+cover_thickness, h=cover_clearance+cover_thickness){
    cylinder(h=h,r=D_o, center=false);
    translate([0,0,h-bolt_head_height-2])
    cylinder(h=bolt_head_height+2, r=bolt_head_r+cover_thickness-0.1, center=false);
}

module standoffs(){
    for (i=bolts_pos){
        translate(i)
        standoff();
     }
}

module bolt_top(shank=bolt_diam, head=bolt_head_r){
    cylinder(r=head,h=bolt_head_height+0.1, center=false);
    translate([0,0,-(cover_clearance+cover_thickness)+0.1])
    cylinder(r=shank/2, h=cover_clearance+cover_thickness,center=false);
}

module bolts_top(){
    translate([0,0,cover_clearance+cover_thickness-bolt_head_height])
    for(i=bolts_pos){
        translate(i)bolt_top();
    }
}

module put_switch(expansion=[4,1.5],position=switch_position){
    extrusion_h=cover_clearance+cover_thickness/2-switch_body[2];
    wall_thickness=1.45;
    difference(){
        union(){
            children();
            translate([0,0,cover_clearance/2]+position)
            cube([switch_body[0]+wall_thickness*2,
                  switch_body[1]+wall_thickness*2,cover_clearance],center=true);
            translate([0,0,switch_body[2]+cover_thickness/2]+position)
            linear_extrude(height=extrusion_h, 
                scale=[(expansion[0]*(switch_lever[0]+tolerance)+cover_thickness*2)/
                                     (switch_lever[0]+tolerance+cover_thickness*2),
                       (expansion[1]*(switch_lever[1]+tolerance)+cover_thickness*2)/
                                     (switch_lever[1]+tolerance+cover_thickness*2)])
                square([switch_lever[0]+cover_thickness*2,
                        switch_lever[1]+cover_thickness*2], center=true);
        }
        union(){
            translate([0,0,switch_body[2]/2]+position)
            cube(switch_body+[tolerance,tolerance,tolerance],center=true);
            translate([0,0,switch_body[2]+switch_lever[2]/2]+position)
            cube(switch_lever+[tolerance,tolerance,tolerance],center=true);
            translate([0,0,switch_body[2]+cover_thickness/2]+position)
            linear_extrude(height=cover_clearance-switch_body[2]+cover_thickness+.002, 
                            scale=expansion)
            square([switch_lever[0]+tolerance,switch_lever[1]+tolerance], center=true);
        }
    }
}
//projection(cut=true)
//rotate([90,0,0])
//put_switch();
module atx(){
    translate([0,board_size[1]/2-13,0]){
        translate([-7.5/2,13-5.6,10.5])
        cube([7.5,5.6,5], center=false);
        translate([-51.8/2,0,0])
        cube([51.8, 13, 10.5], center=false);
    }
}

module notch(wall_thickness=corner_radius){
    hull()
        for(i=[[-103/2,-13,-0.1],[103/2,-13,-0.1],[103/2,-13-50,-0.1],[-103/2,-13-50,-0.1]]){
            translate(i)
            cylinder(r=7+(corner_radius-wall_thickness), 
                     h=cover_clearance+cover_thickness+0.2,center=false);
        }
}

module shell(wall_thickness=corner_radius){
    difference(){
        hull()
        for (i=board_corners){
            translate(i)cylinder(r=wall_thickness, 
                                 h=cover_clearance+cover_thickness, center=false);
        }
        notch(wall_thickness=wall_thickness);
    }
}

module cover(){
    difference(){
        shell();
        translate([0,0,-cover_thickness])
        shell(corner_radius-cover_thickness);
    }
    standoffs();
}

module part(){
    difference(){
        cover();
        union(){
            bolts_top();
            notch();
            atx();
        }
    }
}

put_switch()
part();