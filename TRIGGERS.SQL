
CREATE OR REPLACE FUNCTION myFunction7() RETURNS TRIGGER AS $$
BEGIN


--Check if course is full
IF EXISTS(
SELECT count(stud_id) AND Students_Registered_to_course.course_code, max_nr_studs
FROM Students_Registered_to_course, limited_courses
WHERE stud_id = NEW.stud_id AND course_code = NEW.course_code
GROUP BY stud_id, Students_Registered_to_course.course_code, max_nr_studs
HAVING count(stud_id) > max_nr_studs)

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
