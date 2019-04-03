/*
 * TODO
 * Documentation
 * Make position and angle pid to control motor's speed pid
 */

#include "pid.hpp"


CArray::CArray(int _length)
{
	length = _length;
	array = new float[length];
	reset();
}

CArray::~CArray()
{
	delete [] array;
}

void CArray::reset()
{
	index = 0;
	for (int i = 0; i < length; i++) {
		array[i] = 0.0f;
	}
}

void CArray::add(float val)
{
	index = (index - length -1) % length;
	array[index] = val;
}

float CArray::operator[](int _index)
{
	return array[(index+_index) % length];
}


Pid::Pid(float* _coef_err, int _len_err, float* _coef_sp, int _len_sp):
	err_ca(_len_err),
	sp_ca(_len_sp)
{
	len_err = _len_err;
	len_sp = _len_sp;
	coef_err = _coef_err;
	coef_sp = _coef_sp;
}

Pid::~Pid()
{

}

void Pid::reset()
{
	err_ca.reset();
	sp_ca.reset();
}

float Pid::getPid()
{
	float sum = 0.0f;
	for (int i = 0; i < len_err; i++) {
		sum += coef_err[i] * err_ca[i];
	}
	for (int i = 0; i < len_sp; i++) {
		sum += coef_sp[i] * sp_ca[i];
	}
	return sum;
}

float Pid::getPid(float err, float sp)
{
	err_ca.add(err);
	sp_ca.add(sp);
	return getPid();
}
