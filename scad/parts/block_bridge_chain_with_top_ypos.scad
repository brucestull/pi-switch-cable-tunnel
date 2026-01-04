// scad/parts/block_bridge_chain_with_top_ypos.scad
// ----------------------------------------------------------------------------
// PART: Joined blocks with variable-length bridges + optional full-length top,
// with bridge Y placement control.
// Units: mm
//
// Presets should call: block_bridge_chain_with_top_part(...)
//
// This wrapper exists so presets don’t need to know about library internals.
// ----------------------------------------------------------------------------

use <../lib/block_bridge_chain_with_top_lib.scad>;

// Public part module (stable API for presets)
module block_bridge_chain_with_top_part(
    block_count,
    block_size_xyz,
    bridge_size_y,
    bridge_size_z,
    bridge_lengths,
    bridge_y_pos,
    join_overlap=0.01,
    add_top_block=false,
    top_size_y=1,
    top_size_z=1,
    clamp_top_y_to_block=true
) {
    block_bridge_chain_with_top(
        block_count            = block_count,
        block_size_xyz         = block_size_xyz,
        bridge_size_y          = bridge_size_y,
        bridge_size_z          = bridge_size_z,
        bridge_lengths         = bridge_lengths,
        bridge_y_pos           = bridge_y_pos,
        join_overlap           = join_overlap,
        add_top_block          = add_top_block,
        top_size_y             = top_size_y,
        top_size_z             = top_size_z,
        clamp_top_y_to_block   = clamp_top_y_to_block
    );
}
