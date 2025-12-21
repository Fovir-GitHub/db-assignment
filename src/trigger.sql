DELIMITER $$

-- Trigger to validate the updating of student's status.
-- A student can not be changed from graduated to not graduated or from deferred to graduated directly.
-- If the update meets this situation, the update statement will be terminated, and MySQL will throw an error message.
CREATE TRIGGER before_update_student_status
BEFORE UPDATE ON student
FOR EACH ROW
BEGIN
  IF OLD.status = 'graduated' AND NEW.status != 'graduated' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot change status from graduated to another status';
  ELSEIF OLD.status = 'deferred' AND NEW.status = 'graduated' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot change status from deferred to graduated';
  END IF;
END$$

DELIMITER ;
