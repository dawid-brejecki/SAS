proc import datafile="/home/u62160406/Nowy folder/score_data_id"
DBMS=xlsx out = nowe_data;
run;

* dodawanie etykiet - zmiana nazw;
data scoredata1;
set nowe_data;
label score1 = "math"
score2 = "fizyks"
score3 = "host";

* aby nazwy sie pojawily w print trzeba dodac label do proc print;
* w innych procedurach nie trzeba tego dodawac;
proc print data=scoredata1 label;

* formatowanie, mozna takze np daty;
data scoredata2;
set nowe_data;
srednia = mean(score1, score2, score3);
format srednia 4.1; * wyswietlaja sie lacznie 4 znaki razem z kropka, 1 oznacza ilosc miejsc po przecinku;
run;

* formatowanie w data tworzyp permamentny format;
* formatowanie w proc print dotyczny tylko tej procedury;
proc print data=scoredata2;
format srednia 3.1;
run;

* formatowanie wg swoich upodoban;
data scoredata3;
set scoredata2;
run;
proc format;
value $moj "m" = "facet"
"f" = "kobieta";
value grupa 0-<80 = "deb"
80-<90 = "ok"
90-High = "wow"
Other = "missing"; 
run;
proc print data = scoredata3;
format gender $moj. srednia grupa.;
run;

