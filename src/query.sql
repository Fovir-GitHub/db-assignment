-- SOURCE ./src/create.sql;
-- SOURCE ./src/insert.sql;

-- Query students who enrolled in `CYS103` in 2024/09 semester and their study level and final grades, ordered by the study level.
SELECT stu.student_id AS 'Student ID',
  CONCAT(p.firstname, ' ', p.lastname) AS Name,
  stu.level AS 'Level',
  e.final_grade AS 'Final Grade'
  FROM enrollment AS e
  INNER JOIN student AS stu ON e.student_id = stu.student_id
  INNER JOIN person AS p ON p.id = e.student_id
  WHERE e.semester_year = 2024 AND e.semester_month = 9
  AND e.course_code = 'CYS103' ORDER BY level;

-- Show students who haven't paid the fee successfully.
-- Refer to https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_lpad
SELECT s.student_id AS 'Student ID',
  CONCAT(p.firstname, ' ', p.lastname) AS 'Name',
  f.payment_status AS 'Status',
  CONCAT(f.semester_year, '/', LPAD(f.semester_month, 2, '0')) AS 'Semester'
  FROM student AS s
  INNER JOIN person AS p ON p.id = s.student_id
  LEFT JOIN fee AS f ON f.student_id = s.student_id
  WHERE f.payment_status IS NULL OR f.payment_status != 'Paid';

-- Find the final fee of students whose name starts with 'A' in each semester.
SELECT CONCAT(p.firstname, ' ', p.lastname) AS 'Name',
  CONCAT(f.semester_year, '/', LPAD(f.semester_month, 2, '0')) AS 'Semester',
  f.total_fee AS 'Original Fee',
  f.discount AS 'Discount',
  ROUND(f.total_fee - (f.total_fee * f.discount), 2) AS 'Final Fee'
  FROM fee AS f
  INNER JOIN person AS p ON f.student_id = p.id
  WHERE CONCAT(p.firstname, ' ', p.lastname) LIKE 'A%'
  ORDER BY `Name`;

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
