create database off;
use off;

create table band(
id_band INT PRIMARY KEY AUTO_INCREMENT,
name_band  varchar (45) unique,
city varchar(45),
country varchar(10),
tag varchar(25), 
since year, 
listeners_kilo float
);

drop table band;

load data local infile "D:/bazad/projekt/tab.band/off_band.txt" into table band;

select * from band;

#SELECT id_band, name_band FROM band order by id_band asc
#INTO outfile "D:/bazad/projekt/Upload/lista3.txt" LINES TERMINATED BY '\r\n' ;

create table music(
id_music INT PRIMARY KEY AUTO_INCREMENT,
name_band varchar (45),
name_album text,
best_song text
);

#drop table music;

load data local infile "D:/bazad/projekt/tab.band/off_music.txt" into table music;

select * from music;

create table festival(
id_off INT PRIMARY KEY AUTO_INCREMENT,
name_f  varchar (45),
city_fest text,
edition int, 
year int,
people int
);

#drop table festival;	

load data local infile "D:/bazad/projekt/tab.band/off_fest.txt" into table festival;

select * from festival;

create table lineup(
id_band INT,
name_band varchar (45) unique,
id_off_1 int,
id_off_2 int, 
id_off_3 int
);

#drop table linuep;

load data local infile "D:/bazad/projekt/tab.band/off_lineup.txt" into table lineup;

select * from lineup;

create table user_choice(
id_band INT PRIMARY KEY auto_increment,
name_band  varchar (45) unique,
city varchar(45),
country varchar(10),
tag varchar(25), 
since year, 
listeners_k float,
name_album text,
best_song text,
id_off_1 int,
id_off_2 int, 
id_off_3 int,
Ocena_1do10 int
);

#drop table user_choice;
select * from user_choice;

INSERT INTO user_choice (name_band, city, country, tag, since, listeners_k, name_album, best_song, id_off_1, id_off_2, id_off_3)
  SELECT b.name_band, b.city, b.country, b.tag, b.since, b.listeners_kilo, m.name_album, m.best_song, l.id_off_1, l.id_off_2, l.id_off_3
  FROM band as b inner join music as m on id_band = id_music  inner join lineup as l on b.id_band = l.id_band where b.name_band like '%hey%';

#Wprowadzanie oceny

UPDATE user_choice
SET 
    Ocena_1do10 = 7
WHERE name_band like '%kamp%';


#PLAYLISTY
# 1) Wybrana edycja OFFa po ROKU

select m.name_band, m. name_album, m.best_song, f.year
 from music as m inner join lineup as l on m.id_music = l.id_band 
 inner join festival as f on f.edition = l.id_off_1 where f.year = 2011;

 create view pl_off as select m.name_band, m. name_album, m.best_song, f.year
 from music as m inner join lineup as l on m.id_music = l.id_band 
 inner join festival as f on f.edition = l.id_off_1 where f.year = 2011;

 select *  from pl_off;
 
 SELECT * FROM pl_off INTO outfile "D:/bazad/projekt/Upload/lista7.txt" LINES TERMINATED BY '\r\n';
 
 # 2) Zespół podobny do ulubionego (tag)
 
 select b.tag, b.name_band, m.name_album, m.best_song from band as b 
 left join music as m on b.id_band = m.id_music 
 where tag = (select tag from band where name_band like '%kamp%') limit 20;

create view sim_band as select b.tag, b.name_band, m.name_album, m.best_song from band as b 
 left join music as m on b.id_band = m.id_music 
 where tag = (select tag from band where name_band like '%kamp%') limit 20;
 
 select *  from sim_band;
 
 SELECT * FROM sim_band INTO outfile "D:/bazad/projekt/Upload/lista7.txt" LINES TERMINATED BY '\r\n';
 
 #3 Zespoły spod ulubionego gatunku
 
 SELECT 
	b.tag, 
    b.name_band, m.name_album, m.best_song FROM band AS b LEFT JOIN
    music AS m ON b.name_band = m.name_band WHERE
    b.tag LIKE '%exp%' limit 20;
    
 #4) Sortowanie/playlista po roku założenia (since)  
 
select b.name_band, m.name_album, m.best_song, b.since from band as b
left join music as m on b.id_band = m.id_music where b.since !=0 order by b.since desc limit 30;

#5) Sortowanie po słuchaczach

select b.name_band, m.name_album, m.best_song, listeners_kilo as sluchacze from band as b
left join music as m on b.id_band = m.id_music order by sluchacze desc limit 30;

#6) Najwięcej/najmnniej z: tagu - do rozwiązania

select name_band from band where tag = (select count(tag) from band having (count(tag) =3)); 

select name_band, tag, (select count(distinct(tag))) from band order by tag;


select tag, count(*) as num from band group by tag order by num desc ;

select b.name_band, b.tag, count(*) as num from band as b group by b.tag order by num desc;

select name_band, tag, count(*) as num from band union select name_band, tag, count(*) as num from band;


select name_band, tag,(select count(tag) from band group by tag having count(tag) = 11) as num from band having num = 'indie';
 #b.tag = (select count(*) as num1 from band group by b.tag having num1 = 11);

select name_band, tag from band where (select count(tag) as num from band group by tag having count(num) = 11);


select name_band, tag,(select count(*) from band group by tag) as num from band;

#select b.name_band from band as b inner join music as m on b.id_band = m.id_music; 

#select name_band, tag from band group by tag having (count(*) from band group by tag) = 2  ;


# II. ZAPYTANIA

# *) Zespół podobny do ulubionego (tag) - zapytanie

 select 
 #m.name_band, m. name_album, m.best_song
 *
 from band where tag = (select tag from band where name_band like '%Kamp%'); 
 
# *) Zespół spod ulubionego gatunku - zapytanie

 SELECT 
	b.tag,
    b.name_band,
    m.name_album,
    m.best_song
FROM
    band AS b
        LEFT JOIN
    music AS m ON b.name_band = m.name_band
WHERE
    b.tag LIKE '%exp%';

 #*) Sortowanie po roku
 
  select name_band, since from band where since !=0 order by since desc limit 30;
  
  # *) Sortowanie po sluchaczach
  
  select b.name_band, m.name_album, m.best_song, listeners_kilo as sluchacze from band as b
left join music as m on b.id_band = m.id_music order by sluchacze desc limit 30;