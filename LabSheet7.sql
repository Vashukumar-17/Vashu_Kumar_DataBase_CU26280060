#Q1
DELIMITER //

CREATE PROCEDURE DisplayAllDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorID INT;
    DECLARE v_DoctorName VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorID, v_DoctorName;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_DoctorID AS DoctorID, v_DoctorName AS DoctorName;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DisplayAllDoctors();

-- --------------------------------------------------

#Q2
DELIMITER //

CREATE PROCEDURE DoctorsFeeAbove1000()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorID INT;
    DECLARE v_DoctorName VARCHAR(50);
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName, ConsultationFee
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorID, v_DoctorName, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Fee > 1000 THEN
            SELECT v_DoctorID AS DoctorID,
                   v_DoctorName AS DoctorName,
                   v_Fee AS ConsultationFee;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DoctorsFeeAbove1000();

-- --------------------------------------------------

#Q3
DELIMITER //

CREATE PROCEDURE TotalConsultationFee(OUT p_TotalFee DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Fee DECIMAL(10,2);

    SET p_TotalFee = 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET p_TotalFee = p_TotalFee + v_Fee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL TotalConsultationFee(@TotalFee);
SELECT @TotalFee AS TotalConsultationFee;

-- --------------------------------------------------

#Q4
DELIMITER //

CREATE PROCEDURE CountCardiologyDoctors(OUT p_Count INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Department VARCHAR(40);

    SET p_Count = 0;

    DECLARE cur CURSOR FOR
        SELECT Department
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Department;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Department = 'Cardiology' THEN
            SET p_Count = p_Count + 1;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL CountCardiologyDoctors(@CardiologyCount);
SELECT @CardiologyCount AS CardiologyDoctors;

-- --------------------------------------------------

#Q5
DELIMITER //

CREATE PROCEDURE AverageConsultationFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Fee DECIMAL(10,2);
    DECLARE v_Total DECIMAL(15,2) DEFAULT 0;
    DECLARE v_Count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Total = v_Total + v_Fee;
        SET v_Count = v_Count + 1;
    END LOOP;

    CLOSE cur;

    IF v_Count = 0 THEN
        SELECT 0 AS AverageConsultationFee;
    ELSE
        SELECT v_Total / v_Count AS AverageConsultationFee;
    END IF;
END //

DELIMITER ;

CALL AverageConsultationFee();

-- --------------------------------------------------

#Q6
DELIMITER //

CREATE PROCEDURE IncreasePediatricsFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorID INT;
    DECLARE v_Department VARCHAR(40);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, Department
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorID, v_Department;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Department = 'Pediatrics' THEN
            UPDATE Doctors
            SET ConsultationFee = ConsultationFee * 1.10
            WHERE DoctorID = v_DoctorID;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreasePediatricsFee();

SELECT *
FROM Doctors;

-- --------------------------------------------------

#Q7
DELIMITER //

CREATE PROCEDURE SetReviewForLowFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorID INT;
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, ConsultationFee
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorID, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Fee < 1000 THEN
            UPDATE Doctors
            SET Status = 'Review'
            WHERE DoctorID = v_DoctorID;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL SetReviewForLowFeeDoctors();

SELECT *
FROM Doctors;

-- --------------------------------------------------

#Q8
DELIMITER //

CREATE PROCEDURE DoctorReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorName VARCHAR(50);
    DECLARE v_Department VARCHAR(40);
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorName, Department, ConsultationFee
        FROM Doctors
        ORDER BY Department, DoctorName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorName, v_Department, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_DoctorName AS DoctorName,
               v_Department AS Department,
               v_Fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DoctorReport();

-- --------------------------------------------------

#Q9
DELIMITER //

CREATE PROCEDURE CountActiveDoctors(OUT p_Count INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Status VARCHAR(20);

    SET p_Count = 0;

    DECLARE cur CURSOR FOR
        SELECT Status
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Status;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Status = 'Active' THEN
            SET p_Count = p_Count + 1;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL CountActiveDoctors(@ActiveCount);
SELECT @ActiveCount AS ActiveDoctors;

-- --------------------------------------------------

#Q10
DELIMITER //

CREATE PROCEDURE IncreaseHighFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_DoctorID INT;
    DECLARE v_Fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, ConsultationFee
        FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_DoctorID, v_Fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_Fee >= 1200 THEN
            UPDATE Doctors
            SET ConsultationFee = ConsultationFee * 1.05
            WHERE DoctorID = v_DoctorID;
        END IF;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreaseHighFeeDoctors();

SELECT *
FROM Doctors;

-- --------------------------------------------------

#Q11
DELIMITER //

DROP TRIGGER IF EXISTS trg_after_doctor_insert//

CREATE TRIGGER trg_after_doctor_insert
AFTER INSERT ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
    VALUES
        (NEW.DoctorID, 'INSERT', NULL, NEW.ConsultationFee);
END //

DELIMITER ;

INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (207, 'Dr. Gita', 'Cardiology', 1100, 'Active');

SELECT *
FROM Doctor_Audit
WHERE DoctorID = 207;

-- --------------------------------------------------

#Q12
DELIMITER //

DROP TRIGGER IF EXISTS trg_after_doctor_update_fee//

CREATE TRIGGER trg_after_doctor_update_fee
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Doctor_Audit
            (DoctorID, ActionType, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, 'FEE UPDATE',
             OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = ConsultationFee + 100
WHERE DoctorID = 201;

SELECT *
FROM Doctor_Audit
WHERE DoctorID = 201
ORDER BY AuditID DESC;

-- --------------------------------------------------

#Q13
DELIMITER //

DROP TRIGGER IF EXISTS trg_before_doctor_insert_upper//

CREATE TRIGGER trg_before_doctor_insert_upper
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    SET NEW.DoctorName = UPPER(NEW.DoctorName);
END //

DELIMITER ;

INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (208, 'dr. harish', 'Neurology', 1400, 'Active');

SELECT *
FROM Doctors
WHERE DoctorID = 208;

-- --------------------------------------------------

#Q14
DELIMITER //

DROP TRIGGER IF EXISTS trg_before_doctor_insert_fee//

CREATE TRIGGER trg_before_doctor_insert_fee
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ConsultationFee cannot be negative';
    END IF;
END //

DELIMITER ;

-- Test: this statement should produce an error.
INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (209, 'Dr. Invalid', 'Cardiology', -500, 'Active');

-- --------------------------------------------------

#Q15
DELIMITER //

DROP TRIGGER IF EXISTS trg_after_doctor_delete//

CREATE TRIGGER trg_after_doctor_delete
AFTER DELETE ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
    VALUES
        (OLD.DoctorID, 'DELETE', OLD.ConsultationFee, NULL);
END //

DELIMITER ;

INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (210, 'Dr. TestDelete', 'Dermatology', 800, 'Active');

DELETE FROM Doctors
WHERE DoctorID = 210;

SELECT *
FROM Doctor_Audit
WHERE DoctorID = 210;

-- --------------------------------------------------

#Q16
DELIMITER //

DROP TRIGGER IF EXISTS trg_after_fee_log//

CREATE TRIGGER trg_after_fee_log
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Fee_Log
            (DoctorID, DoctorName, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, NEW.DoctorName,
             OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = ConsultationFee + 50
WHERE DoctorID = 202;

SELECT *
FROM Fee_Log
WHERE DoctorID = 202
ORDER BY LogID DESC;

-- --------------------------------------------------

#Q17
DELIMITER //

DROP TRIGGER IF EXISTS trg_before_doctor_update_fee//

CREATE TRIGGER trg_before_doctor_update_fee
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ConsultationFee cannot be negative';
    END IF;
END //

DELIMITER ;

-- Test: this statement should produce an error.
UPDATE Doctors
SET ConsultationFee = -100
WHERE DoctorID = 203;

-- --------------------------------------------------

#Q18
DELIMITER //

DROP TRIGGER IF EXISTS trg_before_doctor_update_status//

CREATE TRIGGER trg_before_doctor_update_status
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF LOWER(NEW.Status) = 'active' THEN
        SET NEW.Status = 'Active';
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Status = 'active'
WHERE DoctorID = 204;

SELECT DoctorID, DoctorName, Status
FROM Doctors
WHERE DoctorID = 204;

-- --------------------------------------------------

#Q19
DELIMITER //

DROP TRIGGER IF EXISTS trg_after_department_change//

CREATE TRIGGER trg_after_department_change
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.Department <> NEW.Department THEN
        INSERT INTO Doctor_Audit
            (DoctorID, ActionType, OldFee, NewFee)
        VALUES
            (NEW.DoctorID, 'DEPARTMENT CHANGE', NULL, NULL);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Department = 'Oncology'
WHERE DoctorID = 205;

SELECT *
FROM Doctor_Audit
WHERE DoctorID = 205
ORDER BY AuditID DESC;

-- NOTE:
-- Doctor_Audit does not contain OldDepartment/NewDepartment columns.
-- Therefore this trigger records the DoctorID and action type only.
-- The source schema provides no columns for storing the old/new department.

-- --------------------------------------------------

#Q20
DELIMITER //

DROP TRIGGER IF EXISTS trg_validate_doctor_status//

CREATE TRIGGER trg_validate_doctor_status
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.Status IS NULL OR
       NEW.Status NOT IN ('Active', 'Review') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Status must be Active or Review';
    END IF;
END //

DELIMITER ;

-- Valid insert
INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (211, 'Dr. Kavya', 'Pediatrics', 950, 'Active');

-- Invalid insert: this should produce an error.
INSERT INTO Doctors
    (DoctorID, DoctorName, Department, ConsultationFee, Status)
VALUES
    (212, 'Dr. InvalidStatus', 'Cardiology', 1200, 'Unknown');

SELECT *
FROM Doctors
WHERE DoctorID IN (211, 212);

-- --------------------------------------------------
