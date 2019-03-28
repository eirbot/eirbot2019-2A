#ifndef MAIN_HPP
#define MAIN_HPP


// LED
#define PERIOD_LED 1

// Left qei
#define ENCODER_TIM_LEFT TIM3
#define GREEN_L PA_7
#define YELLOW_L PA_6
// Right qei
#define ENCODER_TIM_RIGHT TIM4
#define YELLOW_R PB_7
#define GREEN_R PB_6

// Motors
#define PERIOD_PWM 0.000033f

// Left motor
#define PWM_L PB_3
#define DIR_L PA_8
#define BREAK_L PA_10
#define DIR_FWD_L 1
// Right motor
#define PWM_R PB_10
#define DIR_R PA_9
#define BREAK_R PB_5
#define DIR_FWD_R 1


#endif