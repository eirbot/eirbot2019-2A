/*
 * TODO
 * Documentation
 */

#include <strat.hpp>

Strat::Strat(Navigator* const _navigator, Odometry* const _odometry,
		RGB* const _rgb):
	navigator(_navigator),
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
	navigator->reset();
	t.stop();
	t.reset();
}

void Strat::init(Waypoint* const _wp, DigitalIn* const side,
		DigitalIn* const waiting_key)
	
{
	rgb->setColor(0xff0000);
	wp = _wp;
	odometry->setPos(wp->x, wp->y, wp->a);
	while(!waiting_key);
	while(waiting_key) {
		if (*side == VIOLET) {
			rgb->setColor(0xff00ff);
		} else if (*side == YELLOW) {
			rgb->setColor(0xffff00);
		} else {
			rgb->setColor(0xff8888);
		}
	}
	t.start();
}

bool Strat::run()
{
	wp->action(wp, &t_wp);
	if (wp == NULL || wp->action == NULL) {
		return false;
	} else {
		navigator->setDst(wp->x, wp->y, wp->a);
	}
	return (t.read() < 100.0f);
}

Waypoint wp_init(1.03f, 1.31f, -PI/2, &wp_01a, wp_init_action);
void wp_init_action(Waypoint* wp, float* t_wp){
	*t_wp = 0.0f;
	wp = wp->next;
}

Waypoint wp_01a(1.03f, 1.31f, -PI/2, NULL, wp_init_action);
