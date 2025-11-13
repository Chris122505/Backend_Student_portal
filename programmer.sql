-- DDL (Data Definition Language)
CREATE TABLE course(
  course_code VARCHAR(10)  NOT NULL
 ,course_name VARCHAR(100) DEFAULT''
 ,status      VARCHAR(1)   DEFAULT'A'
 ,CONSTRAINT course_code_pk PRIMARY KEY (course_code)
 );
 
CREATE TABLE college(
  college_code VARCHAR(10)    NOT NULL
 ,college_name VARCHAR(200)   DEFAULT''
 ,CONSTRAINT college_code_pk  PRIMARY KEY(college_code)
 );
 
 CREATE TABLE student(
  student_no    VARCHAR(10)   NOT NULL
 ,lastname      VARCHAR(50)   DEFAULT''
 ,firstname     VARCHAR(50)   DEFAULT''
 ,address       VARCHAR(200)  DEFAULT''
 ,birthday      DATE DEFAULT '01/01/1900'
 ,shs_year_grad INTEGER DEFAULT 2000
 ,CONSTRAINT student_no_pk PRIMARY KEY(student_no)
);

CREATE TABLE sourse{
  
 
