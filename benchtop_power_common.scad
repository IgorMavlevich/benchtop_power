corner_radius = 2.5;
board_size = [132.5, 48];
bolt_distance = [122, 38.5];

switch_position=[-39.5,19.5,0];

terminal_count = 8;
terminal_spacing = 103/(terminal_count-1);

$fs = 0.1;

board_corners = [[board_size[0]/2-corner_radius,board_size[1]/2-corner_radius,0],
                [-board_size[0]/2+corner_radius,board_size[1]/2-corner_radius,0],
                [-board_size[0]/2+corner_radius,-board_size[1]/2+corner_radius,0],
                 [board_size[0]/2-corner_radius,-board_size[1]/2+corner_radius,0]];
bolts_pos = [[bolt_distance[0]/2,bolt_distance[1]/2,0],
            [-bolt_distance[0]/2,bolt_distance[1]/2,0],
            [-bolt_distance[0]/2,-bolt_distance[1]/2,0],
             [bolt_distance[0]/2,-bolt_distance[1]/2,0]];