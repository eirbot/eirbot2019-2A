#ifndef STRAT_HPP
#define STRAT_HPP

#include "mbed.h"
#include <rgb.hpp>
#include <navigator.hpp>
#include <waypoint.hpp>

#define VIOLET 1
#define YELLOW 0

class Strat {
public:
	Strat(Navigator* const _navigator, Odometry* const _odometry,
			RGB* const _rgb);
	~Strat();
	void reset();
	void init(Waypoint* const _wp, DigitalIn* const side,
			DigitalIn* const waiting_key);
	bool run();
	void stop();
private:
	Navigator* const navigator;
	Odometry* const odometry;
	RGB* const rgb;
	Waypoint* wp;
	Timer t;
	float t_wp;
};

extern void wp_init_action(Waypoint* wp, float* t_wp);
extern Waypoint wp_init;

extern void wp_01a_action(Waypoint* wp, float* t_wp);
extern Waypoint wp_01a;

#endif

