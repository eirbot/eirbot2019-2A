#ifndef WAYPOINT_HPP
#define WAYPOINT_HPP

#include "mbed.h"
#include <odometry.hpp>

class Waypoint {
public:
	Waypoint(float const _x, float const _y, float const _a);
	Waypoint(float const _x, float const _y, float const _a,
			Waypoint* const _next, void* const _action);
	~Waypoint();
	float const x;
	float const y;
	float const a;
	Waypoint* next;
	void* const action;
};

#endif

