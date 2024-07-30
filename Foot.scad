/*                             Version 3: 23 July 2024
Notes:
Inspiration: 3D model "smaller pipe for 25 mm tube" (https://www.thingiverse.com/thing:6534684/files)
Aim: Produce a foot that must print without supports, based on these premises:
*  Walls will be thick enough to support PVC pipe while organ being moved, eg on a cart over rough ground
*  PVC pipe will be used for the resonating pipe
*  The pipe will be stopped, not open
*  Frequency will be given
*  Ising's number will be given (affects sound character of pipe, used in flue calculation)
*  Pressure of air at the pipe will be given
*  Mouth height calculated using frequency in this formula (stopped pipe)
        MH = [3.018 - 0.233 ln f]^5 (MH = Mouth Height; f = Frequency; ln = natural log)
*  Flue (the slot in the languid through which air is blown) needs printing at high resolution for accuracy
*  Stem diameter, inside diameter of the stem connecting to the windchest
*  Foot length - from windchest to mouth to resonator = user's choice
*  Upper lip offset - achieved by aligning flue on languid
        [(https://www.colinpykett.org.uk/physics-of-voicing-organ-flue-pipes.htm#Offset)]
References:
* Formula using windsheet width (the thickness of the air stream coming from the flue) to get Ising's number at https://www.mmdigest.com/Tech/isingform.html
    and https://www.rwgiangiulio.com/math/wst.htm [Beware, Imperial units : inch_mm = 25.39]
    windsheet_thickness D =	(I^2 * f^2 * )ρ * H^3)) / 2P
        I = Ising's number; p = air density; P = air pressure; H = mouth height 
        Solution from OpenAI: https://chatgpt.com/share/9501fe4e-4f52-485f-864d-c0a950776f9c
*  Pipe length is: flue to stopper base - the pipe width + stopper 
        pipe_length = 3386 / f - pipe_internal_diameter (plus a bit of headroom?) : INCHES !!
        (https://www.rwgiangiulio.com/math/pipelength.htm)  (https://www.ccoors.de/webpipecalc/)
*  Upper lip offset: (https://www.colinpykett.org.uk/physics-of-voicing-organ-flue-pipes.htm#Offset)
TO BE DONE - 
Make top of lip circular up to height of coupler
Harmonic Bridge aka Frein aka Beard? On or Off 
        (https://www.youtube.com/watch?v=bHBOwiEf6FM and Colin Pykett, below)
*/
// Definitions
// Design parameters

// CHOOSE these:
make = "f"; // f makes a foot, s makes a stopper, else makes nothing
ears_on = 1; // 1 = make ears, 0 = no ears
coupler_on = 1; // 1 = make coupler, 0 = no coupler

// SET these:
PVC_outside = 34; // outside diameter of PVC pipe resonator
PVC_inside = 28; // inside diameter of PVC pipe resonator
frequency = 233.08; // A#3 // Hz of target pipe, used to calculate mouth height
//frequency = 174.61; // F3 bass // Hz of target pipe, used to calculate mouth height
pipe_diameter = PVC_inside; // inside diameter of foot - same as PVC inside
stem_diameter = 6; // inside diameter of tube to couple with windchest
stem_length = 10; // length of pipe to couple with windchest
lower_body_length = 12; // length of lower pipe between stem and languid section
lower_top_length = 18; // length of lower section with languid that mates with upper
upper_length = 30; // user choice: length of upper part
// for stopper
disc_thick = 6; // thickness of stopper
knob_height = 25;
knob_diameter = 15;
knob_stand = 8; // height of knob base
knob_stretch = 2; // factor to multiply knob_height
screw_thread = 4; // diameter of fastening screw
screw_head = 8; // diameter of screw head
screw_free = 5; // length of thread to keep unused within knob (remember to add in disc, used to save cutting screws)
nut_diameter = 7.8; // diameter of hex nut across points
nut_thick = 3.2; // thickness of nut
o_ring_thick = 2.2; // thickness of o_ring

// REVIEW these
Ising = 2.5; // Ising's number for type of pipe sound, set mid-range
Pressure = 988; // air pressure reaching pipe, in Pascals : 988 = ~ 4 ins/ 10 cms H2O
rho = 1.2; // standard air density in Kg/M^3
inch_mm = 25.39; // conversion factor
wall_thick = 3; // thickness of walls in this foot
languid_thick = 1.25; // thickness of the languid (flat plate with air hole)
flue_offset_factor = 0.5; // adjust this amount of flue depth relative to lip (negative moves towards centre)
wind_factor = 0.4; // max proportion of pipe diameter that flue can be
ear_thick = 1; // thickness of the ears
ear_height = 5; // ear protrusion
upper_ear_length = 0.75; // proportion of upper body the ears will cover - too long can clash with coupler
collar_thick = 1.2; // thickness of the joining collar
collar_height = 2.5; // height of joining collar
coupler_height = 15; // height of PVC coupler
coupler_thick = 2.5; // thickness of PVC coupler
printer_fit = 0.2; // amount to allow for printer fitting curved parts
// internal parameters quick for preview, smooth curves for render
$fs = $preview ? 1 : 0.15;
$fa = $preview ? 3 : 2;
epsilon = 0.01; // tiny offset to ensure cuts go through

// Calculated
mouth_height = (3.018 - 0.233 * ln (frequency))^5; // (MH = Mouth Height; f = Frequency; ln = natural log)
outside_diameter = pipe_diameter + wall_thick * 2; // outside diameter of foot
collar_diameter = outside_diameter + collar_thick*2 + printer_fit; // outside diameter of joining collar
flue_width = pipe_diameter * wind_factor; // longer dimension of flue
mh = mouth_height/1000; // convert to metres
flue_depth = 1000 * (Ising^2 * frequency^2 * rho * mh^3) / (2 * Pressure); // in mm
print_flue_depth = flue_depth + printer_fit; // adjust for printer 
lower_lip_width = pipe_diameter * wind_factor;  // width of flat forming lip
upper_lip_width = pipe_diameter * wind_factor; // width of flat forming lip
resonator_length = ((3386 * inch_mm) / frequency) - PVC_inside; // for information only (formula in notes at top)
lip_x = sqrt ((pipe_diameter/2) ^ 2 - (upper_lip_width / 2) ^ 2); // distance from centre of pipe to lip (Pythagoras!)
lip_x_outer = sqrt ((wall_thick + pipe_diameter/2) ^ 2 - (upper_lip_width / 2) ^ 2); // distance from centre of pipe to outside lip
lip_top_shape_x = 1; // amount to add to strengthen top of lip
lip_top_shape_z = 1; // vertical height of slope at  top of lip
lip_top = upper_length - mouth_height; // z height to top of lip
lip_left = -upper_lip_width/2 - epsilon*2; // y distance to left side of lip
lip_width = upper_lip_width/2 + epsilon*2; // half width of lip
lip_shaper = pipe_diameter - wall_thick*2;
flue_offset = -flue_depth * flue_offset_factor; // adjust flue location relative to lip (negative moves towards centre)
knob_radius = knob_diameter/2;
knob_top = knob_diameter * knob_stretch;
knob_z = knob_radius * knob_stretch; // base of stretched knob
o_ring_factor = 0.3; // proportion of o_ring between disc and PVC
disc_diameter = pipe_diameter ; 
/* * * */
module lower () {
    difference () {
        //  tube with languid
        cylinder (d = outside_diameter, h = lower_top_length + languid_thick);
        translate ([0,0,languid_thick])
        cylinder (d = pipe_diameter, h = lower_top_length + languid_thick + epsilon); 
        etch_freq (); // etch frequency into languid
        // cut flue
        translate ([lip_x + flue_offset - printer_fit/2 + epsilon, -flue_width/2, -epsilon]) // the flue
        cube ([print_flue_depth, flue_width, lower_top_length + languid_thick + epsilon*2]);
        }
        translate ([lip_x + flue_offset + flue_depth, -flue_width/2 - epsilon, languid_thick]) // filler between flue and wall
        cube ([lip_x_outer - lip_x + flue_offset - epsilon, flue_width + epsilon *2, lower_top_length+epsilon]); 
    }
module lower_body () {
    difference () {
    translate ([0, 0, lower_top_length + languid_thick - epsilon])
    cylinder (h = lower_body_length, d1 = outside_diameter, d2 = stem_diameter + wall_thick * 2);
    translate ([0, 0, lower_top_length + languid_thick - epsilon*2])
    cylinder (h = lower_body_length + epsilon * 2, d1 = pipe_diameter, d2 = stem_diameter);
    }
}
module etch_freq () {
        // etch frequency into languid
        translate ([0,pipe_diameter/4,-epsilon])
        linear_extrude (height = languid_thick * 0.5)
        rotate ([180,0,-90]) 
        text(str(round(frequency)), font="Liberation Sans:style=Bold", size = 5);    
}
module stem () {
    difference () {
    translate ([0, 0, lower_top_length + languid_thick + lower_body_length - epsilon])
    cylinder (h = stem_length + epsilon*2, d = stem_diameter + wall_thick * 2);
    translate ([0, 0, lower_top_length + languid_thick + lower_body_length - epsilon*2])
    cylinder (h = stem_length + epsilon*4, d = stem_diameter);
    }
}
module upper () {
    difference () {
        cylinder (d = outside_diameter, h = upper_length); 
        translate ([0,0,-epsilon])
        cylinder (d = pipe_diameter, h = upper_length + collar_height + epsilon*2); 
    }
}
module upper_cut () {
// cut out mouth and lip opening
    translate ([pipe_diameter/2-wall_thick, -upper_lip_width/2 - epsilon, coupler_height/2 - epsilon])
    cube ([wall_thick*2 + collar_thick, upper_lip_width - epsilon*2, upper_length - coupler_height/2 + epsilon*2]);
//    translate ([pipe_diameter/2-wall_thick, -upper_lip_width/2 - epsilon, -epsilon])
//    cube ([wall_thick*2 + collar_thick, upper_lip_width - epsilon*2, upper_length + epsilon*2]);
    }
module lip_stick () {
Lip_Points = [
  [ lip_x,  lip_left,  coupler_height/2 - epsilon ],  //0
  [ lip_x_outer,  lip_left,  coupler_height/2 - epsilon ],  //1
  [ lip_x_outer,  lip_width,  coupler_height/2 - epsilon ],  //2
  [ lip_x,  lip_width,  coupler_height/2 - epsilon ],  //3
  [ lip_x + lip_top_shape_x,  lip_left,  lip_top - lip_top_shape_z ],  //4
  [ lip_x + lip_top_shape_x,  lip_width,  lip_top - lip_top_shape_z ],  //5
  [ lip_x,  lip_left,  lip_top ],  //6 
  [ lip_x,  lip_width,  lip_top ] ];  //7 
Lip_Faces = [
  [0,1,2,3],  // bottom
  [4,5,2,1],  // front
  [0,3,7,6],  // inside
  [2,5,7,3],  // right
  [0,6,4,1],  // left
  [4,6,7,5] ]; // top shape

difference () {
    polyhedron( Lip_Points, Lip_Faces );
        translate ([0,0,coupler_height/2 - epsilon*2])
        cylinder (d1 = pipe_diameter, d2 = lip_shaper, h = lip_top); 
        }
    }
module collar () {
    difference () {
        union () {
            rotate ([180, 0, 0 ])
            rotate_extrude (convexity = 10)
            translate([pipe_diameter/2 + wall_thick  - epsilon, - upper_length, 0]) // inside radius, z elevation, no effect
            polygon(points = [ [0, 0], [0, collar_thick], [collar_thick + printer_fit/2, 0]], paths = [ [0, 1, 2] ], convexity = 10); // triangular section
//            polygon(points = [ [0, 0], [0, collar_thick], [collar_thick, 0]], paths = [ [0, 1, 2] ], convexity = 10); // triangular section
            rotate ([180, 0, 0 ])
            rotate_extrude(convexity = 10)
            translate([pipe_diameter/2 + wall_thick + printer_fit/2 - epsilon, -upper_length - collar_height + epsilon, 0]) // inside radius; z elevation; no effect
            polygon(points = [ [0, 0], [collar_thick, 0], [collar_thick, collar_height], [0, collar_height]], paths = [ [0, 1, 2, 3] ], convexity = 10); // square section
            }
        translate ([lip_x - epsilon, -flue_width/2 - (ear_thick * ears_on) - epsilon, upper_length - collar_thick - epsilon])
        cube ([wall_thick * 2 + collar_thick * 2 + epsilon * 2,  flue_width + ear_thick * (ears_on * 2 ) + epsilon * 2, collar_height + collar_thick + epsilon*2]);
    }
}
module lower_ears () {
    for (n = [-flue_width/2 - ear_thick : flue_width + ear_thick : flue_width/2]) {
    translate ([lip_x + flue_depth, n, 0])
    cube ([ear_height, ear_thick, lower_lip_width]);
    }
}
module upper_ears () {
    for (n = [-lip_width - ear_thick : lip_width * 2 + ear_thick : lip_width]) {
    difference () {
        translate ([lip_x + flue_depth, n, upper_length *(1-upper_ear_length)])
        cube ([ear_height, ear_thick, upper_length * upper_ear_length]);
        translate ([lip_x + flue_depth, n-epsilon, upper_length * (1-upper_ear_length)])
        rotate ([0, 45, 0])
        cube ([ear_height, ear_thick + epsilon * 2, upper_lip_width]);
        }
    }
}
module coupler () {
        difference () {
        cylinder (h= coupler_height, d = PVC_outside + coupler_thick*2);
           translate ([0, 0, -epsilon]) 
            cylinder (h= coupler_height + epsilon * 2, d = outside_diameter);
           translate ([0, 0, coupler_height/2]) 
            cylinder (h= coupler_height + epsilon * 2, d = PVC_outside);
        }
}
module knob () {
    difference () {
        union () {
            cylinder (d = knob_radius, h = knob_stand); // stand
            translate ([0, 0, knob_z]) // knob
            resize ([0, 0, knob_top])
            sphere (d = knob_diameter);
            }
        translate ([0, 0, -epsilon])
        cylinder (d = screw_thread, h = knob_top + epsilon * 2);
        translate ([0, 0, screw_free])
        cylinder (d = screw_head, h = knob_top + epsilon * 2);
    }
}
module disc () {
    difference () {
        cylinder (d = disc_diameter, h = disc_thick); // main disc
        translate ([0, 0, -epsilon]) // screw thread
        cylinder (d = screw_thread, h = disc_thick + epsilon * 2);
//        rotate_extrude(convexity = 10) // cut O-ring channel
//        translate ([disc_diameter/2, disc_thick/2,0])
//        circle (d = o_ring_thick);
        translate([0, 0, disc_thick - nut_thick + epsilon]) //  nut recess
        cylinder (d = nut_diameter, h = nut_thick, $fn = 6); // hex hole for nut
    }    
}
//  make the model
if (make == "f") { // make a foot in two parts
difference () {
    upper ();
    upper_cut ();
}
collar();
    if (ears_on == 1) upper_ears ();
    lip_stick ();
//translate ([0,0,upper_length + 1]) { // position languid over lip for visual check
translate ([pipe_diameter * 1.5,0,0]) {
    lower();
    lower_body ();
    stem();
    if (ears_on == 1) lower_ears ();
    }
echo("with frequency ",frequency," and inside diameter",PVC_inside);
echo("resonator_length in mm =",resonator_length,"plus stopper and headroom");
echo ("mouth_height = ",mouth_height);
echo ("flue_width =", flue_width);
echo (flue_depth = flue_depth);
}
if (coupler_on == 1) {
    translate ([-pipe_diameter * 1.5,0,0]) 
        if (outside_diameter > PVC_outside) rotate ([0, 180, 0]) // put larger part on printer plate
            translate ([0, 0, -coupler_height])
        coupler ();
        else
        coupler ();
    }
if (make == "s") { // make a stopper
//knob();
//translate ([disc_diameter, 0, 0])
    disc();
}