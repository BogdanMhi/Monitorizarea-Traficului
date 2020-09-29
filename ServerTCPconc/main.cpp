
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <pthread.h>
#include <arpa/inet.h>
/* portul folosit */
#define PORT 2908
#include <QDebug>
#include <iostream>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <string.h>
#include <stdio.h>


typedef struct thData{
    int idThread; //id-ul thread-ului tinut in evidenta de acest program
    int cl; //descriptorul intors de accept
}thData;

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

static void *treat(void *); /* functia executata de fiecare thread ce realizeaza comunicarea cu clientii */
void raspunde(void *);
void trimiteLocatie(void *);
static char InformatiiExtra[100];
static struct location locatie;


int main ()
{

    struct sockaddr_in server;	// structura folosita de server
    struct sockaddr_in from;
    int sd;		//descriptorul de socket
    pthread_t th[100];    //Identificatorii thread-urilor care se vor crea
    int i=0;





    /* crearea unui socket */
    if ((sd = socket (AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror ("[server]Eroare la socket().\n");
        return errno;
    }
    /* utilizarea optiunii SO_REUSEADDR */
    int on=1;
    setsockopt(sd,SOL_SOCKET,SO_REUSEADDR,&on,sizeof(on));

    /* pregatirea structurilor de date */
    bzero (&server, sizeof (server));
    bzero (&from, sizeof (from));

    /* umplem structura folosita de server */
    /* stabilirea familiei de socket-uri */
    server.sin_family = AF_INET;
    /* acceptam orice adresa */
    server.sin_addr.s_addr = htonl (INADDR_ANY);
    /* utilizam un port utilizator */
    server.sin_port = htons (PORT);

    /* atasam socketul */
    if (bind (sd, (struct sockaddr *) &server, sizeof (struct sockaddr)) == -1)
    {
        perror ("[server]Eroare la bind().\n");
        return errno;
    }

    /* punem serverul sa asculte daca vin clienti sa se conecteze */
    if (listen (sd, 2) == -1)
    {
        perror ("[server]Eroare la listen().\n");
        return errno;
    }
    /* servim in mod concurent clientii...folosind thread-uri */

    QSqlDatabase db =  QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("127.0.0.1");
    db.setUserName("bogdan");
    db.setPassword("password");
    db.setDatabaseName("aplicatie");
    db.open();


    while (1)
    {
        int client;
        thData * td; //parametru functia executata de thread
        socklen_t length = sizeof (from);

        printf ("[server]Asteptam la portul %d...\n",PORT);
        fflush (stdout);

        // client= malloc(sizeof(int));
        /* acceptam un client (stare blocanta pina la realizarea conexiunii) */
        if ( (client = accept (sd, (struct sockaddr *) &from, &length)) < 0)
        {
            perror ("[server]Eroare la accept().\n");
            continue;
        }


        /* s-a realizat conexiunea, se astepta mesajul */

        // int idThread; //id-ul threadului
        // int cl; //descriptorul intors de accept

        td=(struct thData*)malloc(sizeof(struct thData));
        td->idThread=i++;
        td->cl=client;
        QSqlQuery query;

        QString username;
        username.setNum(td->cl);

        query.exec("select o.nume,o.informatii_vreme,s.nume_strada,v.valoare_km from orase o join strazi s on o.id_oras=s.id_oras join viteze v on s.id_strada=v.id_strada where v.id_strada='"+username+"'");

        while (query.next()) {
            QString nume=query.value(0).toString();
            int informatii_vreme=query.value(1).toInt();
            QString nume_strada=query.value(2).toString();
            int speedLimit = query.value(3).toInt();
            locatie.limita_viteza=speedLimit;
            strcpy(locatie.client_oras,nume.toStdString().c_str());
            strcpy(locatie.client_tara,"Romania");
            strcpy(locatie.client_strada,nume_strada.toStdString().c_str());
            locatie.client_vreme=informatii_vreme;

            printf ("[Masina] - %d - Din orasul %s pe strada %s s-a conectat cu succes\n",td->cl,nume.toStdString().c_str(),nume_strada.toStdString().c_str());

        }

        pthread_create(&th[i], nullptr, &treat, td);

    }//while
};
static void *treat(void * arg)
{
    struct thData tdL;
    tdL= *((struct thData*)arg);

    printf("[Masina]-Thread %d - Asteptam mesajul.. \n",tdL.idThread);
    fflush (stdout);
    pthread_detach(pthread_self());
    trimiteLocatie((struct thData*)arg);
    raspunde((struct thData*)arg);
    /* am terminat cu acest client, inchidem conexiunea */
    //close ((intptr_t)arg);
    return(nullptr);

};


void trimiteLocatie(void *arg)
{
    struct thData tdL;
    tdL= *((struct thData*)arg);

    if (write (tdL.cl,(struct location *) &locatie,sizeof(struct location)) <= 0)
    {
        printf("[Masina %d]\n",tdL.idThread);
        perror ("Eroare la write() locatie catre client.\n");
    }
}

void raspunde(void *arg)
{
    std::string alerta;
    int speedlimit,viteza;
    struct thData tdL;
    tdL= *((struct thData*)arg);
    struct speed_client speed_cl;



    if (read (tdL.cl, (struct speed_client *)&speed_cl,sizeof(struct speed_client)) <= 0)
    {
        printf("[Masina %d]\n",tdL.idThread);
        perror ("Eroare la read() de la client.\n");

    }
    //int cod_r;
    else{
            speedlimit=speed_cl.limita_viteza;
            viteza = speed_cl.viteza_actuala;
        printf ("[Masina]- %d - The speed is...%dkm/h and the Limit is %d \n", tdL.idThread,viteza,speedlimit);
        if(viteza>speedlimit)
        {   strcpy(InformatiiExtra,"Mergi prea repede!Incetineste!");

            if (write (tdL.cl, &InformatiiExtra,sizeof(InformatiiExtra)) <= 0)
            {
                printf("[Masina %d]\n",tdL.idThread);
                perror ("Eroare la write() la client.\n");

                //printf("%s",InformatiiExtra.toStdString().c_str());
            }

            printf("[Masina]- %d - The speed is way to fast slow down!!\n",tdL.idThread);

        }

        else
        {   strcpy(InformatiiExtra,"Condu prudent!");
            if (write (tdL.cl, &InformatiiExtra,sizeof(InformatiiExtra)) <= 0)
            {
                printf("[Masina %d]\n",tdL.idThread);
                perror ("Eroare la write() la client.\n");

            }

        }

        raspunde((struct thData*)arg);//am apelat aceasta functie pentru a transmite viteza serverului de cate ori este modificata.
    }

}
