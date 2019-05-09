#ifndef STRAT_HPP
#define STRAT_HPP

#include "mbed.h"
#include <rgb.hpp>
#include <navigator.hpp>
#include <waypoint.hpp>

#define VIOLET 1
#define YELLOW 0

#define DEBOUNCE_MAX 4096

class Strat {
public:
	Strat(Navigator* const _nav, Odometry* const _odometry,
			RGB* const _rgb);
	~Strat();
	void reset();
	void init(Waypoint* const _wp, DigitalIn* const side,
			DigitalIn* const waiting_key);
	bool run();
	void stop();
private:
	Navigator* const nav;
	Odometry* const odometry;
	RGB* const rgb;
	Waypoint* wp;
	Timer t;
	float t_wp;
};

extern void wp_00a_action(Waypoint** wp, Navigator* nav, float* t_wp);
extern Waypoint wp_00a;

extern void wp_10a_action(Waypoint** wp, Navigator* nav, float* t_wp);
extern Waypoint wp_10a;

extern Waypoint wp_11a;
extern Waypoint wp_12a;
extern Waypoint wp_13a;
extern Waypoint wp_14a;
extern Waypoint wp_15a;
extern Waypoint wp_16a;
extern Waypoint wp_17a;
extern Waypoint wp_18a;
extern Waypoint wp_19a;
extern Waypoint wp_20a;
extern Waypoint wp_21a;
extern Waypoint wp_22a;
extern Waypoint wp_23a;
extern Waypoint wp_24a;
extern Waypoint wp_25a;
extern Waypoint wp_26a;
extern Waypoint wp_27a;
extern Waypoint wp_28a;
extern Waypoint wp_29a;
extern Waypoint wp_30a;
extern Waypoint wp_31a;

#endif

