# Pi ↔ Switch Cable Tunnel (OpenSCAD)

A parametric OpenSCAD model that creates a “cable tunnel” / rectangular tube array
to route Ethernet cables cleanly between a stack of Raspberry Pis and a network switch.
It can also be used as part of a mounting / organizing system.

This repo is public so friends/family can print it, remix it, or adapt it.

> Units: millimeters (mm)

## What it does

- Generates an array of identical rectangular tubes along +X.
- The **specified dimensions are the INNER opening** (clearance) of each tube.
- Tube length is along Z.

## Quick start

### Option A: Use the preset (recommended)
Open:

- `scad/presets/default.scad`

Press **F5** (Preview) or **F6** (Render), then export STL.

### Option B: Edit parameters directly
In `scad/presets/default.scad`:

- `inner_size = [X_inner, Y_inner, Z_length];`
- `count      = number_of_tubes;`
- `wall_xy    = wall_thickness;`
- `overlap    = overlap_between_tubes;`

## Parameters

- `inner_size`: inner opening dimensions `[X, Y, Z]`
- `count`: number of tubes in the array
- `wall_xy`: wall thickness in X and Y
- `overlap`: overlap between adjacent tube outer shells to avoid boolean seams
- `eps`: tiny extra to keep tube ends clean/open after boolean ops

## Printing notes (general)

- Consider printing with the tube length (Z) aligned to your printer’s strongest direction.
- If you change `wall_xy`, check your slicer preview for thin walls.

## Images

![OpenSCAD preview](docs/images/openscad_preview.png)

(Optional)
![Installed](docs/images/installed_photo.jpg)

## Exports (STLs)

This repo may include some example STLs under `exports/`.
The “official” downloadable STLs for each version are also attached to GitHub Releases.

## License

Choose a license that matches your intent (MIT is common for OpenSCAD projects).
See `LICENSE`.
