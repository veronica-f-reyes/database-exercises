use germain_1473

create temporary table georgies AS 
select *
from employees.employees
join employees.salaries using(emp_no)
where first_name = 'Georgi';


select * from georgis;

-- Another approach to reading from 1 db, writing to your db w/permissions
use employees;

create temporary table germain_1473.partos AS 
select *
from employees
join salaries using (emp_no)
where first_name like "Parto";

select * from germain_1473.partos;

-- or 

use germain_1473;

select * from partos;

update partos set salary = salary * 1.10;

select * from partos;

alter table partos add email VARCHAR(200);

update partos set email = concat(first_name, ".", last_name, "@company.com");

alter table partos add phone VARCHAR(200);


-- Z score sample

select avg(n) from numbers;

-- unless you manually type out the mean, you'll need a scalar subquery
select n, n - (select avg(n) from numbers) as "numerator", 
	(select std(n) from numbers) as "denominator"
from numbers;

create temporary table germain_1473.zscore AS 
select n, n - (select avg(n) from numbers) as "numerator", 
	(select std(n) from numbers) as "denominator", numerator/denominator
from numbers;

use germain_1473;

select numerator / denominator from zscore;

alter table zscore add zscore float(10, 3);

select * from zscore;

update zscore set zscore = numerator / denominator;

select * from zscore;


-- zscore = (x-avg(x)) / std(x)


--  Temporary Tables Exercises BEGIN HERE ---------------------------------------------------------------------------------

#1. Using the example from the lesson, create a temporary table called employees_with_departments that contains first_name, last_name, and dept_name for employees currently with that department.

use employees;

drop table germain_1473.employees_with_departments;

CREATE TEMPORARY TABLE germain_1473.employees_with_departments AS
SELECT first_name, last_name, dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE dept_emp.to_date > now();

select * from germain_1473.employees_with_departments;


# a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns

ALTER TABLE germain_1473.employees_with_departments ADD full_name VARCHAR(31);

# b. Update the table so that full name column contains the correct data

update germain_1473.employees_with_departments set full_name = CONCAT(first_name, ' ', last_name);

# c. Remove the first_name and last_name columns from the table.

alter table germain_1473.employees_with_departments drop column first_name;

alter table germain_1473.employees_with_departments drop column last_name;

# d.What is another way you could have ended up with this same table?

CREATE TEMPORARY TABLE germain_1473.employees_with_departments AS
SELECT CONCAT(first_name," ", last_name), dept_name
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
WHERE dept_emp.to_date > now();


#2. Create a temporary table based on the payment table from the sakila database.
#Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.

use sakila;
describe payment;

CREATE TEMPORARY TABLE germain_1473.payments AS
SELECT *
FROM payment;

select * from germain_1473.payments;

describe germain_1473.payments;

ALTER TABLE germain_1473.payments MODIFY COLUMN amount float;
UPDATE germain_1473.payments SET amount = amount * 100;
ALTER TABLE germain_1473.payments MODIFY COLUMN amount int;

ALTER TABLE germain_1473.payments ADD amount_int int unsigned null;

UPDATE germain_1473.payments SET amount_int = amount * 100;

drop table germain_1473.payments;


#3. Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries.
# In terms of salary, what is the best department right now to work for? The worst?

-- REMEMBER: cur avg pay - avg of hist pay / std (hist pay)
CREATE TEMPORARY TABLE germain_1473.avg_pay_by_dept AS
SELECT AVG(salary) as "cur_avg_pay", dept_name
FROM salaries
JOIN dept_emp using(emp_no)
JOIN departments USING(dept_no)
WHERE dept_emp.to_date > now()
 	AND salaries.to_date > now()
GROUP BY dept_no; 
 
SELECT * FROM germain_1473.avg_pay_by_dept;
 
ALTER TABLE germain_1473.avg_pay_by_dept ADD zscore float;

UPDATE germain_1473.avg_pay_by_dept SET zscore = ((cur_avg_pay - (SELECT avg(salary) FROM salaries)) / (SELECT STDDEV(salary) FROM salaries));

SELECT * FROM germain_1473.avg_pay_by_dept
ORDER BY zscore DESC;





