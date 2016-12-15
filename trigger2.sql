--Trigger2
DROP TRIGGER IF EXISTS try_unrigester ON Registrations CASCADE;

CREATE or replace FUNCTION try_unregister() RETURNS trigger AS $$
BEGIN
	
	--Kolla om personen köar
	IF NOT EXISTS (
		SELECT stud_id
		FROM waiting_list
		WHERE stud_id = NEW.stud_id AND course_code = NEW.course_code)
		THEN RAISE NOTICE 'student is not on queue'
		END IF;

	--Kolla om personen är först i kön
	IF NOT EXISTS ((SELECT position
		FROM waiting_list
		WHERE position = '1') 
		AND
		(SELECT stud_id, course_code 
		FROM waiting_list 
		WHERE stud_id = NEW.stud_id 
		AND course_code= NEW.course_code))
		THEN RAISE NOTICE 'student is not first in queue'
		END IF;

	-- Kolla om det finns plats i kursen
	IF (
		(SELECT count(stud_id) FROM registrations r WHERE r.course_code = NEW.course_code)
		<
		(SELECT max_nr_studs FROM limited_courses WHERE course_code = NEW.course_code)
		) THEN
		

		then 
		replace into waiting_list (stud_id, course_code, position)
		select(
		coalesce(max(stud_id), - 1) + 1 ),
		coalesce(max(stud_id), - 1) + 1 ) 
		)	

		INSERT FROM waiting_List
		WHERE position = '1'
		INTO students_registered_to_course 
		VALUES (NEW.stud_id, NEW.course_code
 			(SELECT COALESCE(MAX(position), 0) - 1
			FROM CourseQueuePositions
			WHERE course_code = NEW.course_code
	);	

	ELSE
	END IF;
 
	
RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger2
INSTEAD OF INSERT ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_unregister();

			
--Trigger2   ----------------- NYASTEEEEEEEEEE

--when a student unregisters from a course if the student was properly registered and not only on the waiting list, 
--the first student (if any) in the waiting list should be registered for the course instead.
--Note: this should only be done if there is actually room on the course (the course might have been over-full due to 
--an administrator overriding the restriction and adding students directly).
DROP TRIGGER IF EXISTS try_unrigester ON Registrations CASCADE;

CREATE or replace FUNCTION try_unregister() RETURNS trigger AS $$
BEGIN


	--Check status of student
	IF NOT EXISTS (Select stud_id, status
		FROM registrations
		WHERE status = 'Waiting'
		AND stud_id = OLD.stud_id AND course_code = OLD.course_code)
		THEN RAISE NOTICE 'Student is not on queue';
		END IF;	
	

	--Kolla om personen köar
	IF NOT EXISTS (
		SELECT stud_id
		FROM waiting_list
		WHERE stud_id = OLD.stud_id AND course_code = OLD.course_code)
		THEN RAISE NOTICE 'student is not on queue';
		END IF;

	--Kolla om personen är först i kön
	IF NOT EXISTS ( SELECT stud_id, course_code, position 
		FROM waiting_list
		WHERE position = '1' 
		AND stud_id = OLD.stud_id AND course_code = OLD.course_code)
		THEN RAISE NOTICE 'student is not first in queue';
		END IF;
	
	
	-- Kolla om det finns plats i kursen
	IF (
		(SELECT count(stud_id) FROM registrations r WHERE r.course_code = OLD.course_code)
		<
		(SELECT max_nr_studs FROM limited_courses WHERE course_code = OLD.course_code)
		) THEN
		

		--THEN 
		--REPLACE INTO  waiting_list (stud_id, course_code, position)
		--select(
		--coalesce(max(stud_id), - 1) + 1 ),
		--coalesce(max(stud_id), - 1) + 1 ) 
		--)	

		DELETE FROM waiting_List
		WHERE position = '1' AND course_code = OLD.course_code 

		INSERT INTO students_registered_to_course 
		VALUES OLD.stud_id, OLD.course_code
 			--(SELECT COALESCE(MAX(position), 0) - 1
			--FROM CourseQueuePositions
			--WHERE course_code = NEW.course_code
	);	

	ELSE
	END IF;
 
	
RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger2
INSTEAD OF DELETE ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_unregister();



