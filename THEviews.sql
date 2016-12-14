DROP VIEW IF EXISTS StudentsFollowing, FinishedCourses CASCADE;
DROP VIEW IF EXISTS Registrations, PassedCourses CASCADE;
DROP VIEW IF EXISTS UnreadMandatory, CourseQueuePositions CASCADE;
DROP VIEW IF EXISTS PathToGraduation CASCADE;

------------------------------------------------------------------------------------


CREATE VIEW StudentsFollowing AS
SELECT stud_id, stud_name, ssn, prog_name, branch_name FROM Students NATURAL full OUTER
JOIN Stud_Chooses_Branch;
  
----------------------------------------------------------------------------------
CREATE VIEW FinishedCourses AS 
SELECT course_name, credits, stud_id, grade
FROM Courses NATURAL JOIN finished_courses;


----------------------------------------------------------------------------------

CREATE OR REPLACE VIEW Registrations AS 
(SELECT w.course_code,w.stud_id, 'Waiting' AS Status
FROM Waiting_List w)
UNION ALL
(SELECT r.*, 'Registered' AS Status
FROM Students_Registered_To_Course r)
;

--------------------------------------------------------------------------------

DROP VIEW IF EXISTS PassedCourses;
CREATE VIEW PassedCourses AS 
SELECT stud_id, course_code, grade, credits
FROM FinishedCourses NATURAL JOIN Courses WHERE Grade IN ( '3', '4', '5');

------------------------------------------------------------------------------

CREATE VIEW UnreadMandatory as

SELECT stud_id, course_code
FROM students
JOIN mandatory_course_program
ON students.prog_name = mandatory_course_program.prog_name
UNION
SELECT stud_id, course_code
FROM stud_chooses_branch    
JOIN mandatory_course_branch
ON stud_chooses_branch.branch_name = mandatory_course_branch.branch_name
--AND stud_chooses_branch.branch_name NOT IN (select stud_id, course_code from PassedCourses)

  EXCEPT (SELECT stud_id, course_code FROM passedcourses);
  
  ----------------------------------
CREATE OR REPLACE  VIEW CourseQueuePositions AS
SELECT stud_id, course_code, position 
FROM waiting_list;
  
  -----------------------------------------------------------------------
  
  -----PathtograduaOIRT-------------------------
  DROP VIEW IF EXISTS pathtograduation ;
CREATE VIEW pathtograduation AS

WITH credit_student AS
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id)

, unread_count AS
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id)

 , read_mathematical AS
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id)
  
, read_research AS
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id)

, read_seminar AS
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id)
  
, read_recommended AS 
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id)
  

(SELECT  s.stud_id AS Student, c.sum AS credits, u.count AS UnreadMandatory,
	m.sum AS MathCredits, r.sum AS ResearchCredits, ss.count AS seminarcourses,
	rec.sum AS RecCourses, 'NOT QUALIFIED' AS GRADUATABLE 
FROM students s
 LEFT JOIN credit_student c ON s.stud_id = c.stud_id
 LEFT JOIN unread_count u ON u.stud_id = s.stud_id 
 LEFT JOIN read_mathematical m ON m.stud_id = s.stud_id
 LEFT JOIN read_research r ON r.stud_id = s.stud_id
 LEFT JOIN read_seminar ss ON ss.stud_id = s.stud_id
 LEFT JOIN read_recommended rec ON rec.stud_id = s.stud_id) 

except

(SELECT  s.stud_id AS Student, c.sum AS credits, u.count AS UnreadMandatory,
	m.sum AS MathCredits, r.sum AS ResearchCredits, ss.count AS seminarcourses,
	rec.sum AS RecCourses, 'QUALIFIED' AS GRADUATABLE 
FROM students s
 LEFT JOIN credit_student c ON s.stud_id = c.stud_id
 LEFT JOIN unread_count u ON u.stud_id = s.stud_id 
 LEFT JOIN read_mathematical m ON m.stud_id = s.stud_id
 LEFT JOIN read_research r ON r.stud_id = s.stud_id
 LEFT JOIN read_seminar ss ON ss.stud_id = s.stud_id
 LEFT JOIN read_recommended rec ON rec.stud_id = s.stud_id

 WHERE  c.sum >= 5 AND
	u.count IS NULL AND
	m.sum >= 20 AND
	r.sum >= 10 AND
	ss.count >= 1 AND
	rec.sum >= 10
);
