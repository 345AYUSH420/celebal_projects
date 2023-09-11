--  store procedure to copy the contents of one table to other table;


create database celebal;
use celebal;


DELIMITER //

CREATE PROCEDURE celeballevel2(IN TableNameA VARCHAR(255), IN TableNameB VARCHAR(255), IN ColumnValues VARCHAR(10000))
BEGIN
    -- Declare variables;
    DECLARE cName VARCHAR(10000);
    DECLARE Query VARCHAR(10000);
    
    -- Temporary table to store column names
    CREATE TEMPORARY TABLE IF NOT EXISTS tc (
        ColumnName VARCHAR(255)
    );
    
    -- Insert column names into temporary table
    INSERT INTO tc
    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = TableNameA;
    
    -- Concatenate column names
    SELECT GROUP_CONCAT(ColumnName) INTO cName FROM tc;

    
    -- Generate the insert query
    SET @Query = CONCAT('INSERT INTO ', TableNameB, ' (', cName, ') SELECT ', ColumnValues, ' FROM ', TableNameA);
    
    -- Execute the insert query
    PREPARE stmt FROM @Query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Truncate data from TableA
    SET @Query = CONCAT('TRUNCATE TABLE ', TableNameA);
    PREPARE stmt FROM @Query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS tc;
    
    -- Display success message
    SELECT CONCAT('Data from ', TableNameA, ' has been inserted into ', TableNameB, '. ', TableNameA, ' has been truncated.') AS Result;
END //

DELIMITER ;




-- store procedure to see the data of both the tables after the above operation; 

DELIMITER //

CREATE PROCEDURE getval(IN TableName VARCHAR(255))
BEGIN
    -- Execute the select query
    SET @Query = CONCAT('SELECT * FROM ', TableName);
    PREPARE stmt FROM @Query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END //

DELIMITER ;



CREATE TABLE TableA (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT
);

CREATE TABLE TableB (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT
);

insert into TableA values(1 , 'a',10);



CALL celeballevel2('TableA', 'TableB', 'id, name, age');
CALL getval('TableA');
CALL getval('TableB');








