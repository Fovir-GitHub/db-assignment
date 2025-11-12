-- Create and switch to the database
-- after dropping the existed one.
DROP DATABASE IF EXISTS StudentCourse;
CREATE DATABASE StudentCourse;
USE StudentCourse;

-- Create table `Course`.
CREATE TABLE Course (
  CourseCode  VARCHAR(10) PRIMARY KEY NOT NULL,
  Title       VARCHAR(50) NOT NULL,
  CreditHour  INT         NOT NULL,

  -- TODO: Check the data type of `Semester`.
  Semester    INT         NOT NULL
);

-- Create table `Programme`.
-- TODO:
--  1. Check the data type of `Duration`.
--  2. Set `Coordinator` as a foreign key.
CREATE TABLE Programme (
  ProgrammeCode   VARCHAR(10)   PRIMARY KEY NOT NULL,
  Name            VARCHAR(50)   NOT NULL,
  Faculty         VARCHAR(50)   NOT NULL,
  Duration        INT           NOT NULL DEFAULT 4,
  Coordinator     VARCHAR(50)   NULL,

  CourseCode      VARCHAR(10)   NOT NULL,
  FOREIGN KEY FK_Course_CourseCode(CourseCode)
    REFERENCES Course(CourseCode),

  -- Prevent a programme from having multiple same courses.
  UNIQUE(ProgrammeCode, CourseCode)
);

