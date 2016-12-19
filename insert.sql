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
