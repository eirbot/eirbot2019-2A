#include "main.hpp"
#include <mbed.h>
#include <qei.hpp>
#include <lmd18200.hpp>

#ifdef DEBUG
#include <debug.hpp>
#ifdef TRANSFER
#include <testers.hpp>
#endif
#endif


#ifdef DEBUG
int err = NO_ERROR;
Serial ser(USBTX, USBRX);
Qei qei_l(ENCODER_TIM_LEFT, &err);
Qei qei_r(ENCODER_TIM_RIGHT, &err);
#else
Qei qei_l(ENCODER_TIM_LEFT);
Qei qei_r(ENCODER_TIM_RIGHT);
#endif

DigitalOut led = LED2;
LMD18200 motor_l(PWM_L, DIR_L, BREAK_L, DIR_FWD_L, PERIOD_PWM);
LMD18200 motor_r(PWM_R, DIR_R, BREAK_R, DIR_FWD_R, PERIOD_PWM);


int main()
{
#ifdef DEBUG
	led = 1;
	ser.baud(115200);
	wait(3.0f);
	led = 0;
	ser.printf("\r\nstart\r\n");
	ser.printf("error code: %d\r\n", err);
	ser.getc();
#ifdef TRANSFER
	impulse(&ser, &motor_l, &motor_r, &qei_l, &qei_r);
#endif
#endif
	motor_l.setPwm(0.0f);
	motor_r.setPwm(0.0f);
}
