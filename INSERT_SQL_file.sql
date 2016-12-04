INSERT INTO Departments(dept_id, dept_name) VALUES ('CS','Computer Science');
INSERT INTO Departments(dept_id, dept_name) VALUES ('IT','Information Technology');
INSERT INTO Departments(dept_id, dept_name) VALUES ('MS','Mathematical Sciences');

--______________________________________________________________


INSERT INTO Programs (prog_name, prog_id) VALUES ('Computer Engineering','CE');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Electrical Engineering','EE');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Industrial Economy and Production','IEP');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Marine Engineering','ME');
INSERT INTO Programs (prog_name, prog_id) VALUES ('Machine Engineering','MCE');


--______________________________________________________________


INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Databases','TDA357',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Object oriented Programming','DAT050',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Real time Systems','LET625',5, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Programming','LEU482',10, 'CS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Machine oriented Programming','LEU500',10, 'IT');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Mathematical analysis','MVE415',5, 'MS');
INSERT INTO Courses (course_name, course_code, credits, dept_id) VALUES ('Linear Algebra','LMT211',10, 'MS');

--______________________________________________________


INSERT INTO Classifications(Class_name) VALUES	('research course');
INSERT INTO Classifications(Class_name) VALUES	('seminar course');
INSERT INTO Classifications(Class_name) VALUES	('mathematical course');

--_____________________________________________________________

INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('200','TDA357');	
INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('400','DAT050');
INSERT INTO Limited_courses (max_nr_studs, course_code) VALUES ('150','MVE415');
	
--__________________________________________________


INSERT INTO Branches (branch_name, prog_name) VALUES ('Computer Languages','Computer Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Interaction Design','Industrial Economy and Production');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Software Engineering','Electrical Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Energy','Marine Engineering');
INSERT INTO Branches (branch_name, prog_name) VALUES ('Materials','Machine Engineering');

--______________________________________________________


INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('shahadt','Computer Engineering','960413','Shahad Tomasson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('espinod','Industrial Economy and Production','930909','Espino Dante');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('betr','Computer Engineering','950303','Beti Ramone');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('cocob','Marine Engineering','950616','Coco Bertsson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('joseg','Electrical Engineering','960606','Jose Gunarson');
INSERT INTO Students (stud_id, prog_name, ssn, stud_name) VALUES ('isbele','Industrial Economy and Production','930101','Isbel Erve');


--______________________________________________________________________

INSERT INTO Has_Classification(class_name, course_code) VALUES ('mathematical course','TDA357');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('research course','DAT050');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('seminar course','LET625');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('research course','LEU482');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('mathematical course','LEU500');
INSERT INTO Has_Classification(class_name, course_code) VALUES ('seminar course','MVE415');

--________________________________________________________________________

INSERT INTO Course_Requires_Course (course_code, required_course) VALUES ('TDA357','DAT050');
INSERT INTO Course_Requires_Course (course_code, required_course) VALUES ('LEU500','MVE415');

--_________________________________________________________________________


INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('TDA357','Computer Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LMT211','Machine Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LEU482','Electrical Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('DAT050','Marine Engineering');
INSERT INTO Mandatory_Course_Program (course_code, prog_name) VALUES ('LET625','Industrial Economy and Production');

--______________________________________________________________________

INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('TDA357','shahadt');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LET625','espinod');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('TDA357','betr');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('DAT050','cocob');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LEU482','joseg');
INSERT INTO Students_Registered_To_Course (course_code, stud_id) VALUES ('LET625','isbele');

--______________________________________________________________________

INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('TDA357','shahadt','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('DAT050','espinod','5');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LET625','betr','3');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('DAT050','cocob','3');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('LET625','joseg','4');
INSERT INTO Finished_Courses(course_code, stud_id, grade) VALUES('TDA357','isbele','5');

--______________________________________________________________________

INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('TDA357','Computer Languages','Computer Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('LEU500','Interaction Design','Computer Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('TDA357','Software Engineering','Computer Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('LMT211','Energy','Marine Engineering');
INSERT INTO Recommended_Course_Branch (course_code, branch_name, prog_name) VALUES('MVE415','Materials','Machine Engineering');

--_________________________________________________________________________________

INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('DAT050','Computer Languages','Machine Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('LET625','Interaction Design','Industrial Economy and Production');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('MVE415','Software Engineering','Computer Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('LEU500','Energy','Marine Engineering');
INSERT INTO Mandatory_Course_Branch (course_code,branch_name, prog_name) VALUES('TDA357','Materials','Machine Engineering');

--___________________________________________________________________________

INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('shahadt','Computer Languages','Computer Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('espinod','Interaction Design','Industrial Economy and Production');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('betr','Computer Languages','Computer Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('cocob','Energy','Marine Engineering');
INSERT INTO Stud_Chooses_Branch (stud_id, branch_name, prog_name) VALUES('joseg','Software Engineering','Electrical Engineering');


--________________________________________________________________________________

INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('isbele','TDA357','6');
INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('joseg','DAT050','1');
INSERT INTO Waiting_List(stud_id, course_code, position) VALUES('espinod','MVE415','8');

--_____________________________________________________________________________

INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('CS','Computer Engineering');
INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('IT','Industrial Economy and Production');
INSERT INTO hosting_Deptarment (dept_id, prog_name) VALUES ('MS','Machine Engineering');
