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

-- Create table `Student`.
CREATE TABLE Student (
  MatricNumber  INT             PRIMARY KEY NOT NULL,
  Firstname     VARCHAR(15)     NOT NULL,
  Lastname      VARCHAR(15)     NOT NULL,
  BirthDate     DATE            NOT NULL,
  HomeStreet    VARCHAR(30)     NOT NULL,
  HomeCity      VARCHAR(15)     NOT NULL,
  HomePostcode  INT             NOT NULL,
  CurrentCGPA   DECIMAL(10, 2)  DEFAULT 0,
  Status        VARCHAR(10)     NOT NULL,
  Level         VARCHAR(10)     NOT NULL,

  ProgrammeCode VARCHAR(10)     NOT NULL,
  FOREIGN KEY FK_Programme_ProgrammeCode(ProgrammeCode)
    REFERENCES Programme(ProgrammeCode)
);

-- Create table `Staff` to be the superclass of `Advisor` and `Coordinator`.
CREATE TABLE Staff (
  StaffID         INT           PRIMARY KEY NOT NULL,
  Name            VARCHAR(20)   NOT NULL,
  ContactNumber   VARCHAR(11)   NOT NULL,
  Department      VARCHAR(50)   NOT NULL,
  OfficeLocation  VARCHAR(100)  NOT NULL
);

-- Create table `Advisor`.
CREATE TABLE Advisor (
  StaffID         INT           PRIMARY KEY NOT NULL,
  Name            VARCHAR(20)   NOT NULL,
  Department      VARCHAR(50)   NOT NULL,
  OfficeLocation  VARCHAR(100)  NOT NULL,
  ContactNumber   VARCHAR(11)   NOT NULL
);

-- Create table `Enrollment`.
CREATE TABLE Enrollment (
  ID                INT             PRIMARY KEY NOT NULL AUTO_INCREMENT,
  AcademicSession   VARCHAR(10)     NOT NULL,
  RegistrationDate  DATE            NOT NULL,
  CGPA              DECIMAL(10, 2)  NOT NULL,
  FinalGrade        INT             NULL,

  StaffID           INT             NOT NULL,
  FOREIGN KEY FK_Advisor_StaffID(StaffID)
    REFERENCES Advisor(StaffID),

  MatricNumber      INT             NOT NULL,
  FOREIGN KEY FK_Student_MatricNumber(MatricNumber)
    REFERENCES Student(MatricNumber),

  CourseCode        VARCHAR(10)     NOT NULL,
  FOREIGN KEY FK_Course_CourseCode(CourseCode)
    REFERENCES Course(CourseCode)
);
