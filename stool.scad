/* All measurements in mm and degree angles */
nlegs = 4;

leg_r1 = 45 / 2;
leg_r2 = 20 / 2;

leg_h = 900;
leg_h_cone = 800;


leg_top_r = 200 / 2;
leg_bottom_r = 440 / 2;

leg_tilt = atan((leg_bottom_r - leg_top_r) / leg_h);

base_h = 30;
base_w = 300;
base_r = base_w / 2;

bar_h = 400;

module hbar(len, h=40, w=20) {
	r = 8;

	linear_extrude(len)
		offset(r, $fn=30)
			square([w-2*r, h-2*r], center=true);

	//cube([w, h, 20], center = true);
}

module leg() {

	/* Compute space between legs on top */
	angle_leg = 360 / nlegs;
	r = leg_top_r;
	d = (sin(angle_leg / 2) * r) * 2;

	angle_ext = (180 - angle_leg) / 2;

	rotate([0,0,180 + angle_ext])
		translate([0,-10,0])
			linear_extrude(50)
				square([d, 20]);

	frac = bar_h / leg_h;
	rt = (1-frac) * leg_top_r + frac * leg_bottom_r;
	dt = (sin(angle_leg / 2) * rt) * 2;
	
	away = sin(leg_tilt) * bar_h;

	translate([away,0,0])
		rotate([0,0,180 + angle_ext])
			translate([0,-10,bar_h])
				rotate([90,0,0])
					hbar(len=dt);
				//linear_extrude(30)
				//	offset(r=10)
				//		square([dt, 20]);

	/* Build the circular leg */

	rotate([0,leg_tilt,0])
		rotate_extrude($fn = 80)
			polygon( points=[[0,0],
					[leg_r1, 0],
					[leg_r1, leg_h - leg_h_cone],
					[leg_r2, leg_h],
					[0, leg_h]] );
}

module legs() {
	mirror([0,0,1])
		for (angle = [ 0 : 360/nlegs : 360 ])
			rotate([0,0,angle])
				translate([leg_top_r,0,0])
				leg();
}

// Use % for translucid

cylinder(base_h, base_r, base_r, $fn=120);
legs();

//translate([0,0,-900])
//	cylinder(base_h, leg_bottom_r, leg_bottom_r, $fn=120);


#rotate([0,0,360/nlegs / 2]) {
	translate([50,150,-bar_h])
		sphere(d=100);
	translate([-50,150,-bar_h])
		sphere(d=100);
}
