        -- Analytic (Window) Functions (Practice in Oracle Syntax)


--  (i) Meanings, Values, Relations, and Advantages

--      Exercise AF.1.1: Employee Ranking by Salary
-- Problem: For each department, rank employees by their salary in descending order. Display department name, employee name, salary, and their rank using 
-- ROW_NUMBER(), RANK(), and DENSE_RANK().
-- Bridging Focus: PostgreSQL users are familiar with these functions. The exercise is to practice the Oracle syntax and observe the behavior of different 
-- ranking functions, especially with ties in salary (e.g., Grace Davis and Henry Wilson).
-- Concepts: ROW_NUMBER() OVER(), RANK() OVER(), DENSE_RANK() OVER(), PARTITION BY, ORDER BY.
SELECT 
    ROW_NUMBER() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) UNIQUE_RANK,
    DENSE_RANK() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) SPECIALIZED_UNIQUE_RANK, 
    RANK() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) WEIGHTED_RANK, 
    DENSE_RANK() OVER(PARTITION BY DEPARTMENTID ORDER BY SALARY DESC) CONTINUOUS_RANK, 
    e.*
FROM ADVANCED_QUERYING.EMPLOYEES e;

--      Exercise AF.1.2: Salary Comparison with Previous/Next Hired Employee
-- Problem: For each employee, show their salary, and the salary of the employee hired immediately before them and immediately after them within the same 
-- department. Order by department and then by hire date. Include the names of the previous/next employees.
-- Concepts: LAG() OVER(), LEAD() OVER(), PARTITION BY, ORDER BY.
SELECT 
    e.SALARY, 
    LAG(SALARY, 1) OVER(PARTITION BY DEPARTMENTID ORDER BY HIREDATE DESC) PREVIOUS_SALARAY,
    LEAD(SALARY, 1) OVER(PARTITION BY DEPARTMENTID ORDER BY HIREDATE DESC) NEXT_SALARY
FROM ADVANCED_QUERYING.EMPLOYEES e;

--      Exercise AF.1.3: Running Total and Department Average Salary
-- Problem: For each employee, display their name, department, salary, a running total of salaries within their department (ordered by hire date), and the 
-- average salary for their department. Also, show the total salary for their department.
-- Concepts: SUM() OVER(), AVG() OVER(), PARTITION BY, ORDER BY (for running total), frame clause.
SELECT eo.EMPLOYEENAME, eo.DEPARTMENTID, eo.SALARY, SUM(eo.SALARY) OVER(PARTITION BY eo.SALARY ORDER BY eo.HIREDATE) DATED_SALARY, l.DEPARTMENTAL_SALARY
FROM ADVANCED_QUERYING.EMPLOYEES eo, LATERAL(
    SELECT SUM(ei.SALARY) DEPARTMENTAL_SALARY 
    FROM ADVANCED_QUERYING.EMPLOYEES ei 
    WHERE ei.DEPARTMENTID = eo.DEPARTMENTID GROUP BY ei.DEPARTMENTID
) l ORDER BY eo.DEPARTMENTID, eo.HIREDATE;


--  (ii) Disadvantages and Pitfalls

--      Exercise AF.2.1: Misinterpreting Ranking Functions
-- Problem: Consider the 'Sales' department where 'Grace Davis' and 'Henry Wilson' have the same salary. Write a query to rank them by salary. Explain how the 
-- results of ROW_NUMBER(), RANK(), and DENSE_RANK() would differ and which might be "misleading" if the user isn't careful about the specific requirement (e.g., if they wanted to identify distinct salary tiers).
-- Concepts: Nuances between ROW_NUMBER, RANK, DENSE_RANK.
SELECT * 
FROM ADVANCED_QUERYING.EMPLOYEES 
NATURAL JOIN ADVANCED_QUERYING.DEPARTMENTS
WHERE EMPLOYEES.EMPLOYEENAME IN ('Grace Davis', 'Henry Wilson')
AND DEPARTMENTS.DEPARTMENTNAME = 'Sales';

--      Exercise AF.2.2: Impact of PARTITION BY and ORDER BY
-- Problem: Show how changing or omitting PARTITION BY or ORDER BY in a LAG function changes the result. Calculate LAG(salary):
-- Partitioned by department, ordered by hire date.
-- No partition, ordered by hire date globally.
-- Explain what happens if you try to use LAG partitioned by department but with no explicit order in the OVER clause. Also, demonstrate SUM() OVER() with and 
-- without PARTITION BY and ORDER BY to show its different behaviors (department total vs. grand total vs. running total).
-- Concepts: Critical role of PARTITION BY and ORDER BY in window definitions.
SELECT 
    LAG(SALARY) OVER(PARTITION BY DEPARTMENTID ORDER BY HIREDATE DESC) DEPARTMENTAL_LAG, -- This creates two null values for each department
    LAG(SALARY) OVER(ORDER BY HIREDATE DESC) GLOBAL_LAG --, -- This just creates two null values (first and last dates)
    -- LAG(SALARY) OVER(PARTITION BY DEPARTMENTID) -- This creates an error because time is ordered
FROM ADVANCED_QUERYING.EMPLOYEES;


--  (iii) Contrasting with Inefficient Common Solutions

--      Exercise AF.3.1: Calculating Rank - Efficient vs. Inefficient
-- Problem: Calculate the salary rank for each employee within their department (highest salary = rank 1, using dense ranking logic).
-- First, describe how one might attempt this inefficiently using a correlated subquery.
-- Then, provide the efficient Oracle Analytic Function solution.
-- Concepts: DENSE_RANK() OVER() vs. correlated subqueries for ranking.
-- Answer: a correlated query solves this using statements about uniqueness of two conditions, one categorical for departments and 
-- another ordered with dates where is evaluated how many in the seelct statement for each user how many employees within the same
-- department have higher salaries + 1
SELECT DENSE_RANK() OVER (PARTITION BY e.DEPARTMENTID ORDER BY e.salary) AS drank FROM ADVANCED_QUERYING.EMPLOYEES e;