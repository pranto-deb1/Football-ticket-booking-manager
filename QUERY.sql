-- create users table --
CREATE TABLE Users (
  user_id serial PRIMARY KEY,
  full_name varchar(100) NOT NULL,
  email varchar(100) UNIQUE NOT NULL,
  role varchar(25) DEFAULT 'Football Fan' CHECK (role IN ('Ticket Manager', 'Football Fan')),
  phone_number varchar(20)
);


-- create matches table --
CREATE TABLE Matches (
  match_id serial PRIMARY KEY,
  fixture varchar(150) NOT NULL,
  tournament_category varchar(150) NOT NULL,
  base_ticket_price decimal(10, 2),
  match_status varchar(20) DEFAULT 'Available' CHECK (
    match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed')
  )
);


-- create bookings table --
CREATE TABLE Bookings (
  booking_id serial PRIMARY KEY,
  user_id int NOT NULL,
  match_id int NOT NULL,
  seat_number varchar(20),
  payment_status varchar(25) DEFAULT 'Pending' CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  ),
  total_cost decimal(10, 2) NOT NULL,
  FOREIGN key (user_id) REFERENCES Users (user_id),
  FOREIGN key (match_id) REFERENCES Matches (match_id)
);


-- insert users --
insert into Users (full_name, email, role, phone_number) values
('Tanvir Rahman','tanvir@mail.com','Football Fan','+8801711111111'),
('Asif Haque','asif@mail.com','Football Fan','+8801722222222'),
('Sajjad Rahman','sajjad@mail.com','Ticket Manager','+8801733333333'),
('Jannat Ara','jannat@mail.com','Football Fan',NULL),
('Nusrat Jahan','nusrat@mail.com','Football Fan','+8801744444444'),
('Mahmud Hasan','mahmud@mail.com','Football Fan','+8801755555555'),
('Farhan Ahmed','farhan@mail.com','Football Fan','+8801766666666'),
('Rifat Hossain','rifat@mail.com','Ticket Manager','+8801777777777'),
('Mim Akter','mim@mail.com','Football Fan','+8801788888888'),
('Shakib Chowdhury','shakib@mail.com','Football Fan',NULL),
('Nayeem Islam','nayeem@mail.com','Football Fan','+8801799999999'),
('Sadia Rahman','sadia@mail.com','Ticket Manager','+8801811111111'),
('Mehedi Hasan','mehedi@mail.com','Football Fan','+8801822222222'),
('Tania Sultana','tania@mail.com','Football Fan',NULL);

-- insert matches --
insert into Matches (fixture, tournament_category, base_ticket_price, match_status) values
('Real Madrid vs Barcelona','Champions League',150,'Available'),
('Man City vs Liverpool','Premier League',120,'Selling Fast'),
('Bayern Munich vs PSG','Champions League',130,'Available'),
('AC Milan vs Inter Milan','Serie A',90,'Sold Out'),
('Juventus vs Roma','Serie A',80,'Available'),
('Arsenal vs Chelsea','Premier League',110,'Available'),
('Tottenham vs Manchester United','Premier League',125,'Selling Fast'),
('Borussia Dortmund vs RB Leipzig','Bundesliga',95,'Available'),
('Atletico Madrid vs Sevilla','La Liga',85,'Available'),
('Napoli vs Lazio','Serie A',90,'Selling Fast'),
('Ajax vs PSV Eindhoven','Eredivisie',75,'Available'),
('Benfica vs Porto','Primeira Liga',100,'Sold Out'),
('Celtic vs Rangers','Scottish Premiership',80,'Available'),
('Galatasaray vs Fenerbahce','Super Lig',105,'Selling Fast'),
('Flamengo vs Palmeiras','Brasileirao',70,'Postponed');

-- insert bookings --
insert into Bookings (user_id, match_id, seat_number, payment_status, total_cost) values
(1, 1,'A-12','Confirmed',150),
(1, 2,'B-04','Confirmed',120),
(2, 1,'A-13','Confirmed',150),
(3, 1,NULL,NULL,150),
(4, 2,'C-20','Pending',120),
(5, 3, 'D-05', 'Confirmed', 130),
(6, 4, 'E-10', 'Confirmed', 90),
(7, 5, 'F-08', 'Pending', 80),
(8, 6, 'G-15', 'Confirmed', 110),
(9, 7, 'H-22', 'Confirmed', 125),
(10, 8, 'J-03', 'Pending', 95),
(11, 9, 'K-17', 'Confirmed', 85),
(12, 10, 'L-09', 'Confirmed', 90),
(13, 11, NULL, NULL, 75),
(14, 12, 'M-14', 'Confirmed', 100);


-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
select match_id, fixture, base_ticket_price 
  from Matches 
  where tournament_category='Champions League' 
  and match_status = 'Available';


-- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
select user_id, full_name, email
  from Users 
  where full_name like 'Tanvir%' 
  or full_name like '%Haque%'


-- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
select booking_id, user_id, match_id, coalesce(payment_status, 'Action Required')
  as systematic_status 
  from Bookings 
  where payment_status is null


-- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
select booking_id, Users.full_name, Matches.fixture, total_cost from Bookings
inner join Users on Bookings.user_id = Users.user_id
inner join Matches on Bookings.match_id = Matches.match_id



-- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
select Users.user_id, full_name, Bookings.booking_id from Users
left join Bookings on Users.user_id = Bookings.user_id


-- Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.
select booking_id, match_id, total_cost from Bookings where total_cost > (select avg(total_cost) from Bookings)


-- Query 7: Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.
select * from Matches order by base_ticket_price desc limit 2 offset 1







