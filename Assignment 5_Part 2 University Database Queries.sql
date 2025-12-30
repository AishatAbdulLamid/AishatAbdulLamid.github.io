/*SELECT * FROM course;
SELECT * FROM prereq;
SELECT * FROM instructor;
SELECT salary FROM instructor;*/

						/*Query 1*/
/*Write a query that returns a list of course_ids from the course 
table for courses that do not have any prerequisites listed in the 
prereq table. This should be sorted from smallest to largest. Your
solution must use a SET operator.*/

SELECT course.course_id FROM course
EXCEPT
SELECT prereq.course_id FROM prereq
ORDER BY course_id ASC;

						/*Query 2*/
/*Write a query to return an alphabetical list of dept_names from the department 
table showing all departments that are assigned to at least one instructor in the 
instructor table. You must use a SET operator in your solution.*/

SELECT dept_name FROM department
INTERSECT
SELECT instructor.dept_name FROM instructor
ORDER BY dept_name ASC;

						/*Query 3*/
/*Write a query that returns an alphabetical list of dept_names for every department 
that satisfies at least one of the following conditions: 
●	The department has a budget less than $50,000
●	The department has at least one instructor whose salary is greater than $100,000
●	The department has at least one student whose total credits are equal to 
the highest total credits taken by any student. 
Remember, be sure you do not hardcode the number of total credits. Your solution 
must include at least one SET operator and at least one subquery. Do not use 
JOINs.*/ 

SELECT dept_name FROM department 
WHERE department.budget < 50000
UNION
SELECT instructor.dept_name FROM instructor 
WHERE instructor.salary > 100000
UNION
SELECT student.dept_name FROM student
WHERE student.tot_cred = (SELECT MAX(tot_cred) 
FROM student)
ORDER BY dept_name ASC;

						/*Query 4*/
/*Write a query that returns the course_id and title of courses and their 
prerequisites. Your output should name the returned columns: course_id, 
course_name, prereq_id, prereq_name (in that order). Only include courses that 
have prerequisites in the results. Organize your results by course_id, ascending. 
Your solution must use a JOIN.
Hint: You may need to JOIN the same table multiple times here to accomplish what 
you need. This is known as a self JOIN.*/

SELECT course.course_id, course.title AS course_name, 
prereq.prereq_id, c.title AS prereq_name
FROM course 
JOIN prereq ON course.course_id = prereq.course_id
JOIN course AS c ON prereq.prereq_id = c.course_id
ORDER BY course_id ASC;

						/*Query 5*/
/*Write a query to find the id of each student who has never taken a course at the 
university. Your solution must use an OUTER JOIN- do not use any subqueries or 
set operations.
Hint: Do not use the tot_cred field in the student table as it may not accurately 
indicate if a student has taken courses. Adding a test student to the database who 
has not attended any classes can help validate your query. Also consider that 
columns like course_id or tot_cred could be empty for other reasons.*/

SELECT student.id, student.name FROM student
FULL OUTER JOIN takes ON student.id = takes.id
FULL OUTER JOIN department ON student.dept_name = department.dept_name
FULL OUTER JOIN course ON department.dept_name = course.dept_name
WHERE takes.course_id IS NULL;

						/*Query 6*/
SELECT title, dept_name FROM course
WHERE course_id IN (SELECT course_id FROM takes WHERE year = 2008); 

						/*Query 7*/
SELECT course.title, course.dept_name, taken.sec_id, taken.semester
FROM course
JOIN(SELECT DISTINCT course_id, sec_id, semester FROM takes
WHERE year = 2009) AS taken USING (course_id)
ORDER BY taken.course_id;

						/*Query 8*/
SELECT name, dept_name, (SELECT COUNT(*) AS num_stud FROM advisor
WHERE advisor.i_id = instructor.ID) FROM instructor
ORDER BY dept_name, name;

						/*Query 9*/
SELECT course_id FROM section WHERE year = 2006 AND semester = 'Fall'
INTERSECT 
SELECT course_id FROM section WHERE year = 2008 AND semester = 'Spring';