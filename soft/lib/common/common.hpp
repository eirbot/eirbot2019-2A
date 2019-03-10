#ifndef COMMON_HPP
#define COMMON_HPP

#include "mbed.h"


float sg(float val);
float max(float val_1, float val_2);
float min(float val_1, float val_2);
float min(float val_1, float val_2, float val_3);
void blink(DigitalOut* led);


#endif

