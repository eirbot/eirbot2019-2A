#ifndef LMD18200_HPP
#define LMD18200_HPP

#include "mbed.h"
#include <common.hpp>


#define DIR_FORWARD 0
#define DIR_BACKWARD 1
#define BREAK_OFF 0
#define BREAK_ON 1


class LMD18200
{
public:
	LMD18200(PinName _pwm, PinName _dir, PinName _br, bool _dir_fwd,
			float _period);
	~LMD18200();
	float getPwm();
	bool getDir();
	bool getBreak();
	void setPwm(float _pwm);
	void setDirection(bool _dir);
	void setBreak(bool _br);
private:
	bool dir_fwd;
	PwmOut pwm;
	DigitalOut dir;
	DigitalOut br;
};


#endif
