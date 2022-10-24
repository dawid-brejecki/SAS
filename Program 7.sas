proc import datafile="/home/u62160406/Nowy folder/score_data_miss"
DBMS=xlsx out = scoredata0;
run;

* sortowanie od najmniejszego score1 i najwiekszego score2;
* zapis do nowego zbioru (jesli pominiemy to nadpisze oryginalny zbior);
proc sort data=scoredata0 out = scoredata1;
by score1 descending score2;

* usuwanie obserwacji ktore maja taka sama wartosc co sortujaca kolumna score1;
* zapisywane one sa do nowego datasetu exctract;
proc sort data=scoredata0 out = scoredata2 nodupkey dupout = ecxtract;
by score1;

* tworzenie prostego raportu;
proc import datafile="/home/u62160406/Nowy folder/score_data_id"
DBMS=xlsx out = scoredata0 replace;
run; * import i nadpisanie danych scoredata0;
proc print data=scoredata0;
run; * wyswietlanie;
proc print data=scoredata0 obs='observation number';
run; * zmiana nazwy kolumny obserwacji;
proc print data=scoredata0 noobs;
run; * usuwanie kolumny obserwacji;
proc print data=scoredata0;
ID name;
run; * nadanie zmiennej name najwiekszej wagi;
proc sort data=scoredata0;
by name;
run; * sortowanie wg name - trwale;
proc print data=scoredata0;
var stu_id, gender;
ID name;
where gender='m';
run; * wybieranie tylko wybranych kolumn i filtrowanie;

* tworzenie raportu z sumami czesciowymi;
proc import datafile="/home/u62160406/Nowy folder/FunRun_data_id_class"
DBMS = xlsx out = FR0;
run;
proc print data=FR0 noobs;
var name stu_id gender class fund;
sum fund;
format fund dollar5.1;
run; * usuwanie zmiennej obs, wybieranie kolumn i dodanie sumy koncowej;
proc print data=FR0 noobs;
var name stu_id gender class fund;
sum fund;
by class;
format fund dollar5.1;
run; * dodanie sum czesciowych wg class;
proc print data=FR0 noobs sumlabel="Total Fund Raised" grandtotal_label="Grand Total";
title "Fund raised";
var name stu_id gender class fund;
sum fund;
by class;
format fund dollar5.1;
run; * dodawanie nazw sumom czesciowym i tytulu;

* tworzenie raportu ze statystykami;
proc import datafile="/home/u62160406/Nowy folder/score_data_miss"
DBMS = xlsx out = scoredata0 replace;
run;
data scoredata1;
set scoredata0;
TotalScore=sum(score1, score2, score3);
AverageScore=mean(score1, score2, score3);
run;

* calosciowy raport, maxdec = 1 oznacza 1 cyfre po przecinku wyswietlana
proc means data=scoredata1 maxdec=1 n mean max min median mode range stddev sum;
var score1 score2 score3 averagescore;
title"summary"
run;

* raport z podzialem na plec - najpierw trzeba posortowac;
proc sort data=scoredata1 out = scoredata2;
by gender;
run;
proc means data=scoredata1 maxdec=1 n mean max min median mode range stddev sum;
by gender;
var score1 score2 score3 averagescore;
title"summary"
run;

* inny sposob - bardziej kompaktowy wyglad i nie trzeba wczesniej sortowac;
proc means data=scoredata1 maxdec=1 n mean max min median mode range stddev sum;
class gender;
var score1 score2 score3 averagescore;
title"summary"
run;
* z dodana info o missing;
proc means data=scoredata1 maxdec=1 missing n mean max min median mode range stddev sum;
class gender;
var score1 score2 score3 averagescore;
title"summary"
run;

* wyswietlenie raportow czestosci;
proc freq data=scoredata;
tables gender gender*grade; * wyswietla dwa podsumowania - gender oraz gender z podzialem na grade;
run;

* wyswietlenie raportow bez procentow w kolumnach i wierszach oraz z info o missing;
proc freq data = scoredata;
tables gender gender*grade/missing nocol norow;

* bardzo duzo statystyk opisowych o zmiennej;
proc univariate data=scoredata1;
var averagescore;

* z rozbiciem na gender;
proc sort data=scoredata1 out=scoredata2;
by gender;
proc univariate data=scoredata2;
var averagescore;
by gender;

* szczegolowe info o datasecie np SCORE;
proc contens data=score._ALL_;
* mniej szczegolowe;
proc contens data=score._ALL_ NODS;
* info o tabeli z datasetu;
proc contents data=score.score_data;

* eksport danych
* do csv;
proc export data=score.score_data(where=(gender='f'))
outfile="/home/u62160406/Nowy folder/nowedane.csv"
dbms = csv
replace; * jesli zastepujemy plik

* do delimited file;
proc export data=score.score_data
outfile="/home/u62160406/Nowy folder/df"
dbms = dlm
replace;
delimiter='&';

* do excela;
proc export data=score.score_data
outfile="/home/u62160406/Nowy folder/exceldane"
dbms = XLSX replace;
sheet='data'; * wskazujemy arkusz;

* EKSPORT poprzez ODS do powerpoint, rtf, pdf;
proc import datafile="/home/u62160406/Nowy folder/score_data_miss"
DBMS = xlsx out = scoredata0 replace;
run;
ods pdf file="/home/u62160406/Nowy folder/plik.pdf";
ods rtf file="/home/u62160406/Nowy folder/plik.rtf";
ods powerpoint file="/home/u62160406/Nowy folder/plik.ppt";
proc print data=scoredata0;
id name;
run;
ods pdf close;
ods rtf close;
ods powerpoint close;
* ods _ALL_ CLOSE - mozna tez tak;
* eksport do html;
proc import datafile="/home/u62160406/Nowy folder/score_data_miss"
DBMS = xlsx out = scoredata0 replace;
run;
ods html file="/home/u62160406/Nowy folder/plik.pdf";
proc print data=scoredata0;
id name;
run;
proc means data=scoredata0;
var score1, score2, score3;
class gender;
run;
ods html close;

* eksport do excel;
ods excel file="/home/u62160406/Nowy folder/plik.pdf";
options(sheet_interval="bygroup"; * nowy arkusz dla kazdej grupy;
sheet_label="gender ="; * nazwa arkusza;
embedded_titles="yes"
embed_titles_once="yes");
TITLE 'Summary of Scores by Gender';
ods noproctitle;
proc means data=scoredata0;
var score1, score2, score3;
class gender;
run;
ods excel close;
