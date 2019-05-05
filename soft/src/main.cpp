#include "main.hpp"
#include <mbed.h>
#include <qei.hpp>
#include <pid.hpp>
#include <lmd18200.hpp>
#include <speed_block.hpp>
#include <odometry.hpp>
#include <navigator.hpp>
#include <RGB.h>

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

float coef_err_l[] = {0.01* 0.8659f, 0.01* -0.7513f, 0.01* -0.8629, 0.01* 0.7543};
float coef_co_l[] = {1.0f, -0.9107f, -0.1491f, 0.05982f};
float coef_err_r[] = {0.01* 0.8659f, 0.01* -0.7513f, 0.01* -0.8629, 0.01* 0.7543};
float coef_co_r[] = {1.0f, -0.9107f, -0.1491f, 0.05982f};

DigitalOut led = LED2;
RGB ledRGB(LED_R_PIN, LED_G_PIN, LED_B_PIN);
Qei qei_l(ENCODER_TIM_LEFT, &err);
Qei qei_r(ENCODER_TIM_RIGHT, &err);
Pid pid_l(coef_err_l, NB_COEF_ERR, coef_co_l, NB_COEF_CO);
Pid pid_r(coef_err_r, NB_COEF_ERR, coef_co_r, NB_COEF_CO);
LMD18200 motor_l(PWM_L, DIR_L, BREAK_L, DIR_FWD_L, PERIOD_PWM);
LMD18200 motor_r(PWM_R, DIR_R, BREAK_R, DIR_FWD_R, PERIOD_PWM);
SpeedBlock speed_block(&qei_l, &pid_l, &motor_l, &qei_r, &pid_r, &motor_r);
Odometry odometry(&qei_l, &qei_r);
Navigator navigator(&odometry, &speed_block);


int main()
{
	ledRGB.off();
#ifdef DEBUG
	led = 1;
	ser.baud(115200);
	wait(3.0f);
	led = 0;
	ser.printf("\r\nstart\r\n");
	ser.printf("error code: %d\r\n", err);
	//ser.getc();
#ifdef LENGTH_CALIB
	length_calibration(&ser, &qei_l, &qei_r);
#endif
#ifdef ANGLE_CALIB
	angle_calibration(&ser, &qei_l, &qei_r);
#endif
#ifdef TRANSFER
	transfer(&ser, &motor_l, &motor_r, &qei_l, &qei_r);
#endif
#ifdef PID
	pid_test(&ser, &speed_block);
#endif
#ifdef SPEED
	speed_test(&ser, &speed_block);
#endif
#ifdef SQUARE
	square(&ser, &speed_block);
#endif
#ifdef ODOMETRY
	test_odometry(&ser, &odometry);
#endif
#ifdef NAVIGATOR
	test_navigator(&ser, &navigator, &odometry);
#endif
#ifdef STRAT
	test_strat(&ser, &navigator, &odometry);
#endif
#endif
	speed_block.reset();
}
