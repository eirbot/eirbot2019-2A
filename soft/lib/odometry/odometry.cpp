/*
 * TODO
 * Documentation
 * Add all constants in config.hpp
 */

#include "odometry.hpp"


Odometry::Odometry(Qei* _qei_l, Qei* _qei_r):
	qei_l(_qei_l),
	qei_r(_qei_r)
{
	reset();
}

Odometry::~Odometry()
{
	
}

void Odometry::reset()
{
	x = 0;
	y = 0;
	a = 0;
	ticker.detach();
}

void Odometry::start()
{
	qei_l_val = qei_l->getQei();
	qei_r_val = qei_r->getQei();
	ticker.attach(callback(this, &Odometry::refresh), PERIOD_ODOMETRY);
}

void Odometry::getPos(float* const _x, float* _y, float* _a)
{
	*_x = x;
	*_y = y;
	*_a = a;
}


void Odometry::setPos(float* _x, float* _y, float* _a)
{
	x = *_x;
	y = *_y;
	a = *_a;
}

void Odometry::refresh()
{
	//float dl = (float)block_l.getQei(qei_l);
	//float dr = (float)block_r.getQei(qei_r);
	float dl = 0.0f;
	float dr = 0.0f;
	float angle = (dr-dl)/EPS;
	float dx = (dl+dr)/2.0f;
	float dy = 0.0f;
	if (abs(angle) > 0.0000175f) {
		float radius = (dl+dr)/2.0f/angle;
		dx = radius*sin(angle);
		dy = radius*(1.0f-cos(angle));
	}
	x += cos(a)*dx - sin(a)*dy;
	y += sin(a)*dx + cos(a)*dy;
	a += angle;
	if (abs(a) > PI) a -= sg(a)*TWOPI;
}
