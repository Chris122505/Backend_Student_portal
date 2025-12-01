------------------------------------------------------------
-- PLM STUDENT PORTAL SCHEMA (WITH BUILDING & ROOM)
------------------------------------------------------------

------------------------------------------------------------
-- 1. COLLEGE
------------------------------------------------------------
CREATE TABLE college (
  college_id   VARCHAR(10)    PRIMARY KEY,
  college_name VARCHAR(100)   NOT NULL,
  status       VARCHAR(20)    DEFAULT 'ACTIVE'
);

------------------------------------------------------------
-- 2. COURSE
------------------------------------------------------------
CREATE TABLE course (
  course_id   VARCHAR(10)    PRIMARY KEY,
  college_id  VARCHAR(10)    NOT NULL,
  course_name VARCHAR(100)   NOT NULL,
  status      VARCHAR(20)    DEFAULT 'ACTIVE',
  CONSTRAINT fk_course_college
    FOREIGN KEY (college_id)
    REFERENCES college(college_id)
);

------------------------------------------------------------
-- 3. CURRICULUM
------------------------------------------------------------
CREATE TABLE curriculum (
  curriculum_id VARCHAR(30)   PRIMARY KEY,
  course_id     VARCHAR(10)   NOT NULL,
  date_started  DATE          NOT NULL,
  status        VARCHAR(20)   DEFAULT 'ACTIVE',
  CONSTRAINT fk_curriculum_course
    FOREIGN KEY (course_id)
    REFERENCES course(course_id)
);

------------------------------------------------------------
-- 4. TERM (AY + MIDTERM/FINALS)
------------------------------------------------------------
CREATE TABLE term (
  term_id   VARCHAR(30)  PRIMARY KEY,
  sy_start  NUMBER(4)    NOT NULL,   -- e.g. 2025
  sy_end    NUMBER(4)    NOT NULL,   -- e.g. 2026
  sem       VARCHAR(10)  NOT NULL,   -- 'MIDTERM' or 'FINALS'
  label     VARCHAR(50)  NOT NULL,   -- e.g. '2025-2026 FINALS'
  status    VARCHAR(20)  DEFAULT 'ACTIVE'
);

-- Only allow MIDTERM and FINALS
ALTER TABLE term
  ADD CONSTRAINT chk_term_sem
  CHECK (sem IN ('MIDTERM', 'FINALS'));

------------------------------------------------------------
-- 5. BLOCK (section, e.g. BSCS 2-2)
------------------------------------------------------------
CREATE TABLE block (
  block_id    VARCHAR(30)  PRIMARY KEY,
  block_code  VARCHAR(20)  NOT NULL, -- 'BSCS 2-1'
  course_id   VARCHAR(10)  NOT NULL,
  year_level  NUMBER(1)    NOT NULL,
  status      VARCHAR(20)  DEFAULT 'ACTIVE',
  CONSTRAINT fk_block_course
    FOREIGN KEY (course_id)
    REFERENCES course(course_id)
);

------------------------------------------------------------
-- 6. BUILDING
------------------------------------------------------------
CREATE TABLE building (
  building_id   VARCHAR(20)  PRIMARY KEY,
  building_name VARCHAR(100) NOT NULL,
  status        VARCHAR(20)  DEFAULT 'ACTIVE'
);

------------------------------------------------------------
-- 7. ROOM
------------------------------------------------------------
CREATE TABLE room (
  room_id     VARCHAR(30)  PRIMARY KEY,
  building_id VARCHAR(20)  NOT NULL,
  room_code   VARCHAR(20)  NOT NULL,  -- e.g. '201', 'MSTEAMS'
  room_name   VARCHAR(50),
  room_type   VARCHAR(20),            -- 'LECTURE','LAB','ONLINE',etc.
  capacity    NUMBER(4),
  status      VARCHAR(20)  DEFAULT 'ACTIVE',
  CONSTRAINT fk_room_building
    FOREIGN KEY (building_id)
    REFERENCES building(building_id)
);

------------------------------------------------------------
-- 8. APP_USER (login accounts)
------------------------------------------------------------
CREATE TABLE app_user (
  user_id        VARCHAR(30)   PRIMARY KEY,
  username       VARCHAR(50)   UNIQUE NOT NULL,
  password_hash  VARCHAR(255)  NOT NULL,
  user_type      VARCHAR(20)   NOT NULL,  -- 'STUDENT','FACULTY','ADMIN'
  status         VARCHAR(20)   DEFAULT 'ACTIVE',
  created_at     DATE          DEFAULT SYSDATE
);

------------------------------------------------------------
-- 9. STUDENT
------------------------------------------------------------
CREATE TABLE student (
  student_id  VARCHAR(15)  PRIMARY KEY,  -- e.g. 202410214
  user_id     VARCHAR(30)  UNIQUE,
  course_id   VARCHAR(10)  NOT NULL,
  block_id    VARCHAR(30),
  last_name   VARCHAR(50)  NOT NULL,
  first_name  VARCHAR(50)  NOT NULL,
  middle_name VARCHAR(50),
  gender      VARCHAR(10),
  birthday    DATE,
  nationality VARCHAR(50),
  blood_type  VARCHAR(5),
  address     VARCHAR(255),
  email       VARCHAR(100),
  year_level  NUMBER(1),
  status      VARCHAR(20),
  contact_no  VARCHAR(30),
  CONSTRAINT fk_student_user
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id),
  CONSTRAINT fk_student_course
    FOREIGN KEY (course_id)
    REFERENCES course(course_id),
  CONSTRAINT fk_student_block
    FOREIGN KEY (block_id)
    REFERENCES block(block_id)
);

------------------------------------------------------------
-- 10. FACULTY
------------------------------------------------------------
CREATE TABLE faculty (
  faculty_id   VARCHAR(30)  PRIMARY KEY,
  user_id      VARCHAR(30)  UNIQUE,
  last_name    VARCHAR(50)  NOT NULL,
  first_name   VARCHAR(50)  NOT NULL,
  middle_name  VARCHAR(50),
  gender       VARCHAR(10),
  birthday     DATE,
  nationality  VARCHAR(50),
  address      VARCHAR(255),
  email        VARCHAR(100),
  status       VARCHAR(20),
  contact_no   VARCHAR(30),
  civil_status VARCHAR(20),
  CONSTRAINT fk_faculty_user
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
);

------------------------------------------------------------
-- 11. ADMIN_USER (admin accounts & profile)
------------------------------------------------------------
CREATE TABLE admin_user (
  admin_id     VARCHAR(30)  PRIMARY KEY,
  user_id      VARCHAR(30)  UNIQUE,
  last_name    VARCHAR(50)  NOT NULL,
  first_name   VARCHAR(50)  NOT NULL,
  middle_name  VARCHAR(50),
  gender       VARCHAR(10),
  birthday     DATE,
  nationality  VARCHAR(50),
  address      VARCHAR(255),
  email        VARCHAR(100),
  status       VARCHAR(20),
  contact_no   VARCHAR(30),
  civil_status VARCHAR(20),
  CONSTRAINT fk_admin_user
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
);

------------------------------------------------------------
-- 12. LOGIN_LOG
------------------------------------------------------------
CREATE TABLE login_log (
  log_id         VARCHAR(30)  PRIMARY KEY,
  user_id        VARCHAR(30)  NOT NULL,
  login_datetime DATE         DEFAULT SYSDATE,
  ip_address     VARCHAR(50),
  user_device    VARCHAR(100),
  CONSTRAINT fk_loginlog_user
    FOREIGN KEY (user_id)
    REFERENCES app_user(user_id)
);

------------------------------------------------------------
-- 13. SUBJECT
------------------------------------------------------------
CREATE TABLE subject (
  subject_id   VARCHAR(30)  PRIMARY KEY,
  subject_code VARCHAR(20)  UNIQUE NOT NULL, -- 'CSC 0212'
  subject_name VARCHAR(100) NOT NULL,
  units        NUMBER(2,1)  NOT NULL,
  course_year  NUMBER(1),
  sem          VARCHAR(10), -- curricular sem (1/2/etc) if you want
  lec_lab      VARCHAR(10)  -- 'LECTURE','LAB','BOTH'
);

------------------------------------------------------------
-- 14. CURRICULUM_SUBJECT (subjects in a curriculum)
------------------------------------------------------------
CREATE TABLE curriculum_subject (
  curriculum_subject_id VARCHAR(30)  PRIMARY KEY,
  curriculum_id         VARCHAR(30)  NOT NULL,
  subject_id            VARCHAR(30)  NOT NULL,
  year_level            NUMBER(1),
  semester              VARCHAR(10),
  type                  VARCHAR(10),  -- 'MAJOR'/'MINOR'
  CONSTRAINT fk_currsub_curr
    FOREIGN KEY (curriculum_id)
    REFERENCES curriculum(curriculum_id),
  CONSTRAINT fk_currsub_sub
    FOREIGN KEY (subject_id)
    REFERENCES subject(subject_id)
);

------------------------------------------------------------
-- 15. SUBJECT_PREREQUISITE (self-join)
------------------------------------------------------------
CREATE TABLE subject_prerequisite (
  subject_id        VARCHAR(30) NOT NULL,
  prereq_subject_id VARCHAR(30) NOT NULL,
  CONSTRAINT pk_subject_prereq
    PRIMARY KEY (subject_id, prereq_subject_id),
  CONSTRAINT fk_prereq_subject
    FOREIGN KEY (subject_id)
    REFERENCES subject(subject_id),
  CONSTRAINT fk_prereq_subject_req
    FOREIGN KEY (prereq_subject_id)
    REFERENCES subject(subject_id)
);

------------------------------------------------------------
-- 16. SCHEDULE (class offering for a block in a term)
--     NOW USING room_id (FK ? room)
------------------------------------------------------------
CREATE TABLE schedule (
  schedule_id VARCHAR(30)  PRIMARY KEY,
  subject_id  VARCHAR(30)  NOT NULL,
  block_id    VARCHAR(30)  NOT NULL,
  faculty_id  VARCHAR(30),
  term_id     VARCHAR(30)  NOT NULL,
  day_of_week VARCHAR(5)   NOT NULL,  -- 'M','T','W','TH','F','S'
  time_start  VARCHAR(10)  NOT NULL,  -- '18:00'
  time_end    VARCHAR(10)  NOT NULL,  -- '20:00'
  room_id     VARCHAR(30),
  CONSTRAINT fk_sched_subject
    FOREIGN KEY (subject_id)
    REFERENCES subject(subject_id),
  CONSTRAINT fk_sched_block
    FOREIGN KEY (block_id)
    REFERENCES block(block_id),
  CONSTRAINT fk_sched_faculty
    FOREIGN KEY (faculty_id)
    REFERENCES faculty(faculty_id),
  CONSTRAINT fk_sched_term
    FOREIGN KEY (term_id)
    REFERENCES term(term_id),
  CONSTRAINT fk_sched_room
    FOREIGN KEY (room_id)
    REFERENCES room(room_id)
);

------------------------------------------------------------
-- 17. ENROLLMENT (one record per student per term)
------------------------------------------------------------
CREATE TABLE enrollment (
  enrollment_id       VARCHAR(30)  PRIMARY KEY,
  student_id          VARCHAR(15)  NOT NULL,
  term_id             VARCHAR(30)  NOT NULL,
  date_enrolled       DATE         DEFAULT SYSDATE,
  status              VARCHAR(20),     -- 'REGULAR','IRREGULAR',etc.
  control_no          VARCHAR(20),
  registration_status VARCHAR(20),
  copy_type           VARCHAR(20),
  total_units         NUMBER(3),
  remarks             VARCHAR(255),
  reference_no        VARCHAR(50),
  encoder_id          VARCHAR(30),
  encode_date         DATE,
  CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id)
    REFERENCES student(student_id),
  CONSTRAINT fk_enrollment_term
    FOREIGN KEY (term_id)
    REFERENCES term(term_id),
  CONSTRAINT fk_enrollment_encoder
    FOREIGN KEY (encoder_id)
    REFERENCES admin_user(admin_id)
);

------------------------------------------------------------
-- 18. ENROLLMENT_SUBJECT (lines of the COR)
------------------------------------------------------------
CREATE TABLE enrollment_subject (
  enrollment_subject_id VARCHAR(30)  PRIMARY KEY,
  enrollment_id         VARCHAR(30)  NOT NULL,
  schedule_id           VARCHAR(30)  NOT NULL,
  curriculum_subject_id VARCHAR(30),
  CONSTRAINT fk_enrsub_enrollment
    FOREIGN KEY (enrollment_id)
    REFERENCES enrollment(enrollment_id),
  CONSTRAINT fk_enrsub_schedule
    FOREIGN KEY (schedule_id)
    REFERENCES schedule(schedule_id),
  CONSTRAINT fk_enrsub_currsub
    FOREIGN KEY (curriculum_subject_id)
    REFERENCES curriculum_subject(curriculum_subject_id)
);

------------------------------------------------------------
-- 19. GRADE
------------------------------------------------------------
CREATE TABLE grade (
  grade_id              VARCHAR(30)  PRIMARY KEY,
  enrollment_subject_id VARCHAR(30)  NOT NULL,
  final_grade           NUMBER(5,2),
  remark                VARCHAR(20), -- 'PASSED','FAILED','INC',etc.
  grade_date            DATE,
  CONSTRAINT fk_grade_enrsub
    FOREIGN KEY (enrollment_subject_id)
    REFERENCES enrollment_subject(enrollment_subject_id)
);

------------------------------------------------------------
-- CONSTRAINTS (DATA QUALITY, REALISTIC PORTAL BEHAVIOR)
------------------------------------------------------------

---------------- APP_USER ----------------
ALTER TABLE app_user
  ADD CONSTRAINT chk_app_user_type
  CHECK (user_type IN ('STUDENT','FACULTY','ADMIN'));

ALTER TABLE app_user
  ADD CONSTRAINT chk_app_user_status
  CHECK (status IN ('ACTIVE','INACTIVE','LOCKED'));

ALTER TABLE app_user
  ADD CONSTRAINT chk_app_user_password_complexity
  CHECK (
    REGEXP_LIKE(
      password_hash,
      '^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z]).{8,}$'
    )
  );

---------------- COLLEGE ----------------
ALTER TABLE college
  ADD CONSTRAINT uq_college_name
  UNIQUE (college_name);

---------------- COURSE ----------------
ALTER TABLE course
  ADD CONSTRAINT uq_course_name_per_college
  UNIQUE (college_id, course_name);

---------------- CURRICULUM ----------------
ALTER TABLE curriculum
  ADD CONSTRAINT uq_curriculum_course_start
  UNIQUE (course_id, date_started);

---------------- TERM ----------------
ALTER TABLE term
  ADD CONSTRAINT chk_term_sy_range
  CHECK (sy_end = sy_start + 1);

ALTER TABLE term
  ADD CONSTRAINT uq_term_sy_sem
  UNIQUE (sy_start, sy_end, sem);

---------------- BLOCK ----------------
ALTER TABLE block
  ADD CONSTRAINT uq_block_code
  UNIQUE (block_code);

ALTER TABLE block
  ADD CONSTRAINT chk_block_year_level
  CHECK (year_level BETWEEN 1 AND 5);

ALTER TABLE block
  ADD CONSTRAINT uq_block_course_level_code
  UNIQUE (course_id, year_level, block_code);

---------------- BUILDING / ROOM ----------------
ALTER TABLE building
  ADD CONSTRAINT uq_building_name
  UNIQUE (building_name);

ALTER TABLE room
  ADD CONSTRAINT uq_room_building_code
  UNIQUE (building_id, room_code);

ALTER TABLE room
  ADD CONSTRAINT chk_room_capacity
  CHECK (capacity IS NULL OR capacity > 0);

---------------- STUDENT ----------------
ALTER TABLE student
  ADD CONSTRAINT chk_student_gender
  CHECK (gender IN ('MALE','FEMALE','PREFER NOT TO SAY')
         OR gender IS NULL);

ALTER TABLE student
  ADD CONSTRAINT chk_student_year_level
  CHECK (year_level BETWEEN 1 AND 5 OR year_level IS NULL);

ALTER TABLE student
  ADD CONSTRAINT chk_student_email
  CHECK (email IS NULL OR REGEXP_LIKE(email, '^[^@]+@[^@]+\.[^@]+$'));

ALTER TABLE student
  ADD CONSTRAINT uq_student_email
  UNIQUE (email);

---------------- FACULTY ----------------
ALTER TABLE faculty
  ADD CONSTRAINT chk_faculty_gender
  CHECK (gender IN ('MALE','FEMALE','PREFER NOT TO SAY')
         OR gender IS NULL);

ALTER TABLE faculty
  ADD CONSTRAINT chk_faculty_status
  CHECK (status IN ('ACTIVE','INACTIVE') OR status IS NULL);

ALTER TABLE faculty
  ADD CONSTRAINT uq_faculty_email
  UNIQUE (email);

---------------- ADMIN_USER ----------------
ALTER TABLE admin_user
  ADD CONSTRAINT chk_admin_status
  CHECK (status IN ('ACTIVE','INACTIVE') OR status IS NULL);

ALTER TABLE admin_user
  ADD CONSTRAINT uq_admin_email
  UNIQUE (email);

---------------- LOGIN_LOG ----------------
ALTER TABLE login_log
  ADD CONSTRAINT chk_loginlog_ip_length
  CHECK (LENGTH(ip_address) <= 50 OR ip_address IS NULL);

---------------- SUBJECT ----------------
ALTER TABLE subject
  ADD CONSTRAINT chk_subject_units
  CHECK (units > 0);

ALTER TABLE subject
  ADD CONSTRAINT chk_subject_lec_lab
  CHECK (lec_lab IN ('LECTURE','LAB','BOTH') OR lec_lab IS NULL);

ALTER TABLE subject
  ADD CONSTRAINT uq_subject_name
  UNIQUE (subject_name);

---------------- CURRICULUM_SUBJECT ----------------
ALTER TABLE curriculum_subject
  ADD CONSTRAINT chk_currsub_year_level
  CHECK (year_level BETWEEN 1 AND 5 OR year_level IS NULL);

ALTER TABLE curriculum_subject
  ADD CONSTRAINT chk_currsub_semester
  CHECK (semester IN ('1ST','2ND','SUMMER') OR semester IS NULL);

ALTER TABLE curriculum_subject
  ADD CONSTRAINT chk_currsub_type
  CHECK (type IN ('MAJOR','MINOR') OR type IS NULL);

ALTER TABLE curriculum_subject
  ADD CONSTRAINT uq_currsub_subject
  UNIQUE (curriculum_id, subject_id);

---------------- SUBJECT_PREREQUISITE ----------------
ALTER TABLE subject_prerequisite
  ADD CONSTRAINT chk_subjprereq_no_self
  CHECK (subject_id <> prereq_subject_id);

---------------- SCHEDULE ----------------
ALTER TABLE schedule
  ADD CONSTRAINT chk_sched_day_of_week
  CHECK (day_of_week IN ('M','T','W','TH','F','S'));

ALTER TABLE schedule
  ADD CONSTRAINT chk_sched_time_format
  CHECK (REGEXP_LIKE(time_start, '^[0-2][0-9]:[0-5][0-9]$')
     AND REGEXP_LIKE(time_end,   '^[0-2][0-9]:[0-5][0-9]$'));

ALTER TABLE schedule
  ADD CONSTRAINT chk_sched_time_order
  CHECK (time_start < time_end);

ALTER TABLE schedule
  ADD CONSTRAINT uq_sched_block_subject_term
  UNIQUE (subject_id, block_id, term_id);

ALTER TABLE schedule
  ADD CONSTRAINT uq_sched_block_day_time
  UNIQUE (block_id, term_id, day_of_week, time_start);

---------------- ENROLLMENT ----------------
ALTER TABLE enrollment
  ADD CONSTRAINT chk_enrollment_status
  CHECK (status IN ('REGULAR','IRREGULAR','CANCELLED') OR status IS NULL);

ALTER TABLE enrollment
  ADD CONSTRAINT chk_enrollment_reg_status
  CHECK (registration_status IN ('REGULAR','LATE','ADVISED') OR registration_status IS NULL);

ALTER TABLE enrollment
  ADD CONSTRAINT chk_enrollment_total_units
  CHECK (total_units >= 0 OR total_units IS NULL);

ALTER TABLE enrollment
  ADD CONSTRAINT uq_enrollment_student_term
  UNIQUE (student_id, term_id);

---------------- ENROLLMENT_SUBJECT ----------------
ALTER TABLE enrollment_subject
  ADD CONSTRAINT uq_enrsub_enrollment_schedule
  UNIQUE (enrollment_id, schedule_id);

---------------- GRADE ----------------
ALTER TABLE grade
  ADD CONSTRAINT chk_grade_final
  CHECK (final_grade BETWEEN 1.00 AND 5.00 OR final_grade IS NULL);

ALTER TABLE grade
  ADD CONSTRAINT chk_grade_remark
  CHECK (
    remark IN ('PASSED','FAILED','INC','DROPPED','NG')
    OR remark IS NULL
  );

ALTER TABLE grade
  ADD CONSTRAINT uq_grade_enrsub
  UNIQUE (enrollment_subject_id);

ALTER TABLE grade
  ADD CONSTRAINT chk_grade_final_allowed
  CHECK (
    final_grade IS NULL OR
    final_grade IN (1.00, 1.25, 1.50, 1.75,
                    2.00, 2.25, 2.50, 2.75,
                    3.00, 4.00, 5.00)
  );

------------------------------------------------------------
-- SAMPLE DATA (MATCHES ALL CONSTRAINTS)
------------------------------------------------------------

-- 1. COLLEGE
INSERT INTO college (college_id, college_name, status) VALUES
  ('CISTM', 'College of Information Science and Technology Management', 'ACTIVE');

INSERT INTO college (college_id, college_name, status) VALUES
  ('CNURS', 'College of Nursing', 'ACTIVE');

-- 2. COURSE
INSERT INTO course (course_id, college_id, course_name, status) VALUES
  ('BSCS', 'CISTM', 'Bachelor of Science in Computer Science', 'ACTIVE');

INSERT INTO course (course_id, college_id, course_name, status) VALUES
  ('BSIT', 'CISTM', 'Bachelor of Science in Information Technology', 'ACTIVE');

-- 3. CURRICULUM
INSERT INTO curriculum (curriculum_id, course_id, date_started, status) VALUES
  ('CURR_BSCS_2025', 'BSCS', DATE '2025-08-01', 'ACTIVE');

INSERT INTO curriculum (curriculum_id, course_id, date_started, status) VALUES
  ('CURR_BSIT_2025', 'BSIT', DATE '2025-08-01', 'ACTIVE');

-- 4. TERM
INSERT INTO term (term_id, sy_start, sy_end, sem, label, status) VALUES
  ('TERM_2025_MID', 2025, 2026, 'MIDTERM', '2025-2026 MIDTERM', 'ACTIVE');

INSERT INTO term (term_id, sy_start, sy_end, sem, label, status) VALUES
  ('TERM_2025_FIN', 2025, 2026, 'FINALS', '2025-2026 FINALS', 'ACTIVE');

-- 5. BLOCK
INSERT INTO block (block_id, block_code, course_id, year_level, status) VALUES
  ('BLK_BSCS2A', 'BSCS 2-1', 'BSCS', 2, 'ACTIVE');

INSERT INTO block (block_id, block_code, course_id, year_level, status) VALUES
  ('BLK_BSCS2B', 'BSCS 2-2', 'BSCS', 2, 'ACTIVE');

-- 6. BUILDING
INSERT INTO building (building_id, building_name, status) VALUES
  ('ONLINE', 'Online / Virtual', 'ACTIVE');

INSERT INTO building (building_id, building_name, status) VALUES
  ('MAB', 'Main Academic Building', 'ACTIVE');

-- 7. ROOM
INSERT INTO room (
  room_id, building_id, room_code, room_name, room_type, capacity, status
) VALUES (
  'ROOM_ONLINE_MSTEAMS', 'ONLINE', 'MSTEAMS',
  'MS Teams Virtual Room', 'ONLINE', NULL, 'ACTIVE'
);

INSERT INTO room (
  room_id, building_id, room_code, room_name, room_type, capacity, status
) VALUES (
  'ROOM_MAB201', 'MAB', '201',
  'MAB 201', 'LECTURE', 40, 'ACTIVE'
);

-- 8. APP_USER
INSERT INTO app_user (user_id, username, password_hash, user_type, status, created_at) VALUES
  ('USR_STUD1', '202410214', 'Passw0rd1',  'STUDENT', 'ACTIVE', SYSDATE);

INSERT INTO app_user (user_id, username, password_hash, user_type, status, created_at) VALUES
  ('USR_STUD2', '202410215', 'Passw0rd2',  'STUDENT', 'ACTIVE', SYSDATE);

INSERT INTO app_user (user_id, username, password_hash, user_type, status, created_at) VALUES
  ('USR_FAC1',  'fac_juan',  'Faculty1A',  'FACULTY', 'ACTIVE', SYSDATE);

INSERT INTO app_user (user_id, username, password_hash, user_type, status, created_at) VALUES
  ('USR_ADM1',  'admin_plm', 'Admin001A',  'ADMIN',   'ACTIVE', SYSDATE);

-- 9. STUDENT
INSERT INTO student (
  student_id, user_id, course_id, block_id,
  last_name, first_name, middle_name,
  gender, birthday, nationality, blood_type,
  address, email, year_level, status, contact_no
) VALUES (
  '202410214', 'USR_STUD1', 'BSCS', 'BLK_BSCS2A',
  'DE LA CRUZ', 'JUAN', 'A.',
  'MALE', DATE '2006-03-15', 'Filipino', 'O+',
  'Manila City', 'juan.delacruz2024@plm.edu.ph',
  2, 'ENROLLED', '09171234567'
);

INSERT INTO student (
  student_id, user_id, course_id, block_id,
  last_name, first_name, middle_name,
  gender, birthday, nationality, blood_type,
  address, email, year_level, status, contact_no
) VALUES (
  '202410215', 'USR_STUD2', 'BSCS', 'BLK_BSCS2B',
  'SANTOS', 'MARIA', 'L.',
  'FEMALE', DATE '2006-07-21', 'Filipino', 'A+',
  'Caloocan City', 'maria.santos2024@plm.edu.ph',
  2, 'ENROLLED', '09181234567'
);

-- 10. FACULTY
INSERT INTO faculty (
  faculty_id, user_id,
  last_name, first_name, middle_name,
  gender, birthday, nationality,
  address, email, status, contact_no, civil_status
) VALUES (
  'FAC001', 'USR_FAC1',
  'GARCIA', 'PEDRO', 'M.',
  'MALE', DATE '1985-05-10', 'Filipino',
  'Quezon City', 'pedro.garcia@plm.edu.ph',
  'ACTIVE', '09181231231', 'MARRIED'
);

-- 11. ADMIN_USER
INSERT INTO admin_user (
  admin_id, user_id,
  last_name, first_name, middle_name,
  gender, birthday, nationality,
  address, email, status, contact_no, civil_status
) VALUES (
  'ADM001', 'USR_ADM1',
  'REYES', 'ANA', 'S.',
  'FEMALE', DATE '1980-02-01', 'Filipino',
  'Manila City', 'ana.reyes@plm.edu.ph',
  'ACTIVE', '09191231231', 'SINGLE'
);

-- 12. LOGIN_LOG
INSERT INTO login_log (
  log_id, user_id, login_datetime, ip_address, user_device
) VALUES (
  'LOG_1', 'USR_STUD1', SYSDATE, '127.0.0.1', 'Chrome on Windows'
);

INSERT INTO login_log (
  log_id, user_id, login_datetime, ip_address, user_device
) VALUES (
  'LOG_2', 'USR_FAC1', SYSDATE, '127.0.0.1', 'Chrome on Windows'
);

-- 13. SUBJECT
INSERT INTO subject (
  subject_id, subject_code, subject_name,
  units, course_year, sem, lec_lab
) VALUES (
  'SUBJ_DISMATH', 'MTH 0101', 'Discrete Mathematics',
  3, 1, '1ST', 'LECTURE'
);

INSERT INTO subject (
  subject_id, subject_code, subject_name,
  units, course_year, sem, lec_lab
) VALUES (
  'SUBJ_OOP', 'CSC 0212', 'Object-Oriented Programming',
  3, 2, '2ND', 'LECTURE'
);

INSERT INTO subject (
  subject_id, subject_code, subject_name,
  units, course_year, sem, lec_lab
) VALUES (
  'SUBJ_DSA', 'CSC 0213', 'Data Structures and Algorithms',
  3, 2, '2ND', 'LECTURE'
);

-- 14. CURRICULUM_SUBJECT
INSERT INTO curriculum_subject (
  curriculum_subject_id, curriculum_id, subject_id,
  year_level, semester, type
) VALUES (
  'CURRSUB_DISMATH', 'CURR_BSCS_2025', 'SUBJ_DISMATH',
  1, '1ST', 'MAJOR'
);

INSERT INTO curriculum_subject (
  curriculum_subject_id, curriculum_id, subject_id,
  year_level, semester, type
) VALUES (
  'CURRSUB_OOP', 'CURR_BSCS_2025', 'SUBJ_OOP',
  2, '2ND', 'MAJOR'
);

INSERT INTO curriculum_subject (
  curriculum_subject_id, curriculum_id, subject_id,
  year_level, semester, type
) VALUES (
  'CURRSUB_DSA', 'CURR_BSCS_2025', 'SUBJ_DSA',
  2, '2ND', 'MAJOR'
);

-- 15. SUBJECT_PREREQUISITE
INSERT INTO subject_prerequisite (subject_id, prereq_subject_id) VALUES
  ('SUBJ_DSA', 'SUBJ_DISMATH');

INSERT INTO subject_prerequisite (subject_id, prereq_subject_id) VALUES
  ('SUBJ_OOP', 'SUBJ_DSA');

-- 16. SCHEDULE (using room_id)
-- BSCS 2-1 OOP, MIDTERM
INSERT INTO schedule (
  schedule_id, subject_id, block_id, faculty_id, term_id,
  day_of_week, time_start, time_end, room_id
) VALUES (
  'SCH_OOP_BSCS2A_MID',
  'SUBJ_OOP', 'BLK_BSCS2A', 'FAC001', 'TERM_2025_MID',
  'M', '09:00', '11:00', 'ROOM_ONLINE_MSTEAMS'
);

-- BSCS 2-1 DSA, MIDTERM
INSERT INTO schedule (
  schedule_id, subject_id, block_id, faculty_id, term_id,
  day_of_week, time_start, time_end, room_id
) VALUES (
  'SCH_DSA_BSCS2A_MID',
  'SUBJ_DSA', 'BLK_BSCS2A', 'FAC001', 'TERM_2025_MID',
  'W', '09:00', '11:00', 'ROOM_ONLINE_MSTEAMS'
);

-- BSCS 2-2 OOP, MIDTERM
INSERT INTO schedule (
  schedule_id, subject_id, block_id, faculty_id, term_id,
  day_of_week, time_start, time_end, room_id
) VALUES (
  'SCH_OOP_BSCS2B_MID',
  'SUBJ_OOP', 'BLK_BSCS2B', 'FAC001', 'TERM_2025_MID',
  'T', '13:00', '15:00', 'ROOM_ONLINE_MSTEAMS'
);

-- 17. ENROLLMENT
INSERT INTO enrollment (
  enrollment_id, student_id, term_id,
  date_enrolled, status,
  control_no, registration_status, copy_type,
  total_units, remarks, reference_no,
  encoder_id, encode_date
) VALUES (
  'ENR_2025MID_202410214', '202410214', 'TERM_2025_MID',
  SYSDATE, 'REGULAR',
  'CTL001', 'REGULAR', 'STUDENT''S COPY',
  6, 'NO REMARKS', 'RA 10931 (CHED UNIFAST)',
  'ADM001', SYSDATE
);

INSERT INTO enrollment (
  enrollment_id, student_id, term_id,
  date_enrolled, status,
  control_no, registration_status, copy_type,
  total_units, remarks, reference_no,
  encoder_id, encode_date
) VALUES (
  'ENR_2025MID_202410215', '202410215', 'TERM_2025_MID',
  SYSDATE, 'REGULAR',
  'CTL002', 'REGULAR', 'STUDENT''S COPY',
  6, 'NO REMARKS', 'RA 10931 (CHED UNIFAST)',
  'ADM001', SYSDATE
);

-- 18. ENROLLMENT_SUBJECT
INSERT INTO enrollment_subject (
  enrollment_subject_id, enrollment_id,
  schedule_id, curriculum_subject_id
) VALUES (
  'ENRSUB_1',
  'ENR_2025MID_202410214',
  'SCH_OOP_BSCS2A_MID',
  'CURRSUB_OOP'
);

INSERT INTO enrollment_subject (
  enrollment_subject_id, enrollment_id,
  schedule_id, curriculum_subject_id
) VALUES (
  'ENRSUB_2',
  'ENR_2025MID_202410214',
  'SCH_DSA_BSCS2A_MID',
  'CURRSUB_DSA'
);

INSERT INTO enrollment_subject (
  enrollment_subject_id, enrollment_id,
  schedule_id, curriculum_subject_id
) VALUES (
  'ENRSUB_3',
  'ENR_2025MID_202410215',
  'SCH_OOP_BSCS2B_MID',
  'CURRSUB_OOP'
);

-- 19. GRADE
INSERT INTO grade (
  grade_id, enrollment_subject_id,
  final_grade, remark, grade_date
) VALUES (
  'GRD_1', 'ENRSUB_1',
  1.50, 'PASSED', SYSDATE
);

INSERT INTO grade (
  grade_id, enrollment_subject_id,
  final_grade, remark, grade_date
) VALUES (
  'GRD_2', 'ENRSUB_2',
  2.25, 'PASSED', SYSDATE
);

INSERT INTO grade (
  grade_id, enrollment_subject_id,
  final_grade, remark, grade_date
) VALUES (
  'GRD_3', 'ENRSUB_3',
  1.75, 'PASSED', SYSDATE
);


------------------------------------------------------------
-- VIEW: VW_TABLE_ROW_COUNTS
-- Quick overview if each table has data
------------------------------------------------------------
------------------------------------------------------------
-- VIEW: VW_STUDENT_DASHBOARD (ALL INNER JOINS)
------------------------------------------------------------
CREATE OR REPLACE VIEW vw_student_dashboard AS
SELECT
  s.student_id,
  s.last_name
    || ', '
    || s.first_name
    || CASE
         WHEN s.middle_name IS NOT NULL
         THEN ' ' || s.middle_name
         ELSE ''
       END                         AS student_name,
  s.email,
  s.year_level,
  s.status                        AS student_status,
  c.course_id,
  c.course_name,
  col.college_id,
  col.college_name,
  b.block_id,
  b.block_code,
  e.enrollment_id,
  t.term_id,
  t.label                         AS term_label,
  t.sem                           AS term_sem,
  e.total_units,
  e.status                        AS enrollment_status
FROM student   s
INNER JOIN course   c  ON s.course_id = c.course_id
INNER JOIN college  col ON c.college_id = col.college_id
INNER JOIN block    b  ON s.block_id = b.block_id
INNER JOIN enrollment e ON e.student_id = s.student_id
INNER JOIN term     t  ON t.term_id = e.term_id;

SELECT * FROM vw_student_dashboard
ORDER BY student_id, term_id;

COMMIT;
