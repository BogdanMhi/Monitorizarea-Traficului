#include "myglobalobject.h"
#include <QDebug>


MyGlobalObject::MyGlobalObject()
{}

QString MyGlobalObject::doSomething(const QString &text) {
 //qDebug() << "MyGlobalObject doSomething called with" << text;
    tx = text;
    Q_EMIT textChanged(tx);
    return tx;
}

QString MyGlobalObject::doSomethingVar( QString &text) {
 //qDebug() << "MyGlobalObject doSomething called with" << text;
    tx = text;
    Q_EMIT textChanged(tx);
    return tx;
}


QString MyGlobalObject::getSomething()
{
    return tx;
}

