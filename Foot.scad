/*
Basics derived from measuring "smaller pipe for 25 mm tube"
    (https://www.thingiverse.com/thing:6534684/files)
Produces a foot in two parts, based on these premises:
*  PVC pipe will be used for the resonating pipe
*  The pipe will be stopped, not open
*  Frequency will be given
*  Mouth height should be (but is not) based on frequency using this formula
        MH = [3.018 - 0.233 ln f]^5 (MH = Mouth Height; f = Frequency; ln = natural log)
        (https://www.rwgiangiulio.com/math/mouthheight.htm)
        a = 440Hz, stopped MH = 8.1
     My first shot: multiply flue length by cut up fraction (see calculated definitions)
*  Cut-up (ratio mouth height to width) preset as cut-up (a guess for now)
*  Flue (the slot in the languid through which air is blown) needs printing at high resolution for accuracy
    For now, it's preset as flue_length and flue_width (a proportion of the pipe diameter)
    Formula using windsheet width (the thickness of the air stream coming from the flue) to get Ising's number at https://www.mmdigest.com/Tech/isingform.html
    and https://www.rwgiangiulio.com/math/wst.htm [Beware, Imperial units]
    windsheet_thickness =	(I^2 * f^2 * )ρ * H^3)) / 2P
        I = Ising's number; p = air density; P = air pressure; H = mouth height 
*  Stem diameter, outside diameter of the stem entering the windchest
*  Pipe length is: flue to stopper base - the pipe width + stopper 
        pipe_length = 3386 / f - pipe_internal_diameter (plus a bit of headroom?)
        (https://www.rwgiangiulio.com/math/pipelength.htm)
        (https://www.ccoors.de/webpipecalc/)
*  Foot length - from windchest to mouth, user's choice
*  Ears: On or Off : TO BE DONE
*  Harmonic Bridge aka Beard: On or Off : TO BE DONE
        (https://www.youtube.com/watch?v=bHBOwiEf6FM and Colin Pykett, below)
*  Upper lip offset - to be considered
        (https://www.colinpykett.org.uk/physics-of-voicing-organ-flue-pipes.htm#Offset)
*/
// Definitions
// internal parameters quick for preview, smooth curves for render
$fs = $preview ? 1 : 0.15;
$fa = $preview ? 3 : 2;
epsilon = 0.01; // tiny offset to ensure cuts go through
// Design parameters
pipe_diameter = 25; // outside diameter of pvc resonator pipe, inside diameter of model
stem_diameter = 6; // inside diameter of tube to couple with windchest
stem_length = 10; // length of pipe for air inlet
body_length = 15; // length of lower pipe between stem and languid section
frequency = 440; // Hz of target pipe
wall_thick = 2; // thickness of walls in this foot
resonator_base_thick = 2; // thickness of base for square resonator connection
resonator_side_thick = 2; // thickness of walls for resonator connection
resonator_side_high = 10; // height of walls for resonator connection
resonator_square = 40; // length & width of base for square resonator connection
languid_thick = 1.25; // thickness of the languid (flat plate with air hole)
flue_width = 1.1; // narrow dimension of the flue in the languid
flue_factor = 0.5; // max proportion of pipe diameter that flue can be
cut_up = 1 / 3.5; // sets mouth height ratio of tall : wide
flue_offset = 0.25; // adjust flue location relative to lip
lip_angle = 12; // angle between the lip and pipe - adjust so no holes around lip
lower_lip_length = 12; // length of flat forming lip
upper_lip_length = 12; // length of flat forming lip
upper_lip_add = wall_thick / 2; // to assure join of lip to tube (guessed amount, not calculated)
ear_thick = 1; // thickness of the ears
ear_height = 5; // ear protrusion
lower_length = 25; // length of taper to inlet tube
upper_body = 20; // length of inserted pvc resonator pipe
outlet_block = 8; // distance to hold resonator
stopper_height = 1.5; // width + height of stopper inside pipe foot
collar_thick = 1.2; // thickness of the joining collar
collar_height = 2.5; // height of joining collar
taper_angle = 15; // angle to form supports (mm cone height)
collar_diameter = pipe_diameter + wall_thick *2 + collar_thick*2; // diameter of joining collar

// Calculated
outside_diameter = pipe_diameter + wall_thick * 2; // outside diameter of resonator & lower connections
flue_length = pipe_diameter * flue_factor; // longer dimension of flue
upper_length = upper_lip_length + upper_body; // total length of the upper part
mouth_height =  cut_up*flue_length; // vertical height of mouth
lip_x = sqrt ((pipe_diameter/2) ^ 2 - (flue_length / 2) ^ 2); // distance from centre of pipe to lip (Pythagoras!)
/* * * */
module lower () {
    difference () {
        //  tube above languid
        cylinder (d = outside_diameter, h = lower_lip_length + languid_thick);
        translate ([0,0,languid_thick])
        cylinder (d = pipe_diameter, h = lower_lip_length + languid_thick + epsilon); 
        // etch frequency into languid
        translate ([0,pipe_diameter/4,-epsilon])
        linear_extrude (height = languid_thick * 0.5)
        rotate ([180,0,-90]) 
        text(str(frequency), font="Liberation Sans:style=Bold", size = 5);
        // cut flue
        translate ([lip_x + flue_offset, -flue_length/2, -epsilon]) // 
        cube ([flue_width, flue_length, lower_lip_length + languid_thick + epsilon*2]);
        }
    // lower lip inside tube
    translate ([lip_x + flue_offset + flue_width, -flue_length/2, 0]) 
    cube ([flue_width, flue_length, lower_lip_length + languid_thick + epsilon*2]);
}
module lower_body () {
    difference () {
    translate ([0, 0, lower_lip_length + languid_thick - epsilon])
    cylinder (h = body_length, d1 = outside_diameter, d2 = stem_diameter + wall_thick * 2);
    translate ([0, 0, lower_lip_length + languid_thick - epsilon*2])
    cylinder (h = body_length + epsilon * 2, d1 = pipe_diameter, d2 = stem_diameter);
    }
}
module stem () {
    difference () {
    translate ([0, 0, lower_lip_length + languid_thick + body_length - epsilon])
    cylinder (h = stem_length + epsilon*2, d = stem_diameter + wall_thick * 2);
    translate ([0, 0, lower_lip_length + languid_thick + body_length - epsilon*2])
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
// cut out mouth and lip openings
    translate ([pipe_diameter/2-wall_thick, -flue_length/2 - epsilon, upper_length - mouth_height - upper_lip_length+epsilon])
    cube ([wall_thick*2 + collar_thick, flue_length - epsilon*2, upper_lip_length + mouth_height + collar_height + epsilon]);
    }
module lip_stick () {
    translate ([lip_x, flue_length/2, upper_length - mouth_height])
    rotate ([0,90,-90])
    rotate_extrude (angle = lip_angle)
    polygon(points = [ [0, 0], [upper_lip_length + upper_lip_add, 0], [upper_lip_length + upper_lip_add, flue_length + epsilon*2], [0, flue_length + epsilon*2] ], paths = [ [0, 1, 2, 3] ], convexity = 10);
    }
module collar () {
    difference () {
        union () {
            rotate ([180, 0, 0 ])
            rotate_extrude (convexity = 10)
            translate([pipe_diameter/2 + wall_thick - epsilon, - upper_length, 0]) // inside diameter, z elevation, no effect
            polygon(points = [ [0, 0], [0, collar_thick], [collar_thick, 0]], paths = [ [0, 1, 2] ], convexity = 10); // triangular section
    
            rotate ([180, 0, 0 ])
            rotate_extrude(convexity = 10)
            translate([pipe_diameter/2 + wall_thick - epsilon, -upper_length - collar_height + epsilon, 0]) // inside diameter; z elevation; no effect
            polygon(points = [ [0, 0], [collar_thick, 0], [collar_thick, collar_height], [0, collar_height]], paths = [ [0, 1, 2, 3] ], convexity = 10); // square section
            }
        translate ([lip_x - epsilon, -flue_length/2 - ear_thick - epsilon, upper_length - collar_thick - epsilon])
        cube ([wall_thick * 2 + collar_thick * 2 + epsilon * 2,  flue_length + ear_thick * 2 + epsilon * 2, collar_height + collar_thick + epsilon*2]);
    }
}
module insert_stop () {
    rotate ([180, 0, 0 ])
    rotate_extrude(convexity = 10)
    translate([pipe_diameter/2 + epsilon, -outlet_block, 0]) // inside diameter, z elevation, no effect
    circle (r = wall_thick-epsilon);
}
module lower_ears () {
    for (n = [-flue_length/2 - ear_thick : flue_length + ear_thick : flue_length/2])
    translate ([lip_x + flue_width, n, 0])
    cube ([ear_height, ear_thick, lower_lip_length]);
}
module upper_ears () {
    for (n = [-flue_length/2 - ear_thick : flue_length + ear_thick : flue_length/2]) {
    difference () {
        translate ([lip_x + flue_width, n, upper_length - upper_lip_length - upper_lip_add - mouth_height ])
        cube ([ear_height, ear_thick, upper_lip_length + mouth_height + upper_lip_add]);
        translate ([lip_x + flue_width, n-epsilon, upper_length - upper_lip_length - upper_lip_add - mouth_height])
        rotate ([0, 45, 0])
        cube ([ear_height, ear_thick + epsilon * 2, upper_lip_length + upper_lip_add + mouth_height]);
        }
    }
}
module square_resonator () {
    difference () {
    cube ([resonator_square + resonator_side_thick * 2, resonator_square + resonator_side_thick * 2, resonator_base_thick]);
    translate ([resonator_square + resonator_side_thick - outside_diameter/2, resonator_square / 2 + resonator_side_thick, 
        -epsilon]) cylinder (d = outside_diameter, h = resonator_base_thick + epsilon * 2);
    }
    for (n = [0 : 1]) {
        translate ([0, n * (resonator_square + resonator_side_thick), 0])
        cube ([resonator_square + resonator_side_thick * 2, resonator_side_thick, resonator_side_high]);
        translate ([n * (resonator_square + resonator_side_thick), 0, 0])
        cube ([resonator_side_thick, resonator_square + resonator_side_thick * 2, resonator_side_high]);
    }
}
//  make the model

difference () {
    upper ();
    upper_cut ();
}
collar();
upper_ears ();
lip_stick ();
insert_stop ();

translate ([pipe_diameter * 1.25,0,0]) {
    lower();
    lower_body ();
    stem();
    lower_ears ();
}

translate ([0, pipe_diameter * 1.25, 0])
square_resonator ();