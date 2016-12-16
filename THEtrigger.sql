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

	
	-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji
