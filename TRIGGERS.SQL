DROP TRIGGER tryregistrations ON registrations;
CREATE or replace FUNCTION try_register() RETURNS trigger AS $$
BEGIN

-- Kolla om han redan klarat kursen
IF EXISTS(
SELECT stud_id, course_code
FROM finished_courses
WHERE stud_id = NEW.stud_id
AND course_code = NEW.course_code)
THEN RAISE Notice '% has passed the course already', NEW.stud_id;
ELSE
 	-- check if course required courses are passed
	IF EXISTS(
	-- alla required course per kurs
	(select
	required_course from course_requires_course crc
	where crc.course_code = new.course_code )
	EXCEPT
	-- alla passed courses per student
	(select
	course_code from PassedCourses pc
	where pc.stud_id = new.stud_id)
	)
	THEN RAISE EXCEPTION 'STUDENT HAS NOT PASSED PREREQUISITES';
	ELSE
		--check if student already registered
		IF EXISTS(
		SELECT stud_id
		FROM registrations
		WHERE status = 'Registered' AND (stud_id,course_code) = (NEW.stud_id,NEW.course_code))
		THEN RAISE exception 'student is already registered to course';
		ELSE    
		--Check if course is full, put student on waitig list
			IF (
			(select count(stud_id) from registrations r where r.course_code = new.course_code)
 			< (SELECT max_nr_studs from limited_courses where course_code = new.course_code))
			THEN
  			insert into Students_Registered_To_Course values (new.course_code,new.stud_id);
			else insert into waiting_list values (new.course_code, new.stud_id);
			return new;
			END IF; 
		END IF;
	END IF;
END IF;

RETURN NEW;
END; 
$$ LANGUAGE 'plpgsql';

-----

CREATE TRIGGER tryRegistrations
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_register();
