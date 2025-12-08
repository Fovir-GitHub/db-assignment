-- TODO:
--  - Refactor the structure of database.

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

-- Create table `staff` to be the superclass of `advisor` and `coordinator`.
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

-- Create table `semester`
CREATE TABLE semester (
  year    INT   NOT NULL,
  month   INT   NOT NULL,
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
    REFERENCES programme(programme_code)
);

-- Create table `course_prerequisite`.
CREATE TABLE course_prerequisite (
  course_code     VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_code(course_code)
    REFERENCES course(course_code),

  prerequisite_code VARCHAR(10)   NOT NULL,
  FOREIGN KEY fk_course_course_code(prerequisite_code)
    REFERENCES course(course_code),

  PRIMARY KEY (course_code, prerequisite_code)
);

-- Create table `advisor`.
CREATE TABLE advisor (
  advisor_id  VARCHAR(16)   PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_staff_staff_id(advisor_id)
    REFERENCES staff(staff_id)
);

-- Create table `student`.
-- `student_id` -- `programme code + intake year + semester + incremental ID`.
--              e.g. `CYS2809001`, `CYS2704010`, etc.
-- `status` -- One of `active`, `deferred`, or `graduated`.
-- `level` -- `Year 1`, `Year 2`, etc.
CREATE TABLE student (
  student_id      VARCHAR(16)     PRIMARY KEY NOT NULL,
  FOREIGN KEY fk_person_id(student_id)
    REFERENCES person(id),

  cgpa            DECIMAL(10, 2)  DEFAULT 0,
  status          VARCHAR(10)     DEFAULT 'active',
  level           VARCHAR(10)     DEFAULT 'Year 1',

  programme_code  VARCHAR(10)     NOT NULL,
  FOREIGN KEY fk_programme_programme_code(programme_code)
    REFERENCES programme(programme_code),

  advisor_id      VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_advisor_advisor_id(advisor_id)
    REFERENCES advisor(advisor_id)
);

-- Create table `enrollment`.
-- `semester` -- `year + intake month` like `2024/09`, `2025/02`, etc.
-- `final_grade` -- `A`, `B+`, `B`, etc.
CREATE TABLE enrollment (
  registration_date   DATETIME        NOT NULL,
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
    REFERENCES semester(year, month),
  PRIMARY KEY (student_id, course_code, semester_year, semester_month)
);

-- Create table `fee`.
CREATE TABLE fee (
  invoice_id      INT             PRIMARY KEY AUTO_INCREMENT,
  student_id      VARCHAR(16)     NOT NULL,
  FOREIGN KEY fk_student_student_id(student_id)
    REFERENCES student(student_id),

  total_credit    INT             NOT NULL DEFAULT 0,
  total_fee       DECIMAL(10, 2)  NOT NULL DEFAULT 0,
  discount        DECIMAL(10, 2)  NOT NULL DEFAULT 0,
  semester        INT             NOT NULL,
  payment_status  ENUM('Pending', 'Paid', 'Overdue')
);

DELIMITER $$

-- Calculate fee after insertion.
CREATE TRIGGER calculate_fee_after_insert
AFTER INSERT ON enrollment
FOR EACH ROW
BEGIN
  INSERT INTO fee (student_id, total_fee)
  VALUES (NEW.student_id, 0)
  ON DUPLICATE KEY UPDATE total_fee = total_fee;

  UPDATE fee SET total_fee =
    (SELECT (SUM(c.credit_hour) * 300) FROM enrollment AS e
      INNER JOIN course AS c ON e.course_code = c.course_code
      INNER JOIN student AS s ON s.student_id = e.student_id
      WHERE s.student_id = NEW.student_id)
    WHERE NEW.student_id = student_id;
END$$

-- Calculate fee after updating.
CREATE TRIGGER calculate_fee_after_update
AFTER UPDATE ON enrollment
FOR EACH ROW
BEGIN
  UPDATE fee SET total_fee =
    (SELECT (SUM(c.credit_hour) * 300) FROM enrollment AS e
      INNER JOIN course AS c ON e.course_code = c.course_code
      INNER JOIN student AS s ON s.student_id = e.student_id
      WHERE s.student_id = NEW.student_id)
    WHERE NEW.student_id = student_id;
END$$

-- Calculate fee after deletion.
CREATE TRIGGER calculate_fee_after_delete
AFTER DELETE ON enrollment
FOR EACH ROW
BEGIN
  UPDATE fee SET total_fee =
    COALESCE(
      (SELECT (SUM(c.credit_hour) * 300) FROM enrollment AS e
      INNER JOIN course AS c ON e.course_code = c.course_code
      INNER JOIN student AS s ON s.student_id = e.student_id
      WHERE s.student_id = OLD.student_id), 0
    )
    WHERE OLD.student_id = student_id;
END$$

DELIMITER ;
