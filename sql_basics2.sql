/* 모든 학과 교수들의 평균 연봉*/
select dept_name, avg(salary)
from instructor
group by dept_name;

/* 모든 학과 교수들의 평균 연봉이 42000$ 이상 */
select dept_name, avg(salary)
from instructor
group by dept_name
having avg(salary) > 42000;

/* 모든 학과 교수의 연봉의 총합 */
/* count(*)를 제외하고 모든 aggregate 함수는 null값이 있는 tuple을 배제 
   만약 table이 전부 비어있다면 count는 0을 반환, 나머지 함수는 null을 반환 */
select sum(salary)
from instructor;

/* tuple이 총 몇갠지 반환 */
select count(*)
from instructor;

/* subquery로 봄 2010년도와 가을 2009년도에 열린 강의들 */
select distinct course_id
from section
where semester='Spring' and year='2010' and course_id in
(select course_id from section where semester='Fall' and year='2009');	

/* set 으로 구현 */
(select course_id from section where semester='Spring' and year=2010)
intersect
(select course_id from section where semester='Fall' and year =2009);

/* 2009년 가을에만 */
select distinct course_id
from section
where semester = 'Fall' and year= 2009 and
course_id not in (select course_id
from section
where semester = 'Spring' and year= 2010);

/* ID 10101인 교수의 수업을 한 번이라도 들은 학생 수 =some은 in과 같음 */
select count(distinct id)
from takes
where course_id in (select course_id from teaches where id='10101');

/* join으로 해결 */
select count(distinct takes.id)
from takes join teaches using(course_id)
where teaches.id='10101';
 
/* 최소한 한명의 컴공 교수보다 연봉 높은 모든 학과의 교수 */
select name 
from instructor
where salary > some (select salary from instructor where dept_name='Comp. Sci.');

/* 모든 생물학 교수보다 연봉이 높은 교수 */
select name
from instructor
where salary > all (select salary from instructor where dept_name='Biology');
