#ifndef WAYPOINT_HPP
#define WAYPOINT_HPP

#include "mbed.h"
#include <odometry.hpp>
#include <navigator.hpp>

class Waypoint {
public:
	Waypoint();
	Waypoint(float const _x, float const _y, float const _a);
	Waypoint(float const _x, float const _y, float const _a,
			Waypoint* const _next,
			void (*_action)(Waypoint*, Navigator*, float*));
	~Waypoint();
	float const x;
	float const y;
	float const a;
	Waypoint* next;
	void (*action)(Waypoint* wp, Navigator* nav, float* t_wp);
};

#endif

