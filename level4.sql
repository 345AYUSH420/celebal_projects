
create database celebal;
use celebal;


CREATE TABLE SubjectAllotments (
    StudentID VARCHAR(50) NOT NULL,
    SubjectID VARCHAR(50) NOT NULL,
    Is_Valid BIT NOT NULL,
    PRIMARY KEY (StudentID, SubjectID)
);
CREATE TABLE SubjectRequest (
    StudentID VARCHAR(50) NOT NULL,
    SubjectID VARCHAR(50) NOT NULL,
    PRIMARY KEY (StudentID, SubjectID)
);
INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
VALUES
    ('159103036', 'PO1491', 1),
    ('159103036', 'PO1492', 0),
    ('159103036', 'PO1493', 0),
    ('159103036', 'PO1494', 0),
    ('159103036', 'PO1495', 0);



DELIMITER //
CREATE PROCEDURE updatesubjectAgain(IN student_id VARCHAR(50), IN subject_id VARCHAR(50))
BEGIN
    -- Insert the requested subject into SubjectRequest table
    INSERT INTO SubjectRequest (StudentID, SubjectID)
    VALUES (student_id, subject_id);

    -- Check if the student_id exists in SubjectAllotments
    SET @is_valid_count = (SELECT COUNT(*) FROM SubjectAllotments WHERE StudentID = student_id AND Is_Valid = 1);

    IF @is_valid_count = 1 THEN
        -- Update the existing valid subject to be invalid
        UPDATE SubjectAllotments
        SET Is_Valid = 0
        WHERE StudentID = student_id AND Is_Valid = 1;
    END IF;

    -- Insert the requested subject as a valid record
    INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
    VALUES (student_id, subject_id, 1);


END //
DELIMITER ;

CALL updatesubjectAgain('159103036', 'PO1497');
CALL updatesubjectAgain('159103036', 'PO1498');