#include "dialobserver.h"
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <string.h>
#include <arpa/inet.h>
#include <chrono>
#define port 2908
#include <myglobalobject.h>
#include <QtSql/QSqlError>
#include <SqlQueryModel.h>
#include <QTimer>
#include <QDateTime>

struct location
{
    int client_vreme;
    char client_oras[30];
    char client_tara[10];
    char client_strada[40];
    int limita_viteza;
};

struct speed_client
{
    int viteza_actuala;
    int limita_viteza;
};


int main(int argc, char *argv[])
{

    QGuiApplication::setApplicationName("Automotive");
    QGuiApplication::setOrganizationName("QtProject");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);

    QGuiApplication app(argc, argv);

    QIcon::setThemeName("automotive");

        QSqlDatabase db =  QSqlDatabase::addDatabase("QMYSQL");
        db.setHostName("127.0.0.1");
        db.setUserName("bogdan");
        db.setPassword("password");
        db.setDatabaseName("aplicatie");

        db.open();
        QSqlQuery query;






    DialObserver dial_observer;
    QQmlApplicationEngine engine;

    struct location locatie;
    struct sockaddr_in server;

    int sd;			// descriptorul de socket
    char raspuns[100];
    QString raspuns1; //Folosit pentru conversia din char in STRING;



    /* cream socketul */
    if ((sd = socket (AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror ("Eroare la socket().\n");
        return errno;
    }

    /* umplem structura folosita pentru realizarea conexiunii cu serverul */
    /* familia socket-ului */
    server.sin_family = AF_INET;
    /* adresa IP a serverului */
    server.sin_addr.s_addr = inet_addr("127.0.0.1");
    /* portul de conectare */
    server.sin_port = htons (port);

    /* ne conectam la server */
    if (connect (sd, (struct sockaddr *) &server,sizeof (struct sockaddr)) == -1)
    {
        qDebug() << ("[client]Eroare la connect().\n");


    }
    else
    {
        if (read (sd,(struct location *) &locatie,sizeof(struct location)) <= 0)
        {
            qDebug()<<printf("[Masina %d]\n",sd);
            qDebug()<<"Eroare la read() locatie de la client.\n";
        }


        MyGlobalObject* oras_vreme = new MyGlobalObject();
        QString locatie_vreme;
        locatie_vreme.setNum(locatie.client_vreme);
        engine.rootContext()->setContextProperty("vreme", oras_vreme);


        MyGlobalObject* oras_locatie = new MyGlobalObject();
        QString locatie_oras = locatie.client_oras;
        engine.rootContext()->setContextProperty("oras", oras_locatie);



        MyGlobalObject* tara_locatie = new MyGlobalObject();
        QString locatie_tara = locatie.client_tara;
        engine.rootContext()->setContextProperty("tara", tara_locatie);



        MyGlobalObject* limita_viteza = new MyGlobalObject();
        QString viteza_limita;
        viteza_limita.setNum(locatie.limita_viteza);
        engine.rootContext()->setContextProperty("viteza", limita_viteza);


        MyGlobalObject* database = new MyGlobalObject();
        database->doSomething("Conectat la baza de data");
        engine.rootContext()->setContextProperty("database", database);


        MyGlobalObject* myGlobal = new MyGlobalObject();
        myGlobal->doSomething("M-am conectat cu succes");
        engine.rootContext()->setContextProperty("myGlobalObject", myGlobal);
        engine.load(QUrl("qrc:/qml/automotive.qml"));
        tara_locatie->doSomething(locatie_tara);
        oras_locatie->doSomething(locatie_oras);
        limita_viteza->doSomething(viteza_limita);
        oras_vreme->doSomething(locatie_vreme);

    }


    QTime time = QTime::currentTime();
    QString time_text=time.toString("hh : mm");
    MyGlobalObject* ceas = new MyGlobalObject();
    engine.rootContext()->setContextProperty("timp",ceas);
    ceas->doSomething(time_text);

    QDate date = QDate::currentDate();
    QString date_text=date.toString("dd/MMMM/yyyy");
    MyGlobalObject* data = new MyGlobalObject();
    engine.rootContext()->setContextProperty("dataT",data);
    data->doSomething(date_text);



    int lim=locatie.limita_viteza;
    MyGlobalObject* alrt = new MyGlobalObject();
    speed_client speed_cl;
    SqlQueryModel sqlmodel;
    sqlmodel.setQuery("SELECT nume ,informatii_evenimente,informatii_combustibil,informatii_vreme FROM orase");
    engine.rootContext()->setContextProperty("sqlmodel", &sqlmodel);

    SqlQueryModel sqlmodelalerte;
    sqlmodelalerte.setQuery("SELECT ora,nume,strada,tipul FROM alerte");
    engine.rootContext()->setContextProperty("sqlmodelalerte", &sqlmodelalerte);


    engine.rootContext()->setContextProperty("alrt", alrt);




    MyGlobalObject* accident = new MyGlobalObject();
    engine.rootContext()->setContextProperty("accident", accident);


    QString alerta="Nicio alerta";
    QString aux="2";

    engine.rootContext()->setContextProperty("dial_observer", &dial_observer);

    QObject::connect(&dial_observer, &DialObserver::speedChanged, [&sd,&alrt,&raspuns,&raspuns1,&speed_cl,&lim,&accident,&alerta,&ceas,&data,&aux,&sqlmodelalerte,&locatie,&query](int speed){
        speed_cl.viteza_actuala=speed;
        speed_cl.limita_viteza=lim;
        QString raspuns_alerta;
        alerta=accident->getSomething();

        QTime time = QTime::currentTime();
        QString time_text=time.toString("hh : mm");
        ceas->doSomething(time_text);
        QDate date = QDate::currentDate();
        QString date_text=date.toString("dd/MMMM/yyyy");
        data->doSomething(date_text);

        if(alerta=="Accident" && aux!="Accident")
            {
            QString SQuery="INSERT INTO alerte VALUES('"+time_text+"','"+locatie.client_oras+"','"+locatie.client_strada+"','"+alerta+"')";
            query.exec(SQuery);
            aux=alerta;

        }

        if(alerta=="Ambuteiaj" && aux!="Ambuteiaj")
             {  QString SQuery="INSERT INTO alerte VALUES('"+time_text+"','"+locatie.client_oras+"','"+locatie.client_strada+"','"+alerta+"')";
                query.exec(SQuery);
                aux=alerta;
                  sqlmodelalerte.queryStrChanged(); }


        if(alerta=="Obstacol" && aux!="Obstacol")
            {  QString SQuery="INSERT INTO alerte VALUES('"+time_text+"','"+locatie.client_oras+"','"+locatie.client_strada+"','"+alerta+"')";
               query.exec(SQuery);
               aux=alerta;
                }





        if (write (sd,(struct speed_client *)&speed_cl,sizeof(struct speed_client)) <= 0)
        { qDebug() << ("[client]Eroare la write() spre server.\n"); }
        if(read(sd,&raspuns,sizeof (raspuns)) <= 0)
        { qDebug() << ("[client]Eroare la read() de la server.\n"); }

        else
        {
            raspuns1=raspuns;
            alrt->doSomething(raspuns1);

        }

    });


    if (engine.rootObjects().isEmpty())
        return -1;


    return app.exec();

}
