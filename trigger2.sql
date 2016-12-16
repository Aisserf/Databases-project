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

------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION try_unregister() RETURNS TRIGGER AS $$
DECLARE
	sId BIGINT;
BEGIN
	IF EXISTS (
		-- Kolla om personen va registeread i kurse
	SELECT stud_id, course_code
	FROM students_registered_to_course
	WHERE stud_id = OLD.stud_id 
	AND course_code = OLD.course_code
	) THEN 
		-- Ta bort personen
		DELETE FROM students_registered_to_course WHERE course_code = OLD.course_code AND stud_id = OLD.stud_id;

		IF EXISTS (
			-- Kolla om kursen va en restricted course
			SELECT course_code
			FROM limited_courses
			WHERE course_code = OLD.course_code
		) THEN
			IF (
				-- Kolla om det får plats mer folk i kursen
				(SELECT count(stud_id) 
				FROM students_registered_to_course r 
				WHERE r.course_code = OLD.course_code)
				<
				(SELECT max_nr_studs 
				FROM limited_courses 
				WHERE course_code = OLD.course_code)
		
			) THEN 
				sId := select stud_id, course_code
				-- Hämta första personen i waiting_list
				from waiting_list
				where course_code = old.course_code
				AND position = '1'
				AND stud_id = sId;				
				
					
				
				IF (stud_id IS NOT NULL)
				THEN
					-- Lägg in han i kursen
					INSERT INTO students_registered_to_course
					VALUES (OLD.stud_id, OLD.course_code);
					-- Ta bort han från waiting_list 
					DELETE FROM waiting_List
					WHERE position = '1'
					AND course_code = OLD.course_code
					and stud_id = sId;
					
					-- Nedanstående kod ändrar alla i waiting_list med kursen minus 1
					UPDATE waiting_list
					set  position = position - 1;
					END IF;






				END IF;
			END IF;
		END IF;

else

		-- Kolla om elven finns i waiting_list
		IF EXISTS (select stud_id, course_code
			from waiting_list
			where course_code = old.course_code
			and stud_id = old.stud_id
			
		) THEN -- Om i så fall ta bort honom från waiting_list
				DELETE FROM waiting_List where course_code = old.course_code and stud_id = sId;
		END IF;
END IF;
	
RETURN OLD;
END
$$ LANGUAGE 'plpgsql';
----------------------------------------


--Trigger2

--when a student unregisters from a course if the student was properly registered and not only on the waiting list, the first student (if any) in the waiting list should be registered for the course instead. Note: this should only be done if there is actually room on the course (the course might have been over-full due to an administrator overriding the restriction and adding students directly).
DROP TRIGGER IF EXISTS trigger3 ON Registrations CASCADE;

CREATE or replace FUNCTION try_unregister() RETURNS trigger AS $$
BEGIN 

IF exists (
	SELECT stud_id, course_code
	FROM registrations
	WHERE stud_id = OLD.stud_id 
	AND course_code = OLD.course_code)
        THEN DELETE FROM students_registered_to_course WHERE course_code = OLD.course_code AND stud_id = OLD.stud_id;

ELSE IF(

	SELECT stud_id	
	FROM registrations 
	WHERE status = 'Waiting' 
	AND stud_id = OLD.stud_id AND course_code = OLD.course_code)
	
	THEN		
	DELETE FROM waiting_List
	WHERE position = '1' AND course_code = OLD.course_code; 

	INSERT INTO students_registered_to_course 
	VALUES (OLD.stud_id, OLD.course_code);


END IF;

	IF (
		(SELECT count(stud_id) 
		FROM students_registered_to_course r 
		WHERE r.course_code = OLD.course_code)
		<
		(SELECT max_nr_studs 
		FROM limited_courses 
		WHERE course_code = OLD.course_code)
		) 

		THEN
		DELETE FROM waiting_List
		WHERE position = '1'
		AND course_code = OLD.course_code;


		INSERT INTO students_registered_to_course
		VALUES (OLD.stud_id, OLD.course_code);

		UPDATE waiting_list
		set  position = position - 1;
		END IF;

RETURN OLD;
END
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trigger3
INSTEAD OF DELETE ON Registrations
FOR EACH ROW
EXECUTE PROCEDURE try_unregister();





