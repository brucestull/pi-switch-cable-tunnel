// scad/presets/block_bridge_chain_with_top_ypos_example.scad
// ----------------------------------------------------------------------------
// Preset example for the block/bridge chain part.
// Units: mm
// ----------------------------------------------------------------------------

use <../parts/block_bridge_chain_with_top_ypos.scad>;

// -----------------------------
// High-level “design intent” variables
// -----------------------------
STOCK_Z          = 3;     // formerly ELEMENT_THICKNESS
BRIDGE_SIZE_Y    = 9;     // formerly ELEMENT_WIDTH (used as bridge thickness in Y)

// -----------------------------
// Block + bridge definition
// -----------------------------
BLOCK_COUNT      = 6;

// Each block is [X, Y, Z]
BLOCK_SIZE_XYZ   = [20, 66, STOCK_Z];

// Bridge cross-section (Y thickness, Z thickness)
BRIDGE_SIZE_Z    = STOCK_Z;

// Where the bridge starts in Y:
// - "min" | "center" | "max" | numeric Y start
BRIDGE_Y_START   = 37.5;

// Per-bridge X lengths (must be BLOCK_COUNT - 1 entries)
BRIDGE_LENGTHS   = [18, 14, 18, 18, 18];

// Small overlap to ensure clean unions
JOIN_OVERLAP     = 0.01;

// -----------------------------
// Optional top cap
// -----------------------------
ADD_TOP_BLOCK            = true;

// Top block dimensions (X auto computed to span entire assembly)
TOP_SIZE_Y               = 3;

// Your original logic: top Z derived from “bridge width minus thickness”.
// Keep it explicit here so it’s not mysterious.
TOP_SIZE_Z               = BRIDGE_SIZE_Y - STOCK_Z;

// Clamp top Y so it stays within the block footprint (recommended true)
CLAMP_TOP_Y_TO_BLOCK     = true;

// -----------------------------
// Render
// -----------------------------
block_bridge_chain_with_top_part(
    block_count          = BLOCK_COUNT,
    block_size_xyz       = BLOCK_SIZE_XYZ,
    bridge_size_y        = BRIDGE_SIZE_Y,
    bridge_size_z        = BRIDGE_SIZE_Z,
    bridge_lengths       = BRIDGE_LENGTHS,
    bridge_y_pos         = BRIDGE_Y_START,
    join_overlap         = JOIN_OVERLAP,
    add_top_block        = ADD_TOP_BLOCK,
    top_size_y           = TOP_SIZE_Y,
    top_size_z           = TOP_SIZE_Z,
    clamp_top_y_to_block = CLAMP_TOP_Y_TO_BLOCK
);
