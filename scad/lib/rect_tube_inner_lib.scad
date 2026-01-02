// scad/lib/rect_tube_inner_lib.scad
// Shared library: rectangular tube defined by INNER opening.
// Units: mm

// Helper: convert inner opening -> outer size (Z is the tube length, unchanged)
function outer_from_inner(inner, wall) = [inner[0] + 2*wall, inner[1] + 2*wall, inner[2]];

// Rectangular tube defined by INNER opening dimensions (hollow in X/Y, open along Z)
module rect_tube_inner(inner, wall, eps=0.01) {
    outer = outer_from_inner(inner, wall);

    // Basic safety check
    if (inner[0] <= 0 || inner[1] <= 0 || inner[2] <= 0) {
        echo("ERROR: inner dimensions must be positive: ", inner);
    } else if (wall <= 0) {
        echo("ERROR: wall must be positive: wall=", wall);
    } else {
        difference() {
            // Outer solid
            cube(outer, center=false);

            // Inner cutout: starts at +wall in X/Y, extends slightly past in Z
            // to guarantee the ends stay open after boolean ops.
            translate([wall, wall, -eps])
                cube([inner[0], inner[1], inner[2] + 2*eps], center=false);
        }
    }
}

// Array helper: places `count` tubes along X, based on OUTER size, with overlap.
module tube_array_inner(inner, count, wall, overlap=0.01, eps=0.01) {
    outer = outer_from_inner(inner, wall);

    union() {
        for (i = [0 : count-1]) {
            translate([i * (outer[0] - overlap), 0, 0])
                rect_tube_inner(inner, wall, eps);
        }
    }
}
