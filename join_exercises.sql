use employees;

describe titles;

describe salaries;

DESCRIBE employees;

DESCRIBE dept_manager;

DESCRIBE dept_emp;

SELECT *
FROM employees
JOIN salaries
ON salaries.emp_no = employees.emp_no;

SELECT *
FROM employees
JOIN titles 
ON titles.emp_no = employees.emp_no
JOIN salaries
on salaries.emp_no = employees.emp_no
WHERE salaries.to_date > now()		
	AND titles.to_date > now();
	
SELECT * 
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
JOIN salaries on salaries.emp_no = employees.emp_no
JOIN titles on titles.emp_no = employees.emp_no;	


#----JOINS EXERCISES----

#Join Example Database

#1. Use the join_example_db. Select all the records from both the users and roles tables.
use join_example.db;
describe roles;
describe users;
SELECT * from users;
SELECT * from roles;


#2. Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.
SELECT *
FROM users
JOIN roles ON  users.role_id = roles.id;

SELECT *
FROM users
LEFT JOIN roles ON  users.role_id = roles.id;

SELECT *
FROM users
RIGHT JOIN roles ON  users.role_id = roles.id;

SELECT *
FROM roles
LEFT JOIN users ON roles.id = users.role_id;

SELECT *
FROM roles
RIGHT JOIN users ON roles.id = users.role_id;

#3. Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the
# role. Hint: You will also need to use group by in the query.

SELECT roles.id, users.role_id, COUNT(*)
FROM roles
LEFT JOIN users ON roles.id = users.role_id
GROUP BY roles.id;

# ---- EMPLOYEES DB Exercises ------

#2. Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.

SELECT departments.dept_name, employees.first_name, employees.last_name
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
JOIN dept_manager on dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date > now()
ORDER BY departments.dept_name ASC;

#3. Find the name of all departments currently managed by women.

SELECT departments.dept_name, employees.first_name, employees.last_name
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
JOIN dept_manager on dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date > now()
    AND employees.gender = 'F'
ORDER BY departments.dept_name ASC;

#4. Find the current titles of employees currently working in the Customer Service department.

SELECT titles.title, COUNT(*) as count
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
JOIN titles on titles.emp_no = employees.emp_no
WHERE departments.dept_name = 'Customer Service'
	AND titles.to_date > now()
GROUP BY titles.title
ORDER BY titles.title ASC;

#5. Find the current salary of all current managers.

SELECT departments.dept_name, employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
JOIN dept_manager on dept_manager.emp_no = employees.emp_no
JOIN salaries on salaries.emp_no = employees.emp_no
WHERE dept_manager.to_date > now()
	AND salaries.to_date > now()
ORDER BY departments.dept_name ASC;

#6. Find the number of current employees in each department.

SELECT departments.dept_no, departments.dept_name, COUNT(*) as num_employees
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments on dept_emp.dept_no = departments.dept_no
WHERE dept_emp.to_date > now()
GROUP BY dept_no
ORDER BY dept_no ASC;

#7. Which department has the highest average salary? Hint: Use current not historic information.

SELECT 
	departments.dept_name AS department_name,
	AVG(salaries.salary) AS average_salary	
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON salaries.emp_no = employees.emp_no
WHERE salaries.to_date > now()
	AND  dept_emp.to_date > now()
GROUP BY departments.dept_name
ORDER BY average_salary DESC
LIMIT 1;

#8. Who is the highest paid employee in the Marketing department?
SELECT employees.first_name, employees.last_name, departments.dept_name, salaries.salary
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON salaries.emp_no = employees.emp_no
WHERE  departments.dept_name = 'Marketing'
	AND salaries.to_date > now()
	AND dept_emp.to_date > now()	
ORDER BY salaries.salary DESC
LIMIT 1;

#9. Which current department manager has the highest salary?
SELECT departments.dept_name as "Department Name", employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN salaries ON salaries.emp_no = employees.emp_no
WHERE dept_manager.to_date > now()
	AND salaries.to_date > now()
	AND dept_emp.to_date > now()
ORDER BY salaries.salary DESC
LIMIT 1;


#10. Bonus Find the names of all current employees, their department name, and their current manager's name.

SELECT CONCAT(employees.first_name, ' ', employees.last_name) as "Employee Name", departments.dept_name as "Department Name", 
#and their current manager's name
CONCAT(e1.first_name, ' ', e1.last_name) as "Manager Name"
FROM employees 
LEFT JOIN dept_emp on dept_emp.emp_no = employees.emp_no
LEFT JOIN departments on dept_emp.dept_no = departments.dept_no
LEFT JOIN dept_manager on dept_manager.emp_no = employees.emp_no
LEFT JOIN employees as e1 on e1.emp_no = dept_manager.emp_no
WHERE dept_emp.to_date > now();

#HINT FROM CHARLES ATCHISON--- Create a new table
SELECT
		dept_manager.dept_no,
		CONCAT(first_name, ' ', last_name) AS manager_name
	FROM 
		employees 
	JOIN 
		dept_manager
		ON
			dept_manager.emp_no = employees.emp_no
			AND
				dept_manager.to_date >= NOW();
				

#11. Who is the highest paid employee within each department.  ti.first_name, ti.last_name

SELECT  department_name, highest_dept_salary
FROM (SELECT departments.dept_name as department_name, max(salaries.salary) as highest_dept_salary
		FROM employees
	JOIN dept_emp on dept_emp.emp_no = employees.emp_no
	JOIN departments on dept_emp.dept_no = departments.dept_no
	JOIN salaries on salaries.emp_no = employees.emp_no
	WHERE  salaries.to_date > now()
		AND dept_emp.to_date > now()
	GROUP BY departments.dept_name) t1;



#--- Charles' Atchinson's Solution --

SELECT 
	t1.dept_name AS 'Department Name',
	t1.salary AS 'Salary',
	CONCAT(first_name,' ', last_name) AS 'Employee Name'
FROM 
	(
	-- Part 1 which builds the base table to employee names, salaries and dept names
	SELECT
		salary, dept_name, first_name, last_name
	FROM
		salaries
	JOIN
		dept_emp 
	USING(emp_no)
	JOIN 
		departments 
	USING(dept_no)
	JOIN 
		employees
	USING(emp_no)
	WHERE 
		dept_emp.to_date >= NOW()
	AND 
		salaries.to_date >= NOW()
	) AS t1 # This is table_1 result created
INNER JOIN
	(
	-- Part 2 builds another table to cross reference the previous part with the calculated max salaries
	SELECT dept_name, MAX(salary) as max_salary
	FROM 
		(
		SELECT
			salary, dept_name, first_name, last_name
		FROM
			salaries
		JOIN
			dept_emp 
		USING(emp_no)
		JOIN 
			departments 
		USING(dept_no)
		JOIN 
			employees
		USING(emp_no)
		WHERE 
			dept_emp.to_date >= NOW()
			AND 
			salaries.to_date >= NOW()
		) as t2
	GROUP BY dept_name
	) AS t2 # This is table_2 result created
	-- Joins both tables based on the dept_name and matches the salary & department name with the max_salary
	ON 
	t1.dept_name = t2.dept_name
	AND
	t1.salary = t2.max_salary
ORDER BY 'Department Name' DESC;


#----Ryan's quick solution-----

(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd001'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd002'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd003'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd004'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd005'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd006'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd006'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd007'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd008'
order by salary DESC
limit 1)
union
(select dept_no, salary, emp_no, first_name, last_name
from salaries
join dept_emp using(emp_no)
join employees using(emp_no)
where dept_no = 'd009'
order by salary DESC
limit 1);

