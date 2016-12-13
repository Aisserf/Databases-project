

INSERT INTO registrations (course_code, stud_id) VALUES ('LMT211','betr');




CREATE OR REPLACE FUNCTION myFunction7() RETURNS TRIGGER AS $$
BEGIN


--Check if course is full
IF EXISTS(
SELECT count(stud_id)
FROM Registrations r, limited_courses lc
WHERE stud_id = NEW.stud_id 
AND r.course_code = NEW.course_code
HAVING count(stud_id) >= max_nr_studs)

THEN RAISE EXCEPTION 'course is full';

ELSE RETURN NEW;
END IF;
END $$ LANGUAGE 'plpgsql';


--Check if student has passes preregusites
IF NOT(
SELECT course_code, required_course
FROM course_requires_course NATURAL JOIN passed_courses
ON course_code = required_code
WHERE course_code = NEW.course_code
AND required_course = NEW.required_course
HAVING course_code = required_course)

THEN RAISE EXCEPTION 'STUDENT HAS NOT PASSED PREREQUISITES';

ELSE RETURN NEW;
END IF;
END $$ LANGUAGE 'plpgsql';


--Check if student has already passed course
IF EXISTS(
SELECT stud_id, course_code
FROM finished_courses
WHERE stud_id = NEW.stud_id
AND course_code = NEW.course_code)

THEN RAISE EXCEPTION 'student has already passed this course';
ELSE  RETURN NEW;
END IF;
END $$ LANGUAGE 'plpgsql';


--Check if student is already registered to course
IF EXISTS(
SELECT (stud_id AND course_code)
FROM Students_Registered_to_courses
WHERE stud_id = NEW.stud_id AND course_code = NEW.course_code)

THEN RAISE EXCEPTION 'student is already registered to course';

ELSE RETURN NEW;
END IF;
END $$ LANGUAGE 'plpgsql';


CREATE TRIGGER myTrigger7
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE myFunction7();

______________________________________________________________________________________________________________
-- albins suggestion

DROP TRIGGER IF EXISTS Register ON Registrations CASCADE;
DROP TRIGGER IF EXISTS Unregister ON Registrations CASCADE;

---------------------------------------------------------------------

CREATE OR REPLACE FUNCTION try_register() RETURNS TRIGGER AS $$
BEGIN
	IF NOT EXISTS (
		-- Kolla om det finns någon student
    	SELECT (stud_id AND course_code)
	FROM Students_Registered_to_courses
	WHERE stud_id = NEW.stud_id 
	AND course_code = NEW.course_code)
	THEN RAISE EXCEPTION '% does not exist', NEW.studentID;
	END IF;

	IF EXISTS (
		-- Kolla om han redan är registerad
	) THEN RAISE EXCEPTION '% is already registered', NEW.studentID;
	END IF;

	IF EXISTS (
		-- Kolla om han redan klarat kursen
		IF EXISTS(
		SELECT stud_id, course_code
		FROM finished_courses
		WHERE stud_id = NEW.stud_id
		AND course_code = NEW.course_code)
	) THEN RAISE EXCEPTION '% has passed the course already', NEW.studentID;
	END IF;
					
	IF EXISTS ( 
		-- Kolla om han klarat alla pre-courses
	) THEN RAISE EXCEPTION '% has not passed the pre-courses', NEW.studentID;
	END IF;
	
	IF (
		-- Kolla om kursen är full
	) THEN -- Om den är full så lägg in han i kölistan
	ELSE
		-- den va inte full, så han kan således registreras på kursen!
	END IF;
	
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

---------------------------------------------------------------------

CREATE TRIGGER Register 
	INSTEAD OF INSERT ON Registrations
	FOR EACH ROW
	EXECUTE PROCEDURE try_register();

---------------------------------------------------------------------
	
CREATE OR REPLACE FUNCTION try_unregister() RETURNS TRIGGER AS $$
DECLARE
	sId BIGINT;
BEGIN
	IF EXISTS (
		-- Kolla om studenten existerar
	) THEN 
		IF EXISTS (
			-- Kolla om kursen existerar
		) THEN
			-- Ta bort studenten från kursen
				
			--
			-- Kolla på något sätt om det finns platser i kursen
			-- och om i så fall gör nedanstående grejer.
			--
				
			sId := Lika med han som är plats 1
		
			IF (sId IS NOT NULL) -- Alltså att det fanns någon på plats 1
			THEN 
				-- Lägg in han i kursen
				-- Ta bort honom från kölistan
				
				-- Uppdatera alla som är kvar i kölistan med deras värde minus 1
			END IF;
		END IF;
	END IF;
	
	RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

---------------------------------------------------------------------
	
CREATE TRIGGER Unregister 
	INSTEAD OF DELETE ON Registrations
	FOR EACH ROW
	EXECUTE PROCEDURE try_unregister();
	
--------------------------------------------------------------------------
	DROP TRIGGER IF EXISTS Register ON Registrations CASCADE;
CREATE OR REPLACE FUNCTION try_register() RETURNS TRIGGER AS $$
BEGIN
 
    -- Kolla om han redan klarat kursen
    IF EXISTS(
    SELECT stud_id, course_code
    FROM finished_courses
    WHERE stud_id = NEW.stud_id
    AND course_code = NEW.course_code)
   THEN RAISE EXCEPTION '% has passed the course already', NEW.studentID;
  END IF;

  return new;

  END
$$ LANGUAGE 'plpgsql';
    
CREATE TRIGGER Register
  INSTEAD OF INSERT ON Registrations
  FOR EACH ROW
  EXECUTE PROCEDURE try_register();
  _____________________________________________________________________________________________
-- check if course is full - second try:

CREATE or replace FUNCTION "myfunction7"() RETURNS trigger AS $$
BEGIN


--Check if course is full, put student on waitig list
IF (
(select count(stud_id) from registrations r where r.course_code = new.course_code)
 < (SELECT max_nr_studs from limited_courses where course_code = new.course_code))
THEN
  insert into Students_Registered_To_Course values (new.course_code,new.stud_id);
else return new;
end if;
end $$ language 'plpgsql';
-----------
-- check if course required courses are passed
CREATE or replace  FUNCTION public."myfunction7"() RETURNS trigger AS $$
BEGIN

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

ELSE RETURN NEW;
END IF;
END $$ LANGUAGE plpgsql;

