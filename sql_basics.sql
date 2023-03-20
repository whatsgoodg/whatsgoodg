select name
from instructor; --모든 name을 instructor에서 뽑음

select distinct dept_name --중복 제거한 과 이름
from instructor;

select all dept_name --중복 제거 x
from instructor;

select id, name, salary/12 as monthly_salary --salary를 12로 나눌 수 있음
from instructor;

select name --컴공과에서 80000 달러 이상의 연봉
from instructor
where dept_name='Comp. Sci.' and salary > 80000;

select *
from instructor, teaches; --instructor X teaches 모든 경우의 수

-- JOINS
select name, course_id --카테시안한 후, id가 같은 놈들 중 name, course, id 열만 선택
from instructor, teaches
where instructor.id = teaches.id;

select section.course_id, semester, year, title --컴공엣 제공하는 수업의 id, 학기, 년도, 이름
from section, course
where section.course_id = course.course_id and dept_name='Comp. Sci.';

--Natrual Join
select name, course_id --카테시안 후 같은 attribute와 이의 값이 모두 같은 row들을 추출
from instructor natural join teaches;

--instructor의 이름과 그들이 가르치는 모든 수업의 title을 추출
-- wrong
select name, title
from instructor natural join teaches natural join course; --dept하고 마지막에 겹쳐 문제 발생

--correct
select name, title
from instructor natural join teaches, course
where teaches.course_id = course.course_id; --dept를 조인에서 제외하여 강사가 가르치는데, 강사와 과가 다를 경우도 포함시킴

--another version
select name, title
from (instructor natural join teaches) join course using(course_id); --course_id만 사용하여 조인하겠다. dept 제외

--Rename Operation
-- T와 S를 카테시안 한 이후, 컴공의 salary가 가장 작은 isntructor보다 높은 salary의 inst 이름 전부다 출력
select distinct T.name
from instructor as T, instructor as S
where T.salary > S.salary and S.dept_name ='Comp. Sci.';

--String Operation
select name
from instructor
where name like '%ste%'; --ste이 문자열에 포함되어 있으면 ok

select (name || ' in ') || dept_name as concat
from instructor;

--Ordering
select distinct name
from instructor
order by name desc; --desc 지우면 오름차순 

--between
select name
from instructor
where salary between 90000 and 100000;

--Tuple comparison 
select name, course_id
from instructor, teaches
where (instructor.id, dept_name) =(teaches.id, 'Biology');

--Set operation(default가 중복제거)

--2009년 가을과 2010년 봄에 열린 강의 모두 (m + n, 집합에 있는 놈들 전부)
(select course_id from section where semester ='Fall' and year = 2009)
union
(select course_id from section where semester = 'Spring' and year =2010);


--2009년 가을과 2010년 봄 두 계절 모두 열린 강의(min(m, n) 물론 m과 n은 같은 원소의 개수)
(select course_id from section where semester ='Fall' and year = 2009)
intersect 
(select course_id from section where semester = 'Spring' and year =2010);

--2009년 가을에 열렸지만, 2010년 봄에 열리지 않은 강의(max(0, m-n) m에서 같은 놈 n을 빼야함 m,n은 둘 다 열린 강의들)
(select course_id from section where semester ='Fall' and year = 2009)
except
(select course_id from section where semester = 'Spring' and year =2010);

-- Null values는 존재하지 않는 값 또는 unknown 값 
-- 5 + null = null
-- null과의 비교는 무조건 unknown 반환
-- unknown은 or ture 시 true, and false시 false 나머진 싹다 unknown
-- where에 known이 있으면 false로 간주

select name
from instructor
where salary is null; -- salary가 null이다.

-- statistics
select avg(salary) --salary의 평균값 하나 추출
from instructor
where dept_name ='Comp. Sci.';

select count(distinct id) --2010 봄에 가르친 모든 교수 수
from teaches
where semester = 'Spring' and year ='2010';

select count(*) --모든 row의 수 
from course; 
