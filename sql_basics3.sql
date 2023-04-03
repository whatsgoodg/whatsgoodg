/* exists: tuple에 대해 조건이 공집합이면 false이므로 출력하지 않는다. */
select course_id
from section as S
where semester='Fall' and year=2009 and exists 
	(select *
     from section as T
	 where semester='Spring' and year=2010 and S.course_id =  T.course_id);


/* Not exists: tuple에 대해 조건이 공집합이면 true로 출력 */
select S.id, S.name
from student as S
where not exists ((select course_id
				  from course
				  where dept_name='Biology')
				  except
				  (select T.course_id
				 from takes as T
				 where T.id = S.id));
				 
SELECT s.name
FROM student s
WHERE NOT EXISTS (
    SELECT *
    FROM course c
    WHERE c.dept_name = 'Biology'
    AND c.course_id NOT IN (
        SELECT t.course_id
        FROM takes t
        WHERE t.id = s.id
    )
);

SELECT s.name
FROM student s
WHERE 'Biology' = ALL (
    SELECT c.dept_name
    FROM course c
    WHERE c.course_id IN (
        SELECT t.course_id
        FROM takes t
        WHERE t.id = s.id
    )
);

SELECT s.name
FROM student s, course c
WHERE c.dept_name = 'Biology'
AND c.course_id IN (
    SELECT t.course_id
    FROM takes t
    WHERE t.id = s.id
)
GROUP BY s.name
HAVING COUNT(DISTINCT c.course_id) = (
    SELECT COUNT(*)
    FROM course c2
    WHERE c2.dept_name = 'Biology'
);

/* from clause에 subquery써서 42000 달러보다 높은 평균 연봉 가진 dept */
select dept_name, avg_salary
from (select dept_name, avg(salary)
	  from instructor
	  group by dept_name) as dept_avg(dept_name, avg_salary)
where avg_salary > 42000;


/* lateral은 from 시점에서의 table을 참조할 수 있다.*/
select name, salary, avg_salary
from instructor l1,  lateral (select avg(salary)
							from instructor l2
							where l2.dept_name=l1.dept_name) as sc_avg(avg_salary);

select name, salary, avg_salary
from instructor l1, (select dept_name, avg(salary)
								from instructor l2
								group by dept_name) l2(dept_name, avg_salary)
where l1.dept_name = l2.dept_name;

/* with clause max budget을 가진 dept */
with max_budget(value) as
(select max(budget) from department)
select department.budget, dept_name
from department, max_budget
where department.budget=max_budget.value;

							
	
