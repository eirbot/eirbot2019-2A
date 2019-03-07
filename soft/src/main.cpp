#include "main.hpp"
#include <mbed.h>
#include <qei.hpp>
#include <lmd18200.hpp>
#ifdef DEBUG
#include <debug.hpp>
#endif

DigitalOut led = LED2;
Ticker ticker_led;

#ifdef DEBUG
int err = NO_ERROR;
Serial pc(USBTX, USBRX);
Qei qei_l(ENCODER_TIM_LEFT, &err);
Qei qei_r(ENCODER_TIM_RIGHT, &err);
short dl;
short dr;
#else
Qei qei_l(ENCODER_TIM_LEFT);
Qei qei_r(ENCODER_TIM_RIGHT);
#endif

int main()
{
#ifdef DEBUG
	pc.baud(115200);
	pc.printf("\r\nStart\r\n");
	pc.printf("Error code : %d\r\n", err);
#endif
	ticker_led.attach(&blink, PERIOD_LED)
	while (1) {
		
	}
}
