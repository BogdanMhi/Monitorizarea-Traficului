#include "dialobserver.h"

DialObserver::DialObserver(QObject *parent) : QObject(parent)
{}

int DialObserver::speed() const{
    return m_speed;
}

void DialObserver::setSpeed(int speed){
    if (m_speed == speed)
        return;
    m_speed = speed;
    emit speedChanged(m_speed);
}
