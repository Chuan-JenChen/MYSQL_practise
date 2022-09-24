create database test ;
use test ;


create table Student(
	StudentId varchar(10),
    StudentName varchar(50),
	StudentAge	datetime,
    StudentSex	varchar(10)
);


insert into Student values('01' , '趙雷' , '1990-01-01' , '男');
insert into Student values('02' , '錢電' , '1990-12-21' , '男');
insert into Student values('03' , '孫風' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '李美' , '1992-03-01' , '女');
insert into Student values('07' , '鄭竹' , '1989-07-01' , '女');
insert into Student values('08' , '張三' , '1990-01-20' , '女');


select * from Student;
drop table Student;

create table Course(
	CourseId varchar(10),
    CourseName varchar(50),
	TeacherId varchar(10)
);
insert into Course values
('01' , '國文' , '02'),
('02' , '數學' , '01'),
('03' , '英文' , '03');

select * from Course;
drop table Course;

create table Teacher(
	TeacherId varchar(10),
    TeacherName varchar(50)
);
insert into Teacher values('01' , '張七');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

select * from Teacher;
drop table Teacher;

create table SC(
	SId varchar(10),
    CId varchar(50),
	SCScore  varchar(10)
);
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);
insert into SC values('08' , '02' , 58);

select * from SC;
drop table SC;

-- 查询" 01 “课程比” 02 "课程成绩高的学生的信息及课程分数 
-- select t1.SId,t1.SCScore as class1,t2.SCScore as class2
select*
from
(select SId,CId,SCScore from SC where CId ='01')t1,
(select SId,CId,SCScore from SC where CId ='02')t2
where t1.SId=t2.Sid and t1.SCScore>t2.SCScore;

-- 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
select * ,avg(SCScore) as avgs
from SC
join Student on SC.SId=Student.StudentId
group by SC.SId
having avg(SCScore) >= 60;
-- 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
Select SC.SId,StudentName,count(CId),avg(SCScore)
from SC
left join Student
On SC.SId=Student.StudentId
group by SC.SId ;


-- 4.1 查有成绩的学生信息
select *
from SC 
join Student
on SC.SId=Student.StudentId ;

-- 5.查询「李」姓老师的数量
select * ,count(TeacherName)
from Course
join SC on SC.CId=Course.CourseId
join Teacher on Teacher.TeacherId=Course.TeacherId
where TeacherName = "李四";

-- 6.查询学过「張七」老师授课的同学的信息
select * 
from Course
join SC on SC.CId=Course.CourseId
join Teacher on Teacher.TeacherId=Course.TeacherId
join Student on SC.SId=Student.StudentId
where TeacherName = "張七";

-- 7.查询没有学全所有课程的同学的信息
select Student.*
from Student
where StudentId not in(select SId from SC group by SId having count(CId) 
= (select count(CourseId ) from Course)) ;

-- 有1沒有2
select *
from SC
where SC.CId ='01' and SC.SId 
not in
(select SC.SId
from SC where SC.CId ='02') ;


show warnings;

-- 8.查询至少有一門课与学号为" 01 "的同学所学相同的同学的信息
-- DISTINCT 不重複
select DISTINCT Student.* 
from SC
join Student
on SC.SId = Student.StudentId 
where SC.CId in (select CId from SC where SId ='01' );

-- 9.查询和" 01 "号的同学学习的课程 完全相同的其他同学的信息
#所有資料
select *
from SC
join Student
on SC.SId = Student.StudentId;
#學生01選課的課程種類
select CId from SC where SId='01';
#學生01課程種類的數量
select count(CId ) from SC where SId='01';
#結合
select *
from SC
join Student
on SC.SId = Student.StudentId
where SC.CId in (select CId from SC where SId='01') -- and SC.SId != '01'
group by SC.SId
having count(SC.CId)= (select count(CId ) from SC where SId='01' );

-- 10.查询没学过"张三"老师讲授的任一门课程的学生姓名





