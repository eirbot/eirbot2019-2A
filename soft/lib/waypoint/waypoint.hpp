#ifndef WAYPOINT_HPP
#define WAYPOINT_HPP

#include "mbed.h"
#include <odometry.hpp>

class Waypoint {
public:
	Waypoint();
	Waypoint(float const _x, float const _y, float const _a);
	Waypoint(float const _x, float const _y, float const _a,
			Waypoint* const _next, void (*_action)(Waypoint*, float*));
	~Waypoint();
	float const x;
	float const y;
	float const a;
	Waypoint* next;
	void (*action)(Waypoint* wp, float* t_wp);
};

#endif

