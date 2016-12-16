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
  FOREIGN KEY (prog_name, branch_name) REFERENCES Branches(prg_name, branch_name)
);
--_____________________________________________________________________

CREATE TABLE Mandatory_Course_Branch(
  course_code char(6) REFERENCES Courses(course_code),
  branch_name  TEXT REFERENCES  Branches(branch_name),
  prog_name  TEXT REFERENCES Programs(prog_name),
  PRIMARY KEY(course_code,branch_name,prog_name),
  FOREIGN KEY (prog_name, branch_name) REFERENCES Branches(prg_name, branch_name)
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
