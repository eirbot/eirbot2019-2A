#ifndef TESTERS_HPP
#define TESTERS_HPP


#include <mbed.h>
#include <qei.hpp>
#include <lmd18200.hpp>

#define LENGTH_TEST 5.0f
void length_calibration(Serial* ser, Qei* qei_l, Qei* qei_r);

#define ANGLE_TEST 10.0f
void angle_calibration(Serial* ser, Qei* qei_l, Qei* qei_r);

#define T1 3.0f
#define T2 7.0f
#define PWM1 0.2f
#define PWM2 0.5f
void transfer(Serial* ser, LMD18200* motor_l, LMD18200* motor_r,
		Qei* qei_l, Qei* qei_r);


#endif
