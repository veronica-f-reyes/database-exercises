use employees;

select * from titles;

#2. In your script, use DISTINCT to find the unique titles in the titles table. How many unique titles have there ever been? Answer that in a comment in your SQL file.
#--7 unique titles

SELECT DISTINCT title 
FROM titles;

#3. Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.
#--5

SELECT last_name 
FROM employees
WHERE last_name LIKE "e%e"
GROUP BY last_name;

#4. Write a query to to find all unique combinations of first and last names of all employees whose last names start and end with 'E'.
#--846

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE "E%E"
GROUP BY first_name, last_name;

#5. Write a query to find the unique last names with a 'q' but not 'qu'. Include those names in a comment in your sql code.
#--3

SELECT last_name
FROM employees
WHERE (last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%')
GROUP BY last_name;

#6. Add a COUNT() to your results (the query above) to find the number of employees with the same last name.
#--3 rows, Chleq - 189, Lindqvist - 190,Qiwen 168

SELECT last_name, COUNT(last_name)
FROM employees
WHERE (last_name LIKE '%q%'
	AND last_name NOT LIKE '%qu%')
GROUP BY last_name;

#7. Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.

SELECT first_name, gender, COUNT(*)
FROM employees 
WHERE first_name IN ("Irena", "Vidya", 'Maya')
GROUP BY first_name, gender;

#8. Using your query that generates a username for all of the employees, generate a count employees for each unique username. Are there any duplicate usernames? BONUS: How many duplicate usernames are there?

#300,024 - Total amount of usernames including duplicates
#285,872 - Total amount of unique usernames
#(300,024 - 285,872) = 14,152  = Total amount of duplicate usernames

SELECT  LOWER(CONCAT(
		SUBSTR(first_name, 1, 1), 
	   SUBSTR(last_name,1, 4), 
	    '_', 
	    SUBSTR(birth_date,6,2), 
	    SUBSTR(birth_date,3, 2)
	    )) as username,
	    COUNT(*) as Num_username
FROM employees
GROUP BY username
ORDER BY Num_username DESC;

-- HAVING Num_username > 1; 




#-- JOHN SALAS' CODE ---
SELECT lower(concat(substring(first_name,1,1),
							substring(last_name,1,4),
		                	"_",
		                substring(birth_date,6,2),
		                substring(birth_date,3,2))) AS user_name, 
						count(*) AS dupes
FROM employees
GROUP BY user_name
HAVING dupes > 1;


SELECT count(*) AS 'users_with_dupicate_names', sum(t1.dupes) - count(*) AS 'number_of_duplicates_names_after_the_first' 
FROM (SELECT lower(concat(substring(first_name,1,1),
							substring(last_name,1,4),
		                	"_",
		                substring(birth_date,6,2),
		                substring(birth_date,3,2))) AS user_name, 
						count(*) AS dupes
		FROM employees
		GROUP BY user_name
		HAVING dupes > 1) AS t1;

#-----------------------


#---- Brian Burrham's Code
-- BONUS.   HOW many unique usernames? 
-- 2 ways to count this
-- FIRST number of usernames produced by more than one employee observation
SELECT COUNT(*)
FROM (
SELECT
    lower
    (
        CONCAT 
        (
            SUBSTR(first_name,1,1),     #First Char of first_name
            SUBSTR(last_name,1,4),      #First 4 Chars of last_name
            "_",                      #Underscore
            SUBSTR(birth_date,6,2),     #2 digit month of birth_date
            SUBSTR(birth_date,3,2)      #Last 2 digits of year of birth_date
        )
    )
    AS username,
    COUNT(lower
    (
        CONCAT 
        (
            SUBSTR(first_name,1,1),     #First Char of first_name
            SUBSTR(last_name,1,4),      #First 4 Chars of last_name
            "_",                      #Underscore
            SUBSTR(birth_date,6,2),     #2 digit month of birth_date
            SUBSTR(birth_date,3,2)      #Last 2 digits of year of birth_date
        )
    ))
    AS Instance_Count
FROM employees
GROUP BY username
HAVING Instance_Count > 1      
ORDER BY Instance_Count DESC) AS USERnames;
-- Previous method only counts each user name that appears more than once
-- To count username that is duplicated the number of times that it is duplicated
-- Just take the difference of total employees and usernames that are duplicated
SELECT 
(SELECT COUNT(*) FROM employees)       # Total Employees
-                                      # Minus
(SELECT COUNT(*)                       # Usernames with duplicates
FROM (
SELECT
    lower
    (
        CONCAT 
        (
            SUBSTR(first_name,1,1),     #First Char of first_name
            SUBSTR(last_name,1,4),      #First 4 Chars of last_name
            "_",                      #Underscore
            SUBSTR(birth_date,6,2),     #2 digit month of birth_date
            SUBSTR(birth_date,3,2)      #Last 2 digits of year of birth_date
        )
    )
    AS username,
    COUNT(lower
    (
        CONCAT 
        (
            SUBSTR(first_name,1,1),     #First Char of first_name
            SUBSTR(last_name,1,4),      #First 4 Chars of last_name
            "_",                      #Underscore
            SUBSTR(birth_date,6,2),     #2 digit month of birth_date
            SUBSTR(birth_date,3,2)      #Last 2 digits of year of birth_date
        )
    ))
    AS Instance_Count
FROM employees
GROUP BY username      
ORDER BY Instance_Count DESC) AS USERnames);
-- Returns 14152







