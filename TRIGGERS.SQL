CREATE FUNCTION addtowaitinglist (stud_id) RETURNS TRIGGER AS $$
BEGIN
	< if (#maxnoofstudents < course.sum)>
	THEN add student to class
	ELSE add student to queue 
END IF;
