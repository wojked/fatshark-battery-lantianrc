$fn = 128;

DEPTH = 4; //23
MAX_WIDTH = 85.5; //85
MIN_WIDTH = 80;

BASE_WIDTH = 75; //71.5
BASE_HEIGHT = 44.5; //39.5

CUT_IN = 2.5;
CUT_IN_HEIGHT = 22.5;

MAX_HEIGHT = 47.5; //47
MARGIN_H = 12;
MARGIH_V = 7;

BAT_HEIGHT = 42.00;
BAT_WIDTH = 78.50;
BAT_DEPTH = 5; // ??

PCB_HEIGHT = 42.50; //42.00
PCB_WIDTH = 79.0;  //78.50
PCB_DEPTH = 1.55;   //1.55

BATTERY_BASKET_HEIGHT = 40.50;
BATTERY_BASKET_WIDTH = 78.00;
BATTERY_BASKET_DEPTH = 21.88;

CORNERS_CURVE = 5;

//USB MICRO, TODO: add real numbers
USB_MICRO_WIDTH = 5.8; 
USB_MICRO_HEIGHT = 8.5; //8
USB_MICRO_DEPTH = 2.55;

//USB STANDARD, TODO: add real numbers
USB_STANDARD_WIDTH = 10; 
USB_STANDARD_HEIGHT = 15.5; //14.9
USB_STANDARD_DEPTH = 7.22;

//BATTERY CHECK
BATTERY_CHECK_WIDTH = 5; // 4.6
BATTERY_CHECK_HEIGHT = 5.08;
BATTERY_CHECK_DEPTH = 6.20;
BATTERY_CHECK_OFFSET = 13.85; //13.85

//Inkscape scale
SCALE = 3.58;

EXPLODE = 0;

DEBUG = false;
DEBUG_HINT = false;

bottom();
//translate([0,0,20])
//top();


module bottom(){
    battery_support_layer = 10;
    
    if(battery_support_layer>0){    
        color("grey")
        translate([0,0,battery_support_layer/2])
        lantian_battery_support_layer(battery_support_layer);
           
        // This can to be commented out once we have all the shapes
        if(DEBUG_HINT){
            color("blue")
            translate([0,0,10 + EXPLODE*2])    
            union(){
                rotate([180,0,0])
                scale([SCALE,SCALE,1])
                inkscape_battery();
            }     
        }   
    }
}

module top(){
    top_layer = 2;
    
    if(top_layer>0){
        color("white")
        translate([0,0,top_layer/2])
        main_shape(top_layer);
    } 
}

module main_shape(depth){
    // This is the main shape of the case
    difference(){
        hull(){
            rounded_corners(BASE_WIDTH, MAX_HEIGHT, depth, CORNERS_CURVE);
            rounded_corners(MAX_WIDTH, BASE_HEIGHT, depth, CORNERS_CURVE);
        }
        
        translate([MAX_WIDTH/2,0,0])
        cut_in();
        
        translate([-MAX_WIDTH/2,0,0])
        cut_in();        
    
    }    
}

module cut_in(){
    cube([CUT_IN*2, CUT_IN_HEIGHT, DEPTH*4], true);
}

module battery(){
    translate([0,0,PCB_DEPTH/2])
    union(){        
        
        color("grey")
        translate([0,0,PCB_DEPTH/2 + BATTERY_BASKET_DEPTH/2])        
        battery_basket();
        
        color("red")
        battery_pcb(10,PCB_DEPTH+10);
        
        color("white")
        translate([0,0,-PCB_DEPTH/2])        
        battery_pcb_components(PCB_DEPTH);    
    }
}

module battery_basket(){
    cube([BATTERY_BASKET_WIDTH, BATTERY_BASKET_HEIGHT, BATTERY_BASKET_DEPTH], true);        
}

module battery_pcb(hull_size, hull_size_down){
    hull(){
        cube([PCB_WIDTH, PCB_HEIGHT, PCB_DEPTH], true);    
        
        if(hull_size>PCB_DEPTH){                
            translate([0, 0, hull_size-PCB_DEPTH])                
            cube([PCB_WIDTH, PCB_HEIGHT, PCB_DEPTH], true);    
        }
        
        if(hull_size_down>PCB_DEPTH){                
            translate([0, 0, PCB_DEPTH-hull_size_down])                
            cube([PCB_WIDTH, PCB_HEIGHT, PCB_DEPTH], true);    
        }        
    }
}

module battery_pcb_components(){
    hull_size = 10;
    union(){
        //Slot for micro USB
        translate([(BAT_WIDTH-USB_MICRO_WIDTH)/2,0,-USB_MICRO_DEPTH/2])
        usb_micro(hull_size);        
        
        //Slot for standard USB
        translate([-(BAT_WIDTH-USB_STANDARD_WIDTH)/2,0,-USB_STANDARD_DEPTH/2])
        usb_standard(hull_size);           
        
        //Slot for the button
        translate([
            (BAT_WIDTH-BATTERY_CHECK_WIDTH)/2 - BATTERY_CHECK_OFFSET,
            -(BAT_HEIGHT-BATTERY_CHECK_HEIGHT)/2,
            -BATTERY_CHECK_DEPTH/2
        ])
        battery_check(hull_size);          
    }
}

module lantian_battery_support_layer(depth){
    difference(){
        main_shape(depth);
        battery();
    }    
    
    if(DEBUG){
        battery();
    }
}

module usb_micro(hull_size){
    hull(){        
        //USB MICRO PORT
        cube([USB_MICRO_WIDTH, USB_MICRO_HEIGHT, USB_MICRO_DEPTH], true);
        
        //TUNNEL FOR MICRO PORT
        translate([USB_MICRO_WIDTH, 0, 0])
        cube([USB_MICRO_WIDTH, USB_MICRO_HEIGHT, USB_MICRO_DEPTH], true);    
        
        if(hull_size>USB_MICRO_DEPTH){                
            //lower part
            //USB MICRO PORT
            translate([0, 0, USB_MICRO_DEPTH-hull_size])        
            cube([USB_MICRO_WIDTH, USB_MICRO_HEIGHT, USB_MICRO_DEPTH], true);        
            
            //TUNNEL FOR MICRO PORT        
            translate([USB_MICRO_WIDTH, 0, USB_MICRO_DEPTH-hull_size])
            cube([USB_MICRO_WIDTH, USB_MICRO_HEIGHT, USB_MICRO_DEPTH], true);         
        }
    }
    
}

module usb_standard(hull_size){    
    hull(){
        //USB STANDARD PORT
        cube([USB_STANDARD_WIDTH, USB_STANDARD_HEIGHT, USB_STANDARD_DEPTH], true);
        
        //TUNNEL FOR STANDARD PORT
        translate([-USB_STANDARD_WIDTH, 0, 0])
        cube([USB_STANDARD_WIDTH, USB_STANDARD_HEIGHT, USB_STANDARD_DEPTH], true);
        
        if(hull_size>USB_STANDARD_DEPTH){                        
            //USB STANDARD PORT
            translate([0, 0, USB_STANDARD_DEPTH-hull_size])        
            cube([USB_STANDARD_WIDTH, USB_STANDARD_HEIGHT, USB_STANDARD_DEPTH], true);
            
            //TUNNEL FOR STANDARD PORT
            translate([-USB_STANDARD_WIDTH, 0, USB_STANDARD_DEPTH-hull_size])
            cube([USB_STANDARD_WIDTH, USB_STANDARD_HEIGHT, USB_STANDARD_DEPTH], true);        
        }
    }
}

module battery_check(hull_size){    
    hull(){
        //BATTERY CHECK BUTTON
        cube([BATTERY_CHECK_WIDTH, BATTERY_CHECK_HEIGHT, BATTERY_CHECK_DEPTH], true);
        
        //TUNNEL FOR BUTTON
        translate([0, -BATTERY_CHECK_HEIGHT, 0])
        cube([BATTERY_CHECK_WIDTH, BATTERY_CHECK_HEIGHT, BATTERY_CHECK_DEPTH], true);
        
        if(hull_size>BATTERY_CHECK_DEPTH){
            //BATTERY CHECK BUTTON
            translate([0, 0, BATTERY_CHECK_DEPTH-hull_size])        
            cube([BATTERY_CHECK_WIDTH, BATTERY_CHECK_HEIGHT, BATTERY_CHECK_DEPTH], true);
            
            //TUNNEL FOR BUTTON
            translate([0, -BATTERY_CHECK_HEIGHT, BATTERY_CHECK_DEPTH-hull_size])
            cube([BATTERY_CHECK_WIDTH, BATTERY_CHECK_HEIGHT, BATTERY_CHECK_DEPTH], true);        
        }
    }
}

// Should be extracted to a LIB or sth
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

module inkscape_battery(){
    fudge = 0.1;

    module poly_rect4745(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-41.460186,-7.182880],[-30.635770,-7.182880],[-30.635770,7.717400],[-41.460186,7.717400]]);
      }
    }

    module poly_rect4861(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-22.830052,12.700430],[-5.348654,12.700430],[-5.348654,21.204894],[-22.830052,21.204894]]);
      }
    }

    module poly_rect4749(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[20.746795,-22.417230],[27.094445,-22.417230],[27.094445,-15.601860],[20.746795,-15.601860]]);
      }
    }

    module poly_rect4753(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-39.650746,21.014060],[40.391105,21.014060],[40.391105,22.417220],[-39.650746,22.417220]]);
      }
    }

    module poly_path4769(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[19.410475,-15.735500],[19.090048,-14.124593],[18.177543,-12.758933],[16.811882,-11.846428],[15.200975,-11.526000],[13.562450,-11.856805],[12.224415,-12.758936],[11.322287,-14.096974],[10.991485,-15.735500],[11.322289,-17.374023],[12.224418,-18.712057],[13.562453,-19.614186],[15.200975,-19.944990],[16.839501,-19.614189],[18.177539,-18.712061],[19.079671,-17.374025],[19.410475,-15.735500],[19.410475,-15.735500]]);
      }
    }

    module poly_path4761(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-24.154471,14.733220],[-24.576621,16.855524],[-25.778808,18.654728],[-27.578010,19.856917],[-29.700314,20.279070],[-31.822617,19.856917],[-33.621819,18.654728],[-34.824006,16.855524],[-35.246157,14.733220],[-34.810336,12.574529],[-33.621816,10.811719],[-31.859005,9.623199],[-29.700314,9.187380],[-27.541622,9.623199],[-25.778811,10.811719],[-24.590291,12.574529],[-24.154471,14.733220],[-24.154471,14.733220]]);
      }
    }

    module poly_path4759(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-25.557651,-13.864610],[-25.972468,-11.809952],[-27.103710,-10.132097],[-28.781565,-9.000856],[-30.836224,-8.586040],[-32.890882,-9.000856],[-34.568737,-10.132097],[-35.699979,-11.809952],[-36.114796,-13.864610],[-35.699979,-15.919268],[-34.568737,-17.597123],[-32.890882,-18.728364],[-30.836224,-19.143180],[-28.781565,-18.728364],[-27.103710,-17.597123],[-25.972468,-15.919268],[-25.557651,-13.864610],[-25.557651,-13.864610]]);
      }
    }

    module poly_rect146(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[14.069885,-4.119500],[22.007385,-4.119500],[22.007385,4.384970],[14.069885,4.384970]]);
      }
    }

    module poly_path4767(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[36.716145,15.969340],[36.366962,17.698894],[35.414713,19.111265],[34.002340,20.063511],[32.272785,20.412690],[30.543231,20.063511],[29.130858,19.111265],[28.178609,17.698894],[27.829425,15.969340],[28.167655,14.268939],[29.130854,12.827409],[30.572385,11.864210],[32.272785,11.525980],[33.973186,11.864210],[35.414717,12.827409],[36.377916,14.268939],[36.716145,15.969340],[36.716145,15.969340]]);
      }
    }

    module poly_rect4747(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[35.045716,-3.507930],[41.460185,-3.507930],[41.460185,4.777430],[35.045716,4.777430]]);
      }
    }

    module poly_rect4751(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-39.650746,-20.813630],[-38.782120,-20.813630],[-38.782120,22.417220],[-39.650746,22.417220]]);
      }
    }

    module poly_rect4757(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-39.650746,-20.813640],[39.455655,-20.813640],[39.455655,-20.212260],[-39.650746,-20.212260]]);
      }
    }

    module poly_rect4859(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[1.549415,4.762930],[9.770397,4.762930],[9.770397,12.322454],[1.549415,12.322454]]);
      }
    }

    module poly_rect4755(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[38.186135,-20.212260],[39.455665,-20.212260],[39.455665,22.417230],[38.186135,22.417230]]);
      }
    }

    module poly_rect4703(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[-22.751316,-20.412720],[-4.911075,-20.412720],[-4.911075,-9.387850],[-22.751316,-9.387850]]);
      }
    }

    module poly_path4773(h)
    {
      scale([25.4/90, -25.4/90, 1]) union()
      {
        linear_extrude(height=h)
          polygon([[1.369765,0.233850],[0.922183,2.484002],[-0.352426,4.391589],[-2.260013,5.666197],[-4.510165,6.113780],[-6.760317,5.666197],[-8.667904,4.391589],[-9.942513,2.484002],[-10.390096,0.233850],[-9.942513,-2.016302],[-8.667904,-3.923889],[-6.760317,-5.198497],[-4.510165,-5.646080],[-2.260013,-5.198497],[-0.352426,-3.923889],[0.922183,-2.016302],[1.369765,0.233850],[1.369765,0.233850]]);
      }
    }

    poly_rect4745(5);
    poly_rect4861(5);
    poly_rect4749(5);
    poly_rect4753(5);
    poly_path4769(5);
    poly_path4761(5);
    poly_path4759(5);
    poly_rect146(5);
    poly_path4767(5);
    poly_rect4747(5);
    poly_rect4751(5);
    poly_rect4757(5);
    poly_rect4859(5);
    poly_rect4755(5);
    poly_rect4703(5);
    poly_path4773(5);
        
}