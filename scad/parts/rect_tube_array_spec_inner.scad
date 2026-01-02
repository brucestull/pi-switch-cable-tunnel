// scad/parts/rect_tube_array_spec_inner.scad
// Part: array of identical rectangular tubes along +X,
// where the specified size is the INNER (clear) opening.

use <../lib/rect_tube_inner_lib.scad>

// Public “part” module, so presets can call it cleanly.
module rect_tube_array_part(inner_size, count, wall_xy, overlap=0.01, eps=0.01) {
    tube_array_inner(inner_size, count, wall_xy, overlap, eps);
}
