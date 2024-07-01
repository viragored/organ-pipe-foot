# organ-pipe-foot
OpenSCAD code to create organ pipe feet, customisable for size and shape

This is the start of a project with many changes to come

The OpenSCAD code produces a foot, based on these premises:
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
