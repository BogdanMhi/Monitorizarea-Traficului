#include "thread.h"
#include <QDebug>

Thread::Thread(QObject *parent):
    QThread(parent)
{
}

Thread::~Thread()
{
}

void Thread::stop()
{
    requestInterruption();
    wait();
}

void Thread::run()
{
int i=0;
while(!isInterruptionRequested()){
QString text;
    text = QString("M-am conectat cu succes");
        Q_EMIT textChanged(text);
QThread::msleep(20);
    qDebug() <<i++;
}
}
