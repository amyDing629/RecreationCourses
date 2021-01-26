 -- Ward: wardID, Name: ward name, Area: ward area

name: the name of the ward
create table Wards(
Ward Integer primary key,
Name Varchar(100) NOT NULL,
Area Float NOT NULL,
check (Area >= 0));

-- Location: course location, Postal_Code: the postal code of the location, Ward: wardID of the location

create table Locations(
Location varchar(100) primary key,
Postal_Code  varchar(7) NOT NULL,
Ward int,
foreign key(Ward) references Wards(Ward) on update cascade on delete cascade);

-- Facility: course location, Facility: facility name, Facility_Type: facility type, such as “room”, “gym”..., facility_district: south/west/east/north district of the location

create table Facilities(
Location varchar(100),
Facility Varchar(100) NOT NULL,
Facility_Type Varchar(100) NOT NULL,
Facility_district Varchar(50) NOT NULL,
primary key(Location, Facility),
foreign key(Location) references Locations(Location) on update cascade on delete cascade);

-- TimeID: unique id created as key, reg_session:registration season, days_of_the_week: day in a week that the course is held, such as monday, startMonth: the month that the course starts, startDay: the day in the month that the course starts, start_hour: the course starts within an hour from the start_hour, num_of_weeks: duration of the course, course_hours: the total amount of course hours (all sessions included).

create table Times(
TimeID int primary key,
check (TimeID>=0),
Reg_Session varchar(7),
check (Reg_Session in ('Spring', 'Summer', 'Fall', 'Winter')),
Days_of_the_Week varchar(100) NOT NULL,
StartMonth varchar(10),
StartDay int,
check (StartDay >=0 and StartDay <= 31),
Start_hour int,
check (Start_hour >=0 and Start_hour <=23),
Num_of_Weeks int,
check (Num_of_Weeks >= 0),
Course_Hours float,
check (Course_Hours >= 0.0)
);

-- LimitID: unique id created as a key, Min_age: minimum age allowed to attend the course, Max_age: maximum age allowed to attend the course, Min_Reg: minimum registration to open the course, Max_Reg: maximum registration allowed for the course

create table Limits(
LimitID Integer primary key,
Min_age Float NOT NULL,
Max_age Float NOT NULL,
Min_Reg Integer NOT NULL,
Max_Reg Integer NOT NULL,
check (Min_age >= 0 and Max_age >= 0 and Min_Reg >= 0 and Max_Reg >= 0));

-- Program: program name, Section: what the course is about, Subsection: the group of people that are allowed to take the course

create table Programs(
Program Varchar(100) primary key,
Section Varchar(100) NOT NULL,
Subsection Varchar(20) NOT NULL,
check (Subsection in ('Child/Youth', 'Adult', ‘Youth/Adult',  'Early Child', 'Child', 'Youth', 'Older Adult', 'All Ages')));

-- Course_Barcode: unique course code, Name: course name, Location: course location, facility: course facility name, TimeID: course time ID (reference to times table), program: program name (reference to programs table), course_type: register/drop in, number_of_classes: the number of classes the course contains, limitID: course limit ID (reference to limits table), course_waitlist: the number of people in the waitlist, course_reg: the number of people registered for the course, visits: the number of times that attended the course before

create table Courses (
  Course_Barcode integer primary key,
  Name varchar(100) NOT NULL,
  Location varchar(100),
  facility varchar(100),
  TimeID integer,
  Program varchar(100) NOT NULL,
  Course_Type varchar(100), 
  Number_of_classes integer NOT NULL,
  LimitID integer,
  Course_Waitlist integer NOT NULL,
  Course_Reg integer NOT NULL,
  Visits integer NOT NULL,
  foreign key(location,facility) references Facilities(Location, facility) on update cascade on delete cascade,
  foreign key(TimeID) references Times(TimeID) on update cascade on delete cascade,
  foreign key(Program) references Programs(Program) on update cascade on delete cascade,
  foreign key(LimitId) references Limits(LimitID) on update cascade on delete cascade,
  check (Course_Type in ('Regular', 'Drop-In'))
);


