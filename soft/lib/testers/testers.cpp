/*
 * TODO
 * -
 */


#include "testers.hpp"


void transfer(Serial* ser, LMD18200* motor_l, LMD18200* motor_r,
		Qei* qei_l, Qei* qei_r)
{
	float t = 0.0f;
	short val_l = qei_l->getQei();
	short val_r = qei_r->getQei();
	float dl = 0.0f;
	float dr = 0.0f;
	Timer t_timer;
	ser->printf("impulse response parameters:\n\r");
	ser->printf("t1: %fs, pwm1: %f, t2:%fs, pwm2: %f\n\r", T1, PWM1, T2, PWM2);
	ser->printf("pattern:\n\rt\tdl\tdr\n\r");
	ser->printf("starting impulse response...\n\r");
	ser->getc();
	t_timer.start();
	motor_l->setPwm(PWM1);
	motor_r->setPwm(PWM1);
	while (t < T1 && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\t%f", t, dl, dr);
	}
	motor_l->setPwm(PWM2);
	motor_r->setPwm(PWM2);
	while (t < T2 && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\t%f", t, dl, dr);
	}
	motor_l->setPwm(0.0f);
	motor_r->setPwm(0.0f);
}
