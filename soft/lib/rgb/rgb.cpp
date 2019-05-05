
#include <rgb.hpp>

RGB::RGB(PinName r_pin, PinName g_pin, PinName b_pin)
{
    r_out = new PwmOut(r_pin);
    g_out = new PwmOut(g_pin);
    b_out = new PwmOut(b_pin);
    off();
}

RGB::~RGB()
{
    delete r_out;
    delete g_out;
    delete b_out;
}

void RGB::setColor(Color* color)
{
    this->color = color;
    setPwmColor(color->getRed(), r_out);
    setPwmColor(color->getGreen(), g_out);
    setPwmColor(color->getBlue(), b_out);
}

void RGB::setColor(int color)
{
    Color* c = new Color(color);
    setColor(c);
    delete c;
}

Color* RGB::getColor()
{
    return color;
}

void RGB::off()
{
    Color* color = new Color(0);
    setColor(color);
    delete color;
}

void RGB::setPwmColor(int value, PwmOut* output)
{
    output->write(((value) & 0xFF) / 255.0f);
}

