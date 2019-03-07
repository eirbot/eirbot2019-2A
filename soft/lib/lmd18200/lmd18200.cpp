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
	SetPwm(0.0f);
	SetDirection(DIR_FORWARD);
	SetBreak(BREAK_OFF);
}

LMD18200::~LMD18200()
{
	
}

void LMD18200::Reset()
{
	SetPwm(0.0f);
	SetDirection(DIR_BACKWARD);
	SetBreak(BREAK_OFF);
}

void LMD18200::Pause()
{
	SetPwm(0.0f);
}

float LMD18200::GetPwm()
{
	return pwm.read();
}

bool LMD18200::GetDir()
{
	return dir;
}

bool LMD18200::GetBreak()
{
	return br;
}

void LMD18200::SetPwm(float _pwm)
{
	float duty = min(_pwm, 1.0f);
	pwm.write(duty);
}

void LMD18200::SetDirection(bool _dir)
{
	dir = (_dir && !dir_fwd) || (!_dir && dir_fwd);
}

void LMD18200::SetBreak(bool _break)
{
	br = _break;
}

