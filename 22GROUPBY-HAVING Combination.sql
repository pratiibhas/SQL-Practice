use practice;
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

select * from exams;

-- With GROUPBY AND HAVING
select student_id
from exams
where subject in ('Chemistry','Physics')
group by student_id
having count(subject)=2 and count(distinct marks)=1;


-- WITH SELF JOINS
select distinct(s1.student_id)
from exams s1
inner join exams s2
on s1.student_id=s2.student_id
where s1.marks =s2.marks  and s1.subject!=s2.subject