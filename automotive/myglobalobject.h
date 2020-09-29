#ifndef MYGLOBALOBJECT_H
#define MYGLOBALOBJECT_H

#include <QObject>

class MyGlobalObject : public QObject
{
    Q_OBJECT
private:
    QString tx;
    QString db;
public:
    MyGlobalObject();

    Q_SIGNAL bool textChanged(const QString & text);

   public slots: // slots are public methods available in QML
    QString doSomethingVar( QString &text);
    QString doSomething( const QString &text);
    QString getSomething();

};

#endif // MYGLOBALOBJECT_H
