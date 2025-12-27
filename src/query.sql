SOURCE ./src/create.sql;
SOURCE ./src/insert.sql;

-- Query number of students of each advisor to balance advisors' workload.
SELECT a.advisor_id AS 'ID',
  CONCAT(p.firstname, ' ', p.lastname) AS Name,
  COUNT(*) AS 'Number of Students'
  FROM student AS s
  INNER JOIN advisor AS a ON a.advisor_id = s.advisor_id
  INNER JOIN person AS p ON p.id = a.advisor_id
  GROUP BY a.advisor_id
  ORDER BY `Number of Students` DESC;

-- Show students who haven't paid the fee successfully.
-- Refer to https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_lpad
SELECT s.student_id AS 'Student ID',
  CONCAT(p.firstname, ' ', p.lastname) AS 'Name',
  f.payment_status AS 'Payment Status',
  CONCAT(f.semester_year, '/', LPAD(f.semester_month, 2, '0')) AS 'Semester',
  p.contact_number AS 'Contact',
  s.emergency_contact AS 'Emergency Contact'
  FROM student AS s
  INNER JOIN person AS p ON p.id = s.student_id
  INNER JOIN fee AS f ON f.student_id = s.student_id
  WHERE f.payment_status IS NULL OR f.payment_status != 'Paid';

-- Find courses with more than 1 prerequisites.
SELECT c.course_code AS 'Course Code',
       c.title AS 'Course Title',
       pc.count AS 'Number of Prerequisites'
  FROM (
      SELECT course_code,
             COUNT(*) AS count
      FROM course_prerequisite
      GROUP BY course_code
  ) AS pc
  INNER JOIN course AS c ON c.course_code = pc.course_code
  HAVING pc.count > 1
  ORDER BY pc.count;

-- Query active students in each programme.
SELECT p.programme_code AS 'Code',
  p.name AS 'Name',
  COUNT(*) AS 'Number of Students'
  FROM student AS s
  INNER JOIN programme AS p ON s.programme_code = p.programme_code
  WHERE s.status = 'active'
  GROUP BY p.programme_code
  ORDER BY `Number of Students`;
