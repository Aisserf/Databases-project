CREATE VIEW V_Students_Following AS
  SELECT * FROM Students NATURAL full OUTER
  JOIN Stud_Chooses_Branch;
  
--——————————————————————————
CREATE VIEW V_Finished_Courses AS 
SELECT * 
FROM Finished_Courses NATURAL JOIN Courses;

--—————————————————————————

CREATE VIEW V_Registrations AS 
SELECT * 
FROM Students_Registered_To_Course NATURAL full OUTER JOIN Waiting_List;

--________________________
CREATE VIEW V_Passed_Courses AS 
SELECT * 
FROM Finished_Courses NATURAL JOIN Courses WHERE Grade IN ( '3', '4', '5');





****************************************************************************

-- TDA357_050 - Betina Andersson, Shahad Naji & Fressia Merino
--_____________________________________________________


CREATE VIEW StudentsFollowing AS
  SELECT stud_id, stud_name, ssn, prog_name, branch_name FROM Students NATURAL full OUTER
  JOIN Stud_Chooses_Branch;
  
--——————————————————————————
CREATE VIEW FinishedCourses AS 
SELECT course_name, credits, stud_id, grade
FROM Courses NATURAL JOIN finished_courses;


--—————————————————————————

CREATE VIEW Registrations AS 
SELECT * 
FROM Students_Registered_To_Course NATURAL full OUTER JOIN Waiting_List;

--________________________
CREATE VIEW PassedCourses AS 
SELECT stud_id, course_code, grade, credits
FROM Finished_Courses NATURAL JOIN Courses WHERE Grade IN ( '3', '4', '5');

------------------------------------------------------------------------------
CREATE VIEW UnreadMandatory as

select stud_id, course_code
from students 
join mandatory_course_program 
on students.prog_name = mandatory_course_program.prog_name
UNION
select stud_id, course_code 
from stud_chooses_branch    --(Sepil's suggestion, tidigare "FROM Student")
join mandatory_course_branch 
on stud_chooses_branch.branch_name = mandatory_course_branch AND stud_choosees_branch.branch_name NOT IN (select stud_id, course_code from PassedCourses);


-------------------------------------------------------------------------------


SELECT stud_id, course_code, prog_name, branch_name
FROM students NATURAL  FULL OUTER JOIN mandatory_course_program
join mandatory_course_branch;
