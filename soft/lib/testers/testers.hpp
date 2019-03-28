#ifndef TESTERS_HPP
#define TESTERS_HPP


#include <mbed.h>
#include <qei.hpp>
#include <lmd18200.hpp>

#define LENGTH_TEST 5.0f
void length_calibration(Serial* const ser, Qei* const qei_l, Qei* const qei_r);

#define ANGLE_TEST 10.0f
void angle_calibration(Serial* const ser, Qei* const qei_l, Qei* const qei_r);

#define T1 3.0f
#define T2 7.0f
#define PWM1 0.2f
#define PWM2 0.5f
void transfer(Serial* const ser, LMD18200* const motor_l,
		LMD18200* const motor_r, Qei* const qei_l, Qei* const qei_r);
void transfer2(Serial* const ser, LMD18200* const motor_l,
		LMD18200* const motor_r, Qei* const qei_l, Qei* const qei_r);


#endif
