#Q1
DELIMITER //

CREATE PROCEDURE ShowStudents()
BEGIN
    SELECT * FROM Student;
END //

DELIMITER ;

CALL ShowStudents();

-- --------------------------------------------------

#Q2
DELIMITER //

CREATE PROCEDURE ShowDepartments()
BEGIN
    SELECT * FROM Department;
END //

DELIMITER ;

CALL ShowDepartments();

-- --------------------------------------------------

#Q3
DELIMITER //

CREATE PROCEDURE ShowCourses()
BEGIN
    SELECT * FROM Course;
END //

DELIMITER ;

CALL ShowCourses();

-- --------------------------------------------------

#Q4
DELIMITER //

CREATE PROCEDURE GetStudent(IN p_StudentID INT)
BEGIN
    SELECT *
    FROM Student
    WHERE StudentID = p_StudentID;
END //

DELIMITER ;

CALL GetStudent(3);

-- --------------------------------------------------

#Q5
DELIMITER //

CREATE PROCEDURE GetStudentsByDept(IN p_DeptID INT)
BEGIN
    SELECT *
    FROM Student
    WHERE DeptID = p_DeptID;
END //

DELIMITER ;

CALL GetStudentsByDept(102);

-- --------------------------------------------------

#Q6
DELIMITER //

CREATE PROCEDURE StudentsAboveMarks(IN p_Marks DECIMAL(5,2))
BEGIN
    SELECT *
    FROM Student
    WHERE Marks > p_Marks;
END //

DELIMITER ;

CALL StudentsAboveMarks(80);

-- --------------------------------------------------

#Q7
DELIMITER //

CREATE PROCEDURE TotalStudents()
BEGIN
    SELECT COUNT(*) AS TotalStudents
    FROM Student;
END //

DELIMITER ;

CALL TotalStudents();

-- --------------------------------------------------

#Q8
DELIMITER //

CREATE PROCEDURE CheckResult(IN p_StudentID INT)
BEGIN
    DECLARE student_marks DECIMAL(5,2);

    SELECT Marks
    INTO student_marks
    FROM Student
    WHERE StudentID = p_StudentID;

    IF student_marks >= 50 THEN
        SELECT 'Pass' AS Result;
    ELSE
        SELECT 'Fail' AS Result;
    END IF;
END //

DELIMITER ;

CALL CheckResult(3);

-- --------------------------------------------------

#Q9
DELIMITER //

CREATE PROCEDURE GetStudentsByGender(IN p_Gender VARCHAR(10))
BEGIN
    SELECT *
    FROM Student
    WHERE Gender = p_Gender;
END //

DELIMITER ;

CALL GetStudentsByGender('Female');

-- --------------------------------------------------

#Q10
DELIMITER //

CREATE PROCEDURE StudentsBetweenMarks(
    IN p_MinMarks DECIMAL(5,2),
    IN p_MaxMarks DECIMAL(5,2)
)
BEGIN
    SELECT *
    FROM Student
    WHERE Marks BETWEEN p_MinMarks AND p_MaxMarks;
END //

DELIMITER ;

CALL StudentsBetweenMarks(70, 90);

-- --------------------------------------------------

#Q11
DELIMITER //

CREATE FUNCTION AddTwoNumbers(
    p_Num1 INT,
    p_Num2 INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN p_Num1 + p_Num2;
END //

DELIMITER ;

SELECT AddTwoNumbers(10, 20) AS Sum;

-- --------------------------------------------------

#Q12
DELIMITER //

CREATE FUNCTION FindSquare(
    p_Num INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN p_Num * p_Num;
END //

DELIMITER ;

SELECT FindSquare(5) AS Square;

-- --------------------------------------------------

#Q13
DELIMITER //

CREATE FUNCTION ResultStatus(
    p_Marks DECIMAL(5,2)
)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_Marks >= 50 THEN
        RETURN 'Pass';
    ELSE
        RETURN 'Fail';
    END IF;
END //

DELIMITER ;

SELECT ResultStatus(75) AS Result;

-- --------------------------------------------------

#Q14
DELIMITER //

CREATE FUNCTION StudentGrade(
    p_Marks DECIMAL(5,2)
)
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    IF p_Marks >= 90 THEN
        RETURN 'A';
    ELSEIF p_Marks >= 75 THEN
        RETURN 'B';
    ELSEIF p_Marks >= 60 THEN
        RETURN 'C';
    ELSE
        RETURN 'D';
    END IF;
END //

DELIMITER ;

SELECT StudentGrade(85) AS Grade;

-- --------------------------------------------------

#Q15
DELIMITER //

CREATE FUNCTION AgeCategory(
    p_Age INT
)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF p_Age >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END //

DELIMITER ;

SELECT AgeCategory(20) AS AgeCategory;

-- --------------------------------------------------

#Q16
DELIMITER //

CREATE FUNCTION CalculateBonus(
    p_Marks DECIMAL(5,2)
)
RETURNS INT
DETERMINISTIC
BEGIN
    IF p_Marks >= 90 THEN
        RETURN 1000;
    ELSEIF p_Marks >= 75 THEN
        RETURN 500;
    ELSE
        RETURN 200;
    END IF;
END //

DELIMITER ;

SELECT CalculateBonus(85) AS Bonus;

-- --------------------------------------------------

#Q17
DELIMITER //

CREATE FUNCTION HigherNumber(
    p_Num1 INT,
    p_Num2 INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    IF p_Num1 >= p_Num2 THEN
        RETURN p_Num1;
    ELSE
        RETURN p_Num2;
    END IF;
END //

DELIMITER ;

SELECT HigherNumber(25, 40) AS HigherNumber;

-- --------------------------------------------------

#Q18
DELIMITER //

CREATE FUNCTION DoubleMarks(
    p_Marks DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_Marks * 2;
END //

DELIMITER ;

SELECT DoubleMarks(85.50) AS DoubleMarks;

-- --------------------------------------------------

#Q19
DELIMITER //

CREATE FUNCTION AgeAfterFiveYears(
    p_Age INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN p_Age + 5;
END //

DELIMITER ;

SELECT AgeAfterFiveYears(20) AS AgeAfterFiveYears;

-- --------------------------------------------------

#Q20
SELECT
    StudentName,
    Marks,
    StudentGrade(Marks) AS Grade
FROM Student;

-- --------------------------------------------------
