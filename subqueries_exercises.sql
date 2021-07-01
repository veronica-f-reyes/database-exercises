#---- SUBQUERIES LESSON EXAMPLES-----

select *
from employees
where emp_no in (
	select emp_no
	from salaries
	where salary > (
		select avg(salary) 
		from salaries
)
);


#Get names of all current managers
select first_name, last_name
from employees
where emp_no in (
	select emp_no
	from dept_manager
	where to_date > now()
);

#Show me all the names for folks whose title are engineers
select *
from employees
where emp_no in (
	select emp_no
	from titles
	where title = "Engineer"
	and emp_no in (
		select emp_no
		from employees 
		where hire_date like '%12-25'
		) #engineers hired on Christmas
);

# Aliasing a subquery to treat it as a table 
# Have to have this alias for this "query as table" to work
select current_salary.salary
from (
	select *
	from salaries
	where to_date > now()
) as current_salary;

select *
from (
	select *
	from salaries
	where to_date > now()
) as current_salary
join employees using(emp_no);

select (select max(salary) from salaries) as max, min(salary) as min
from salaries 
where to_date > now();



#----SUBQUERIES EXERCISES -----

#1. Find all the current employees with the same hire date as employee 101010 using a sub-query. --55


select *
from employees
where hire_date IN (
	select hire_date
	from employees
	where emp_no = '101010'	
	)
	and emp_no in (
		select emp_no
		from dept_emp
		where to_date > now()
);


#2. Find all the titles ever held by all current employees with the first name Aamod. -251

SELECT DISTINCT(title)
FROM titles
WHERE emp_no IN (
	SELECT emp_no 
	FROM employees 
	WHERE first_name = "Aamod"
	)
	AND emp_no IN (
		SELECT emp_no
		FROM dept_emp
		WHERE to_date > now()
);
	

#3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.  -59900
	 
SELECT COUNT(*) 
FROM employees
WHERE emp_no NOT IN(
	SELECT emp_no
	FROM dept_emp
	WHERE to_date > now()
);		 

#4. Find all the current department managers that are female. List their names in a comment in your code.
# Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil

SELECT * 
FROM employees
WHERE emp_no IN (
	SELECT emp_no.        
	FROM dept_manager 
	WHERE to_date > now()
)
	AND gender = 'F';

#5. Find all the employees who currently have a higher salary than the companies overall, historical average salary.  -154,543

select *
from employees
where emp_no in (
	select emp_no
	from salaries
	where salary > (
		select avg(salary) 
		from salaries)
	and to_date > now()	
	)
and emp_no in ( 
	select emp_no
	from dept_emp
	where to_date > now());
    


#6. How many current salaries are within 1 standard deviation of the current highest salary? -83
#(Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this? (concat a % sign)

SELECT COUNT(*) 
FROM salaries
WHERE to_date > NOW()
	AND salary >= (
		SELECT 
			MAX(salary) - STDDEV(salary)
		FROM salaries
		WHERE to_date > NOW()
);

SELECT (SELECT COUNT(*)   
	FROM salaries
	WHERE to_date > NOW()
		AND salary >= (
			SELECT   
				MAX(salary) - STDDEV(salary) 
			FROM salaries
			WHERE to_date > NOW())	
	)
	/
	(SELECT COUNT(*)   --- Total number of current salaries
	FROM salaries
	WHERE to_date > NOW())
	* 100;



#BONUS------------->

# Find all the department names that currently have female managers. --Development, Finance, Human Resources, Research

SELECT dept_name 
FROM departments
WHERE dept_no IN (
	SELECT dept_no
	FROM dept_emp
	WHERE emp_no IN (
		SELECT emp_no
		FROM employees
		WHERE emp_no IN (
			SELECT emp_no
			FROM dept_manager 
			WHERE to_date > now()
		)
			AND gender = 'F'
));

# Find the first and last name of the employee with the highest salary.  --Tokuysha Pesch 

SELECT employees.first_name, employees.last_name
FROM employees
WHERE emp_no IN (
	SELECT emp_no
	FROM salaries
	WHERE salary = (
		SELECT max(salary) 
		FROM salaries
)
);
    

# Find the department name that the employee with the highest salary works in.  --Sales

SELECT dept_name 
FROM departments
WHERE dept_no IN (
	SELECT dept_no
	FROM dept_emp
	WHERE emp_no IN (
		SELECT emp_no
		FROM salaries
		WHERE salary = (
			SELECT max(salary) 
			FROM salaries)));
	
	
