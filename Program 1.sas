* IMPORTOWANIE

* import danych z pliku tekstowego poprzedzielonego pustymi wartosciami;
data pustewart;
infile "/home/u62160406/Nowy folder/DATA_blanks.txt";   
input name $ gender $ age weight;
run;

* import danych z pliku csv;
data csvplik;
infile "/home/u62160406/Nowy folder/DATA_commas.csv" dsd;   
input name $ gender $ age weight;
run;  

* import z dowolnym delimiterem;
data dowdel;
infile "/home/u62160406/Nowy folder/other_del_data.txt" dlm=":";   
input name $ gender $ age weight;
run;

* import z recznym podzialem na kolumny;
* 1-5 oznacza, ze pierwsze 5 znakow w kazdym wierszu nalezy do kolumny name;
data kol;
infile "/home/u62160406/Nowy folder/DATA_column.txt"; 
input name $ 1-5
sex $ 6
weight 7-9
data $ 10-18;
run;   

* import z innym recznym podzialem na kolumny i czytanie daty;
* @6 oznacza ze sex zaczyna sie od 6 znaku w kazdym wierszu i trwa 1 znak;
data dat;
infile "/home/u62160406/Nowy folder/DATA_column.txt"; 
input
@1 name $ 5.
@6 sex $ 1.
@7 weight 3.
@10 data mmddyy10.;
run;

* ladne wyswietlanie daty;
proc print data=dat;
format data mmddyy10.;

* wyswietlanie daty z tekstowym miesiacem;
proc print data=dat;
format data date9.;

* tworzenie wlasnego zbioru danych;
data nowyzbior;
input kol1 kol2;
datalines;
1 2
3 4
;
run;

* tworzenie trwalej biblioteki i trwalego zbioru danych;
libname nowlib 	"/home/u62160406/Nowy folder";
data nowlib.nowedane;
infile "/home/u62160406/Nowy folder/DATA_column.txt"; 
input
@1 name $ 5.
@6 sex $ 1.
@7 weight 3.
@10 data mmddyy10.;
run;

* importowanie excela, dodatkowo wybranie arkusza (domyslnie jest wybierany pierwszy);
* out = dataset, getnames czy chcemy nazwy kolumn;
proc import datafile="/home/u62160406/Nowy folder/excel_data"
DBMS=xlsx out = excel_data1; 
sheet="name_class";
getnames=yes;
run;

* import tylko wybranego zakresu z excela;
proc import datafile="/home/u62160406/Nowy folder/excel_data"
DBMS=xlsx out = excel_data;
range="name_class$A1:B6";
run;

* usuwanie kolumny ze zbioru (tworzenie nowego;
data excel_data2;
set excel_data1;
drop class;
run;

* zadanie;
data nowlib.zad1;
infile "/home/u62160406/Nowy folder/Patient_HD_age.txt"; 
input Pid $ 1
Sdate $ 2-11
Edate $ 12-21
age $ 23-24;
run;   
proc print data=nowlib.zad1;
format Sdate date9.;
format Edate date9.;

* zadanie2 - import excela i zapis go do trwalej biblioteki;
proc import datafile="/home/u62160406/Nowy folder/excel_data"
DBMS=xlsx out = excel_data3; 
sheet="name_class";
getnames=yes;
run;
data nowlib.permanent;
set excel_data3;
run;