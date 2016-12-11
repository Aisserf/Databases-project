

CREATE FUNCTION AddToWaitingList() RETURNS TRIGGER AS $TryRegisterStudent$
BEGIN
	--Check that course isn’t full
	IF NEW.MaxNoOfStudents > studentsInCourse THEN
	RAISE EXCEPTION ’Course is full’;
	END IF;
	--Check that student isn’t already registered
	IF NEW.Stud_Id = registration.stud_id.course THEN
	RAISE EXCEPTION ’student is already registered’;
	END IF;
	--If there is room in class
	IF NEW.studentsinclass < maxNoOfStudents THEN
END
$TryRegisterStudent$ LANGUAGE plpgsql;
--RAISE EXCEPTION ’if student is already registered she cannot queue’;
    
CREATE TRIGGER TryRegisterStudent 
 INSTEAD OF INSERT ON Registrations
--WHEN studentisonqueue
FOR EACH ROW 
EXECUTE PROCEDURE addtowaitinglist(course_code,stud_id);

-----------------------------------------------------------------------

CREATE TRIGGER TryRegisterStudent
INSTEAD OF INSERT OR UPDATE OR DELETE ON Registrations 
FOR EACH ROW EXECUTE PROCEDURE AddToWaitingList();
