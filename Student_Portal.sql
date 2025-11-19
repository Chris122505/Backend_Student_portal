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
  address_id VARCHAR(10)  NOT NULL
 ,student_id VARCHAR(10)  NOT NULL
 ,house_no   VARCHAR(300) DEFAULT''
 ,street     VARCHAR(300) DEFAULT''
 ,brgy       VARCHAR(300) DEFAULT''
 ,town       VARCHAR(300) DEFAULT''
 ,city       VARCHAR(300) DEFAULT''
 ,zipcode    INTEGER      DEFAULT 0
 ,CONSTRAINT address_id_pk PRIMARY KEY(address_id) 
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

CREATE TABLE ENROLLMENT(
  enrollment_id VARCHAR(10)   NOT NULL
 ,student_id    VARCHAR(10)   NOT NULL
 ,school_year   VARCHAR(50)   DEFAULT''
 ,sem           INTEGER       DEFAULT 0
 ,date_enrolled DATE          DEFAULT'12-OCT-9999'
 ,status        VARCHAR(100)  DEFAULT'Regular'
 ,CONSTRAINT enrollment_id_pk PRIMARY KEY(enrollment_id) 
 ,CONSTRAINT student_id_fk_1 FOREIGN KEY(student_id) REFERENCES student(student_id) 
);

CREATE TABLE SUBJECT(
  subject_id     VARCHAR(10)  NOT NULL
 ,subject_name   VARCHAR(500) DEFAULT''
 ,units          INTEGER      DEFAULT 0
 ,CONSTRAINT subject_id_pk PRIMARY KEY(subject_id) 
);

CREATE TABLE ENROLLED_SUBJECT(
  enrollment_id VARCHAR(10) NOT NULL
 ,subject_id     VARCHAR(10) NOT NULL
 ,status         VARCHAR(50) DEFAULT'In-progress'
 ,CONSTRAINT enrolled_subject_pk PRIMARY KEY(enrollment_id, subject_id)
 ,CONSTRAINT enrollment_id_fk FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id)
 ,CONSTRAINT subject_id_fk FOREIGN KEY(subject_id) REFERENCES subject(subject_id) 
);


CREATE TABLE GRADES(
  grade_id    VARCHAR(10)  NOT NULL
 ,student_id  VARCHAR(10)  NOT NULL
 ,subject_id  VARCHAR(10)  NOT NULL
 ,school_year VARCHAR(50)  DEFAULT''
 ,sem         INTEGER      DEFAULT 0
 ,grade       NUMBER(5,2)  DEFAULT 0
 ,remark      VARCHAR(100) DEFAULT''
 ,CONSTRAINT grade_id_pk PRIMARY KEY(grade_id)
 ,CONSTRAINT student_id_fk_2 FOREIGN KEY(student_id) REFERENCES student(student_id) 
 ,CONSTRAINT subject_id_fk_1 FOREIGN KEY(subject_id) REFERENCES subject(subject_id) 
);

CREATE TABLE PAYMENT(
  payment_id    VARCHAR(10) 
 ,student_id    VARCHAR(10) 
 ,payment_type  VARCHAR(50) DEFAULT''
 ,amount        NUMBER(5,2) DEFAULT 0
 ,balance       NUMBER(5,2) DEFAULT 0
 ,status        VARCHAR(50) DEFAULT''
 ,due_date      DATE        DEFAULT'12-OCT-9999'
 ,CONSTRAINT payment_id_pk PRIMARY KEY(payment_id)
 ,CONSTRAINT student_id_fk_3 FOREIGN KEY(student_id) REFERENCES student(student_id) 
);

CREATE TABLE MESSAGES(
  message_id    VARCHAR(10) 
 ,sender_id     VARCHAR(10) 
 ,reciever_id   VARCHAR(10)
 ,subject       VARCHAR(200)  DEFAULT''
 ,message_body  VARCHAR(1000) DEFAULT''
 ,status        VARCHAR(50)   DEFAULT''
 ,created_at    DATE          DEFAULT'12-OCT-9999'
 ,CONSTRAINT message_id_pk PRIMARY KEY(message_id) 
 ,CONSTRAINT sender_id_fk FOREIGN KEY(sender_id) REFERENCES PORTAL_USER(user_id)
 ,CONSTRAINT reciever_id_fk FOREIGN KEY(reciever_id) REFERENCES PORTAL_USER(user_id)
);

CREATE TABLE FACULTY(
  faculty_id          VARCHAR(10)   NOT NULL
 ,college_id          VARCHAR(10)   NOT NULL
 ,user_id             VARCHAR(10)   NOT NULL
 ,last_name           VARCHAR(100)  NOT NULL
 ,first_name          VARCHAR(100)  NOT NULL
 ,middle_name         VARCHAR(100)  NOT NULL
 ,gender              VARCHAR(6)    DEFAULT''
 ,birthday            DATE          DEFAULT'12-OCT-9999'
 ,age                 INTEGER       DEFAULT 0
 ,nationality         VARCHAR(100)  DEFAULT''
 ,civil_status        VARCHAR(100)  DEFAULT''
 ,employment_status   VARCHAR(100)  DEFAULT''
 ,employment_date     DATE          DEFAULT'12-OCT-9999'
 ,title               VARCHAR(50)   NOT NULL
 ,blood_type          VARCHAR(10)   DEFAULT''
 ,email               VARCHAR(200)  DEFAULT''
 ,status              VARCHAR(50)   DEFAULT'Active'
 ,salary              NUMBER(10, 2) DEFAULT 0 NOT NULL
 ,CONSTRAINT faculty_id_pk PRIMARY KEY(faculty_id) 
 ,CONSTRAINT college_id_fk_1 FOREIGN KEY(college_id) REFERENCES college(college_id) 
 ,CONSTRAINT user_id_fk_1 FOREIGN KEY(user_id) REFERENCES portal_user(user_id) 
);


CREATE TABLE FACULTY_ADDRESS(
  FT_address_id VARCHAR(10)  NOT NULL
 ,faculty_id    VARCHAR(10)  NOT NULL
 ,house_no      VARCHAR(300) DEFAULT''
 ,street        VARCHAR(300) DEFAULT''
 ,brgy          VARCHAR(300) DEFAULT''
 ,town          VARCHAR(300) DEFAULT''
 ,city          VARCHAR(300) DEFAULT''
 ,zipcode       INTEGER      DEFAULT 0
 ,CONSTRAINT FT_address_id_pk PRIMARY KEY(FT_address_id) 
 ,CONSTRAINT faculty_id_fk FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id) 
);

CREATE TABLE FACULTY_CONTACT_NO(
  faculty_id    VARCHAR(10) NOT NULL
 ,contact_no    VARCHAR(20) DEFAULT''
 ,tin_no        VARCHAR(20) DEFAULT''
 ,sss_no        VARCHAR(20) DEFAULT''
 ,pag_ibig_no   VARCHAR(20) DEFAULT''
 ,philhealth_no VARCHAR(20) DEFAULT''
 ,gsis_no       VARCHAR(20) DEFAULT''
 ,CONSTRAINT faculty_id_pk_1 PRIMARY KEY(faculty_id)
 ,CONSTRAINT faculty_id_fk_1 FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id) 
);

CREATE TABLE LOGIN_LOG(
  log_id            VARCHAR(10) NOT NULL
 ,user_id           VARCHAR(10) NOT NULL
 ,login_datetime    DATE        DEFAULT SYSDATE
 ,logout_datetime   DATE        DEFAULT SYSDATE
 ,login_status      VARCHAR(10) DEFAULT'Success'
 ,session_id        VARCHAR(100) DEFAULT''
 ,CONSTRAINT log_id_pk PRIMARY KEY(log_id)
 ,CONSTRAINT user_id_fk_2 FOREIGN KEY(user_id) REFERENCES portal_user(user_id) 
);

CREATE TABLE DEPARTMENT(
  department_id   VARCHAR(10)   NOT NULL
 ,department_name VARCHAR(800)  DEFAULT''
 ,department_code VARCHAR(50)   DEFAULT''
 ,status          VARCHAR(20)   DEFAULT''
 ,CONSTRAINT department_id_pk PRIMARY KEY(department_id)
);

CREATE TABLE PORTAL_ADMIN(
  admin_id        VARCHAR(10)   NOT NULL
 ,user_id         VARCHAR(10)   NOT NULL
 ,department_id   VARCHAR(10)   NOT NULL
 ,last_name       VARCHAR(100)  DEFAULT''
 ,first_name      VARCHAR(100)  DEFAULT''
 ,middle_name     VARCHAR(100)  DEFAULT''
 ,gender          VARCHAR(6)    DEFAULT''
 ,birthday        DATE          DEFAULT'12-OCT-9999'
 ,age             INTEGER       DEFAULT 0
 ,nationality     VARCHAR(100)  DEFAULT''
 ,civil_status    VARCHAR(100)  DEFAULT''
 ,admin_position  VARCHAR(300)  DEFAULT''
 ,email           VARCHAR(200)  DEFAULT''
 ,status          VARCHAR(20)   DEFAULT''
 ,CONSTRAINT admin_id_pk PRIMARY KEY(admin_id) 
 ,CONSTRAINT user_id_fk_3 FOREIGN KEY(user_id) REFERENCES portal_user(user_id) 
 ,CONSTRAINT department_id_fk FOREIGN KEY(department_id) REFERENCES department(department_id)
);

CREATE TABLE ADMIN_CONTACT_NO(
  admin_id      VARCHAR(10) NOT NULL
 ,contact_no    VARCHAR(20) DEFAULT''
 ,tin_no        VARCHAR(20) DEFAULT''
 ,sss_no        VARCHAR(20) DEFAULT''
 ,pag_ibig_no   VARCHAR(20) DEFAULT''
 ,philhealth_no VARCHAR(20) DEFAULT''
 ,gsis_no       VARCHAR(20) DEFAULT''
 ,CONSTRAINT admin_id_pk_1 PRIMARY KEY(admin_id)
 ,CONSTRAINT admin_id_fk FOREIGN KEY(admin_id) REFERENCES portal_admin(admin_id) 
);

CREATE TABLE ROOM(
  room_id         VARCHAR(10) NOT NULL
 ,room_capacity   INTEGER     DEFAULT 0
 ,building        VARCHAR(50) DEFAULT''
 ,room_no         INTEGER     DEFAULT 0
 ,CONSTRAINT room_id_pk PRIMARY KEY(room_id) 
);

CREATE TABLE SCHEDULE(
  block_id        VARCHAR(10) NOT NULL
 ,subject_id      VARCHAR(10) NOT NULL
 ,faculty_id      VARCHAR(10) NOT NULL
 ,room_id         VARCHAR(10) NOT NULL
 ,schedule_day    VARCHAR(50) DEFAULT''
 ,schedule_start  VARCHAR(10) NOT NULL
 ,schedule_end    VARCHAR(10) NOT NULL
 ,CONSTRAINT schedule_pk PRIMARY KEY(block_id, subject_id) 
 ,CONSTRAINT block_id_fk_1 FOREIGN KEY(block_id) REFERENCES block(block_id)
 ,CONSTRAINT subject_id_fk_2 FOREIGN KEY(subject_id) REFERENCES subject(subject_id) 
 ,CONSTRAINT faculty_id_fk_2 FOREIGN KEY(faculty_id) REFERENCES faculty(faculty_id)
 ,CONSTRAINT room_id_fk FOREIGN KEY(room_id) REFERENCES room(room_id)
);
