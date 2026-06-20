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



