/*
 * TODO
 * Documentation
 */

#include "common.hpp"


float sg(float const val)
{
	return (val < 0.0f) ? -1.0f : 1.0f;
}

float max(float const val_1, float const val_2)
{
	return (val_1 > val_2) ? val_1 : val_2;
}

float min(float const val_1, float const val_2)
{
	return (val_1 < val_2) ? val_1 : val_2;
}

float min(float const val_1, float const val_2, float const val_3)
{
	return min(min(val_1, val_2), val_3);
}

void blink(DigitalOut* const led) {
	*led = !*led;
}