DROP VIEW IF EXISTS StudentsFollowing, FinishedCourses CASCADE;
DROP VIEW IF EXISTS Registrations, PassedCourses CASCADE;
DROP VIEW IF EXISTS PathToGraduation CASCADE;
DROP VIEW IF EXISTS UnreadMandatory, CourseQueuePositions CASCADE;

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


CREATE VIEW PassedCourses AS 
SELECT stud_id, course_code, grade, credits
FROM Finished_Courses NATURAL JOIN Courses WHERE Grade IN ( '3', '4', '5');

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
FROM waiting_list


-------------------PATHtoGRADUATION-----no ready!---------------------------------------

CREATE VIEW PathToGraduation AS
SELECT *
FROM
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id ) r1

  LEFT OUTER JOIN
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id) r2
  
  on r1.stud_id = r2.stud_id

  LEFT OUTER JOIN
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id) r3
  
  on r2.stud_id = r3.stud_id

  LEFT OUTER JOIN
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id) r4
  
  on r3.stud_id = r4.stud_id

  LEFT OUTER JOIN
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id) r5
  
  on r4.stud_id = r5.stud_id
  
LEFT OUTER JOIN
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id) r6
  
  on r5.stud_id = r6.stud_id

WHERE r1.sum > 5 AND
  r2.count < 1 AND
  r3.sum > 19 AND
  r4.sum > 9 AND
  r5.count > 0 AND
  r6.sum < 9;

  
  -----------------------------------------------------------------------
  -- TDA357_050 - Betina Andersson, Shahad Naji & Fressia Merino

