-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji

--trigger1
DROP TRIGGER IF EXISTS tryRegistrations ON Registrations CASCADE;

CREATE or replace FUNCTION try_register() RETURNS trigger AS $$
BEGIN
	-- Kolla om han redan klarat kursen
	IF EXISTS
	(
		SELECT stud_id --, course_code
		FROM finished_courses
		WHERE stud_id = NEW.stud_id AND course_code = NEW.course_code
	) THEN RAISE Notice '% has passed the course already', NEW.stud_id;
	END IF;
	
 	-- check if course required courses are passed
	IF EXISTS (
	-- alla required course per kurs
		(SELECT required_course
		FROM course_requires_course crc
		WHERE crc.course_code = NEW.course_code )
		EXCEPT
		-- alla passed courses per student
		(SELECT course_code FROM PassedCourses pc
		WHERE pc.stud_id = NEW.stud_id)
	) THEN RAISE EXCEPTION 'STUDENT HAS NOT PASSED PREREQUISITES';
	END IF;
	
	--check if student already registered
	IF EXISTS (
		SELECT stud_id
		FROM Registrations
		WHERE stud_id = NEW.stud_id AND course_code =  NEW.course_code
	) THEN RAISE EXCEPTION 'student is already registered to course or waintiiiiiin';
	END IF;
	
	--Check if course is full, put student on waitig list
	IF (
		(SELECT count(stud_id) FROM registrations r WHERE r.course_code = NEW.course_code)
		>=
		(SELECT max_nr_studs FROM limited_courses WHERE course_code = NEW.course_code)
	) THEN
		INSERT INTO waiting_list 
			VALUES (NEW.stud_id, NEW.course_code, (
				SELECT COALESCE(MAX(position), 0) + 1
				FROM CourseQueuePositions
				WHERE course_code = NEW.course_code
			));
	ELSE
		INSERT INTO Students_Registered_To_Course VALUES (NEW.course_code, NEW.stud_id);
	END IF;
	
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tryRegistrations
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_register();

-----------------------------------------------------Second Trigger - comming soon!--------
DROP TRIGGER IF EXISTS trigger3 ON Registrations CASCADE;
CREATE or replace FUNCTION try_unregister() RETURNS trigger AS $$

DECLARE
isRegistered INT;
onQ INT;
courseQ INT;
maxStudents INT;
numberOfStudents INT;
firstInQ TEXT;

BEGIN 

SELECT count(*)
INTO isRegistered	--Put all registered students here
FROM registrations
WHERE stud_id = OLD.stud_id AND course_code = OLD.course_code
AND status = 'Registered';

SELECT count(*) 
INTO onQ	--To help check if the student is queuing
FROM registrations
WHERE stud_id = OLD.stud_id AND course_code = OLD.course_code
AND status = 'Waiting';

SELECT count(*)
INTO courseQ		--To help check how long the queu is for the course
FROM Registrations
WHERE course_code = OLD.course_code
AND status = 'Waiting';

SELECT max_nr_studs 
INTO maxStudents		--To help check the maximun number of students
FROM limited_courses
WHERE course_code = OLD.course_code;

SELECT count(Students_registered_to_course.stud_id)
INTO numberOfStudents		--To help check how many are currently reading this course
FROM students_registered_to_course
WHERE course_code = OLD.course_code;

SELECT coursequeuepositions.stud_id
INTO firstInQ		-- To help check who is first in queue
FROM coursequeuepositions
WHERE position = 1 AND course_code = OLD.course_code;


--Check if student is registered
IF isRegistered > 0
THEN
DELETE FROM students_registered_to_course
WHERE students_registered_to_course.course_code = OLD.course_code
AND students_registered_to_course.stud_id = OLD.stud_id;
  --Check if there is room for more people in the course
  IF numberOfStudents <= maxStudents
  THEN 
    --Check if there's a student queuing for that course
    IF courseQ > 0	--If there is, place in course, delete from queue
    THEN 
    INSERT INTO students_registered_to_course(course_code, stud_id)
    VALUES (OLD.course_code, firstInQ);
    DELETE FROM waiting_list 
    WHERE waiting_list.course_code = OLD.course_code AND waiting_list.stud_id = firstInQ;
    UPDATE waiting_list SET position = position -1 WHERE course_code = OLD.course_code;
    END IF;
  ELSE
    DELETE FROM students_registered_to_course WHERE course_code = OLD.course_code AND stud_id = OLD.stud_id;
  END IF;

--Check if student is queuing
  ELSE IF onQ > 0
  THEN
  DELETE FROM waiting_list 
  WHERE waiting_list.course_code = OLD.course_code AND waiting_list.stud_id = OLD.stud_id;
  UPDATE waiting_list SET position = position -1 WHERE course_code = OLD.course_code;
  ELSE
  RAISE EXCEPTION 'This student is not on que, nor is she registered';
END IF;
END IF;

RETURN OLD;
END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger3
INSTEAD OF DELETE ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_unregister();
	
	-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji
