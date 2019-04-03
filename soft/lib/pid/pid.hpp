#ifndef PID_HPP
#define PID_HPP

#include "mbed.h"
#include "common.hpp"


#define NB_COEF 4

class CArray
{
public:
	CArray(int _length);
	~CArray();
	void reset();
	void add(float value);
	float operator[](int _index);
private:
	int index;
	int length;
	float* array;
};

class Pid
{
public:
	Pid(float* _coef_err, int _len_err, float* _coef_sp, int _len_sp);
	~Pid();
	void reset();
	float getPid();
	float getPid(float err, float sp);
private:
	float* coef_err;
	int len_err;
	float* coef_sp;
	int len_sp;
	CArray err_ca;
	CArray sp_ca;
};


#endif
