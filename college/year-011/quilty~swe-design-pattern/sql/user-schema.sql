drop database quilty;
create database quilty;
use quilty;


create or replace table users(
	username varchar(64) primary key,
	password varchar(64) not null
);

create or replace table tasks (
	task_id int auto_increment primary key,
	task_todo varchar(767),
	task_created_date timestamp default CURRENT_TIMESTAMP,
	task_is_public int default 0 check(task_is_public in (1,0)),
	task_owner varchar(64) not null references users(username) on delete cascade
);

create or replace table friends(
	someone varchar(64) references users(username) on delete cascade,
	friend_with varchar(64) references users(username) on delete cascade,
	friendship_date timestamp default CURRENT_TIMESTAMP,
	constraint friend_with_pk primary key(someone, friend_with)
);


create or replace table likes_task(
	task_id varchar(767),
	liked_by varchar(64) not null references users(username) on delete cascade,
	constraint likes_task_pk primary key(task_id, liked_by)
);


insert into users(username, password) values
('ghost', 'passghost'),
('bart', 'passbart'),
('bender', 'passbender'),
('rayla', 'passrayla'),
('katara', 'passkatara'),
('shuri', 'passshuri'),
('alien', 'passalien'),
('pixel', 'passpixel'),
('rick', 'passrick'),
('morty', 'passmorty'),
('summer', 'passsummer'),
('beth', 'passbeth'),
('cat', 'passcat'),
('jerry', 'nojerrys');



-- bi-directional friendship

insert into friends (someone, friend_with) values
 ('rick', 'ghost'),
 ('ghost', 'rick'),

 ('rick', 'alien'),
 ('alien', 'rick'),

 ('rick', 'shuri'),
 ('shuri', 'rick'),

 ('summer', 'shuri'),
 ('shuri', 'summer'),

 ('rick', 'bender'),
 ('bender', 'rick'),

 ('rick', 'morty'),
 ('morty', 'rick'),

 ('katara', 'rayla'),
 ('rayla', 'katara'),

 ('bender', 'ghost'),
 ('ghost', 'bender'),

 ('cat', 'morty'),
 ('morty', 'cat'),

 ('rayla', 'ghost'),
 ('ghost', 'rayla'),

 ('rayla', 'alien'),
 ('alien', 'rayla'),

 ('rayla', 'pixel'),
 ('pixel', 'rayla'),

 ('summer', 'cat'),
 ('cat', 'summer'),

 ('morty', 'bart'),
 ('bart', 'morty'),

 ('cat', 'rick'),
 ('rick', 'cat');



insert into tasks(task_todo, task_is_public, task_owner) values
('hangout with bender', 1, 'rick'),
('save wakanda from thanos', 0, 'shuri'),
('go visit other emojis with alien and pixel',1, 'ghost'),
('learn wine bending', 1, 'katara'),
('write tati-z@ code for her', 1, 'rick'),
('eat your homework', 1, 'cat'),
('go to school', 1, 'morty'),
('steal morty off school. it s not a place for smart people', 0, 'rick'),
('get riggity riggity wrecked', 1, 'rick'),
('get shwifty', 1, 'rick'),
('swap myself with simple rick', 1, 'rick'),
('go on jessy s birthday', 1, 'morty'),
('scream wubba lubba dub dub at the top of my lungs', 1, 'rick'),
('become a pickle to avoid family therapy', 0, 'rick'),
('visit rick', 1, 'shuri'),
('hangout with summer', 1, 'shuri'),
('visit bart simpson', 1, 'morty');

insert into likes_task values
(5, 'bender'),
(5, 'ghost'),
(5, 'shuri'),
(5, 'morty'),
(13, 'summer'),
(13, 'alien'),
(1, 'bender'),
(1, 'ghost'),
(1, 'pixel'),
(10, 'bender'),
(5, 'alien'),
(15,'rick'),
(16, 'summer');

commit;

select * from tasks;

select * from users;
select task_todo,task_owner,liked_by from likes_task join tasks using(task_id);
select * from friends where someone='rick';
select * from tasks where task_is_public=1 and task_owner='shuri';


select TASK_TODO, COUNT(LIKED_BY) from LIKES_TASK join TASKS using(TASK_ID) group by TASK_TODO;

select tasks.*, count(LIKED_BY) "likes" from Tasks left join LIKES_TASK USING(TASK_ID)
where task_is_public=1 and task_owner ='rick' group by TASK_TODO;