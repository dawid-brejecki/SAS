* konwertowanie;
* sas konwertuje automatycznie, ale mozna tez recznie - input na naumeryczne, put na char;
score = rawscore *1;
score = input(rawscore, 7.);
gender = gender ||'/'||gender2;
gender = put(gender, 8.)
* 7 i 8, bo takie dlugosci mialy zmienne;

* SCAN function;
* skanuje stringa, i zwraca ktorys kolejny wyraz jaki chcemy, wg delimiterow jakie podamy;
* jesli nie podamy zadnych delimiterow, sam uzyje domyslnych. Delimiterow moze byc wiecej niz 1;
lastname = scan(name,1,',: ');

* SUBSTR function;
middle = substr(middlename, 1, 3);
* zwraca 3 znaki zacznynajac od 1. Jesli nie podamy ile, zwroci wszystkie;
* substr mozna tez uzywac do zmieniania chara np:;
if exchange = '000' then susbtr(region,1,3) = 'NNW';
* zamienia trzy pierwsze znaki w regionie na NWW;

* TRIM I CATX;
* trim usuwa puste znaki z chara;
studentname = trim(lastname) || ',' || trim(firstname);
* CATX laczy stringi, automatycznie usuwajac puste znaki. Warto jednak przed nim ustalic wielkosc zmiennej;
length studentname $25;
studentname = catx(', ', lastname, firstname);

* INDEX;
* zwraca pozycje w stringu danego stringa;
* rezultatem jest liczba np. 8;
index_num = index(phone, '0700');

* PROPCASE, LOWERCASE, UPPERCASE;
propcase(name, '.'); * . to delimeter przez nas okreslony, mozna dac ich wiecej;

* TRANWRD;
* zamienia string na inny string, warto przed tym ustawic dlugosc zmiennej;
phone_update = tranwrd(phone, '000', '667'); *zamienia 000 na 667;

* ZAOKRAGLEANIE - INT LUB ROUND;
int(phone);
round(phone,.01);