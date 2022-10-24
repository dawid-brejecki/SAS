* LACZENIE TABEL;

* MERGING - TROCHE JAK INNER JOIN; 
* ZAWIERA WSZYSTKIE ZMIENNE Z OBYDWU TABEL;
* LACZENIE BAZUJE NA ICH POZYCJACH, JESLI ZMIENNA JEST TAKA SAMA;
* TO LICZY SIE OBSERWACJA Z OSTATNIEGO SETU;
* LICZBA WIERSZY TAKA JAK Z MNIEJSZEGO SETU;
NUM VARA		NUM VARB
1	A1			2	B1
3	A2			4	B2
5	A3

WYNIK
NUM	VARA	VARB
2	A1		B1
4	A2		B2;

data costam;
set a;
set b;
run;

* CONCATENATING PO PROSTU DOPISUJE WIERSZE NA KONIEC NAWET JAK SA;
* TAKIE SAME, ZMIENNE TAKIE JAK WE WSZYSTKICH ZBIORACH;
data costam;
set a b;
run;

* APPEND DZIALA PODOBNIE JAK CONCATENATING, ALE CONCAT TWORZY NOWY ZBIOR DANYCH;
* A APPEND DOPISUJE OBSERWACJE Z DRUGIEGO ZBIORU DO PIERWSZEGO (BAZOWEGO);
* LICZBA ZMIENNYCH TAKA SAMA JAK W BAZOWYM ZBIORZE, Z DRUGIEGO ZOSTAJA PO PROSTU UCIETE;
* JESLI ZMIENNE SIE ROZNIA TYPEM LUB SA INNE NIZ W BAZOWYM TO TRZEBA UZYC FORECE;
PROC APPEND BASE = SCOREDATAP
DATA = SCOEREDATA FORCE;
RUN;

* INTERLEAVING;
* PRZED UZYCIEM NALEZY POSORTOWAC WG DANEJ ZMIENNEJ;
* ZAWIERA WSZYSTKIE OBSERWACJE, POSORTOWANE WG ZMIENNEJ;
proc sort data=scoredata1;
 by id;
proc sort data=scoredata2;
 by id;
data interleave;
set scoredata1 scoredata2;
by id;
run;

* MATCH MERGING W KOŃCU DZIAŁA JAK JOIN;
* WCZESNIEJ POSORTOWAC WG DANEJ ZMIENNEJ;
* JESLI ZNAJDZIE SIE JESZCZE INNA KOLUMNA NIZ LACZACA TO DANE Z PIERWSZEGO SETU;
* BEDA NADPISANE PRZEZ DRUGI SET;
id vara
1 	a1
2	a2
3	a3

id varb
1	b1
2	b2
4	b3

id vara varb
1	a1	b1
2	a2	b2
3	a3	
4		b3;
proc sort data = scoredata1;
 by id;
proc sort data = scoredata2;
 by id;
data new;
merge scoredata1 scoredata2;
by id;

* ABY NIE NADPISYWAC DANYCH UZYWAMY RENAME:;
data new;
merge scoredata1 scoredata2 (rename=(gender=gendernew));
by id;

* POMIJANIE OBSERWACJI NIEPASUJACYCH;
data mma;
merge scoredata1 (in=A) scoredata2 (in=B);
* tworzenie zmiennej tymczasowej;
by stu_id;
if A=1 and B=1;
run;

* POMIJANIE KOLUMN;
* mozna to robic poprzez drop w data - wtedy zostaje w oryginalnym secie;
* a nie ma w nowym. Mozna tez zrobic to w merge;
data mma (drop=stu_id);
merge scoredata1(in=A) scoredata2 (IN = B drop=score3 );
by stu_id;
if A=1 and B=1; * pomijanie unmatching observations;
run;

