// scad/presets/default.scad
// Default preset: Pi ↔ Switch cable tunnel
// Units: mm

use <../parts/rect_tube_array_spec_inner.scad>

// Inner (clear) opening dimensions:
inner_size = [16, 25.4, 115];  // [X_inner, Y_inner, Z_length]
count      = 10;

overlap  = 1;
wall_xy  = 2;
eps      = 0.01;

// Render the part with this preset:
rect_tube_array_part(inner_size, count, wall_xy, overlap, eps);
