CREATE TABLE STUDENT(
  student_id  VARCHAR(10)  NOT NULL
 ,course_id   VARCHAR(10)  NOT NULL
 ,block_id    VARCHAR(10)  NOT NULL
 ,user_id     VARCHAR(10)  NOT NULL
 ,last_name   VARCHAR(100) NOT NULL 
 ,first_name  VARCHAR(100) NOT NULL 
 ,middle_name VARCHAR(100) NOT NULL  
 ,gender      VARCHAR(6)   DEFAULT''
 ,birthday    DATE         DEFAULT'12-OCT-9999'
 ,age         INTEGER      DEFAULT 0
 ,nationality VARCHAR(100) DEFAULT''
 ,blood_type  VARCHAR(10)  DEFAULT''
 ,contact_no  VARCHAR(15)  DEFAULT''
 ,email       VARCHAR(200) DEFAULT''
 ,status      VARCHAR(50)  DEFAULT''
 ,CONSTRAINT student_id_pk PRIMARY KEY(student_id) 
 ,CONSTRAINT course_id_fk_1 FOREIGN KEY(course_id) REFERENCES course(course_id) 
 ,CONSTRAINT block_id_fk FOREIGN KEY(block_id) REFERENCES block(block_id) 
 ,CONSTRAINT user_id_fk FOREIGN KEY(user_id) REFERENCES portal_user(user_id)
);

CREATE TABLE STUDENT_ADDRESS(
  student_id VARCHAR(10)  NOT NULL
 ,house_no   VARCHAR(300) DEFAULT''
 ,street     VARCHAR(300) DEFAULT''
 ,brgy       VARCHAR(300) DEFAULT''
 ,town       VARCHAR(300) DEFAULT''
 ,city       VARCHAR(300) DEFAULT''
 ,zipcode    INTEGER      DEFAULT 0
 ,CONSTRAINT student_id_fk FOREIGN KEY(student_id) REFERENCES student(student_id) 
);

CREATE TABLE BLOCK(
  block_id    VARCHAR(10) NOT NULL
 ,course_id   VARCHAR(10) NOT NULL
 ,year_level  INTEGER     DEFAULT 0
 ,block_no    INTEGER     DEFAULT 0 
 ,status      VARCHAR(1)  DEFAULT'A'
 ,CONSTRAINT block_id_pk PRIMARY KEY (block_id) 
 ,CONSTRAINT course_id_fk FOREIGN KEY (course_id) REFERENCES course(course_id) 
);

CREATE TABLE COURSE(
  course_id     VARCHAR(10)   NOT NULL
 ,college_id    VARCHAR(10)   NOT NULL
 ,course_name   VARCHAR(500)  NOT NULL 
 ,CONSTRAINT course_id_pk PRIMARY KEY(course_id) 
 ,CONSTRAINT college_id_fk FOREIGN KEY(college_id) REFERENCES COLLEGE(college_id)
);

CREATE TABLE COLLEGE(
  college_id    VARCHAR(10)   NOT NULL
 ,college_name  VARCHAR(300)  DEFAULT''
 ,dean          VARCHAR(300)  DEFAULT''
 ,CONSTRAINT college_id_pk PRIMARY KEY(college_id) 
);

CREATE TABLE PORTAL_USER(
  user_id     VARCHAR(10)   NOT NULL
 ,username    VARCHAR(100)  NOT NULL
 ,password    VARCHAR(10)   NOT NULL
 ,user_type   VARCHAR(100)  DEFAULT''
 ,email       VARCHAR(300)  DEFAULT''
 ,status      VARCHAR(1)    DEFAULT'A'
 ,last_login  DATE          DEFAULT'12-OCT-9999'
 ,CONSTRAINT user_id PRIMARY KEY(user_id)
);
