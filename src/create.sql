-- TODO:
--  - Change the relation between `course` and `programme` to many-to-many.
--  - Add triggers to calculate total fee automatically.

-- Create and switch to the database
-- after dropping the existed one.
DROP DATABASE IF EXISTS enrollment_system;
CREATE DATABASE enrollment_system;
USE enrollment_system;

-- Create table `person` to be the superclass of `student` and `staff`.
-- The format of `id` is different between `student` and `staff`.
CREATE TABLE person (
  id          VARCHAR(16)     PRIMARY KEY NOT NULL,
  firstname   VARCHAR(15)     NOT NULL,
  lastname    VARCHAR(15)     NOT NULL
);

-- Create table `staff` to be the superclass of `advisor` and `coordinator`.
-- `staff_id` -- `S + programme code + start year + incremental ID`.
--                e.g. `SCYS2012001`, `SCYS2013010`, etc.
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
  coordinator_id    VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(coordinator_id)
    REFERENCES staff(staff_id),

  start_year        INT           NOT NULL, -- In YYYY format.
  qualification     VARCHAR(50)   NOT NULL
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

-- Create table `course`.
-- `course_code` -- `programme_code + year + incremental ID with a leading 0`.
--                e.g. `CYS101`, `CST213`, etc.
CREATE TABLE course (
  course_code     VARCHAR(10) PRIMARY KEY NOT NULL,
  title           VARCHAR(50) NOT NULL,
  credit_hour     INT         NOT NULL,
  semester        INT         NOT NULL,

  programme_code  VARCHAR(10) NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code)
);

-- Create table `advisor`.
CREATE TABLE advisor (
  advisor_id  VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(advisor_id)
    REFERENCES staff(staff_id)
);

-- Create table `student`.
-- `student_id` -- `programme code + intake year + academic session + incremental ID`.
--              e.g. `CYS2809001`, `CYS2704010`, etc.
-- `status` -- One of `active`, `deferred`, or `graduated`.
-- `level` -- `Year 1`, `Year 2`, etc.
CREATE TABLE student (
  student_id      VARCHAR(16)     PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(student_id)
    REFERENCES person(id),

  birth_date      DATE            NOT NULL,
  home_street     VARCHAR(30)     NOT NULL,
  home_city       VARCHAR(15)     NOT NULL,

  -- Use `VARCHAR` to avoid leading 0 problems.
  home_postcode   VARCHAR(10)     NOT NULL,
  current_cgpa    DECIMAL(10, 2)  DEFAULT 0,
  status          VARCHAR(10)     NOT NULL,
  level           VARCHAR(10)     NOT NULL,

  programme_code  VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code),

  advisor_id      VARCHAR(15)     NOT NULL,
  FOREIGN KEY fk_advisor_advisor_id(advisor_id)
    REFERENCES advisor(advisor_id)
);

-- Create table `enrollment`.
-- `academic_session` -- `year + intake month` like `2024/09`, `2025/02`, etc.
-- `final_grade` -- `A`, `B+`, `B`, etc.
CREATE TABLE enrollment (
  id                  INT             PRIMARY KEY NOT NULL AUTO_INCREMENT,
  academic_session    VARCHAR(10)     NOT NULL,
  registration_date   DATE            NOT NULL,
  cgpa                DECIMAL(10, 2)  NOT NULL,
  final_grade         VARCHAR(3)      NULL,

  advisor_id          VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_advisor_advisor_id(advisor_id)
    REFERENCES advisor(advisor_id),

  student_id          VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  course_code         VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code)
);

-- Create table `fee`.
-- TODO:
--    - Design discount based on grade.
CREATE TABLE fee (
  student_id  VARCHAR(16)     PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  total_fee   DECIMAL(10, 2)  NOT NULL DEFAULT 0
);
