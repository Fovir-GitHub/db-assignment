-- Create and switch to the database
-- after dropping the existed one.
DROP DATABASE IF EXISTS student_course;
CREATE DATABASE student_course;
USE student_course;

-- Create table `person` to be the superclass of `student` and `staff`.
CREATE TABLE person (
  id          VARCHAR(16)     PRIMARY KEY NOT NULL,
  firstname   VARCHAR(15)     NOT NULL,
  lastname    VARCHAR(15)     NOT NULL
);

-- Create table `staff` to be the superclass of `advisor` and `coordinator`.
CREATE TABLE staff (
  staff_id          VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(staff_id)
    REFERENCES person(id),

  contact_number    VARCHAR(11)   NOT NULL,
  department        VARCHAR(50)   NOT NULL,
  office_location   VARCHAR(100)  NULL
);

-- Create table `coordinator`.
CREATE TABLE coordinator (
  staff_id      VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(staff_id)
    REFERENCES staff(staff_id),

  start_year    INT         NOT NULL,
  qualification VARCHAR(50) NOT NULL
);

-- Create table `programme`.
CREATE TABLE programme (
  programme_code  VARCHAR(10)   PRIMARY KEY NOT NULL,
  name            VARCHAR(50)   NOT NULL,
  faculty         VARCHAR(50)   NOT NULL,
  duration        INT           NOT NULL DEFAULT 4,

  coordinator_id  VARCHAR(16)   NOT NULL,
  FOREIGN KEY fk_coordinator_staff_id(coordinator_id)
    REFERENCES coordinator(staff_id)
);

-- Create table `course`.
CREATE TABLE course (
  course_code     VARCHAR(10) PRIMARY KEY NOT NULL,
  title           VARCHAR(50) NOT NULL,
  credit_hour     INT         NOT NULL,
  semester        INT         NOT NULL,

  programme_code  VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code)
);

-- Create table `advisor`.
CREATE TABLE advisor (
  staff_id  VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(staff_id)
    REFERENCES staff(staff_id)
);

-- Create table `student`.
CREATE TABLE student (
  student_id      VARCHAR(16)     PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(student_id)
    REFERENCES person(id),

  birth_date      DATE            NOT NULL,
  home_street     VARCHAR(30)     NOT NULL,
  home_city       VARCHAR(15)     NOT NULL,
  home_postcode   VARCHAR(10)     NOT NULL,
  current_cgpa    DECIMAL(10, 2)  DEFAULT 0,
  status          VARCHAR(10)     NOT NULL,
  level           VARCHAR(10)     NOT NULL,

  programme_code  VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code),

  advisor_id      VARCHAR(15)     NOT NULL,
  FOREIGN KEY fk_advisor_staff_id(advisor_id)
    REFERENCES advisor(staff_id)
);

-- Create table `enrollment`.
CREATE TABLE enrollment (
  id                  INT             PRIMARY KEY NOT NULL AUTO_INCREMENT,
  academic_session    VARCHAR(10)     NOT NULL,
  registration_date   DATE            NOT NULL,
  cgpa                DECIMAL(10, 2)  NOT NULL,
  final_grade         INT             NULL,

  staff_id            VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_advisor_staff_id(staff_id)
    REFERENCES advisor(staff_id),

  student_id          VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  course_code         VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code)
);

-- Create table `fee`.
-- TODO: Check the data type of `total_fee` and design discount based on grade.
CREATE TABLE fee (
  student_id  VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  total_fee   INT           NOT NULL DEFAULT 0
);
