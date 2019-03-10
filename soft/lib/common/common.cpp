/*
 * TODO
 * Documentation
 */

#include "common.hpp"


float sg(float val)
{
	return (val < 0.0f) ? -1.0f : 1.0f;
}

float max(float val_1, float val_2)
{
	return (val_1 > val_2) ? val_1 : val_2;
}

float min(float val_1, float val_2)
{
	return (val_1 < val_2) ? val_1 : val_2;
}

float min(float val_1, float val_2, float val_3)
{
	return min(min(val_1, val_2), val_3);
}

void blink(DigitalOut* led) {
	*led = !*led;
}
