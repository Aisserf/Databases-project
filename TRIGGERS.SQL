

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

CREATE OR REPLACE FUNCTION AddToWaitingList() RETURNS TRIGGER AS $TryRegisterStudent$
declare 

BEGIN

--------------------------------------------------------------------------

CREATE FUNCTION public."CourseRegistration"() RETURNS trigger AS $$
BEGIN
IF EXISTS(
SELECT count(stud_id), course_code, max_nr_studs
FROM Students_Registered_to_courses NATURAL JOIN limited_courses
WHERE stud_id = NEW.stud_id AND course_code = NEW.course_code
GROUP BY stud_id, course_code
HAVING count(stud_id) >= max_nr_stud)

THEN RAISE EXCEPTION 'course is full';
ELSE RETURN NEW;
END IF;

IF EXISTS(
SELECT stud_id, course_code
FROM finished_courses
WHERE stud_id = NEW.stud_id
AND course_code = NEW.course_code)

THEN RAISE EXCEPTION 'student has already passed this course';
ELSE  RETURN NEW;
END IF;

IF NOT(
SELECT course_code, required_course
FROM course_requires_course NATURAL JOIN passed_courses
ON course_code = required_code
WHERE course_code = NEW.course_code
AND required_course = NEW.required_course)
THEN RAISE EXCEPTION 'STUDENT HAS NOT PASSED PREREQUISITES ';
	ELSE RETURN NEW;
END IF;


END $$ LANGUAGE plpgsql;




