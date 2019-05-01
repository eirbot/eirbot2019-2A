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
	motor_l->setDirection(DIR_FORWARD);
	motor_r->setDirection(DIR_FORWARD);
	ser->printf("impulse response parameters:\n\r");
	ser->printf("t1: %fs, pwm1: %f, t2:%fs, pwm2: %f\n\r",
			T1_transfer, PWM1, T2_transfer, PWM2);
	ser->printf("pattern:\n\rt\tdl\tdr\n\r");
	ser->printf("starting impulse response...\n\r");
	ser->getc();
	t_timer.start();
	motor_l->setPwm(PWM1);
	motor_r->setPwm(PWM1);
	while (t < T1_transfer && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\t%f\n\r", t, dl, dr);
	}
	motor_l->setPwm(PWM2);
	motor_r->setPwm(PWM2);
	while (t < T2_transfer && !ser->readable()) {
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
	ser->printf("t1: %fs, pwm1: %f, t2:%fs, pwm2: %f\n\r",
			T1_transfer, PWM1, T2_transfer, PWM2);
	ser->printf("starting left motor impulse response...\n\r");
	ser->getc();
	t_timer.start();
	motor_l->setPwm(PWM1);
	while (t < T1_transfer && !ser->readable()) {
		t = t_timer.read();
		dl = qei_l->getQei(&val_l);
		ser->printf("%f\t%f\n\r", t, dl);
	}
	motor_l->setPwm(PWM2);
	while (t < T2_transfer && !ser->readable()) {
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
	while (t < T1_transfer && !ser->readable()) {
		t = t_timer.read();
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\n\r", t, dr);
	}
	motor_r->setPwm(PWM2);
	while (t < T2_transfer && !ser->readable()) {
		t = t_timer.read();
		dr = qei_r->getQei(&val_r);
		ser->printf("%f\t%f\n\r", t, dr);
	}
	motor_r->setPwm(0.0f);
}

void pid_test(Serial* const ser, SpeedBlock* const speed_block)
{
	float t = 0.0f;
	float SPspeed_l = 1.0f;
	float SPspeed_r = 1.0f;
	float PVspeed_l = 0.0f;
	float PVspeed_r = 0.0f;
	float pwm_l = 0.0f;
	float pwm_r = 0.0f;
	ser->printf("pattern:\n\riteration\tSPspeed_l\tPVspeed_l\tpwm_l\t\t"
			"SPspeed_r\tPVspeed_r\tpwm_r\n\r");
	ser->printf("starting speed test...\n\r");
	speed_block->setSpeed(SPspeed_l, SPspeed_r);
	ser->getc();
	while (1) {
		speed_block->getPVspeed(&PVspeed_l, &PVspeed_r);
		speed_block->getPWM(&pwm_l, &pwm_r);
		ser->printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\n\r",
				t, SPspeed_l, PVspeed_l, pwm_l, SPspeed_r, PVspeed_r, pwm_r);
		t += 0.003f;
		speed_block->refresh();
		ser->getc();
	}
}

void speed_test(Serial* const ser, SpeedBlock* const speed_block)
{
	float t = 0.0f;
	float SPspeed_l = 50.0f;
	float SPspeed_r = 50.0f;
	float PVspeed_l = 0.0f;
	float PVspeed_r = 0.0f;
	float pwm_l = 0.0f;
	float pwm_r = 0.0f;
	Timer t_timer;
	ser->printf("pattern:\n\rtime\t\tSPspeed_l\tPVspeed_l\tpwm_l\t\t"
			"SPspeed_r\tPVspeed_r\tpwm_r\n\r");
	ser->printf("starting speed test...\n\r");
	ser->printf("starting translation test...\n\r");
	ser->getc();
	t_timer.start();
	speed_block->start();
	while (!ser->readable()) {
		t = t_timer.read();
		speed_block->getPVspeed(&PVspeed_l, &PVspeed_r);
		speed_block->getPWM(&pwm_l, &pwm_r);
		ser->printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\n\r",
				t, SPspeed_l, PVspeed_l, pwm_l, SPspeed_r, PVspeed_r, pwm_r);
		//SPspeed_l = min(SPspeed_l + DELTA_V, MAX_SP);
		//SPspeed_r = min(SPspeed_r + DELTA_V, MAX_SP);
		speed_block->setSpeed(SPspeed_l, SPspeed_r);
		wait(0.01f);
	}
	ser->getc();
	speed_block->reset();
	ser->printf("starting rotation test...\n\r");
	t_timer.stop();
	t_timer.reset();
	SPspeed_l = 0.0f;
	SPspeed_r = 0.0f;
	ser->getc();
	t_timer.start();
	speed_block->start();
	while (!ser->readable()) {
		t = t_timer.read();
		speed_block->getPVspeed(&PVspeed_l, &PVspeed_r);
		speed_block->getPWM(&pwm_l, &pwm_r);
		ser->printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\n\r",
				t, SPspeed_l, PVspeed_l, pwm_l, SPspeed_r, PVspeed_r, pwm_r);
		SPspeed_l = min(SPspeed_l + DELTA_V, MAX_SP);
		SPspeed_r = -min(-SPspeed_r + DELTA_V, MAX_SP);
		speed_block->setSpeed(SPspeed_l, SPspeed_r);
		wait(0.1f);
	}
	speed_block->reset();
}

void square(Serial* const ser, SpeedBlock* const speed_block)
{
	float SPspeed;
	Timer t_timer;
	ser->printf("starting square example...\n\r");
	t_timer.start();
	speed_block->start();
	while (!ser->readable()) {
		speed_block->setSpeed(0.0f, 0.0f);
		SPspeed = 0.0f;
		t_timer.reset();
		while (t_timer.read() < 1.0f && !ser->readable());
		t_timer.reset();
		while (t_timer.read() < 2.5f && !ser->readable())
		{
			SPspeed = min(SPspeed + DELTA_V, MAX_SP);
			speed_block->setSpeed(SPspeed, SPspeed);
		}
		speed_block->setSpeed(0.0f, 0.0f);
		SPspeed = 0.0f;
		t_timer.reset();
		while (t_timer.read() < 1.0f && !ser->readable());
		t_timer.reset();
		while (t_timer.read() < 0.85f && !ser->readable())
		{
			SPspeed = min(SPspeed + DELTA_V, MAX_SP);
			speed_block->setSpeed(SPspeed, -SPspeed);
		}
	}
	speed_block->reset();
}

void test_odometry(Serial*const ser, Odometry* const odometry)
{
	float x = 0;
	float y = 0;
	float a = 0;
	odometry->reset();
	odometry->start();
	ser->printf("starting odometry test...\n\r");
	ser->printf("pattern:\n\rx\t\ty\t\ta\t\tx(m)\t\ty(m)\t\ta(pi.rad)\n\r");
	ser->getc();
	while (!ser->readable()) {
		odometry->getPos(&x, &y, &a);
		ser->printf("%8f\t%8f\t%8f\t%8f\t%8f\t%f\r", x, y, a, x/TICKS_PM, y/TICKS_PM, a/TICKS_PRAD/PI);
	}
	odometry->reset();
}
