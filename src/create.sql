-- Create and switch to the database
-- after dropping the existed one.
DROP DATABASE IF EXISTS enrollment_system;
CREATE DATABASE enrollment_system;
USE enrollment_system;

-- Create table `person` to be the superclass of `student` and `staff`.
-- The format of `id` is different between `student` and `staff`.
CREATE TABLE person (
  id              VARCHAR(16)     PRIMARY KEY NOT NULL,
  firstname       VARCHAR(15)     NOT NULL,
  lastname        VARCHAR(15)     NOT NULL,
  birth_date      DATE            NULL,
  home_street     VARCHAR(30)     NULL,
  home_city       VARCHAR(15)     NULL,
  -- Use `VARCHAR` to avoid leading 0 problems.
  home_postcode   VARCHAR(10)     NULL,
  contact_number  VARCHAR(11)     NULL
);

-- Create table `staff` to be the superclass of `advisor`, `lecturer`, and `coordinator`.
-- `staff_id` -- `S + programme code + start year + incremental ID`.
--                e.g. `SCYS2012001`, `SCYS2013010`, etc.
CREATE TABLE staff (
  staff_id          VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(staff_id)
    REFERENCES person(id),

  department        VARCHAR(50)   NOT NULL,
  office_location   VARCHAR(100)  NULL
);

-- Create table `coordinator`.
CREATE TABLE coordinator (
  coordinator_id    VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(coordinator_id)
    REFERENCES staff(staff_id),

  qualification     VARCHAR(50)   NOT NULL
);

-- Create table `advisor`.
CREATE TABLE advisor (
  advisor_id  VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(advisor_id)
    REFERENCES staff(staff_id),

  start_year  INT           NOT NULL -- In YYYY format.
);

-- Create table `programme`.
-- `programme_code` -- Abbreviation of programme name like `CYS`, `CST`, etc.
CREATE TABLE programme (
  programme_code  VARCHAR(10)   PRIMARY KEY NOT NULL,
  name            VARCHAR(50)   NOT NULL,
  faculty         VARCHAR(50)   NOT NULL,
  duration        INT           NOT NULL DEFAULT 4,

  coordinator_id  VARCHAR(16)   NOT NULL,
  FOREIGN KEY fk_coordinator_coordinator_id(coordinator_id)
    REFERENCES coordinator(coordinator_id)
);

-- Create table `semester`
CREATE TABLE semester (
  year    INT   NOT NULL,
  month   INT   NOT NULL CHECK(month = 1 OR month = 5 OR month =9),
  PRIMARY KEY (year, month)
);

-- Create table `course`.
-- `course_code` -- `programme_code + year + incremental ID with a leading 0`.
--                e.g. `CYS101`, `CST213`, etc.
CREATE TABLE course (
  course_code     VARCHAR(10)   PRIMARY KEY NOT NULL,
  title           VARCHAR(50)   NOT NULL,
  credit_hour     INT           NOT NULL,
  programme_code  VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code),

  semester_year   INT           NOT NULL,
  semester_month  INT           NOT NULL,
  FOREIGN KEY fk_semester_year_month(semester_year, semester_month)
    REFERENCES semester(year, month)
);

-- Create table `course_prerequisite`.
CREATE TABLE course_prerequisite (
  course_code     VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code),

  prerequisite_code VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_required(prerequisite_code)
    REFERENCES course(course_code),

  PRIMARY KEY (course_code, prerequisite_code)
);

-- Create table `lecturer`.
CREATE TABLE lecturer (
  lecturer_id   VARCHAR(16)   NOT NULL,
  FOREIGN KEY fk_staff_staff_id(lecturer_id)
    REFERENCES staff(staff_id),

  course_code   VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code),

  PRIMARY KEY (lecturer_id, course_code)
);

-- Create table `student`.
-- `student_id` -- `programme code + intake year + semester + incremental ID`.
--              e.g. `CYS2809001`, `CYS2704010`, etc.
-- `status` -- One of `active`, `deferred`, or `graduated`.
-- `level` -- `Year 1`, `Year 2`, etc.
CREATE TABLE student (
  student_id          VARCHAR(16)     PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(student_id)
    REFERENCES person(id),

  emergency_contact   VARCHAR(11)     NOT NULL,
  cgpa                DECIMAL(10, 2)  DEFAULT 0,
  status              ENUM('active', 'deferred', 'graduated') DEFAULT 'active',
  level               VARCHAR(10)     DEFAULT 'Year 1',
  CHECK (level REGEXP '^Year \\d$'),

  programme_code      VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code),

  advisor_id          VARCHAR(16)     NULL,
  FOREIGN KEY fk_advisor_advisor_id(advisor_id)
    REFERENCES person(id)
);

-- Create table `enrollment`.
-- `semester` -- `year + intake month` like `2024/09`, `2025/02`, etc.
-- `final_grade` -- `A`, `B+`, `B`, etc.
CREATE TABLE enrollment (
  enrollment_id       INT             PRIMARY KEY AUTO_INCREMENT,
  registration_date   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  final_grade         CHAR(2)         NULL,

  student_id          VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  course_code         VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code),

  semester_year       INT             NOT NULL,
  semester_month      INT             NOT NULL,
  FOREIGN KEY fk_semester_year_month(semester_year, semester_month)
    REFERENCES semester(year, month)
);

-- Create table `fee`.
CREATE TABLE fee (
  student_id      VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  total_credit    INT             NOT NULL DEFAULT 0,
  total_fee       DECIMAL(10, 2)  NOT NULL DEFAULT 0,
  discount        DECIMAL(10, 2)  NOT NULL DEFAULT 0 CHECK (discount <= 1),
  date            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

  semester_year   INT             NOT NULL,
  semester_month  INT             NOT NULL,
  FOREIGN KEY fk_semester_year_month(semester_year, semester_month)
    REFERENCES semester(year, month),

  payment_status  ENUM('Pending', 'Paid', 'Overdue') NOT NULL DEFAULT 'Pending',
  payment_method  ENUM('Cash', 'QR', 'Card') NOT NULL DEFAULT 'Cash',

  PRIMARY KEY (student_id, semester_year, semester_month)
);
