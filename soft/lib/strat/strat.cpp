/*
 * TODO
 * Documentation
 */

#include <strat.hpp>

Strat::Strat(Navigator* const _nav, Odometry* const _odometry,
		RGB* const _rgb):
	nav(_nav),
	odometry(_odometry),
	rgb(_rgb)
{
	reset();
}

Strat::~Strat()
{
}

void Strat::reset()
{
	rgb->off();
	nav->reset();
	t.stop();
	t.reset();
}

void Strat::init(Waypoint* const _wp, DigitalIn* const side,
		DigitalIn* const waiting_key)
	
{
	rgb->setColor(1, 0, 0);
	wp = _wp;
	odometry->setPos(wp->x, wp->y, wp->a);
	while(!*waiting_key);
	while(*waiting_key) {
		if (*side == VIOLET) {
			rgb->setColor(1, 0, 1);
		} else if (*side == YELLOW) {
			rgb->setColor(1, 1, 0);
		} else {
			rgb->setColor(1, 0, 0);
		}
	}
	t.start();
}

bool Strat::run()
{
	wp->action(wp, nav, &t_wp);
	if (wp == NULL || wp->action == NULL) {
		return true;
	} else {
		nav->setDst(wp->x, wp->y, wp->a);
	}
	return true; //(t.read() < 100.0f);
}

Waypoint wp_00a(1.03f, 1.31f, -PI/2, &wp_10a, wp_00a_action);
void wp_00a_action(Waypoint* wp, Navigator* nav, float* t_wp){
	*t_wp = 0.0f;
	wp = wp->next;
}

Waypoint wp_10a(1.10f, 0.85f, 0.85f*PI, &wp_11a, wp_10a_action);
Waypoint wp_11a(0.85f, 0.95f, NAN, &wp_12a, wp_10a_action);
Waypoint wp_12a(0.58f, 1.32f, NAN, &wp_13a, wp_10a_action);
Waypoint wp_13a(0.69f, 0.95f, -PI, &wp_14a, wp_10a_action);
Waypoint wp_14a(0.45f, 0.95f, 0.54f*PI, &wp_15a, wp_10a_action);
Waypoint wp_15a(0.44f, 1.30f, NAN, &wp_16a, wp_10a_action);
Waypoint wp_16a(0.79f, 0.15f, 0.06f*PI, &wp_17a, wp_10a_action);
Waypoint wp_17a(1.37f, 0.29f, 0.77f*PI, &wp_18a, wp_10a_action);
Waypoint wp_18a(0.51f, 1.17f, NAN, &wp_19a, wp_10a_action);
Waypoint wp_19a(1.38f, 0.24f, -0.97f*PI, &wp_20a, wp_10a_action);
Waypoint wp_20a(1.03f, 0.22f, 0.63f*PI, &wp_21a, wp_10a_action);
Waypoint wp_21a(0.51f, 0.73f, NAN, &wp_22a, wp_10a_action);
Waypoint wp_22a(0.51f, 1.11f, NAN, &wp_23a, wp_10a_action);
Waypoint wp_23a(0.66f, 0.75f, NAN, &wp_24a, wp_10a_action);
Waypoint wp_24a(0.28f, -0.13f, 0.50f*PI, &wp_25a, wp_10a_action);
Waypoint wp_25a(0.28f, -0.27f, NAN, &wp_26a, wp_10a_action);
Waypoint wp_26a(0.42f, -0.77f, 1.00f*PI, &wp_27a, wp_10a_action);
Waypoint wp_27a(0.32f, -0.75f, 1.00f*PI, &wp_28a, wp_10a_action);
Waypoint wp_28a(0.42f, -0.75f, 0.29f*PI, &wp_29a, wp_10a_action);
Waypoint wp_29a(1.28f, 0.23f, -0.06f*PI, &wp_30a, wp_10a_action);
Waypoint wp_30a(1.44f, 0.19f, -0.06f*PI, &wp_31a, wp_10a_action);
Waypoint wp_31a(1.00f, 0.00f, 0.00f*PI, NULL, wp_10a_action);

void wp_10a_action(Waypoint* wp, Navigator* nav, float* t_wp){
	if (nav->ready()) {
		*t_wp = 0.0f;
		wp = wp->next;
	}
}
