CREATE FUNCTION AddToWaitingList (stud_id) RETURNS TRIGGER AS $$
BEGIN
	< if (#max_nr_studs < course.sum)>
	THEN add student to class
	ELSE add student to waiting 
END IF;
****************************************************************

CREATE FUNCTION AddToWaitingList() RETURNS TRIGGER AS $TryRegisterStudent$
DECLARE
	
	

BEGIN
  IF (#max_nr_studs < course.sum)
  THEN INSERT INTO Courses (course_code, stud_id)
  VALUES (course, stud_id);
  
  ELSE 
  INSERT INTO Wainting_list(course, stud_id)
  VALUES (course, stud_id)
END IF;
$TryRegisterStudent$ LANGUAGE 'plpgsql';
--RAISE EXCEPTION ’if student is already registered she cannot queue’;
    
CREATE TRIGGER TryRegisterStudent 
 INSTEAD OF INSERT ON Registrations
--WHEN studentisonqueue
  FOR EACH ROW 
EXECUTE PROCEDURE addtowaitinglist(course_code,stud_id);
