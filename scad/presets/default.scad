// scad/presets/default.scad
// ----------------------------------------------------------------------------
// Preset: "Pi ↔ Switch cable tunnel" (DEFAULT)
// Units: millimeters (mm)
//
// What this preset does:
// - Defines the INNER (clear opening) dimensions of a rectangular tube
// - Creates an array of identical tubes along +X (a multi-lane tunnel)
//
// Repo convention:
// - presets/* only set parameters + call a part module
// - parts/* provide a clean public module API
// - lib/* contains reusable geometry + helper functions
// ----------------------------------------------------------------------------

use <../parts/rect_tube_array_spec_inner.scad>;

// -----------------------------
// Preset parameters (EDIT THESE)
// -----------------------------

// Inner (clear opening) dimensions of ONE tube:
// [X_inner, Y_inner, Z_length]
inner_size = [16, 25.4, 115];

// How many tubes in the array (placed along +X)
count = 8;

// Overlap between neighboring tubes (mm).
// Why overlap?
// - When booleans/unions happen, tiny overlaps help avoid seam / non-manifold issues.
// If you ever see artifacts, bump overlap slightly (e.g. 0.2 → 0.5 → 1.0).
overlap = 1;

// Wall thickness on the X and Y sides (mm).
// (Z is the tube length; it stays open at both ends.)
wall_xy = 2;

// Tiny epsilon for boolean cuts (mm).
// Used to extend the inner cutout slightly past the ends to keep it “open”.
eps = 0.01;

// -----------------------------
// Render the model for this preset
// -----------------------------
rect_tube_array_part(
    inner_size = inner_size,
    count      = count,
    wall_xy    = wall_xy,
    overlap    = overlap,
    eps        = eps
);
