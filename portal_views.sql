CREATE OR REPLACE VIEW vw_student_grade AS
SELECT 
  s.student_id
  , s.last_name
    || ', '
    || s.first_name
    || CASE
         WHEN s.middle_name IS NOT NULL
         THEN ' ' || s.middle_name
         ELSE ''
       END                         AS student_name
  , t.sy_start||'-'||t.sy_end      AS school_year
  , su.sem
  , c.course_name
  , su.subject_code
  , su.subject_name ||' '|| su.lec_lab  AS subject_name
  , su.units
  , g.final_grade
  , g.remark
  
      ,(
        SELECT 
            ROUND(
                SUM(g2.final_grade * su2.units) /
                SUM(su2.units)
            , 5)
        FROM grade g2
        JOIN enrollment_subject es2 
            ON g2.enrollment_subject_id = es2.enrollment_subject_id
        JOIN schedule sc2
            ON es2.schedule_id = sc2.schedule_id
        JOIN subject su2
            ON sc2.subject_id = su2.subject_id
        WHERE es2.enrollment_id = e.enrollment_id
    ) AS gwa
  
FROM student s
INNER JOIN course c
  ON s.course_id = c.course_id
INNER JOIN enrollment e
  ON s.student_id = e.student_id
INNER JOIN enrollment_subject es
  ON e.enrollment_id = es.enrollment_id
INNER JOIN schedule sc
  ON es.schedule_id = sc.schedule_id
INNER JOIN subject su
  ON sc.subject_id = su.subject_id
INNER JOIN grade g
    ON es.enrollment_subject_id = g.enrollment_subject_id
INNER JOIN term t
    ON e.term_id = t.term_id
ORDER BY s.student_id;

-- INSERT COLLEGE_ID TO FACULTY
ALTER TABLE faculty
  ADD college_id VARCHAR(10) DEFAULT '';
ALTER TABLE faculty
  ADD CONSTRAINT college_id_fk FOREIGN KEY(college_id) REFERENCES college(college_id);

-- VIEW FOR FACULTY INFORMATION
CREATE OR REPLACE VIEW vw_faculty_information AS
SELECT
  f.faculty_id
  , f.last_name
    || ', '
    || f.first_name
    || CASE
         WHEN f.middle_name IS NOT NULL
         THEN ' ' || f.middle_name
         ELSE ''
       END                         AS faculty_name
  , c.college_name
  , f.email
  , f.status
FROM faculty f
  INNER JOIN college c
    ON f.college_id = c.college_id;
    
-- VIEW FOR FACULTY PROFILE
CREATE OR REPLACE VIEW vw_faculty_profile AS
SELECT
  f.faculty_id
  , f.last_name
    || ', '
    || f.first_name
    || CASE
         WHEN f.middle_name IS NOT NULL
         THEN ' ' || f.middle_name
         ELSE ''
       END                         AS faculty_name
  , f.gender
  , f.address
  , TRUNC(MONTHS_BETWEEN(SYSDATE, f.birthday) / 12) AS age
  , f.birthday
  , f.nationality
  , f.civil_status
  , f.contact_no
FROM faculty f;

-- VIEW FOR FACULTY SCHEDULE
CREATE OR REPLACE VIEW vw_faculty_schedule AS
SELECT
  f.faculty_id
  , f.last_name
    || ', '
    || f.first_name
    || CASE
         WHEN f.middle_name IS NOT NULL
         THEN ' ' || f.middle_name
         ELSE ''
       END                         AS faculty_name
  , t.sy_start||'-'||t.sy_end      AS school_year
  , su.sem
  , c.course_id
  , su.subject_name
  , su.units
  , b.block_code
  , sc.day_of_week||' - '||sc.time_start||'- '||sc.time_end||' '||r.room_name  AS schedule
FROM faculty f
INNER JOIN schedule sc
  ON f.faculty_id = sc.faculty_id
INNER JOIN subject su
  ON sc.subject_id = su.subject_id
INNER JOIN block b
  ON sc.block_id = b.block_id
INNER JOIN course c
  ON b.course_id = c.course_id
INNER JOIN room r
  ON sc.room_id = r.room_id
INNER JOIN term t
  ON sc.term_id = t.term_id;

-- VIEW FOR FACULTY CLASS
CREATE OR REPLACE VIEW vw_faculty_class AS
SELECT
  f.faculty_id
  , f.last_name
    || ', '
    || f.first_name
    || CASE
         WHEN f.middle_name IS NOT NULL
         THEN ' ' || f.middle_name
         ELSE ''
       END                         AS faculty_name
  , su.subject_name
  , sc.day_of_week||' - '||sc.time_start||'- '||sc.time_end||' '||r.room_name  AS schedule
  , t.sy_start||'-'||t.sy_end      AS school_year
  , su.sem
  , su.units
  , s.student_id
  , s.last_name
    || ', '
    || s.first_name
    || CASE
         WHEN s.middle_name IS NOT NULL
         THEN ' ' || s.middle_name
         ELSE ''
       END                         AS student_name
  , s.status
  , s.email
FROM faculty f
INNER JOIN schedule sc
  ON f.faculty_id = sc.faculty_id
INNER JOIN subject su
  ON sc.subject_id = su.subject_id      
INNER JOIN room r
  ON sc.room_id = r.room_id              
INNER JOIN enrollment_subject es
  ON sc.schedule_id = es.schedule_id 
INNER JOIN enrollment e
  ON es.enrollment_id = e.enrollment_id
INNER JOIN student s
  ON e.student_id = s.student_id
INNER JOIN term t
  ON sc.term_id = t.term_id;
  
-- VIEW FOR GRADE SUBMISSION  
CREATE OR REPLACE VIEW vw_faculty_grade AS
SELECT
  f.faculty_id
  , f.last_name
    || ', '
    || f.first_name
    || CASE
         WHEN f.middle_name IS NOT NULL
         THEN ' ' || f.middle_name
         ELSE ''
       END                         AS faculty_name
  , su.subject_name
  , b.block_code
  , t.sy_start||'-'||t.sy_end      AS school_year
  , su.sem
  , s.student_id
  , s.last_name
    || ', '
    || s.first_name
    || CASE
         WHEN s.middle_name IS NOT NULL
         THEN ' ' || s.middle_name
         ELSE ''
       END                         AS student_name
  , su.units
  , g.final_grade                  AS grade
  , g.remark
FROM faculty f
INNER JOIN schedule sc
  ON f.faculty_id = sc.faculty_id
INNER JOIN block b
  ON sc.block_id = b.block_id
INNER JOIN subject su
  ON sc.subject_id = su.subject_id
INNER JOIN room r
  ON sc.room_id = r.room_id
INNER JOIN enrollment_subject es
  ON sc.schedule_id = es.schedule_id
INNER JOIN enrollment e
  ON es.enrollment_id = e.enrollment_id
INNER JOIN student s
  ON e.student_id = s.student_id
INNER JOIN grade g
  ON es.enrollment_subject_id = g.enrollment_subject_id
INNER JOIN term t
  ON sc.term_id = t.term_id
ORDER BY 
  f.faculty_id
  , su.subject_name
  , b.block_code
  , s.last_name;
