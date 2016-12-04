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


