/*
 * TODO
 * -
 */


#include "testers.hpp"


void length_calibration(Serial* const ser, Qei* const qei_l, Qei* const qei_r)
{
	short val_l = qei_l->getQei();
	short val_r = qei_r->getQei();
	float dl = 0.0f;
	float dr = 0.0f;
	float length = 0.0f;
	ser->printf("length measurement parameters:\n\r");
	ser->printf("L: %fm\n\r", LENGTH_TEST);
	ser->printf("pattern:\tdl+dr/2\tlength\n\r");
	ser->printf("starting length measurement...\n\r");
	ser->getc();
	while (!ser->readable()) {
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		length += (dl+dr)/2;
		ser->printf("%f\t%f\n\r",  dl+dr/2, length);
	}
}

void angle_calibration(Serial* const ser, Qei* const qei_l, Qei* const qei_r)
{
	short val_l = qei_l->getQei();
	short val_r = qei_r->getQei();
	float dl = 0.0f;
	float dr = 0.0f;
	float angle = 0.0f;
	ser->printf("angle measurement parameters:\n\r");
	ser->printf("A: %fPI rad\n\r", ANGLE_TEST);
	ser->printf("pattern:\tdl+dr/2\tangle\n\r");
	ser->printf("starting angle measurement...\n\r");
	ser->getc();
	while (!ser->readable()) {
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		angle += (dl-dr)/2;
		ser->printf("%f\t%f\n\r",  dl-dr/2, angle);
	}
}

void transfer(Serial* const ser, LMD18200* const motor_l,
		LMD18200* const motor_r, Qei* const qei_l, Qei* const qei_r)
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
		ser->printf("%f\t%f\t%f\n\r", t, dl, dr);
	}
	motor_l->setPwm(PWM2);
	motor_r->setPwm(PWM2);
	while (t < T2 && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\t%f\n\r", t, dl, dr);
	}
	motor_l->setPwm(0.0f);
	motor_r->setPwm(0.0f);
}

void transfer2(Serial* const ser, LMD18200* const motor_l,
		LMD18200* const motor_r, Qei* const qei_l, Qei* const qei_r)
{
	float t = 0.0f;
	short val_l = qei_l->getQei();
	float dl = 0.0f;
	Timer t_timer;
	ser->printf("impulse response parameters:\n\r");
	ser->printf("t1: %fs, pwm1: %f, t2:%fs, pwm2: %f\n\r", T1, PWM1, T2, PWM2);
	ser->printf("starting left motor impulse response...\n\r");
	ser->getc();
	t_timer.start();
	motor_l->setPwm(PWM1);
	while (t < T1 && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		ser->printf("%f\t%f\n\r", t, dl);
	}
	motor_l->setPwm(PWM2);
	while (t < T2 && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		ser->printf("%f\t%f\n\r", t, dl);
	}
	short val_r = qei_r->getQei();
	float dr = 0.0f;
	motor_l->setPwm(0.0f);
	t_timer.stop();
	t_timer.reset();
	ser->printf("starting right motor impulse response...\n\r");
	ser->getc();
	t = t_timer.read();
	t_timer.start();
	motor_r->setPwm(PWM1);
	while (t < T1 && !ser->readable()) {
		t = t_timer.read();
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\n\r", t, dr);
	}
	motor_r->setPwm(PWM2);
	while (t < T2 && !ser->readable()) {
		t = t_timer.read();
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\n\r", t, dr);
	}
	motor_r->setPwm(0.0f);
}
