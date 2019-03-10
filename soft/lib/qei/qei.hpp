#ifndef QEI_HPP
#define QEI_HPP

#include <mbed.h>

// Encoder parameters
#define MAXCOUNT_PERIOD 0xFFFF
#define ENCODER_MODE TIM_ENCODERMODE_TI12

class Qei
{
public:
	Qei(TIM_TypeDef* _TIMx);
	Qei(TIM_TypeDef* _TIMx, int* _err);
	~Qei();
	void reset();
	short getQei();
	short getQei(short* _val);
private:
	TIM_TypeDef* TIMx;
};

#endif
