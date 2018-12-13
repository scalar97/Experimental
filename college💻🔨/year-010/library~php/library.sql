drop table if exists `reservation`;
drop table if exists `book`;
drop table if exists `category`;
drop table if exists `author`;
drop table if exists `user`;

-- the library user table
create table `user`
(
	`username` varchar(32) primary key,
	`password` char(64) not null,
	`firstname` varchar(32) not null,
	`surname` varchar(32) not null,
	`address` varchar(128) not null,	
	`city` varchar(64) not null,
	`telephone` int(7),
	`mobile_phone` int(10) not null

)ENGINE=InnoDB DEFAULT CHARSET=latin1;


create table `author`
(
	`author_id` char(8) primary key,
	`author_name` varchar(32) not null
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- creatin the category table
create table `category`
(
	`category_id` char(10) primary key,
	`category_description` varchar(64)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- the book table
create table `book`
(
	`isbn` char(16) primary key,
	`book_title` varchar(128) not null,
	`edition` int(2) not null,
	`year` int(4),
	`category_id` char(10),
	`reserved` enum('N','Y') not null,
	`username` varchar(32),
	`author_id` char(8)
)ENGINE=InnoDB DEFAULT CHARSET=latin1; 


create table `reservation`
(
	`isbn` char(16) not null,
	`username` varchar(32) not null,
	`reservation_date` datetime default CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=latin1;


	
INSERT INTO `category` (`category_id`, `category_description`) VALUES
(001, 'Health'),
(002, 'Business'),
(003, 'Biography'),
(004, 'Technology'),
(005, 'Travel'),
(006, 'Self-Help'),
(007, 'Cookery'),
(008, 'Fiction');


INSERT INTO `user` (`username`, `password`, `firstname`, `surname`, `address`, `city`, `telephone`, `mobile_phone`) VALUES
('chris', 'password', 'Chris', 'Clarke', '123 Corner Island, Dublin 8', 'Cork', 176543, 872345678),
('eamon', 'password', 'Eamon', 'Smith', '123 Corner Island, Dublin 8', 'Dublin', 176543, 812345678),
('matt', 'password', 'Matt', 'Stephens', '123 Corner Food, Dublin 18', 'Dublin', 176543, 872345678),
('nerie_b', 'password', 'Nerie', 'Cherie', '100  Rue du Midi, Belgium', 'Brussels', 176543, 874539870),
('pitta', 'password', 'Pita', 'Bread', '123 Corner Island, Dublin 8', 'Cork', 176543, 812345678),
('si_', 'password', 'Simon', 'Cowell', '100  Blue Bell, Uk', 'London', 176543, 872345678),
('tati', 'k', 'Tatiana', 'Z.', '123 Main Street', 'Dublin', 11111111, 211111111),
('tux', 'Lix', 'Tux', 'Penguin', '123 Main Street Lower', 'Dublin', 1123111, 21178111);


insert into `author` (`author_id`, `author_name`) 
			  values ('10', 'John Smith'),
			  		 ('11', 'Gayle Lakeman'),
			  		 ('12', 'Alicia Oneill'),
			  		 ('13', 'Stephanie Birchi'),
			  		 ('14', 'Joe Peppard'),
			  		 ('15', 'John Thorpe'),
			  		 ('16', 'Susan O\'Neill'),
			  		 ('17', 'Kevin Graham'),
			  		 ('18', 'Dan Brown'),
			  		 ('19', 'Jamie Oliver'),
			  		 ('20', 'Cleo Blair'),
			  		 ('21', 'George Bush'),
			  		 ('22', 'John Smith'),
			  		 ('23', 'Jon Snow');


INSERT INTO `book` (`isbn`, `book_title`, `author_id`, `edition`, `year`, `category_id`, `reserved`) VALUES
('093-403992', 'Computers in Business', '10', 3, 1997, 003, 'N'),
('23472', 'Exploring Peru', '13', 4, 2005, 005, 'N'),
('237-34823', 'Business Strategy', '14', 2, 1997, 001, 'N'),
('23u8-923849', 'A guide to nutrition', '15', 2, 1997, 001, 'N'),
('2983-3494', 'Cooking for children', '16', 1, 2003, 007, 'N'),
('82n8-308', 'computers for idiots', '17', 5, 1998, 004, 'N'),
('9823-23984', 'My life in picture', '18', 8, 2004, 001, 'N'),
('9823-2403-0', 'DaVinci Code', '19', 1, 2003, 008, 'Y'),
('9823-98345', 'How to cook Italian food','20', 2, 2005, 007, 'N'),
('9823-98487', 'Optimising your business','21', 1, 2001, 002, 'N'),
('98234-029384', 'My ranch in Texas','22', 1, 2005, 001, 'N'),
('988745-234', 'Tara Road', '23', 4, 2002, 008, 'N'),
('993-004-00', 'My life in bits','20',1, 2003, 001, 'N'),
('9987-0039882', 'Shooting History','12', 1, 2003, 001, 'N');


alter table `reservation` add primary key (`isbn`, `username`);
alter table `book` add foreign key (`author_id`) references author (`author_id`) ON DELETE CASCADE;
alter table `book` add foreign key (`category_id`) references category(`category_id`) ON DELETE CASCADE;
alter table `reservation` add foreign key (`isbn`) references book(`isbn`) ON DELETE CASCADE;
alter table `reservation` add foreign key (`username`) references user(`username`) ON DELETE CASCADE;


COMMIT;

/*


-- SELECT `book_title` , `category`, `auth_fname` 
from book 
join `author` using(`author_id`) 
where `author_id` = '12';

-- view all the book and the users who rented them
select book_title Title , firstname, city, reservation_date "Reservation date" 
from reservation 
join book using(isbn) join `user` using(username);

-- only reserved book

-- select book_tile, `year`, reserved , auth_fname from book
-- join author using(author_id)
-- where reserved = 'y';

-- only non reserved books
-- select book_title, `year`, reserved , auth_fname from book
-- join author using(author_id)
-- where reserved = 'n';


-- for every author, display the numbers of books that are not reserved
-- select count(isbn) as "Unreserved", 
-- auth_fname from book 
-- join author using(author_id) 
-- group by auth_fname, reserved 
-- having reserved = 'n'

-- see how many books a user rented:
select count(isbn) "Rented books", firstname
from reservation
join user using(username)
group by firstname;

-- get the numbers of books that a user has rented.
select count(isbn) "Rented", firstname , reservation_date 
from reservation 
join user using(username) 
group by firstname, reservation_date


-- count the numbers of books that have been reserved and show the usernames
-- if no user has reserved it, NULL should be displayed

-- if the book has never been reserved, it will have a null value on the username part
-- if selected from reservation
-- this also meas get the books that do not appear in the reservation

-- for count the number of books reserved by one user
select count(isbn), reservation.username
from reservation
right outer join book using(isbn)
group by reservation.username;


-- show all the book title that they have never reserved by any user
select count(isbn) Rented, book_title, firstname "Rented By", reservation_date "on"
from reservation
inner join user on (user.username = reservation.username)
right outer join book using(isbn)
group by firstname, reservation_date, book_title
having firstname is NULL;


# book titles that have never been rented by a specific user
-- 
select book_title "Title", firstname "Rented by"
from reservation 
join user on (reservation.username = user.username)
right outer join book using(isbn)
where reservation.username not like "tux";

-- Bool that have never been both reserved by this user or no other user
select book_title "Title", firstname "Rented by"
from reservation 
join user on (reservation.username = user.username)
right outer join book using(isbn)
where reservation.username not like "tux" or reservation.username is null; -- this is null will include never rented books


-- secondary join. The reservation table has the username and the isbn. I am now accessing the author, given the 
isbn.
-- first I will join the the resevation table to the book table to get the title of the book, then I will
use this created link to join to the author table using the book table whhich is now available to me.

select book_title "Title", auth_fname "Author", firstname "Rented by"
from reservation 
join user on (reservation.username = user.username)
right outer join book using(isbn) -- this wiil ensure that books that are not reserved are also shown
join author on (book.author_id = author.author_id);

*/