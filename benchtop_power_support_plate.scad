include <benchtop_power_common.scad>

tolerance=0.7;
bolt_diam=3+tolerance;
terminal_depth = 11.5;
terminal_diam = 4+tolerance;

module hex_prism(across_flats, h){
    R=across_flats/sqrt(3);
    cylinder(r=R, h, center=true, $fn=6);
}

module nut_m3(){
    hex_prism(5.4+tolerance/2, h=3.1, center=true, $fn=6);
}

module nut_m4(){
    hex_prism(6.8+tolerance/2, h=3.1, center=true, $fn=6);
}

module terminal(){
    cylinder(r=terminal_diam/2, h=terminal_depth+.1, center=true);
    translate([0,0,(terminal_depth-0.6)/2])
    cylinder(r=(8.9+tolerance)/2, h=0.6+0.1, center=true);
    translate([0,0,(terminal_depth-3)/2-0.6])
    nut_m4();
    translate([0,0,-(terminal_depth-5)/2])
    cylinder(r=(10/2)+tolerance, h=5+0.1, center=true);
}

module bolt(){
    cylinder(r=bolt_diam/2, h=terminal_depth+1, center=true);
    translate([0,0,-(terminal_depth-3)/2])
    nut_m3();
}

module pin(){
    translate([0,0,(terminal_depth-1)/2])
    cylinder(r1=(1+tolerance)/2, r2=(3+tolerance)/2, h=2, center=true);
}

module fuse_holder(){
    for (i=[-1:2:1]){
        translate([i*(17/2),0,0]){
            translate([5.5/2,0,0])pin();
            translate([-5.5/2,0,0])pin();
        }
    }
}

module pins(){
    //Fuse holders
    translate([0,-2.5,0])
    for (i=[0:3]){
        translate([-88.5/2,0,0])
        translate([i*88.5/3,0,0])
        fuse_holder();
    }
    //ATX socket
    translate([0,4,0])
    for (i=[-(12-1)/2:(12-1)/2]){
        translate([i*46.5/11,0,0])
        pin();
        translate([0,5.5,0])
        translate([i*46.5/11,0,0])
        pin();
    }
    //Switch
    translate(switch_position)
    for (i=[-2:2]){
        translate([i*11.5/4,0,0])
        pin();
    }
    //LED
    translate([31.5,12,0])
    union(){
        pin();
        translate([10.5,0,0])pin();
        translate([10.5/2,4.5,0]){
            pin();
            translate([0,2.5,0])pin();
        }
    }
}

module plate(){
    difference(){
        hull(){
            for (i=board_corners){
                translate(i)
                cylinder(r=corner_radius, h=terminal_depth, center=true);
            }
        }
        union(){
            for (i=[-(terminal_count-1)/2:1:(terminal_count-1)/2]){ //terminals
                translate([terminal_spacing*i,-13,0])
                terminal();
            }
            for (i=bolts_pos){ //bolts
                translate(i)bolt();
            }
            pins();
        }
    }
}
translate([0,0,-10])
plate();