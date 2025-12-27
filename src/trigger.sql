SOURCE ./src/query.sql;

DELIMITER $$

CREATE TRIGGER before_update_student_status
BEFORE UPDATE ON fee
FOR EACH ROW
BEGIN
  SET NEW.total_fee = NEW.total_credit * 200;
END$$

DELIMITER ;

SELECT * FROM fee WHERE student_id = 'CIT2409001';

UPDATE fee SET total_credit = 5 WHERE student_id = 'CIT2409001';

SELECT * FROM fee WHERE student_id = 'CIT2409001';
