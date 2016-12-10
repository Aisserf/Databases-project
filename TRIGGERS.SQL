CREATE FUNCTION AddToWaitingList (stud_id) RETURNS TRIGGER AS $$
BEGIN
	< if (#max_nr_studs < course.sum)>
	THEN add student to class
	ELSE add student to waiting 
END IF;
****************************************************************


CREATE TRIGGER TryRegisterStudent 
BEFORE INSTEAD OF INSERT ON Registration
WHEN studentisonqueue
EXECUTE PROCEDURE addtowaitinglist(stud_id);
CREATE FUNCTION addtowaitinglist (course, stud_id) RETURNS TRIGGER AS $$
BEGIN
	< if (#maxnoofstudents < course.sum)>
	THEN INSERT INTO Courses (course_code, stud_id)
	VALUES (course, stud_id)
	
	ELSE INSERT INTO Wainting_list(course, stud_id)
	VALUES (course, stud_id)
END IF;
RAISE EXCEPTION ’if student is already registered she cannot queue’;
sqlstatement
