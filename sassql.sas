* CREATE Table tworzy nowy zbior danych;
proc sql;
create table tabelasql as
select * from scoredata0
where gender in ('m')
order by name;
quit;

* nie ma koniecznosci posiadania tego samego w selekcie i group by - inaczej niz w sql;
proc sql;
select *, mean(score1) from scoredata0
group by gender;
quit;

* DISTINCT;
proc sql;
select distinct * from scoredata0;
quit;

* dodawanie tekstu do wynikow;
proc sql;
select "Mathscore 1", name, "is", score1 from scoredata;

* usuwanie labeli kolumn;
select name label="#" from scoredata;

* dodawanie kolumn kalkulowanych- trzeba uzyc calculate;
proc sql;
select *, mean(score1) as score1_ave format 4.1,
mean(score2) as score2_ave format 4.1,
(calculated score1_ave - calculated score2_ave as diff format = 4.1)
from scoredata;
quit;

* CASE;
proc sql;
select *, sum (score1,score2,score3) /3 as score_avg,
case 
when calculated score_avg >=90 then "A"
when 80<=calculated score_avg <90 then "B"
else "absent" 
end as grade
from scoredata0;
quit;

* zamiana nulli na wartosci;
proc sql;
select name,
coalesce(score1, 0) as score1,
coalesce(gender, 'Missing') as gender
from scoredata0;
quit;

* WHERE PRZYKLADY;
where gender in ('f', 'm');
select sum(score1, score2) as scorenew from scoredata0
where calculated scorenew is null;
where costam between 70 and 100;
where name like 'T%' or name like '___a';
where score lt 60 and score is not missing; * WARTO UZYWAC! lt - less than;
* sa jeszcze eq, ne - not equal, gt, ge - greater or equal, le

* truncated strings;
proc sql;
select * from scoredata0 
where name eqt 'Ja'; * stringi zaczynajace sie na ja np Jack;
where name gtt 'Ja'; * stringi wieksze od ja np Karen;
where name ltt 'Ja'; * stringi mniejsze od ja np Irina;
where name get 'Ja'; * stringi wieksze lub rowne;
where name let 'Ja'; * stringi mniejsze lub rowne;
where name net 'Ja'; * stringi nie rowne ja;
quit;

* AGGREGATE FUNCTIONS LISTA
avg, mean, (count, freq, n )- number of nonmissing values, css - corr sum of squar
max, min, nmiss - number of missing, range - range of values, std, sum, vAR - wariancja;
select sum(score1) from data; - produkuje sume calosci
select name, sum(score1) from data - produkuje sume dla kazdej obserwacji
count(name) - liczy tylko nienullowe;
count(*) - liczy wszystkie;

* NIEWYELIMINOWANIE NULLI W GROUPBY MOZE SPOWODOWAC BLEDNE WYNIKI MEAN ITD,;
select *, mean(score1, score2, score3) from scoredata0
where gender is not missing
group by gender;

* HAVING JEST JAK WHERE DLA GRUP;
select *, sum(mean1, mean2) from scoredata0
group by gender
having gender is not missing;

* JOINS

* mozna laczyc tabele bez join:;
proc sql;
select g.stu_id, g.name, score1, score2
from scoredata1 as g, scoredata2 as h
where g.stu_id = h.stu_id
order by stu_id;
quit;
* lub z join;
proc sql;
select g.stu_id, g.name, score1, score2
from scoredata1 as g inner join scoredata2 as h
on g.stu_id = h.stu_id
order by stu_id;
quit;

* MISSING VALUES SA TRAKTOWANE JAKO KLASY, DLATEGO LACZAC TABELE NALEZY NA TO UWAZAC;
proc sql;
select costamcostam from scoredata1, scoredata2
where scoredata1.id = scoredata2.id and scoredata1.id is not missing
and scoredata2.id is not missing;
quit;

* KIEDY MAMY W JAKIES TABELI DWIE TE SAME WARTOSCI W KOLUMNIE LACZACEJ NP 2 TE SAME ID
BEDZIE TO POWODOWAC BLEDNE POLACZENIE. DLATEGO TRZEBA ZLACZYC TABELE TAKZE PO INNEJ ZMIENNEJ;
proc sql;
select scoredata1.id, scoredata1.name, score1, score2 from scoredata1, scoredata2
where scoredata1.id = scoredata2.id and scoredata1.name = scoredata2.name;
quit;

* SELF JOIN
ODWOŁYWANIE SIĘ DO JEDNEJ TABELI ZEBY ZOBACZYC RELACJE W NIEJ;
proc sql;
select costam from scoredata as tab1, scoredata as tab2
where tab1.score2 = tab2.score3 and tab1.score2 is not missing and tab2.score3 is not missing;
quit;

* LEFT, RIGHT, OUTER JOIN TRZEBA UZYWAC ZE SKLADNIA JOIN;

* CROSS JOIN - KAZDY WIERSZ Z KAZDYM NXM WYNIKOWO
UNION JOIN - JAK OUTER ALE NIE MATCHUJE, N+M WYNIKOWO
NATURAL JOIN - DZIALA JAK ZWYKLY JOIN - WYCHWYTUJE KTORE KOLUMNY W TABELACH MAJA TAKA SAMA NAZWE I TYP
I JESLI WARTOSCI W NICH SA TAKIE SAME, TO MATCHUJE.;
select * from scoredata1 natural join scoredata2;

* SUBQUERIES
* pojedyncze;
PROC SQL;
select *, mean(score1, score2, score3) as stu_mean from score_data
where calculated stu_mean >= (select score_average from score_ave_class where class ='a');
quit;
*wiele - wtedy uzywa sie in lub ><;
proc sql;
select *, mean(score1, score2, score3) as stu_mean from scoredata
where class in (select class from score_ave_class);
quit;
* EXISTS - sprawdza czy podzapytanie zwraca jakis rzad. Jesli tak, poczatkowe zapytanie jest wykonywane,
jezeli nie - zwracane jest nic.;
proc sql;
select column_name from tablename where exists 
(select * from tablename where costam);

* JOINY I SUBQUERIES MOZNA LACZYC;
proc sql;
select *, mean (score1, score2, score3) as stumean
from scoredata as stu, scoreaveclass as cla
where stu.class = cla.class and calculated stumean >=
(select scoreaverage from scoreaveclass as cla
where stu.class = cla.class);

* PODZAPYTANIA MOGA MIEC WIELE POZIOMOW;
proc sql;
select *, mean(score1, score2, score3) as stumean
from scoredatac as stu, scoreaveclass as cla
where stu.class = cla.class and calculated stumean >=
(select scoreaverage from scoreaveclass as cla
where stu.class = cla.class and cla.class in
(select cla.class from scoreaveclass as cla
where scoreaverage > 70));

* SET OPERATORS
podczas gdy joiny lacza tabele poziomo, set operators lacza je pionowo.
Laczy rezultaty dwoch lub wiecej zapytan w nast. sposob:
UNION - produkuje wszystkie unikalne rzedy z zapytan
EXCEPT - rzedy ktore sa czescia tylko pierwszego zapytania
INTERSECT - rzedy ktore sa wspolne dla obu
OUTER UNION - laczy rezultaty obu queries
ALL - dodanie all do union, except i intersect powoduje pozostawienie duplikatow
CORRESPONDING (CORR) - naklada kolumny ktore maja taka sama nazwe w obu tabelach
uzywane z except, intersect, union ktore nie sa w obu tabelach

* UNION tak jak inne sety laczy tabele bazujac na pozycji kolumny, nie na jej nazwie;
proc sql;
select * from tab1
union
select * from tab2;
* duplikaty sa tu odrzucone. by je zachowac trzeba dodac all.
* nazwy kolumn jesli sa inne, sa brane z pierwszej tabeli.
* jeszcze, raz nie jest wazna nazwa kolumny tylko wartosci.;

* EXCEPT usuwa wiersze z tab2, ktore sa w tab1;
proc sql;
select * from tab1
except
select * from tab2;

* INTERSECT tylko wiersze ktore sa takie same w tab1 i tab2;
proc sql;
select * from tab1
except
select * from tab2;

* OUTER UNION dopisuje kolumny z tab2 do tab1, nic nie pomija.
Zeby nadpisal kolumny o tej samej nazwie dodaje sie CORR;
proc sql;
select * from tab1
outer union CORR
select * from tab2;

* UNIKALNE WIERSZE KTORE WYSTEPUJA W TAB1 I TAB2 ALE NIE W OBU;
(query1 except query2)
union
(query2 except query1);

*** TABELE TWORZENIE ITP
Tworzenie od poczatku;
proc sql;
create table stu
(stuname char(10), stugender char(1),
birthdate num informat=date9. format=date9.);
quit;

*Info o tabeli;
proc sql;
describe table stuinfo;
quit;

* Tworzenie z selecta;
proc sql outobs=10; * outobs oznacza ze chcemy wziac tylko 10 obserwacji;
create table scoredata as
select Name 'student name' format $15.,
score1, score2, score3, gender as studentgender,
birthdate 'student birthdate' format = data10.
from scoredata;
quit;

* tworzenie tabeli takiej samej jak innej ale pustej;
proc sql;
create table newscoredata like scoredata;
quit;

* kopiowanie tabeli;
proc sql;
create table scoredata1 as
select * from scoredata (drop=score1); * bez kolumny score1;
quit;

* wpisywanie danych do tabeli;
proc sql;
insert into newscoredata
set name='David', gender ='m', score1=78
set name='Ted', birthdate='03Dec2007'd,
gender='m';
quit;

* wpisywanie poprzez values - bazuje na pozycji, nie wpisuje sie kolumn
musi byc tyle ile w tabeli kolumn;
proc sql;
insert into scoredata
values ('Sara',' ',., 75, 'f', '07Dec2006'd);
quit;

* wpisywanie z selectu;
proc sql;
create table newdata like scoredata;
quit;
proc sql;
insert into newscoredata
select * from scoredata;
quit;

* wpisywanie z selectu tylko wybranych kolumn;
* kolumny musza byc w takiej samej kolejnosci;
proc sql;
create table newscoredata like scoredata;
proc sql;
insert into newscoredata (name, gender, birthdate)
select name, gender, birthdate from scoredata;
quit;

* modyfikowanie istniejacych danych;
proc sql;
update newscoredata
set score1=score1*1.1
where score1<85;

proc sql;
update newscoredata
set score1 = score1 *
case when score1<=60 then 1.1
when 60< score1 <=70 then 2
else 1
end;

* usuwanie danych z tabeli;
proc sql;
delete from newscoredata where gender='f';

* modyfikowanie kolumn;
* dodawanie kolumn;
* trzeba dodac nazwe i typ kolumny;
proc sql;
alter table newscoredata
add score123_mean num label='Average of score', format=4.1;
* i dodanie do niej nowych danych;
proc sql;
update newscoredata
set score123_mean = mean(score1, score2, score3);

* modyfikowanie kolumn;
alter table newdata
modify birthdate label = 'birth_date' format date8.;

* usuwanie kolumn;
alter table newdata
drop score4;

* usuwanie tabeli;
proc sql;
drop table newscoredata;
quit;

* VIEWS - to takie jakby funkcje - przechowuja zapytanie kodu, oszczedzaja miejsce itp;

* tworzenie;
proc sql;
create view newscoredata as
select *, mean(score1, score2, score3) as scoreave,
case when calculatef scoreave >=90 then 'A'
else 'Absent'
end as grade
from scoredata
order by name;

* opis view;
proc sql;
describe view newscoredata;
quit;

* usuwanie view;
proc sql;
drop view newscoredata;

* uzywanie view - zarowno w data jak i proc;
data datafromview;
set newscoredata;
run;

proc data = newscoredata;

* INLINE VIEWS
To podzapytania w from
W przykladzie bedzie to c;

proc sql;
select s.name, s.gender, s.birthdate, mean(score1, score2, score3) as score123mean 'student mean' format 4.1,
c.all_class_mean
from
(select mean(scoreaverage) as allclassmeans format = 4.1 from classave) as c, scoredata as s
where
(calculated score123mean lt calculated allclassmeans) and calculated score123mean ne .;


