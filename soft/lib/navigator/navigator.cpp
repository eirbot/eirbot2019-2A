/*
 * TODO
 * Documentation
 * Add all constants in config.hpp
 */

#include "navigator.hpp"


Navigator::Navigator(Odometry* _odometry, SpeedBlock* _speed_block):
	odometry(_odometry),
	speed_block(_speed_block)
{
	reset();
}

Navigator::~Navigator()
{
}

void Navigator::reset()
{
	ticker.detach();
	odometry->reset();
	speed_block->reset();
}

void Navigator::start()
{
	odometry->start();
	speed_block->start();
	ticker.attach(callback(this, &Navigator::refresh), PERIOD_POS);
}

void Navigator::setDst(Waypoint* const _dst)
{
	dst = _dst;
	ready_val = false;
}

bool Navigator::ready()
{
	return ready_val;
}

void Navigator::refresh()
{
	float x, y, a;
	odometry->getPos(&x, &y, &a);
	float dx = dst->x - x;
	float dy = dst->y - y;
	float r = sqrtf(pow(dx, 2) + pow(dy, 2));
	float t;
	ready_val = false;
	if (abs(r) > THRESH_DIST) {
		t = TICKS_PRAD * atan2(dy, dx) - a;
		t = (abs(t) > PI*TICKS_PRAD) ? t - sg(t)*TWOPI*TICKS_PRAD : t;
		if (abs(t) > PI/2*TICKS_PRAD) {
			t = t - sg(t)*PI*TICKS_PRAD;
			r = -r;
		}
	} else {
		r = 0.0f;
		t = isNan(a) ? 0.0f : dst->a - a;
		t = (abs(t) > PI*TICKS_PRAD) ? t - sg(t)*TWOPI*TICKS_PRAD : t;
		if (abs(t) < THRESH_ANGLE) {
			t = 0.0f;
			ready_val = true;
		}
	}
	r = sg(r)*min(A_DIST*abs(r), CEIL_DIST);
	t = sg(t)*min(A_ANGLE*abs(t), CEIL_ANGLE);
	speed_block->setSpeed(r-t, r+t);
}
