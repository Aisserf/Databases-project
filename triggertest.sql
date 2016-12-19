--List information
SELECT * FROM pathtograduation;
--Register student
INSERT INTO Registrations (course_code, stud_id) VALUES ('LET625','espinod');
--Register again, ERROR message should pop up
INSERT INTO Registrations (course_code, stud_id) VALUES ('LET625','espinod');
-- Unregister student
DELETE FROM Registrations WHERE course_code = 'LET625' AND stud_id = 'espinod';
--Unregister again and show that it doesn't crash your program
DELETE FROM Registrations WHERE course_code = 'LET625' AND stud_id = 'espinod';

--Register student without requirements for course
INSERT INTO Registrations (course_code, stud_id) VALUES ('LEU500','isebel');





--Unregister a registered student, show that the waiting list is updated
SELECT * FROM Registrations WHERE course_code = 'MVE415';
DELETE FROM Registrations WHERE course_code = 'MVE415' AND stud_id = 'joseg';
SELECT * FROM Registrations WHERE course_code = 'MVE415';
--Register the same student again and show that the person ended up last in waiting list
INSERT INTO Registrations (course_code, stud_id) VALUES ('MVE415','joseg');
SELECT * FROM Registrations WHERE course_code = 'MVE415';
--Unregister the same student, show that the waiting list stays the same
DELETE FROM Registrations WHERE course_code = 'MVE415' AND stud_id = 'joseg';
SELECT * FROM Registrations WHERE course_code = 'MVE415';



--Register a student to and overfull course so the person ends up in the waiting list
SELECT * FROM Registrations WHERE course_code = 'DAT050';
INSERT INTO Registrations (course_code, stud_id) VALUES ('DAT050','joseg');
SELECT * FROM Registrations WHERE course_code = 'DAT050';
--Unregister a student from the same course and show that the waiting list stays the same
DELETE FROM Registrations WHERE course_code = 'DAT050' AND stud_id = 'shahadt';
SELECT * FROM Registrations WHERE course_code = 'DAT050';


