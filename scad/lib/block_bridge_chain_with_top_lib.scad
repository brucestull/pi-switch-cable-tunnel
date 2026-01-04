// scad/lib/block_bridge_chain_with_top_lib.scad
// ----------------------------------------------------------------------------
// LIBRARY: Joined blocks with variable-length bridges + optional full-length top
// Units: millimeters (mm)
//
// This library provides the "engine" module that builds the assembly.
// Presets should not call this directly; they should call the part wrapper in
// scad/parts/.
//
// Coordinate system:
// - Origin is the bottom-left-back corner of the FIRST block.
// - +X runs along the chain of blocks.
// - +Y runs "up" within the block footprint in Y.
// - +Z runs upward (thickness/height).
//
// Concepts:
// - Blocks are identical solids placed along +X.
// - Bridges connect block i to block i+1 with per-bridge X-length.
// - A top cap can span the full assembly in X.
// - Bridge Y placement can be min/center/max or numeric Y start.
// ----------------------------------------------------------------------------


// -----------------------------
// Small utilities (pure functions)
// -----------------------------

// Sum of the first n elements of vector v (safe-clamped).
function sum_first(v, n) =
    (n <= 0) ? 0 :
    (n > len(v)) ? sum_first(v, len(v)) :
    v[n-1] + sum_first(v, n-1);

// Clamp scalar v to [lo, hi].
function clamp(v, lo, hi) = (v < lo) ? lo : (v > hi) ? hi : v;

// Convert a "placement spec" into an explicit Y start coordinate.
// Supported:
// - "min"    -> 0
// - "center" -> (container_y - feature_y)/2
// - "max"    -> (container_y - feature_y)
// - number   -> that number (interpreted as a Y start coordinate)
function resolve_y_start(pos, container_y, feature_y) =
    (pos == "min")    ? 0 :
    (pos == "center") ? (container_y - feature_y) / 2 :
    (pos == "max")    ? (container_y - feature_y) :
                        pos;

// X position (origin) of block i (0-based).
// Includes bridge lengths placed before it, and overlap correction.
function block_origin_x(i, block_size_x, bridge_lengths, join_overlap) =
    i * block_size_x
    + sum_first(bridge_lengths, i)
    - (2 * i * join_overlap);

// X position (origin) of bridge j (0-based), between block j and j+1.
function bridge_origin_x(j, block_size_x, bridge_lengths, join_overlap) =
    block_origin_x(j, block_size_x, bridge_lengths, join_overlap) + block_size_x - join_overlap;

// Total X length of the whole assembly.
function assembly_size_x(block_count, block_size_x, bridge_lengths, join_overlap) =
    (block_count * block_size_x)
    + sum_first(bridge_lengths, block_count - 1)
    - (2 * (block_count - 1) * join_overlap);


// -----------------------------
// Primitive solids (modules)
// -----------------------------
module solid_block(size_xyz) {
    cube(size_xyz, center=false);
}

module solid_bridge(len_x, size_y, size_z) {
    cube([len_x, size_y, size_z], center=false);
}


// ----------------------------------------------------------------------------
// Main builder module (engine)
//
// Parameters map closely to your original script.
// ----------------------------------------------------------------------------
module block_bridge_chain_with_top(
    block_count,
    block_size_xyz,          // [X, Y, Z] for each block
    bridge_size_y,           // thickness of bridge in Y
    bridge_size_z,           // thickness of bridge in Z
    bridge_lengths,          // array length = block_count-1
    bridge_y_pos,            // "min" | "center" | "max" | number (Y start)
    join_overlap=0.01,
    add_top_block=false,
    top_size_y=1,            // thickness of top in Y
    top_size_z=1,            // height of top in Z
    clamp_top_y_to_block=true
) {

    // -----------------------------
    // Safety checks (fail early)
    // -----------------------------
    assert(block_count >= 1, "block_count must be >= 1");
    assert(len(bridge_lengths) == max(block_count - 1, 0),
        "bridge_lengths must have exactly block_count-1 entries");

    assert(bridge_size_y > 0, "bridge_size_y must be > 0");
    assert(bridge_size_y <= block_size_xyz[1], "bridge_size_y must be <= block_size_xyz[1]");
    assert(bridge_size_z > 0, "bridge_size_z must be > 0");

    assert(top_size_y > 0, "top_size_y must be > 0");
    assert(top_size_z > 0, "top_size_z must be > 0");

    // -----------------------------
    // Derived values
    // -----------------------------
    block_size_x = block_size_xyz[0];
    block_size_y = block_size_xyz[1];
    block_size_z = block_size_xyz[2];

    // Resolve + clamp bridge Y start so it stays fully inside the block footprint.
    _raw_bridge_y = resolve_y_start(bridge_y_pos, block_size_y, bridge_size_y);
    bridge_y_start = clamp(_raw_bridge_y, 0, block_size_y - bridge_size_y);

    // Full X size of assembly
    assembly_x = assembly_size_x(block_count, block_size_x, bridge_lengths, join_overlap);

    // Top sits on the tallest Z among block vs bridge
    base_z = max(block_size_z, bridge_size_z);

    // Top block sizing + placement
    top_size_xyz = [assembly_x, top_size_y, top_size_z];

    // Align top’s Y start to bridge’s Y start (same “lane”)
    _raw_top_y = bridge_y_start;
    _top_y_clamped = clamp(_raw_top_y, 0, block_size_y - top_size_y);
    top_y_start = clamp_top_y_to_block ? _top_y_clamped : _raw_top_y;

    // Top spans the full assembly: X=0; Z sits at base_z, with tiny overlap for union cleanliness
    top_pos = [0, top_y_start, base_z - join_overlap];

    // -----------------------------
    // Build geometry
    // -----------------------------
    union() {
        // Blocks
        for (i = [0 : block_count - 1]) {
            translate([block_origin_x(i, block_size_x, bridge_lengths, join_overlap), 0, 0])
                solid_block(block_size_xyz);
        }

        // Bridges (only if there are 2+ blocks)
        for (j = [0 : block_count - 2]) {
            translate([bridge_origin_x(j, block_size_x, bridge_lengths, join_overlap), bridge_y_start, 0])
                solid_bridge(bridge_lengths[j], bridge_size_y, bridge_size_z);
        }

        // Optional full-length top block
        if (add_top_block) {
            translate(top_pos)
                solid_block(top_size_xyz);
        }
    }
}
