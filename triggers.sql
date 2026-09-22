create database hyd;

use hyd;

CREATE TABLE employees(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2)
);

CREATE TABLE employee_audit(
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    emp_name VARCHAR(50),
    action_type VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER $$
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit
    (emp_id, emp_name, action_type)
    VALUES
    (NEW.emp_id, NEW.emp_name, 'INSERT');
END $$
DELIMITER ;


INSERT INTO employees
VALUES (106, 'Arjun', 1, 52000);


SELECT * FROM employee_audit;
DELETE FROM employees
WHERE emp_id = 106;

DELIMITER $$
CREATE TRIGGER after_employee_delete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit
    (emp_id, emp_name, action_type)
    VALUES
    (OLD.emp_id, OLD.emp_name, 'DELETE');
END $$
DELIMITER ;


UPDATE employees
SET salary = 60000
WHERE emp_id = 101;


DELIMITER $$
CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit
    (emp_id, emp_name, action_type)
    VALUES
    (NEW.emp_id, NEW.emp_name, 'UPDATE');
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER check_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 20000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be less than 20000';
    END IF;
END $$
DELIMITER ;


INSERT INTO employees
VALUES (107, 'Ravi', 1, 15000);
INSERT INTO employees VALUES (108, 'Meena', 1, 30000);


DELIMITER $$
CREATE TRIGGER prevent_salary_reduction
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary reduction is not allowed';
    END IF;
END $$
DELIMITER ;

UPDATE employees
SET salary = 40000
WHERE emp_id = 101;


UPDATE employees
SET salary = 60000
WHERE emp_id = 101;

