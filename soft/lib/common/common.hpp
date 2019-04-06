#ifndef COMMON_HPP
#define COMMON_HPP

#include "mbed.h"


float sg(float const val);
float max(float const val_1, float const val_2);
float min(float const val_1, float const val_2);
float min(float const val_1, float const val_2, float const val_3);
float limit(float const val, float const min, float const max);
void blink(DigitalOut* const led);


#endif

