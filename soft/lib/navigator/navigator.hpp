
#ifndef NAVIGATOR_HPP
#define NAVIGATOR_HPP

#include <mbed.h>
#include <math.h>
#include <common.hpp>
#include <speed_block.hpp>
#include <odometry.hpp>
#include <waypoint.hpp>

#define PERIOD_POS 0.02f

#define A_DIST 0.003f
#define A_ANGLE 0.01f

#define THRESH_DIST (0.01f*TICKS_PM)
#define THRESH_ANGLE (PI/64*TICKS_PRAD)

#define CEIL_DIST 50
#define CEIL_ANGLE 50

class Navigator
{
public:
	Navigator(Odometry* odometry, SpeedBlock* _speed_block);
	~Navigator();
	void reset();
	void start();
	void setDst(Waypoint* const _dst);
	bool ready();
private:
	void refresh();
	Waypoint* dst;
	bool ready_val;
	Odometry* const odometry;
	SpeedBlock* const speed_block;
	Ticker ticker;
};

#endif
