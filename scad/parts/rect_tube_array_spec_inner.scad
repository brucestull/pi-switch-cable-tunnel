// scad/parts/rect_tube_array_spec_inner.scad
// ----------------------------------------------------------------------------
// PART: Array of identical rectangular tubes along +X
// Spec style: INNER dimensions define the clear opening (hollow region).
//
// Why a "part" wrapper?
// - Presets should call a stable public module (this file)
// - The wrapper delegates to the lower-level library geometry
//
// This file should NOT contain hard-coded preset values.
// ----------------------------------------------------------------------------

use <../lib/rect_tube_inner_lib.scad>;

// Public “part” module: presets call this.
// Parameters:
// - inner_size: [X_inner, Y_inner, Z_length]  (mm)
// - count: number of tubes in the array
// - wall_xy: wall thickness for X and Y sides (mm)
// - overlap: overlap between tubes along X to avoid seam artifacts (mm)
// - eps: tiny extension for boolean cut (mm)
module rect_tube_array_part(inner_size, count, wall_xy, overlap=0.01, eps=0.01) {
    tube_array_inner(
        inner   = inner_size,
        count   = count,
        wall    = wall_xy,
        overlap = overlap,
        eps     = eps
    );
}
