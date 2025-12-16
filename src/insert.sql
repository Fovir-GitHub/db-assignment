INSERT INTO person (id, firstname, lastname, birth_date, home_street, home_city, home_postcode, contact_number) VALUES
('CYS2809001', 'Alice', 'Tan', '2005-04-15', '1 Jalan A', 'Kuala Lumpur', '50000', '0123456789'),
('CYS2809002', 'Bob', 'Lee', '2004-11-22', '2 Jalan B', 'Petaling Jaya', '46000', '0123456790'),
('CYS2809003', 'Charlie', 'Lim', '2005-06-10', '3 Jalan C', 'Kuala Lumpur', '50010', '0123456791'),
('CYS2809004', 'David', 'Ng', '2005-08-05', '4 Jalan D', 'Shah Alam', '40000', '0123456792'),
('CYS2809005', 'Eva', 'Wong', '2004-12-30', '5 Jalan E', 'Kuala Lumpur', '50020', '0123456793'),
('SCYS2012001', 'Frank', 'Cheah', '1980-01-15', '6 Jalan F', 'Kuala Lumpur', '50030', '0123456794'),
('SCYS2012002', 'Grace', 'Ho', '1985-03-22', '7 Jalan G', 'Petaling Jaya', '46010', '0123456795'),
('SCYS2012003', 'Henry', 'Chong', '1978-07-10', '8 Jalan H', 'Kuala Lumpur', '50040', '0123456796'),
('SCYS2012004', 'Irene', 'Koh', '1982-09-05', '9 Jalan I', 'Shah Alam', '40010', '0123456797'),
('SCYS2012005', 'Jason', 'Lim', '1979-12-30', '10 Jalan J', 'Kuala Lumpur', '50050', '0123456798'),
('SCYS2013001', 'Karen', 'Tan', '1990-05-15', '11 Jalan K', 'Kuala Lumpur', '50060', '0123456799'),
('SCYS2013002', 'Leo', 'Yeo', '1988-08-22', '12 Jalan L', 'Petaling Jaya', '46020', '0123456700'),
('SCYS2013003', 'Mia', 'Ng', '1983-02-10', '13 Jalan M', 'Kuala Lumpur', '50070', '0123456701'),
('SCYS2013004', 'Nick', 'Wong', '1986-11-05', '14 Jalan N', 'Shah Alam', '40020', '0123456702'),
('SCYS2013005', 'Olivia', 'Lee', '1992-12-30', '15 Jalan O', 'Kuala Lumpur', '50080', '0123456703');

INSERT INTO staff (staff_id, department, office_location) VALUES
('SCYS2012001', 'Computer Science', 'Block A, Room 101'),
('SCYS2012002', 'Information Technology', 'Block B, Room 202'),
('SCYS2012003', 'Cybersecurity', 'Block C, Room 303'),
('SCYS2012004', 'Software Engineering', 'Block D, Room 404'),
('SCYS2012005', 'Computer Science', 'Block E, Room 505'),
('SCYS2013001', 'Information Technology', 'Block F, Room 101'),
('SCYS2013002', 'Cybersecurity', 'Block G, Room 202'),
('SCYS2013003', 'Software Engineering', 'Block H, Room 303'),
('SCYS2013004', 'Computer Science', 'Block I, Room 404'),
('SCYS2013005', 'Information Technology', 'Block J, Room 505');

INSERT INTO coordinator (coordinator_id, qualification) VALUES
('SCYS2012001', 'PhD in Computer Science'),
('SCYS2012002', 'MSc in IT'),
('SCYS2012003', 'PhD in Cybersecurity'),
('SCYS2012004', 'MSc in Software Engineering'),
('SCYS2012005', 'PhD in Computer Science');

INSERT INTO advisor (advisor_id, start_year) VALUES
('SCYS2013001', 2015),
('SCYS2013002', 2016),
('SCYS2013003', 2017),
('SCYS2013004', 2018),
('SCYS2013005', 2019);

INSERT INTO programme (programme_code, name, faculty, duration, coordinator_id) VALUES
('CYS', 'Cybersecurity', 'Faculty of IT', 4, 'SCYS2012003'),
('CST', 'Computer Science', 'Faculty of Computing', 4, 'SCYS2012001'),
('CIT', 'Information Technology', 'Faculty of IT', 4, 'SCYS2012002'),
('SE', 'Software Engineering', 'Faculty of Computing', 4, 'SCYS2012004');

INSERT INTO semester (year, month) VALUES
(2024, 1), (2024, 5), (2024, 9),
(2025, 1), (2025, 5), (2025, 9),
(2026, 1), (2026, 5), (2026, 9),
(2027, 1), (2027, 5), (2027, 9),
(2028, 1), (2028, 5), (2028, 9);

INSERT INTO course (course_code, title, credit_hour, programme_code, semester_year, semester_month) VALUES
('CYS101', 'Intro to Cybersecurity', 3, 'CYS', 2024, 1),
('CYS102', 'Network Security', 3, 'CYS', 2024, 5),
('CYS103', 'Cryptography', 3, 'CYS', 2024, 9),
('CST101', 'Intro to CS', 3, 'CST', 2024, 1),
('CST102', 'Data Structures', 3, 'CST', 2024, 5),
('CST103', 'Algorithms', 3, 'CST', 2024, 9),
('CIT101', 'IT Fundamentals', 3, 'CIT', 2024, 1),
('CIT102', 'Database Systems', 3, 'CIT', 2024, 5),
('CIT103', 'Web Development', 3, 'CIT', 2024, 9),
('SE101', 'Software Engineering Basics', 3, 'SE', 2024, 1),
('SE102', 'Software Design', 3, 'SE', 2024, 5),
('SE103', 'Software Testing', 3, 'SE', 2024, 9);

INSERT INTO course_prerequisite (course_code, prerequisite_code) VALUES
('CYS102', 'CYS101'),
('CYS103', 'CYS102'),
('CST102', 'CST101'),
('CST103', 'CST102'),
('CIT102', 'CIT101'),
('CIT103', 'CIT102'),
('SE102', 'SE101'),
('SE103', 'SE102');

INSERT INTO lecturer (lecturer_id, course_code) VALUES
('SCYS2012003', 'CYS101'),
('SCYS2013002', 'CYS102'),
('SCYS2013003', 'CYS103'),
('SCYS2012001', 'CST101'),
('SCYS2012002', 'CST102'),
('SCYS2013001', 'CST103'),
('SCYS2012002', 'CIT101'),
('SCYS2013004', 'CIT102'),
('SCYS2013005', 'CIT103'),
('SCYS2012004', 'SE101'),
('SCYS2012005', 'SE102'),
('SCYS2013003', 'SE103');

INSERT INTO student (student_id, cgpa, status, level, programme_code, advisor_id) VALUES
('CYS2809001', 3.50, 'active', 'Year 1', 'CYS', 'SCYS2013001'),
('CYS2809002', 3.20, 'active', 'Year 1', 'CYS', 'SCYS2013002'),
('CYS2809003', 3.80, 'active', 'Year 2', 'CYS', 'SCYS2013003'),
('CYS2809004', 2.90, 'active', 'Year 2', 'CYS', 'SCYS2013004'),
('CYS2809005', 3.60, 'active', 'Year 3', 'CYS', 'SCYS2013005');

INSERT INTO enrollment (student_id, course_code, semester_year, semester_month, final_grade) VALUES
('CYS2809001', 'CYS101', 2024, 1, 'A'),
('CYS2809001', 'CYS102', 2024, 5, 'B+'),
('CYS2809002', 'CYS101', 2024, 1, 'B'),
('CYS2809002', 'CYS102', 2024, 5, 'A-'),
('CYS2809003', 'CYS101', 2024, 1, 'A'),
('CYS2809003', 'CYS102', 2024, 5, 'A'),
('CYS2809004', 'CYS101', 2024, 1, 'B+'),
('CYS2809004', 'CYS102', 2024, 5, 'B'),
('CYS2809005', 'CYS103', 2024, 9, 'A');

INSERT INTO fee (student_id, total_credit, total_fee, discount, semester_year, semester_month, payment_status, payment_method) VALUES
('CYS2809001', 6, 3000, 0, 2024, 5, 'Paid', 'Card'),
('CYS2809002', 6, 3000, 100, 2024, 5, 'Paid', 'Cash'),
('CYS2809003', 6, 3000, 200, 2024, 5, 'Pending', 'QR'),
('CYS2809004', 6, 3000, 0, 2024, 5, 'Overdue', 'Card'),
('CYS2809005', 3, 1500, 0, 2024, 9, 'Pending', 'Cash');
