/*
 * TODO
 * Documentation
 */

#include <strat.hpp>

Waypoint::Waypoint(float const _x, float const _y, float const _a):
	x(_x*TICKS_PM),
	y(_y*TICKS_PM),
	a(abs(_a) > PI ? (_a - sg(a)*2*PI)*TICKS_PRAD : _a * TICKS_PRAD),
	next(NULL),
	action(NULL)
{
}

Waypoint::Waypoint(float const _x, float const _y, float const _a,
		Waypoint* const _next, void* const _action):
	x(_x*TICKS_PM),
	y(_y*TICKS_PM),
	a(abs(_a) > PI ? (_a - sg(a)*2*PI)*TICKS_PRAD : _a * TICKS_PRAD),
	next(_next),
	action(_action)
{
}

Waypoint::~Waypoint()
{
}
