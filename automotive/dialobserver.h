#ifndef DIALOBSERVER_H
#define DIALOBSERVER_H

#include <QObject>

class DialObserver: public QObject{
    Q_OBJECT
    Q_PROPERTY(int speed READ speed WRITE setSpeed NOTIFY speedChanged)

public:
    DialObserver(QObject *parent=nullptr);
    int speed() const;
public slots:
    void setSpeed(int speed);

signals:
    void speedChanged(int speed);
private:
    int m_speed;
};

#endif // DIALOBSERVER_H
