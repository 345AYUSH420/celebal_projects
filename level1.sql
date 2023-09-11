create database celebal;
use celebal;



create table student (
    roll_no int primary key,
    firstName varchar(50),
    lastName varchar(50),
    section varchar(10)
);




--  store procedure for getting the columns of a table in the form of a table.

DELIMITER //

CREATE PROCEDURE ayush(IN TableName VARCHAR(255))
BEGIN
    -- Create temporary table to store column names
    CREATE TEMPORARY TABLE IF NOT EXISTS TempColumns (
        ColumnName VARCHAR(255)
    );

    -- Insert column names into temporary table
    INSERT INTO TempColumns
    SELECT COLUMN_NAME
    FROM information_schema.columns
    WHERE table_name = TableName;

    -- Select the column names
        SELECT ColumnName AS ColumnName
        FROM TempColumns;

    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS TempColumns;
END //

DELIMITER ;

call ayush('student');
