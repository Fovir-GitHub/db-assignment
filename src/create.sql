-- Create and switch to the database
-- after dropping the existed one.
DROP DATABASE IF EXISTS student_course;
CREATE DATABASE student_course;
USE student_course;

-- Create table `course`.
CREATE TABLE course (
  course_code VARCHAR(10) PRIMARY KEY NOT NULL,
  title       VARCHAR(50) NOT NULL,
  credit_hour INT         NOT NULL,

  -- TODO: Check the data type of `Semester`.
  semester    INT         NOT NULL
);

-- Create table `programme`.
-- TODO:
--  1. Check the data type of `Duration`.
--  2. Set `Coordinator` as a foreign key.
CREATE TABLE programme (
  programme_code  VARCHAR(10)   PRIMARY KEY NOT NULL,
  name            VARCHAR(50)   NOT NULL,
  faculty         VARCHAR(50)   NOT NULL,
  duration        INT           NOT NULL DEFAULT 4,
  coordinator     VARCHAR(50)   NULL,

  course_code     VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code),

  -- Prevent a programme from having multiple same courses.
  UNIQUE(programme_code, course_code)
);

-- Create table `student`.
CREATE TABLE student (
  matric_number   INT             PRIMARY KEY NOT NULL,
  firstname       VARCHAR(15)     NOT NULL,
  lastname        VARCHAR(15)     NOT NULL,
  birth_date      DATE            NOT NULL,
  home_street     VARCHAR(30)     NOT NULL,
  home_city       VARCHAR(15)     NOT NULL,
  home_postcode   INT             NOT NULL,
  current_cgpa    DECIMAL(10, 2)  DEFAULT 0,
  status          VARCHAR(10)     NOT NULL,
  level           VARCHAR(10)     NOT NULL,

  programme_code  VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code)
);

-- Create table `staff` to be the superclass of `advisor` and `coordinator`.
CREATE TABLE staff (
  staff_id          INT           PRIMARY KEY NOT NULL,
  name              VARCHAR(20)   NOT NULL,
  contact_number    VARCHAR(11)   NOT NULL,
  department        VARCHAR(50)   NOT NULL,
  office_location   VARCHAR(100)  NOT NULL
);

-- Create table `advisor`.
CREATE TABLE advisor (
  staff_id        INT   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(staff_id)
    REFERENCES staff(staff_id),

  -- Set to unique to avoid duplicated assignments.
  matric_number   INT   NOT NULL UNIQUE,
  FOREIGN KEY fk_student_matric_number(matric_number)
    REFERENCES student(matric_number)
);

-- Create table `coordinator`.
CREATE TABLE coordinator (
  staff_id          INT           PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(staff_id)
    REFERENCES staff(staff_id),

  -- Avoid duplicated assignments.
  programme_code    VARCHAR(10)   NOT NULL UNIQUE,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code)
);

-- Create table `enrollment`.
CREATE TABLE enrollment (
  id                  INT             PRIMARY KEY NOT NULL AUTO_INCREMENT,
  academic_session    VARCHAR(10)     NOT NULL,
  registration_date   DATE            NOT NULL,
  cgpa                DECIMAL(10, 2)  NOT NULL,
  final_grade         INT             NULL,

  staff_id            INT             NOT NULL,
  FOREIGN KEY fk_advisor_staff_id(staff_id)
    REFERENCES advisor(staff_id),

  matric_number       INT             NOT NULL,
  FOREIGN KEY fk_student_matric_number(matric_number)
    REFERENCES student(matric_number),

  course_code         VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code)
);
