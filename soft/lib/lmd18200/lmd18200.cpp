/*
 * TODO
 * Documentation
 */

#include "lmd18200.hpp"


LMD18200::LMD18200(PinName _pwm, PinName _dir, PinName _br, bool _dir_fwd,
		float _period):
	pwm(_pwm),
	dir(_dir),
	br(_br)
{
	dir_fwd = _dir_fwd;
	pwm.period(_period);
	setPwm(0.0f);
	setDirection(DIR_FORWARD);
	setBreak(BREAK_OFF);
}

LMD18200::~LMD18200()
{
	
}

float LMD18200::getPwm()
{
	return pwm.read();
}

bool LMD18200::getDir()
{
	return dir;
}

bool LMD18200::getBreak()
{
	return br;
}

void LMD18200::setPwm(float _duty)
{
	float duty = min(_duty, 1.0f);
	pwm.write(duty);
}

void LMD18200::setDirection(bool _dir)
{
	dir = (_dir && !dir_fwd) || (!_dir && dir_fwd);
}

void LMD18200::setBreak(bool _break)
{
	br = _break;
}

