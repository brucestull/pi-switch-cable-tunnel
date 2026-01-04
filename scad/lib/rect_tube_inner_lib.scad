// scad/lib/rect_tube_inner_lib.scad
// ----------------------------------------------------------------------------
// LIBRARY: Rectangular tube defined by INNER opening dimensions
// Units: millimeters (mm)
//
// This file is intended to be reusable across parts/presets.
// - Contains functions + modules only
// - Does not render a final object by itself (unless called by a part/preset)
//
// Definition:
// - "inner"  = clear opening (hollow region) [X_inner, Y_inner, Z_length]
// - "outer"  = inner + 2*wall in X and Y, Z unchanged
//
// Tube is open at both ends along Z.
// ----------------------------------------------------------------------------


// Helper: convert inner opening -> outer size.
// Note: Z is the tube length (unchanged).
function outer_from_inner(inner, wall) = [
    inner[0] + 2*wall,
    inner[1] + 2*wall,
    inner[2]
];


// Module: a single rectangular tube defined by INNER opening dimensions.
// Parameters:
// - inner: [X_inner, Y_inner, Z_length]
// - wall:  wall thickness (applied to X and Y walls)
// - eps:   boolean safety extension for the inner cutout
module rect_tube_inner(inner, wall, eps=0.01) {

    outer = outer_from_inner(inner, wall);

    // -----------------------------
    // Input validation (fail loudly)
    // -----------------------------
    if (inner[0] <= 0 || inner[1] <= 0 || inner[2] <= 0) {
        echo("ERROR: inner dimensions must be positive: ", inner);
    }
    else if (wall <= 0) {
        echo("ERROR: wall must be positive: wall=", wall);
    }
    else {
        // -----------------------------
        // Geometry:
        // - Start with outer solid box
        // - Subtract inner cavity
        //
        // The inner cavity is translated by [wall, wall] in X/Y so wall thickness
        // is preserved on both sides.
        //
        // We extend the cavity by +/-eps in Z to ensure clean open ends after
        // boolean operations (prevents “capped” ends due to coplanar faces).
        // -----------------------------
        difference() {
            // Outer solid
            cube(outer, center=false);

            // Inner cutout (slightly extended in Z)
            translate([wall, wall, -eps])
                cube([inner[0], inner[1], inner[2] + 2*eps], center=false);
        }
    }
}


// Module: array of tubes along +X based on OUTER size with an overlap.
// Parameters:
// - inner:   inner opening of each tube
// - count:   how many tubes
// - wall:    wall thickness
// - overlap: overlap between adjacent tubes (mm)
// - eps:     boolean safety extension
module tube_array_inner(inner, count, wall, overlap=0.01, eps=0.01) {

    outer = outer_from_inner(inner, wall);

    // -----------------------------
    // Array validation / guard rails
    // -----------------------------
    if (count <= 0) {
        echo("ERROR: count must be > 0. count=", count);
    }
    else if (overlap < 0) {
        echo("ERROR: overlap must be >= 0. overlap=", overlap);
    }
    else if (overlap >= outer[0]) {
        echo("ERROR: overlap must be < outer X size. overlap=", overlap, " outer=", outer);
    }
    else {
        // -----------------------------
        // Placement:
        // Step along X by (outer_x - overlap)
        // so each tube slightly intersects the previous tube.
        // -----------------------------
        union() {
            for (i = [0 : count-1]) {
                translate([i * (outer[0] - overlap), 0, 0])
                    rect_tube_inner(inner, wall, eps);
            }
        }
    }
}
