#ifndef STRAT_HPP
#define STRAT_HPP

#include "mbed.h"
#include <rgb.hpp>
#include <navigator.hpp>
#include <waypoint.hpp>
#include <servo.hpp>

#define VIOLET 1
#define YELLOW 0

#define DEBOUNCE_MAX 4096

class Strat {
public:
	Strat(Navigator* const _nav, Odometry* const _odometry, Serial* const _seg,
			RGB* const _rgb);
	~Strat();
	void reset();
	void printSeg();
	void init(Waypoint* const _wp, DigitalIn* const side,
			DigitalIn* const waiting_key);
	bool run();
private:
	Navigator* const nav;
	Odometry* const odometry;
	Serial* const seg;
	RGB* const rgb;
	Waypoint* wp;
	Timer t;
	Ticker ticker;
	float t_wp;
	int points;
};

extern Waypoint wp_00a;
extern int wp_00a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_00z;
extern int wp_00z_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);

extern Waypoint wp_10a;
extern int wp_10a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_11a;
extern int wp_11a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_12a;
extern int wp_12a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_13a;
extern int wp_13a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_14a;
extern int wp_14a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_15a;
extern int wp_15a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);

extern Waypoint wp_20a;
extern int wp_20a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_21a;
extern int wp_21a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_22a;
extern int wp_22a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_23a;
extern int wp_23a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_24a;
extern int wp_24a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_25a;
extern int wp_25a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_26a;
extern int wp_26a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);

extern Waypoint wp_30a;
extern int wp_30a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_31a;
extern int wp_31a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_32a;
extern int wp_32a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_33a;
extern int wp_33a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_34a;
extern int wp_34a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_35a;
extern int wp_35a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);
extern Waypoint wp_36a;
extern int wp_36a_action(Waypoint** wp, Navigator* nav, Timer* t, float* t_wp);

#endif

