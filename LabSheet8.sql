#Q1
DELIMITER //

CREATE FUNCTION calculate_bmi(
    p_weight_kg DECIMAL(5,2),
    p_height_m DECIMAL(4,2)
)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    RETURN p_weight_kg / (p_height_m * p_height_m);
END //

DELIMITER ;

-- Test with suitable values:
SELECT calculate_bmi(70, 1.75) AS BMI;

-- --------------------------------------------------

#Q2
DELIMITER //

CREATE FUNCTION age_category(
    p_age INT
)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    -- Rules used:
    -- Below 18  = Child
    -- 18 to 59   = Adult
    -- 60 and above = Senior

    IF p_age < 18 THEN
        RETURN 'Child';
    ELSEIF p_age < 60 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Senior';
    END IF;
END //

DELIMITER ;

SELECT
    PatientID,
    PatientName,
    Age,
    age_category(Age) AS AgeCategory
FROM Patients;

-- --------------------------------------------------

#Q3
DELIMITER //

CREATE FUNCTION consultation_with_tax(
    p_fee DECIMAL(10,2),
    p_tax_percent DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_fee + (p_fee * p_tax_percent / 100);
END //

DELIMITER ;

-- Using 18% tax for testing:
SELECT
    PatientID,
    PatientName,
    ConsultationFee AS OriginalFee,
    consultation_with_tax(ConsultationFee, 18) AS FeeWithTax
FROM Patients;

-- --------------------------------------------------

#Q4
DELIMITER //

CREATE FUNCTION medicine_stock_value(
    p_unit_price DECIMAL(10,2),
    p_stock INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    RETURN p_unit_price * p_stock;
END //

DELIMITER ;

SELECT
    MedicineID,
    MedicineName,
    UnitPrice,
    Stock,
    medicine_stock_value(UnitPrice, Stock) AS StockValue
FROM Medicines;

-- --------------------------------------------------

#Q5
DELIMITER //

CREATE PROCEDURE patient_by_gender(
    IN p_gender VARCHAR(10)
)
BEGIN
    SELECT *
    FROM Patients
    WHERE Gender = p_gender;
END //

DELIMITER ;

CALL patient_by_gender('F');

CALL patient_by_gender('M');

-- --------------------------------------------------

#Q6
DELIMITER //

CREATE PROCEDURE patients_above_age(
    IN p_age INT
)
BEGIN
    SELECT *
    FROM Patients
    WHERE Age > p_age;
END //

DELIMITER ;

-- Test with two different ages:
CALL patients_above_age(25);

CALL patients_above_age(40);

-- --------------------------------------------------

#Q7
DELIMITER //

CREATE PROCEDURE update_medicine_stock(
    IN p_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE Medicines
    SET Stock = Stock + p_quantity
    WHERE MedicineID = p_id;
END //

DELIMITER ;

-- Increase stock of medicine 301 by 20:
CALL update_medicine_stock(301, 20);

-- Verify the changed row:
SELECT *
FROM Medicines
WHERE MedicineID = 301;

-- --------------------------------------------------

#Q8
DELIMITER //

CREATE PROCEDURE medicine_count(
    OUT p_count INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_count
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_count(@medicine_total);

SELECT @medicine_total AS TotalMedicines;

-- --------------------------------------------------

#Q9
DELIMITER //

CREATE PROCEDURE patient_report()
BEGIN
    -- The supplied Patients table has no height column.
    -- Therefore, 1.70 metres is used as the report height
    -- so that BMI can be calculated for every patient.

    SELECT
        PatientID,
        PatientName,
        Age,
        calculate_bmi(WeightKg, 1.70) AS BMI,
        age_category(Age) AS AgeCategory
    FROM Patients;
END //

DELIMITER ;

CALL patient_report();

-- --------------------------------------------------

#Q10
DELIMITER //

CREATE PROCEDURE medicine_report()
BEGIN
    SELECT
        MedicineID,
        MedicineName,
        UnitPrice,
        Stock,
        medicine_stock_value(UnitPrice, Stock) AS StockValue,
        CASE
            WHEN Stock = 0 THEN 'Out of Stock'
            WHEN Stock < 30 THEN 'Low Stock'
            WHEN Stock < 75 THEN 'Medium Stock'
            ELSE 'Good Stock'
        END AS StockStatus
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_report();

-- --------------------------------------------------
