#include "main.hpp"
#include <mbed.h>
#include <qei.hpp>
#include <lmd18200.hpp>
#include <pid.hpp>

#ifdef DEBUG
#include <debug.hpp>
#include <testers.hpp>
#endif


#ifdef DEBUG
int err = NO_ERROR;
Serial ser(USBTX, USBRX);
#else
int err = 0;
#endif

float coef_err_l[] = {0.0f, 0.0f, 0.0f, 0.0f};
float coef_sp_l[] = {0.0f, 0.0f, 0.0f, 0.0f};
float coef_err_r[] = {0.0f, 0.0f, 0.0f, 0.0f};
float coef_sp_r[] = {0.0f, 0.0f, 0.0f, 0.0f};

DigitalOut led = LED2;
LMD18200 motor_l(PWM_L, DIR_L, BREAK_L, DIR_FWD_L, PERIOD_PWM);
LMD18200 motor_r(PWM_R, DIR_R, BREAK_R, DIR_FWD_R, PERIOD_PWM);
Qei qei_l(ENCODER_TIM_LEFT, &err);
Qei qei_r(ENCODER_TIM_RIGHT, &err);
Pid pid_l(coef_err_l, NB_COEF_ERR, coef_sp_l, NB_COEF_SP);
Pid pid_r(coef_err_r, NB_COEF_ERR, coef_sp_r, NB_COEF_SP);


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
#ifdef LENGTH_CALIB
	length_calibration(&ser, &qei_l, &qei_r);
#endif
#ifdef ANGLE_CALIB
	angle_calibration(&ser, &qei_l, &qei_r);
#endif
#ifdef TRANSFER
	transfer2(&ser, &motor_l, &motor_r, &qei_l, &qei_r);
#endif
#endif
	motor_l.setPwm(0.0f);
	motor_r.setPwm(0.0f);
}
