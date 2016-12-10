CREATE FUNCTION AddToWaitingList (stud_id) RETURNS TRIGGER AS $$
BEGIN
	< if (#max_nr_studs < course.sum)>
	THEN add student to class
	ELSE add student to waiting 
END IF;
