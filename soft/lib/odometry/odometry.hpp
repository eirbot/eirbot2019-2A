
#ifndef NAVIGATOR_HPP
#define NAVIGATOR_HPP

#include <mbed.h>
#include <common.hpp>
#include <qei.hpp>

const float ticks_per_meter = 43723.0f;
const float eps = 0.318f*ticks_per_meter;

#define PERIOD_ODOMETRY 0.0001f

#define PI 3.14159f
#define TWOPI 6.28319f
#define TICKS_PM 22430.0f
#define EPS (TICKS_PM*0.298f)

class Odometry
{
public:
	Odometry(Qei* const _qei_l, Qei* const _block_r);
	~Odometry();
	void reset();
	void start();
	void getPos(float* const _x, float* const _y, float* const _a);
	void setPos(float* const _x, float* const _y, float* const _a);
private:
	void refresh();
	float x;
	float y;
	float a;
	short qei_l_val;
	short qei_r_val;
	Qei* const qei_l;
	Qei* const qei_r;
	Ticker ticker;
};

#endif
