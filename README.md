# organ-pipe-foot
OpenSCAD code to create organ pipe feet, customisable for size and shape

Aim: Produce a foot that must print without supports, based on these premises:
*  Walls will be thick enough to support PVC pipe while organ being moved, eg on a cart over rough ground
*  PVC pipe will be used for the resonating pipe
*  The pipe will be stopped, not open
*  Frequency will be given
*  Mouth height calculated using frequency in this formula (stopped pipe)
        MH = [3.018 - 0.233 ln f]^5 (MH = Mouth Height; f = Frequency; ln = natural log)
*  Flue (the slot in the languid through which air is blown) needs printing at high resolution for accuracy
*  flue_width is calculated from the Ising formula (link below)
*  Stem diameter, inside diameter of the stem connecting to the windchest
*  Foot length - from windchest to mouth to resonator = user's choice
*  Upper lip offset - achieved by aligning flue on languid
        [(https://www.colinpykett.org.uk/physics-of-voicing-organ-flue-pipes.htm#Offset)]

References:
*  [Formula using windsheet width (the thickness of the air stream coming from the flue) to get Ising's number at https://www.mmdigest.com/Tech/isingform.html
    and https://www.rwgiangiulio.com/math/wst.htm [Beware, Imperial units]
    windsheet_thickness =	(I^2 * f^2 * )ρ * H^3)) / 2P
        I = Ising's number; p = air density; P = air pressure; H = mouth height ]
*  Mouth height: a = 440Hz, stopped MH = 8.1 (https://www.rwgiangiulio.com/math/mouthheight.htm)
*  [Pipe length is: flue to stopper base - the pipe width + stopper 
        pipe_length = 3386 / f - pipe_internal_diameter (plus a bit of headroom?)
        (https://www.rwgiangiulio.com/math/pipelength.htm)
        (https://www.ccoors.de/webpipecalc/)]
*  Upper lip offset: (https://www.colinpykett.org.uk/physics-of-voicing-organ-flue-pipes.htm#Offset)

