

#1. Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a #1 if the employee is still with the company and 0 if not.

SELECT e.emp_no, d.dept_no, e.hire_date, IF(d.to_date < now(), d.to_date, 'NULL') AS end_date, d.to_date > now() AS is_current_employee 
FROM dept_emp as d 
JOIN employees as e on d.emp_no = e.emp_no;


#2 Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the #first letter of their last name.

SELECT first_name, last_name,

	CASE
		WHEN last_name BETWEEN 'A%' AND 'I%' THEN 'A-H'
		WHEN last_name BETWEEN 'I%' AND 'R%' THEN 'I-Q' 
		ELSE 'R-Z'
		END as alpha_group
FROM employees
ORDER BY last_name;

SELECT first_name, last_name,

	CASE
		WHEN (last_name LIKE 'a%'or last_name LIKE 'b%'or  last_name LIKE 'c%'or  last_name LIKE 'd%'or  last_name LIKE 'e%'or  last_name LIKE 'f%'or  last_name LIKE 'g%'or  last_name LIKE 'h%') THEN 'A-H'
		WHEN (last_name LIKE 'i%'or last_name LIKE 'j%'or  last_name LIKE 'k%'or  last_name LIKE 'l%'or  last_name LIKE 'm%'or  last_name LIKE 'n%'or  last_name LIKE 'o%'or  last_name LIKE 'p%'or  last_name LIKE 'q%')THEN 'I-Q' 
		WHEN (last_name LIKE 'r%'or last_name LIKE 's%'or  last_name LIKE 't%'or  last_name LIKE 'u%'or  last_name LIKE 'v%'or  last_name LIKE 'w%'or  last_name LIKE 'x%'or  last_name LIKE 'y%'or  last_name LIKE 'z%') THEN 'R-Z' 
		END as alpha_group
FROM employees
ORDER BY last_name;



#3. How many employees (current or previous) were born in each decade?

SELECT 
	COUNT(CASE WHEN birth_date LIKE '190%' THEN birth_date END) AS '1900s',
	COUNT(CASE WHEN birth_date LIKE '191%' THEN birth_date END) AS '1910s',
	COUNT(CASE WHEN birth_date LIKE '192%' THEN birth_date END) AS '1920s',
	COUNT(CASE WHEN birth_date LIKE '193%' THEN birth_date END) AS '1930s',
	COUNT(CASE WHEN birth_date LIKE '194%' THEN birth_date END) AS '1940s',
	COUNT(CASE WHEN birth_date LIKE '195%' THEN birth_date END) AS '1950s',
	COUNT(CASE WHEN birth_date LIKE '196%' THEN birth_date END) AS '1960s',
	COUNT(CASE WHEN birth_date LIKE '197%' THEN birth_date END) AS '1970s',
	COUNT(CASE WHEN birth_date LIKE '198%' THEN birth_date END) AS '1980s',
	COUNT(CASE WHEN birth_date LIKE '199%' THEN birth_date END) AS '1990s',
	COUNT(CASE WHEN birth_date LIKE '200%' THEN birth_date END) AS '2000s',
	COUNT(CASE WHEN birth_date LIKE '201%' THEN birth_date END) AS '2010s',
	COUNT(CASE WHEN birth_date LIKE '202%' THEN birth_date END) AS '2020s'
from employees;
	
	
#BONUS

#What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?()

SELECT 
	CASE 
		WHEN dept_name IN ('Research','Development') THEN 'R&D'
		WHEN dept_name IN ('Sales','Marketing') THEN 'Sales & Marketing'
		WHEN dept_name IN ('Production','Quality Management') THEN 'Prod & QM'
		WHEN dept_name IN ('Finance','Human Resources') THEN 'Finance & HR'
		WHEN dept_name IN ('Customer Service') THEN 'Customer Service'
 		ELSE dept_name
        END AS dept_group
        , AVG(salaries.salary) as average_salary
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN salaries on dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date > now()
	AND salaries.to_date > now()
GROUP BY dept_group 
ORDER BY dept_group ASC;








