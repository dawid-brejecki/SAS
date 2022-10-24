proc import datafile="/home/u62160406/Nowy folder/score_data_id"
DBMS=xlsx out = nowe_data;
run;
data nowe_data2;
set nowe_data;
grade=7;
score_type = "Math_scores";
total_score = sum(score1, score2);
run;

* jezeli chcemy wykonac jedna czynnosc po if uzywamy tylko if;
* jezeli chcemy wykonac wiecej czynnosci po if trzeba uzyc do;
* NE . oznacza nie jest rowny NULL;
data ifdata;
set nowe_data2;
if gender = "f" then nowakolumna = 1;
else if gender = "m" then nowakolumna = 2;
else nowakolumna = "nic";
if score1 >=70 then do;
grade="A";
pass="pass";
end;
if score1 NE . and score2 NE . then take="complete";

* aby okreslic wielkosc zmiennej char dajemy length przed jej pozniejszym uzyciem;
* length nowazmienna $7; *$ bo zmienna kategoryczna;

* filtrowanie danych = przez if lub delete;
data filterdata;
set ifdata;
if nowakolumna =1;

* albo;
data filterdata2;
set ifdata;
if nowakolumna NE "1" then delete;
