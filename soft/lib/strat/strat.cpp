/*
 * TODO
 * Documentation
 */

#include <strat.hpp>

Strat::Strat(Navigator* const _nav, Odometry* const _odometry,
		Serial* const _seg, RGB* const _rgb):
	nav(_nav),
	odometry(_odometry),
	seg(_seg),
	rgb(_rgb)
{
	reset();
	ticker.attach(callback(this, &Strat::printSeg), 0.5);
}

Strat::~Strat()
{
}

void Strat::reset()
{
	side = false;
	rgb->off();
	nav->reset();
	t.stop();
	t.reset();
}

void Strat::printSeg()
{
	seg->printf("%3.3d", points);
}

void Strat::init(DigitalIn* const side_switch, DigitalIn* const waiting_key)
{
	rgb->setColor(1, 0, 0);
	points = 127;
	unsigned int debounce_counter = 0;
	while(debounce_counter < DEBOUNCE_MAX) {
		debounce_counter += !waiting_key->read();
	}
	debounce_counter = 0;
	while(debounce_counter < DEBOUNCE_MAX) {
		if (side_switch->read() == VIOLET) {
			rgb->setColor(1, 0, 1);
		} else if (side_switch->read() == YELLOW) {
			rgb->setColor(1, 1, 0);
		} else {
			rgb->setColor(1, 0, 0);
		}
		debounce_counter += waiting_key->read();
	}
	side = side_switch->read();
	wp = &wp_00a;
	if (side == VIOLET) {
		odometry->setPos(wp->x, wp->y, wp->a);
	} else {
		odometry->setPos(wp->x, -wp->y, -wp->a);
	}
	points = 0;
	nav->start();
	t.start();
}

bool Strat::run()
{
	points += wp->action(&wp, nav, &t, &t_wp);
	if (wp == NULL || wp->action == NULL) {// || t.read() > 98.0f) {
		points += 35;
		return false;
	} else {
		if (side == VIOLET) {
			nav->setDst(wp->x, wp->y, wp->a);
		} else {
			nav->setDst(wp->x, -wp->y, -wp->a);
		}
		return true;
	}
}

// Init point
Waypoint wp_00a(0.7085f, 1.3165f, -PI/2, &wp_10a, wp_00a_action);
int wp_00a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	*t_wp = t->read();
	*wp = (*wp)->next;
	return 5;
}

// Finish
Waypoint wp_00z(0.850f, 1.250f, PI/2, NULL, wp_00z_action);
int wp_00z_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = NULL;
	}
	return 0;
}

// Get the puck before the blue area
Waypoint wp_10a(0.995f, 1.049f, -0.80f*PI, &wp_11a, wp_10a_action);
int wp_10a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Get the puck before the green area
Waypoint wp_11a(0.859f, 0.966f, NAN, &wp_12a, wp_11a_action);
int wp_11a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Go inside the red area
Waypoint wp_12a(0.537f, 1.303f, NAN, &wp_13a, wp_12a_action);
int wp_12a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 2;
	}
	return 0;
}

// Get the puck before the red area
Waypoint wp_13a(0.689f, 0.976f, -1.00f*PI, &wp_14a, wp_13a_action);
int wp_13a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Push it
Waypoint wp_14a(0.509f, 0.974f, 0.50f*PI, &wp_15a, wp_14a_action);
int wp_14a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Go inside the red area
Waypoint wp_15a(0.500f, 1.219f, NAN, &wp_20a, wp_15a_action);
int wp_15a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 11;
	}
	return 0;
}

// Go back to 1st pass on storm pucks
Waypoint wp_20a(0.790f, 0.150f, 0.00f*PI, &wp_21a, wp_20a_action);
int wp_20a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Place behind the storm
Waypoint wp_21a(1.370f, 0.290f, 0.77f*PI, &wp_22a, wp_21a_action);
int wp_21a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Push the pucks in the red area
Waypoint wp_22a(0.510f, 1.170f, NAN, &wp_23a, wp_22a_action);
int wp_22a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 2;
	}
	return 0;
}

// Go back to the storm
Waypoint wp_23a(1.380f, 0.240f, -1.00f*PI, &wp_24a, wp_23a_action);
int wp_23a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Replace to grab pucks
Waypoint wp_24a(1.030f, 0.220f, 0.63f*PI, &wp_25a, wp_24a_action);
int wp_24a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Push pucks near the red area
Waypoint wp_25a(0.510f, 0.730f, NAN, &wp_26a, wp_25a_action);
int wp_25a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Go in the red area
Waypoint wp_26a(0.510f, 1.110f, NAN, &wp_30a, wp_26a_action);
int wp_26a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 12;
	}
	return 0;
}

// Go next to the accelerator
Waypoint wp_30a(0.288f, -0.105f, 0.00f*PI, &wp_31a, wp_30a_action);
int wp_30a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	servoSetPwmDuty(SERVO_INIT);
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Push atom downto accelerator
Waypoint wp_31a(0.140f, -0.105f, NAN*PI, &wp_32a, wp_31a_action);
int wp_31a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	static unsigned int state = 0;
	if (state == 0 && (t->read() - *t_wp) > 1.5f) {
		*t_wp = t->read();
		servoSetPwmDuty(SERVO_LEFT);
		state = 1;
	} else if (state == 1 && (t->read() - *t_wp) > 0.7f) {
		*t_wp = t->read();
		servoSetPwmDuty(SERVO_RIGHT);
		state = 2;
	} else if (state == 2 && (t->read() - *t_wp) > 0.7f) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		servoSetPwmDuty(SERVO_INIT);
		state = 0;
		return 20;
	}
	return 0;
}

// Go away from the wall
Waypoint wp_32a(0.250, -0.105f, NAN*PI, &wp_33a, wp_32a_action);
int wp_32a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	servoSetPwmDuty(SERVO_INIT);
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Go in front of goldonium
Waypoint wp_33a(0.250f, -0.640f, -1.00f*PI, &wp_34a, wp_33a_action);
int wp_33a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Grab goldonium
Waypoint wp_34a(0.140f, -0.640f, NAN*PI, &wp_35a, wp_34a_action);
int wp_34a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	activatePump();
	if (nav->ready() || (t->read() - *t_wp) > 3.0f) {
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 20;
	}
	return 0;
}

// Go back
Waypoint wp_35a(0.445f, -0.735f, -1.00f*PI, &wp_40a, wp_35a_action);
int wp_35a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Go to the scale
Waypoint wp_40a(1.350f, 0.290f, -0.16f*PI, &wp_41a, wp_40a_action);
int wp_40a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		*t_wp = t->read();
		*wp = (*wp)->next;
	}
	return 0;
}

// Put goldonium into the scale
Waypoint wp_41a(1.436f, 0.200f, NAN, &wp_00z, wp_41a_action);
int wp_41a_action(Waypoint** wp, Navigator* nav, Timer* t,
		float* t_wp){
	if (nav->ready()) {
		releasePump();
		*t_wp = t->read();
		*wp = (*wp)->next;
		return 24;
	}
	return 0;
}
