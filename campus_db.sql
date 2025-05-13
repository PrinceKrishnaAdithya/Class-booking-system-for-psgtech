CREATE TABLE Facility (
    facility_id INT PRIMARY KEY AUTO_INCREMENT,
    facility_name VARCHAR(50) NOT NULL
);

CREATE TABLE Building (
    building_id INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(50) NOT NULL
);

CREATE TABLE Room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL,
    building_id INT NOT NULL,
    capacity INT NOT NULL,
    room_type VARCHAR(20) NOT NULL,
    floor INT NOT NULL,
    FOREIGN KEY (building_id) REFERENCES Building(building_id)
);

CREATE TABLE RoomFacility (
    room_id INT,
    facility_id INT,
    PRIMARY KEY (room_id, facility_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (facility_id) REFERENCES Facility(facility_id)
);

CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(50) NOT NULL
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE Timings (
    timing_id INT PRIMARY KEY AUTO_INCREMENT,
    start_time varchar(10) NOT NULL,
    end_time varchar(10) NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    course_id INT NOT NULL,
    subject_id INT NOT NULL,
    room_id INT NOT NULL,
    timing_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id),
    FOREIGN KEY (timing_id) REFERENCES Timings(timing_id)
);


CREATE TABLE CourseBooking (
    booking_id INT,
    course_id INT,
    PRIMARY KEY (booking_id, course_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO Booking (staff_id, course_id, subject_id, room_id, timing_id, day_of_week, status) VALUES
    (5, 1, 34, 1, 1, 'Monday', 'Confirmed'),
    (3, 1, 3, 1, 2, 'Monday', 'Confirmed'),
	(6, 1, 6, 19, 3, 'Monday', 'Confirmed'),
    (6, 1, 6, 19, 4, 'Monday', 'Confirmed'),
	(4, 1, 4, 1, 5, 'Monday', 'Confirmed'),
    (1, 1, 1, 1, 6, 'Monday', 'Confirmed'),
	(2, 1, 2, 1, 7, 'Monday', 'Confirmed'),
    (4, 1, 8, 18, 1, 'Tuesday', 'Confirmed'),
	(4, 1, 8, 18, 2, 'Tuesday', 'Confirmed'),
    (1, 1, 1, 11, 3, 'Tuesday', 'Confirmed'),
	(3, 1, 3, 11, 4, 'Tuesday', 'Confirmed'),
    (4, 1, 4, 11, 5, 'Tuesday', 'Confirmed'),
	(2, 1, 2, 11, 6, 'Tuesday', 'Confirmed'),
    (5, 1, 5, 11, 7, 'Tuesday', 'Confirmed'),
    (1, 1, 1, 8, 2, 'Wednesday', 'Confirmed'),
	(5, 1, 5, 8, 3, 'Wednesday', 'Confirmed'),
    (4, 1, 4, 8, 4, 'Wednesday', 'Confirmed'),
	(5, 1, 5, 8, 5, 'Wednesday', 'Confirmed'),
    (3, 1, 3, 8, 6, 'Wednesday', 'Confirmed'),
	(9, 1, 33, 8, 7, 'Wednesday', 'Confirmed'),
    (2, 1, 2, 11, 1, 'Thursday', 'Confirmed'),
	(1, 1, 1, 11, 2, 'Thursday', 'Confirmed'),
    (2, 1, 7, 19, 3, 'Thursday', 'Confirmed'),
	(2, 1, 7, 19, 4, 'Thursday', 'Confirmed'),
	(6, 1, 6, 19, 6, 'Thursday', 'Confirmed'),
    (6, 1, 6, 19, 7, 'Thursday', 'Confirmed'),
	(5, 1, 5, 2, 1, 'Friday', 'Confirmed'),
    (4, 1, 4, 2, 2, 'Friday', 'Confirmed'),
	(4, 1, 8, 18, 3, 'Friday', 'Confirmed'),
    (4, 1, 8, 18, 4, 'Friday', 'Confirmed'),
	(2, 1, 7, 19, 5, 'Friday', 'Confirmed'),
	(2, 1, 7, 19, 6, 'Friday', 'Confirmed'),
	
	(24, 2, 25, 9, 1, 'Monday', 'Confirmed'), -- 23XT41, Navaneethan P, H204
    (7, 2, 27, 9, 2, 'Monday', 'Confirmed'),  -- 23XT43, Gowrisankar S, H204
    (26, 2, 30, 12, 3, 'Monday', 'Confirmed'), -- 23XT46, Regis Annie W, M504
    (26, 2, 30, 12, 4, 'Monday', 'Confirmed'), -- 23XT46, Regis Annie W, M504
    (18, 2, 32, 12, 5, 'Monday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504
    (18, 2, 32, 12, 6, 'Monday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504

    (18, 2, 32, 12, 1, 'Tuesday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504
    (18, 2, 32, 12, 2, 'Tuesday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504
    (26, 2, 26, 8, 3, 'Tuesday', 'Confirmed'),  -- 23XT42, Regis Annie W, H203
    (26, 2, 26, 8, 4, 'Tuesday', 'Confirmed'),  -- 23XT42, Regis Annie W, H203
    (24, 2, 25, 12, 5, 'Tuesday', 'Confirmed'), -- 23XT41, Navaneethan P, M504
    (25, 2, 29, 12, 6, 'Tuesday', 'Confirmed'), -- 23XT45, Ramesh Balasubramaniam, M504

    (19, 2, 31, 12, 1, 'Wednesday', 'Confirmed'), -- 23XT47, Sasi Kumar M, M504
    (19, 2, 31, 12, 2, 'Wednesday', 'Confirmed'), -- 23XT47, Sasi Kumar M, M504
    (26, 2, 30, 12, 3, 'Wednesday', 'Confirmed'), -- 23XT46, Regis Annie W, M504
    (26, 2, 30, 12, 4, 'Wednesday', 'Confirmed'), -- 23XT46, Regis Annie W, M504
    (18, 2, 32, 12, 5, 'Wednesday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504
    (18, 2, 32, 12, 6, 'Wednesday', 'Confirmed'), -- 23XT48, Caroline Mary A, M504

    (19, 2, 31, 9, 1, 'Thursday', 'Confirmed'), -- 23XT47, Sasi Kumar M, H204
    (19, 2, 31, 9, 2, 'Thursday', 'Confirmed'), -- 23XT47, Sasi Kumar M, H204
    (26, 2, 30, 9, 3, 'Thursday', 'Confirmed'), -- 23XT46, Regis Annie W, H204
    (26, 2, 30, 9, 4, 'Thursday', 'Confirmed'), -- 23XT46, Regis Annie W, H204
    (27, 2, 28, 10, 5, 'Thursday', 'Confirmed'), -- 23XT44, Suganthi S D, M201
    (27, 2, 28, 10, 6, 'Thursday', 'Confirmed'), -- 23XT44, Suganthi S D, M201

    (7, 2, 27, 12, 1, 'Friday', 'Confirmed'),  -- 23XT43, Gowrisankar S, M504
    (7, 2, 27, 12, 2, 'Friday', 'Confirmed'),  -- 23XT43, Gowrisankar S, M504
    (19, 2, 31, 12, 3, 'Friday', 'Confirmed'), -- 23XT47, Sasi Kumar M, M504
    (19, 2, 31, 12, 4, 'Friday', 'Confirmed'), -- 23XT47, Sasi Kumar M, M504
    (26, 2, 30, 12, 5, 'Friday', 'Confirmed'), -- 23XT46, Regis Annie W, M504
    (26, 2, 30, 12, 6, 'Friday', 'Confirmed'),
    
    (28, 3, 19, 6, 1, 'Monday', 'Confirmed'),  -- 23XC43, Poomagal S, J514
    (28, 3, 19, 9, 2, 'Monday', 'Confirmed'),  -- 23XC43, Poomagal S, H204
    (29, 3, 22, 12, 3, 'Monday', 'Confirmed'), -- 23XC46, Sreelaja N K, M504
    (29, 3, 22, 12, 4, 'Monday', 'Confirmed'), -- 23XC46, Sreelaja N K, M504
    (2, 3, 24, 12, 5, 'Monday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504
    (2, 3, 24, 12, 6, 'Monday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504

    (2, 3, 24, 12, 1, 'Tuesday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504
    (2, 3, 24, 12, 2, 'Tuesday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504
    (29, 3, 18, 8, 3, 'Tuesday', 'Confirmed'),  -- 23XC42, Sreelaja N K, H203
    (29, 3, 18, 8, 4, 'Tuesday', 'Confirmed'),  -- 23XC42, Sreelaja N K, H203
    (7, 3, 17, 12, 5, 'Tuesday', 'Confirmed'),  -- 23XC41, Gowrisankar S, M504
    (9, 3, 21, 12, 6, 'Tuesday', 'Confirmed'),  -- 23XC45, Sakthiganesan M, M504

    (8, 3, 23, 12, 1, 'Wednesday', 'Confirmed'), -- 23XC47, Sreeja N K, M504
    (8, 3, 23, 12, 2, 'Wednesday', 'Confirmed'), -- 23XC47, Sreeja N K, M504
    (29, 3, 22, 12, 3, 'Wednesday', 'Confirmed'), -- 23XC46, Sreelaja N K, M504
    (29, 3, 22, 12, 4, 'Wednesday', 'Confirmed'), -- 23XC46, Sreelaja N K, M504
    (2, 3, 24, 12, 5, 'Wednesday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504
    (2, 3, 24, 12, 6, 'Wednesday', 'Confirmed'),  -- 23XC48, Kasthuri Bai M, M504

    (8, 3, 23, 9, 1, 'Thursday', 'Confirmed'),  -- 23XC47, Sreeja N K, H204
    (8, 3, 23, 9, 2, 'Thursday', 'Confirmed'),  -- 23XC47, Sreeja N K, H204
    (29, 3, 22, 9, 3, 'Thursday', 'Confirmed'), -- 23XC46, Sreelaja N K, H204
    (29, 3, 22, 9, 4, 'Thursday', 'Confirmed'), -- 23XC46, Sreelaja N K, H204
    (27, 3, 20, 10, 5, 'Thursday', 'Confirmed'), -- 23XC44, Suganthi S D, M201
    (27, 3, 20, 10, 6, 'Thursday', 'Confirmed'), -- 23XC44, Suganthi S D, M201

    (7, 3, 17, 12, 1, 'Friday', 'Confirmed'),  -- 23XC41, Gowrisankar S, M504
    (7, 3, 17, 12, 2, 'Friday', 'Confirmed'),  -- 23XC41, Gowrisankar S, M504
    (8, 3, 23, 12, 3, 'Friday', 'Confirmed'),  -- 23XC47, Sreeja N K, M504
    (8, 3, 23, 12, 4, 'Friday', 'Confirmed'),  -- 23XC47, Sreeja N K, M504
    (29, 3, 22, 12, 5, 'Friday', 'Confirmed'), -- 23XC46, Sreelaja N K, M504
    (29, 3, 22, 12, 6, 'Friday', 'Confirmed'),
    
    (15, 4, 15, 18, 1, 'Monday', 'Confirmed'), -- 23XW47, Nikitha Ramakrishnan, CSL3
    (16, 4, 15, 18, 2, 'Monday', 'Confirmed'), -- 23XW47, Saritakumar N, CSL3
    (17, 4, 13, 12, 3, 'Monday', 'Confirmed'), -- 23XW45, Thulasimani L, M504
    (17, 4, 13, 12, 4, 'Monday', 'Confirmed'), -- 23XW45, Thulasimani L, M504
    (10, 4, 16, 20, 5, 'Monday', 'Confirmed'), -- 23XW48, Uma Vetri Selvi G, NSL
    (10, 4, 16, 20, 6, 'Monday', 'Confirmed'), -- 23XW48, Uma Vetri Selvi G, NSL
    (11, 4, 12, 11, 7, 'Monday', 'Confirmed'), -- 23XW44, Kumaresan M, M202

    (11, 4, 12, 11, 1, 'Tuesday', 'Confirmed'), -- 23XW44, Kumaresan M, M202
    (12, 4, 11, 10, 2, 'Tuesday', 'Confirmed'), -- 23XW43, Muthusamy A, M201
    (11, 4, 12, 11, 3, 'Tuesday', 'Confirmed'), -- 23XW44, Kumaresan M, M202
    (13, 4, 10, 10, 4, 'Tuesday', 'Confirmed'), -- 23XW42, Thanalakshmi P, M201
    (17, 4, 13, 10, 5, 'Tuesday', 'Confirmed'), -- 23XW45, Thulasimani L, M201
    (17, 4, 13, 10, 6, 'Tuesday', 'Confirmed'), -- 23XW45, Thulasimani L, M201
    (17, 4, 13, 10, 7, 'Tuesday', 'Confirmed'), -- 23XW45, Thulasimani L, M201

    (15, 4, 9, 1, 1, 'Wednesday', 'Confirmed'),  -- 23XW41, Nikitha Ramakrishnan, J202
    (15, 4, 9, 1, 2, 'Wednesday', 'Confirmed'),  -- 23XW41, Nikitha Ramakrishnan, J202
    (13, 4, 14, 19, 3, 'Wednesday', 'Confirmed'), -- 23XW46, Thanalakshmi P, DSL
    (13, 4, 14, 19, 4, 'Wednesday', 'Confirmed'), -- 23XW46, Thanalakshmi P, DSL
    (16, 4, 15, 18, 5, 'Wednesday', 'Confirmed'), -- 23XW47, Saritakumar N, CSL3
    (16, 4, 15, 18, 6, 'Wednesday', 'Confirmed'), -- 23XW47, Saritakumar N, CSL3
    (12, 4, 11, 11, 7, 'Wednesday', 'Confirmed'), -- 23XW43, Muthusamy A, M202

    (12, 4, 11, 9, 2, 'Thursday', 'Confirmed'),  -- 23XW43, Muthusamy A, H204
    (10, 4, 16, 21, 3, 'Thursday', 'Confirmed'), -- 23XW48, Uma Vetri Selvi G, IIL
    (10, 4, 16, 21, 4, 'Thursday', 'Confirmed'), -- 23XW48, Uma Vetri Selvi G, IIL
    (11, 4, 12, 10, 5, 'Thursday', 'Confirmed'), -- 23XW44, Kumaresan M, M201
    (11, 4, 12, 10, 6, 'Thursday', 'Confirmed'), -- 23XW44, Kumaresan M, M201

    (15, 4, 9, 3, 1, 'Friday', 'Confirmed'),   -- 23XW41, Nikitha Ramakrishnan, J511
    (15, 4, 9, 3, 2, 'Friday', 'Confirmed'),   -- 23XW41, Nikitha Ramakrishnan, J511
    (13, 4, 10, 5, 3, 'Friday', 'Confirmed'),  -- 23XW42, Thanalakshmi P, J513
    (12, 4, 11, 5, 4, 'Friday', 'Confirmed'),  -- 23XW43, Muthusamy A, J513
    (13, 4, 14, 21, 5, 'Friday', 'Confirmed'), -- 23XW46, Thanalakshmi P, IIL
    (13, 4, 14, 21, 6, 'Friday', 'Confirmed');

INSERT INTO subject (subject_name,subject_code) values
	('Optimization Techniques','23XD41'),
	('DataBase Management system','23XD42'),
	('Predictive Analysis','23XD43'),
	('Operating System','23XD44'),
	('Transforms and its applications','23XD45'),
	('Data Analytice and visualization lab','23XD46'),
	('RDBMS lab','23XD47'),
	('Operating systems lab','23XD48'),
	
	('Accounting And Financial Management','23XW41'),
	('Computer Networks','23XW42'),
	('Operations Research','23XW43'),
	('Operating System','23XW44'),
	('Software Engineering Techniques','23XW45'),
	('Computer Networks lab','23XW46'),
	('Unix System Programming lab','23XW47'),
	('Web Development lab','23XW48'),
	
	('Optimization Techniques','23XC41'),
	('Computer Networks','23XC42'),
	('Cryptography','23XC43'),
	('Operating System','23XC44'),
	('Hardware Security','23XC45'),
	('Computer Networks lab','23XC46'),
	('Java Programming lab','23XC47'),
	('Operating Systems lab','23XC48'),
	
	('Stochastic Processes','23XT41'),
	('Computer Networks','23XT42'),
	('Optimization Techniques','23XT43'),
	('Operating Systems','23XT44'),
	('Database Management System','23XT45'),
	('Computer Networks lab','23XT46'),
	('Operating Systems lab','23XT47'),
	('RDBMS lab','23XT48'),
	
	('Seminar','Common_1'),
	('TWM','Common_2');

INSERT INTO building (building_name) values
	('J Block'),
	('H Block'),
	('M Block'),
	('K Block'),
	('A Block');

INSERT INTO course (course_name) values
	('MSc Data Science'),
	('MSc Theoretical Computer Science'),
	('MSc Cyber Security'),
	('MSc Software Systems');

INSERT INTO facility (facility_name) values
	('AC'),
	('Projector'),
	('Smart Board');
    
INSERT INTO staff (staff_name) values
	('Lekshmi RS'),
	('Kasthuri Bai M'),
	('Senthil Kumar M'),
	('Senthil Kumaran V'),
	('Uma Gayathri G'),
	('KrishnaKumar S'),
	('Gowrisankar S'),
	('Sreeja NK'),
	('Sakthiganesan M'),
	('Uma Vetri Selvi G'),
	('Kumaresan M'),
	('Muthusamy A'),
	('Thanalakshmi P'),
	('Nivetha V'),
	('Nikitha Ramakrishnan'),
	('Saritakumar N'),
	('Thulasimani L'),
	('Caroline Mary A'),
	('Sasi Kumar M'),
	('Mohan K'),
	('Sindhuja S'),
	('Mohanraj N'),
	('Syed Nazir Ahmed AS'),
	('Navaneethan P'),
	('Ramesh Balasubramaniam'),
	('Regis Annie W'),
	('Suganthi SD'),
	('Poomagal S'),
	('Sreelaja NK'),
	('Dinakar V');

INSERT INTO Timings (start_time, end_time) VALUES
    ('08:30', '09:20'),
    ('09:20', '10:10'),
    ('10:30', '11:20'),
    ('11:20', '12:10'),
	('13:40', '14:30'),
    ('14:30', '15:20'),
    ('15:30', '16:20');
	

INSERT INTO Room (room_number, building_id, capacity, room_type, floor) VALUES
    ('J202', 1, 50, 'lecture', 1),
    ('J508', 1, 30, 'lecture', 4),
    ('J511', 1, 40, 'lecture', 4),
    ('J512', 1, 60, 'lecture', 4),
    ('J513', 1, 20, 'lecture', 4),
	('J514', 1, 60, 'lecture', 4),
    ('J516', 1, 20, 'lecture', 4),
	('H203', 2, 60, 'lecture', 1),
    ('H204', 2, 20, 'lecture', 1),
	('M201', 3, 20, 'lecture', 1),
	('M202', 3, 60, 'lecture', 1),
    ('M504', 3, 20, 'lecture', 4),
	('K502', 4, 20, 'lecture', 4),
	('A307', 5, 20, 'lecture', 3),
	('A313', 5, 20, 'lecture', 3),
	('CSL 1', 3, 60, 'lab', 0),
    ('CSL 2', 3, 20, 'lab', 0),
	('CSL 3', 3, 20, 'lab', 0),
	('DSL', 3, 60, 'lab', 0),
    ('NSL', 1, 20, 'lab', 3),
	('IIL', 1, 20, 'lab', 4),
	('OCL', 3, 20, 'lab', 1),
	('SIL', 3, 20, 'lab', 1);

