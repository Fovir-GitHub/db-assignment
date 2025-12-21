DELIMITER $$

-- Trigger to validate the updating of student's status.
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
