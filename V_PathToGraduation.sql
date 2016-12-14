CREATE VIEW pathtograduation AS
SELECT *
FROM
(select passedcourses.stud_id, sum(credits)
  from PassedCourses GROUP BY stud_id ) r1

  LEFT OUTER JOIN
(select stud_id, count(course_code) from UnreadMandatory
GROUP BY stud_id) r2
  
  on r1.stud_id = r2.stud_id

  LEFT OUTER JOIN
  (select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'mathematical course'
GROUP BY stud_id) r3
  
  on r2.stud_id = r3.stud_id

  LEFT OUTER JOIN
(select stud_id, sum(credits)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'research course'
GROUP BY stud_id) r4
  
  on r3.stud_id = r4.stud_id

  LEFT OUTER JOIN
  (select stud_id, count(passedcourses.course_code)
from passedcourses
join has_classification
on passedcourses.course_code = has_classification.course_code
WHERE has_classification.class_name = 'seminar course'
GROUP BY stud_id) r5
  
  on r4.stud_id = r5.stud_id
  
LEFT OUTER JOIN
  (select pc.stud_id, sum(credits)
from stud_chooses_branch sb, passedcourses pc, recommended_course_branch rb
where sb.stud_id = pc.stud_id
and sb.branch_name = rb.branch_name
and sb.prog_name = rb.prog_name
and rb.course_code = pc.course_code
group by pc.stud_id) r6
  
  on r5.stud_id = r6.stud_id

WHERE r1.sum > 5 AND
  r2.count < 1 AND
  r3.sum > 19 AND
  r4.sum > 9 AND
  r5.count > 0 AND
  r6.sum < 9;
