#ifndef PUMP_HPP
#define PUMP_HPP

#include <mbed.h>

DigitalOut* pump;
DigitalOut* evalve;

void initPump();
void activatePump();
void releasePump();

#endif
