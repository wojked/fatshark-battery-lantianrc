$fn = 128;

DEPTH = 4; //23
MAX_WIDTH = 85;
MIN_WIDTH = 80;

BASE_WIDTH = 71.5;
BASE_HEIGHT = 39.5;

CUT_IN = 2.5;
CUT_IN_HEIGHT = 22.5;

MAX_HEIGHT = 47;
MARGIN_H = 12;
MARGIH_V = 7;

BAT_HEIGHT = 42.50;
BAT_WIDTH = 78.50;

CORNERS_CURVE = 5;

bottom();

module bottom(){
    scale()
    color("white")
    difference(){
        hull(){
            rounded_corners(BASE_WIDTH, MAX_HEIGHT, DEPTH/2, CORNERS_CURVE);
            rounded_corners(MAX_WIDTH, BASE_HEIGHT, DEPTH/2, CORNERS_CURVE);
        }
        
        translate([MAX_WIDTH/2,0,0])
        cut_in();
        
        translate([-MAX_WIDTH/2,0,0])
        cut_in();        
    
    }
}

module cut_in(){
    cube([CUT_IN*2, CUT_IN_HEIGHT, DEPTH*2], true);
}

module rounded_corners(width, height, depth, corner_curve){
    x_translate = width-corner_curve;
    y_translate = height-corner_curve;     
    
    hull(){
            translate([-x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);    
            
            translate([-x_translate/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);

            translate([x_translate/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
            
            translate([x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
    }        
}
