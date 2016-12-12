, nr_of_unread AS (select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id)
-------------------------------------------------------
, math AS (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id)
-----------------------------------------------------
, research AS (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id)
-----------------------------------------------------------
, seminary AS (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id)
-------------------------------------------------------
, recbranch (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id)

  SELECT stud_id, tot_credits.sum 'YES' AS Graduate
FROM studentsfollowing s LEFT JOIN tot_credits
ON s.stud_ID = tot_credits.stud_id
WHERE credits > 5;



--********************************NEW SHIT********************

CREATE VIEW pathtograduation AS
SELECT *
FROM
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id ) r1

  LEFT OUTER JOIN
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id) r2

  LEFT OUTER JOIN
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id) r3

  LEFT OUTER JOIN
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id) r4

  LEFT OUTER JOIN
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id) r5
  
LEFT OUTER JOIN
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id) r6

WHERE r1 > 5 AND
  r2 < 1 AND
  r3 > 19 AND
  r4 > 9 AND
  r5 > 0 AND
  r6 > 9;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  IGEB N
  
  
  
  CREATE VIEW pathtograduation AS
SELECT *
FROM
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id ) as tot_credits

  --LEFT OUTER JOIN
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id) as courses_left
  
  on tot_credits.stud_id = courses_left.stud_id

  --LEFT OUTER JOIN
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id) as credits_mathematical
  
  on courses_left.stud_id = credits_mathematical.stud_id

  LEFT OUTER JOIN
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id) as credits_research
  
  on credits_mathematical.stud_id = credits_research.stud_id

  LEFT OUTER JOIN
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id) as credits_seminar
  
  on credits_research.stud_id = credits_seminar.stud_id
  
LEFT OUTER JOIN
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id) as credits_recommended
  
  on credits_seminar.stud_id = credits_recommended.stud_id

WHERE r1.sum > 5 AND
  r2.count < 1 AND
  r3.sum > 19 AND
  r4.sum > 9 AND
  r5.count > 0 AND
  r6.sum < 9;















-------------------------------------------------
CREATE VIEW pathtograduation AS
SELECT student,
    COALESCE(r1, 0) AS r1,
    COALESCE(r2, 0) AS r2,
    COALESCE(r3, 0) AS r3,    
    COALESCE(r4, 0) AS r4,
    COALESCE(r5, 0) AS r5,
    COALESCE(r6, 0) AS r6,

CASE
WHEN(
r2 IS NULL
AND r3 >=20
AND r4 >=10
AND r5 >= 1
AND r1 >=10
AND r6 >=10
)
THEN TRUE
ELSE FALSE
END AS can_graduate

FROM
(SELECT stud_id, prog_name, branch_name FROM studentsfollowing) AS student

NATURAL LEFT JOIN
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id ) AS r1

  NATURAL LEFT JOIN
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id) AS r2

  NATURAL LEFT JOIN
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id) AS r3

  NATURAL LEFT JOIN
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id) As r4

NATURAL LEFT JOIN
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id) AS r5
  
NATURAL LEFT JOIN
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id) AS r6;
