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
