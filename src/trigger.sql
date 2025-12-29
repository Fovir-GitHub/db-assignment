SOURCE ./src/query.sql;

CREATE TRIGGER before_update_fee
BEFORE UPDATE ON fee
FOR EACH ROW
SET NEW.total_fee = NEW.total_credit * 200;

SHOW TRIGGERS;

SELECT * FROM fee WHERE student_id = 'CIT2409001';

UPDATE fee SET total_credit = 5
WHERE student_id = 'CIT2409001';

SELECT * FROM fee WHERE student_id = 'CIT2409001';

CREATE TRIGGER after_update_course_credit
AFTER UPDATE ON course
FOR EACH ROW
UPDATE fee
SET total_credit = total_credit + (NEW.credit_hour - OLD.credit_hour)
WHERE student_id IN (
  SELECT student_id FROM enrollment
  WHERE course_code = NEW.course_code
);

SELECT * FROM course WHERE course_code = 'CIT101';
SELECT f.student_id,
       f.total_credit
FROM fee AS f
WHERE f.student_id IN (
  SELECT student_id
  FROM enrollment
  WHERE course_code = 'CIT101'
);

UPDATE course SET credit_hour = 4
WHERE course_code = 'CIT101';

SELECT * FROM course WHERE course_code = 'CIT101';
SELECT f.student_id,
       f.total_credit
FROM fee AS f
WHERE f.student_id IN (
  SELECT student_id
  FROM enrollment
  WHERE course_code = 'CIT101'
);
