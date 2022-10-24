* tworzenie dat;
bdate = mdy(month, day, year);
fixdate = mdy(8,31,2050);
* - przechowywane sa one jako liczby. Warto zmienic ich wyswietlanie przez;
proc print data = scoredata;
format bdate date9.;

* YEAR, QTR, MONTH, DAY, WEEKDAY sluza do ekstrakcji z daty;

* TODAY() I DATE() moga by uzywane zamienne - dzisiejsza data;

* INTCK - liczba okresow miedzy datami;
years = intck('year', start_date, today());
months = intck('months', start_date, today());

* YRDIF, DATDIF - roznica miedzy datami;
daydiff = datdif(startdate, enddat, 'baza np. 30/360');

* DO LOOPS;
data nowe_data3;
set nowe_data2;
do i = 1 to 3;
nowakol = score3 * stu_id;
end;
run;   * w nowej tabeli bedzie zmienna i;

* DO LOOPS Z POMINIECIEM ZMIENNEJ ITERUJACEJ;
data nowe_data4 (drop=i);
set nowe_data3;
do i = 1 to 3;
nowakol = score3 * stu_id;
end;
run;

* every iteration will create an output;
data nowe_data5;
set nowe_data4;
do i = 1 to 3;
nowakol = score3 * stu_id;
output;
end;
run;

* DO UNTIL, DO WHILE;
* DO UNTIL WYKONUJE OPERACJE PRZYNAJMNIEJ RAZ, WHILE NIE JESLI WARUNEK JEST FALSZYWY;
DATA INVEST;
DO UNTIL (CAPITAL>=50000);
CAPITAL = 2000;
CAPITAL = CAPITAL * 10;
YEAR = 1;
END;
RUN;



