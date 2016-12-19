

--DROP OWNED BY tda357_050 CASCADE;


-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji

DROP TABLE IF EXISTS Departments CASCADE;
DROP TABLE IF EXISTS Programs CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;
DROP TABLE IF EXISTS Classifications CASCADE;
DROP TABLE IF EXISTS Limited_Courses CASCADE;
DROP TABLE IF EXISTS Branches CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS Has_Classification CASCADE;
DROP TABLE IF EXISTS Course_Requires_Course CASCADE;
DROP TABLE IF EXISTS Mandatory_Course_Program CASCADE;
DROP TABLE IF EXISTS Students_Registered_To_Course CASCADE;
DROP TABLE IF EXISTS Finished_Courses CASCADE;
DROP TABLE IF EXISTS Recommended_Course_Branch CASCADE;
DROP TABLE IF EXISTS Mandatory_Course_Branch CASCADE;
DROP TABLE IF EXISTS Stud_Chooses_Branch CASCADE;
DROP TABLE IF EXISTS Waiting_List CASCADE;
DROP TABLE IF EXISTS hosting_Deptarment CASCADE;


CREATE TABLE Departments(
	dept_id  TEXT  NOT NULL,
	dept_name    TEXT NOT NULL UNIQUE,
	PRIMARY KEY (dept_id)
);
--______________________________

CREATE TABLE Programs (
  prog_name    TEXT  NOT NULL,
  prog_id  CHAR(5) NOT NULL,
  PRIMARY KEY (prog_name)
);

--________________________________________________

CREATE TABLE Courses (
  course_name  TEXT  NOT NULL,
  course_code  CHAR(6) NOT NULL,
  credits  INTEGER NOT NULL,
  dept_id TEXT NOT NULL,
  PRIMARY KEY (course_code),
  FOREIGN KEY(dept_id) REFERENCES Departments(dept_id)
);

--_________________________________

CREATE TABLE Classifications (
  Class_name  TEXT  NOT NULL PRIMARY KEY
);

--____________________________________________________
CREATE TABLE Limited_courses(
  max_nr_studs  INTEGER NOT NULL,
  course_code  CHAR(6) REFERENCES Courses(course_code),
  CHECK (max_nr_studs > 0),
  PRIMARY KEY (course_code)
);

--_______________________________________________

CREATE TABLE Branches (
  branch_name    TEXT  NOT NULL unique,
  prog_name  TEXT  REFERENCES Programs (prog_name) NOT NULL,
  PRIMARY KEY (branch_name, prog_name)
);

--______________________________________________________
CREATE TABLE Students(
  stud_id  TEXT  NOT NULL,
  prog_name  TEXT  NOT NULL,
  ssn  VARCHAR(6) NOT NULL UNIQUE,
  stud_name  TEXT  NOT NULL,
    PRIMARY KEY (stud_id),
  UNIQUE(stud_id, prog_name)
);
--______________________________________________________

CREATE TABLE Has_CLassification(
  class_name  TEXT  REFERENCES  Classifications(class_name) NOT NULL,
  course_code  CHAR(6)  REFERENCES  Courses(course_code) NOT NULL PRIMARY KEY  
);

--__________________________________________________

CREATE TABLE Course_Requires_Course (
  course_code  char(6)  REFERENCES Courses(course_code),  
  required_course CHAR(6)REFERENCES Courses(course_code),
  PRIMARY KEY (course_code, required_course)
);

--________________________________________________________

CREATE TABLE Mandatory_Course_Program(
  course_code  char(6)  REFERENCES Courses(course_code) NOT NULL,  
  prog_name  TEXT  REFERENCES Programs(prog_name) NOT NULL,
  PRIMARY KEY(course_code, prog_name)
);

--________________________________________________________________

CREATE TABLE Students_Registered_To_Course (
  course_code  CHAR(6) REFERENCES Courses (course_code),
  stud_id  TEXT REFERENCES Students(stud_id) NOT NULL,
  PRIMARY KEY (stud_id, course_code)
);

--______________________________________________________

CREATE TABLE Finished_Courses(
  course_code   char(6)  REFERENCES Courses(course_code) ,
  stud_id   TEXT  REFERENCES Students(stud_Id) ,
  grade     text  NOT NULL,
  PRIMARY KEY(course_code, stud_id),
  constraint grade CHECK (grade = '3' OR grade = '4' OR grade = '5' OR grade = 'U')
);
--__________________________________________________________________________

CREATE TABLE Recommended_Course_Branch(
  course_code char(6) REFERENCES Courses(course_code) ,
  branch_name TEXT REFERENCES Branches(branch_name),
  prog_name TEXT REFERENCES Programs(prog_name),
  PRIMARY KEY(course_code, branch_name, prog_name),
  FOREIGN KEY (prog_name, branch_name) REFERENCES Branches(prog_name, branch_name)
);
--_____________________________________________________________________

CREATE TABLE Mandatory_Course_Branch(
  course_code char(6) REFERENCES Courses(course_code),
  branch_name  TEXT REFERENCES  Branches(branch_name),
  prog_name  TEXT REFERENCES Programs(prog_name),
  PRIMARY KEY(course_code,branch_name,prog_name),
  FOREIGN KEY (prog_name, branch_name) REFERENCES Branches(prog_name, branch_name)
);
--________________________

CREATE TABLE Stud_Chooses_Branch(
  stud_id  TEXT ,
  branch_name TEXT,
  prog_name TEXT,
  PRIMARY KEY(stud_id),
  FOREIGN KEY(stud_id, prog_name) REFERENCES Students(stud_id, prog_name),
  FOREIGN KEY(prog_name, branch_name) REFERENCES Branches(prog_name, branch_name)
);
--_________________________________________________________
CREATE TABLE Waiting_List(
  stud_id TEXT  REFERENCES Students(stud_id),
  course_code char(6)  REFERENCES Limited_Courses(course_code),
  position INT NOT NULL,
  CONSTRAINT position UNIQUE (position, course_code),
  CHECK (position > 0),
  PRIMARY KEY(stud_id, course_code)
);

--________________________________________________________

CREATE TABLE hosting_Deptarment(
  dept_id  TEXT REFERENCES Departments(dept_id) NOT NULL,
  prog_name    TEXT REFERENCES Programs(prog_name) NOT NULL,
  PRIMARY KEY (dept_id, prog_name)
);

-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji


-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji

INSERT INTO Departments(dept_id, dept_name) VALUES ('CS','Computer Science');
INSERT INTO Departments(dept_id, dept_name) VALUES ('IT','Information Technology');
INSERT INTO Departments(dept_id, dept_name) VALUES ('MS','Mathematical Sciences');

------------------------------------------------------------------------------------------


INSERT INTO Programs (prog_name, prog_id) VALUES ('Computer Engineering','CE');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Electrical Engineering','EE');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Industrial Economy and Production','IEP');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Marine Engineering','ME');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Machine Engineering','MCE');


------------------------------------------------------------------------------------------


INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Databases','TDA357',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Object oriented Programming','DAT050',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Real time Systems','LET625',5, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Programming','LEU482',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Machine oriented Programming','LEU500',10, 'IT');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Mathematical analysis','MVE415',5, 'MS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Linear Algebra','LMT211',10, 'MS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Vinprovning','vin123',40, 'CS');

------------------------------------------------------------------------------------------


INSERT INTO Classifications(Class_name) VALUES	('research course');
INSERT INTO Classifications(Class_name) VALUES	('seminar course');
INSERT INTO Classifications(Class_name) VALUES	('mathematical course');

--_____________________________________________________________

INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('1','TDA357');	
INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('1','DAT050');
INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('1','MVE415');
	
------------------------------------------------------------------------------------------


INSERT INTO Branches (branch_name, prog_name) VALUES ('Computer Languages','Computer Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Interaction Design','Industrial Economy and Production');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Software Engineering','Electrical Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Energy','Marine Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Materials','Machine Engineering');

------------------------------------------------------------------------------------------


INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('shahadt','Computer Engineering','960413','Shahad Tomasson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('espinod','Industrial Economy and Production','930909','Espino Dante');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('betr','Computer Engineering','950303','Beti Ramone');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('cocob','Marine Engineering','950616','Coco Bertsson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('joseg','Electrical Engineering','960606','Jose Gunarson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('isbele','Industrial Economy and Production','930101','Isbel Erve');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('ClarkKent','Computer Engineering','951213','Johan Luciasson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('pelle','Computer Engineering','950413','Pelvis Pelvisson ');

------------------------------------------------------------------------------------------

INSERT INTO Has_Classification(class_name, course_code) VALUES ('mathematical course','TDA357');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('research course','DAT050');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('seminar course','LET625');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('research course','LEU482');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('mathematical course','LEU500');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('seminar course','MVE415');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('seminar course','vin123');

------------------------------------------------------------------------------------------

INSERT INTO Course_Requires_Course (course_code, required_course) VALUES ('TDA357','DAT050');
INSERT INTO Course_Requires_Course (course_code, required_course) VALUES ('LEU500','MVE415');

------------------------------------------------------------------------------------------


INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('TDA357','Computer Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LMT211','Machine Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LEU482','Electrical Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('DAT050','Marine Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LET625','Industrial Economy and Production');

------------------------------------------------------------------------------------------

INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('vin123','shahadt');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('vin123','espinod');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('vin123','betr');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('vin123','cocob');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LEU482','joseg');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LET625','isbele');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('DAT050','shahadt');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LEU500','cocob');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('MVE415','joseg');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('DAT050','pelle');

------------------------------------------------------------------------------------------

INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('TDA357','shahadt','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('DAT050','espinod','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LET625','betr','3');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('DAT050','cocob','3');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('MVE415','cocob','4');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LET625','joseg','U');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('TDA357','isbele','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('vin123','pelle','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('TDA357','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('DAT050','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LET625','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LEU482','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LEU500','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('MVE415','ClarkKent','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LMT211','ClarkKent','5');

------------------------------------------------------------------------------------------

INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('TDA357','Computer Languages','Computer Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('LEU500','Interaction Design','Industrial Economy and Production');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('TDA357','Software Engineering','Electrical Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('LMT211','Energy','Marine Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('MVE415','Materials','Machine Engineering');

------------------------------------------------------------------------------------------

INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('DAT050','Computer Languages','Computer Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('LET625','Interaction Design','Industrial Economy and Production');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('MVE415','Software Engineering','Electrical Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('LEU500','Energy','Marine Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('TDA357','Materials','Machine Engineering');

------------------------------------------------------------------------------------------

INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('shahadt','Computer Languages','Computer Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('espinod','Interaction Design','Industrial Economy and Production');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('betr','Computer Languages','Computer Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('cocob','Energy','Marine Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('joseg','Software Engineering','Electrical Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('ClarkKent','Computer Languages','Computer Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('pelle','Computer Languages','Computer Engineering');

------------------------------------------------------------------------------------------

INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('espinod','TDA357','1');
--INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('joseg','DAT050','1');
INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('espinod','MVE415','1');
INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('shahadt','MVE415','2');

----------------------------------------------------------------------------------------

INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('CS','Computer Engineering');
INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('IT','Industrial Economy and Production');
INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('MS','Machine Engineering');


--- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji


-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji

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
	rec.sum >= 10)

union

(SELECT  s.stud_id AS Student, c.sum AS credits, u.count AS UnreadMandatory,
	m.sum AS MathCredits, r.sum AS ResearchCredits, ss.count AS seminarcourses,
	rec.sum AS RecCourses, 'NOT QUALIFIED' AS GRADUATABLE 
FROM students s
 LEFT JOIN credit_student c ON s.stud_id = c.stud_id
 LEFT JOIN unread_count u ON u.stud_id = s.stud_id 
 LEFT JOIN read_mathematical m ON m.stud_id = s.stud_id
 LEFT JOIN read_research r ON r.stud_id = s.stud_id
 LEFT JOIN read_seminar ss ON ss.stud_id = s.stud_id
 LEFT JOIN read_recommended rec ON rec.stud_id = s.stud_id

 WHERE  c.sum < 5 OR
	u.count IS NOT NULL OR
	m.sum < 20 OR
	r.sum < 10 OR
	ss.count < 1 OR
	rec.sum < 10
);


-- TDA357_050 - GRUPP 93- Betina Andersson, Fressia Merino & Shahad Naji
