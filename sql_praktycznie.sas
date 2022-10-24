* PORÓWNANIE TABEL - JAKIE WIERSZE SIĘ ZMIENIŁY;

proc import datafile="/home/u62160406/Nowy folder/score_data_miss_birthdate"
DBMS=xlsx out = score_data_old;
run;

proc import datafile="/home/u62160406/Nowy folder/score_data_miss_birthdate_new"
DBMS=xlsx out = score_data_new;
run;

proc sql;
title "rows updated";
select * from score_data_new
except
select * from score_data_old;
quit;

* 2 TABELE TAKIE SAME, ALE WYSTĘPUJĄ BRAKI W OBU, KTÓRE MOGĄ SIĘ ZASTĄPIĆ NAWZAJEM;

proc import datafile="/home/u62160406/Nowy folder/score1_1"
DBMS=xlsx out = score_1;
run;

proc import datafile="/home/u62160406/Nowy folder/score1_2"
DBMS=xlsx out = score_2;
run;

proc sql;
select s1.name, s1.score1 'score1_s1', s2.score1 'score1_s2',
s1.gender 'gender_s1', s2.gender 'gender_s2',
coalesce (s1.score1, s2.score1) as score1_final, coalesce(s1.gender, s2.gender)
from score_1 as s1 full join score_2 as s2 on s1.name=s2.name order by name;
quit;

* LICZENIE SUM CZESCIOWYCH;

proc import datafile="/home/u62160406/Nowy folder/Carline info"
DBMS=xlsx out = cldata;
run;

proc sql;
select cldata.carline, class, count(class) as count, calculated count/subtotal as percent format = percent8.2
from cldata, (select carline, count(carline) as subtotal from cldata group by carline) as cldata2
where cldata.carline = cldata2.carline
group by cldata.carline, class;
quit;

* UKAZYWANIE DUPLIKATOW I ILE ICH JEST KOLEJNO;

proc import datafile="/home/u62160406/Nowy folder/score_data_id_dups"
DBMS=xlsx out = dups;
run;

proc sql;
select *, count(*) from dups group by
name, score1, score2, score3, gender, stu_id
having count(*)>1;
quit;

* HIERARCHICZNE DANE W TABELI;

proc import datafile="/home/u62160406/Nowy folder/Teacher ID"
DBMS=xlsx out = teacher_id;
run;

proc sql;
select a.ID "teacher id", a.name "teacher name", b.ID "supervisor id",
b.name "supervisor name"
from
teacher_id as A, teacher_id as B /*self join*/
where A.supervisor = B.ID and A.supervisor is not missing;

* PRZYPISYWANIE DANYCH DO DANEJ KOLUMNY W ZAL OD WARUNKOW;

proc import datafile="/home/u62160406/Nowy folder/rewards_ponits"
DBMS=xlsx out = rp_data;
run;

proc sql;
select name, sum(jan), sum(feb), sum(mar) from 
(select name, case
when month(date)=1 then points end as jan,
case
when month(date)=2 then points end as feb,
case
when month(date)=3 then points end as mar
from rp_data)
group by name;
quit;

* UZYWANIE WLASNEJ REGULY SORTOWANIA;

proc sql;
select name, score, month from (select name, score, month, case
when month = 'jan' then 1
when month = 'feb' then 2
when month = 'mar' then 3
when month = 'apr' then 4
when month = 'may' then 5
else .
end as sorter from score_month)
order by sorter, name;
quit;

* UPDATE TABELI DANYMI Z INNEJ TABELI
UPDATUJEMY KOLUMNE SCORE1 JESLI NAME JEST TAKIE SAMO;
proc sql;
create table scoredataupdated as select * from scoredata;
update scoredataupdated as u
set score1=(select score1 from score1data as s1
where u.name=s1.name) where u.name in (select name from score1data);
quit;