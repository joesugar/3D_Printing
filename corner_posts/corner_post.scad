module corner(
    square_size, square_diameter, 
    wall_spacing, wall_length, wall_width)
{
    /* Calculate required intermediate variables
     */
    square_radius = square_diameter / 2;
    wall_offset_lateral = (square_size / 2) - (wall_spacing / 2) - wall_width;
    wall_length_adjusted = wall_length - square_radius;

    /* Define the walls intended to hold the case sides.
     */
    module _walls(length, width, spacing)
    {
        translate(v=[length / 2, -((width + spacing)/2), 0])
            square([length, width], true);
        translate(v=[length / 2,  ((width + spacing)/2), 0])
            square([length, width], true);
    }

    /* Define a square with a couple of rounded corners.
     */
    module _rounded_square(size)
    {
        hull() {
            circle(d = size, center = true);
            translate([-(size / 4),  (size / 4)])
                square(size / 2, center = true);
            translate([ (size / 4), -(size / 4)])
                square(size / 2, center = true);
            translate([-(size / 4), -(size / 4)])
                square(size / 2, center = true);
        }
    }

    /* Define the object that makes up the corner
     * with the hole.
     */
    module _corner(size, radius)
    {
        difference() {
            _rounded_square(size);
            circle(d = radius, center = true);
        }
    }

    /* Define the complete object.
     */
    union() {
        _corner(square_size, square_diameter);
        translate(v=[square_radius, -wall_offset_lateral, 0])
            rotate([0, 0, 0])
                _walls(wall_length_adjusted, wall_width, wall_spacing);
        translate(v=[-wall_offset_lateral, square_radius, 0])
            rotate([0, 0, 90])
                _walls(wall_length_adjusted, wall_width, wall_spacing);
    }
}

/* Main routine.
 */
module main() 
{
    /* Define the scales used for exporting the object.
     * Each value converts a measure to mm.
     *
     * These values are particular to the Solidoodle, which 
     * makes each voxel = 1 mm^3.  If you have a printer that
     * uses a different value they will have to be adjusted.
     *
     * Note:  scale is an operation applied to the figure, not a 
     *        setting for the program.  That's why there's no 
     *        semicolon after the command.
     */
    SCALE_64_TO_MM   = 25.4 / 64;
    SCALE_MILS_TO_MM = 25.4 / 1000;
    SCALE_MM_TO_MM   = 1.0;
    SCALE_CM_TO_MM   = 10.0;
    SCALE_IN_TO_MM   = 25.4;

    /* Set the number of segments used to render a cylinder.
     */ 
    $fn = 12;   // 12 segments for a cylinder

    /* Parametric values defining the object.
     */
    wall_spacing    = 48 * SCALE_MILS_TO_MM;    // spacing between the guide walls
    wall_width      = 80 * SCALE_MILS_TO_MM;    // guide wall thickness
    wall_length     = .375 * SCALE_IN_TO_MM;    // guide wall length

    corner_size     = .25 * SCALE_IN_TO_MM;     // corner wall size (must be bigger than diameter)
    corner_diameter = 2.6 * SCALE_MM_TO_MM;     // corner hole diameter
 
     /* Create the object.
     */
    linear_extrude(height=2 * SCALE_IN_TO_MM)
    {
        corner(
            corner_size, corner_diameter, 
            wall_spacing, wall_length, wall_width);
    }
}

/* Call main routine.
 */
main();
