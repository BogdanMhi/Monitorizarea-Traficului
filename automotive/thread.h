#ifndef THREAD_H
#define THREAD_H

#include <QThread>

class Thread : public QThread
{
    Q_OBJECT
public:
    Thread(QObject *parent=nullptr);
   ~Thread() override;
    Q_SLOT void stop();
    Q_SIGNAL bool textChanged(const QString & text);

protected:
    void run() override;
};

#endif // THREAD_H
