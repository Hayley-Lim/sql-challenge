DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS dept_emp;

CREATE TABLE titles(
title_id VARCHAR NOT NULL PRIMARY KEY,
title VARCHAR NOT NULL
);

CREATE TABLE salaries (
emp_no int NOT NULL PRIMARY KEY,
salary int NOT NULL
);

CREATE TABLE dept_manager (
dept_no VARCHAR  NOT NULL,
emp_no int NOT NULL,
CONSTRAINT pk_dept_manager
PRIMARY KEY (dept_no,emp_no)
);

CREATE TABLE departments (
dept_no VARCHAR NOT NULL PRIMARY KEY,
dept_name VARCHAR NOT NULL
);

CREATE TABLE dept_emp (
emp_no int NOT NULL,
dept_no VARCHAR NOT NULL,
CONSTRAINT pk_dept_emp 
PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE employees (
emp_no int NOT NULL PRIMARY KEY,
emp_title_id VARCHAR NOT NULL,
birth_date date NOT NULL,
First_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
sex VARCHAR NOT NULL,
hire_date date NOT NULL
);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM titles;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;

--Data analysis

-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.

SELECT employees.emp_no, 
employees.last_name, 
employees.first_name, 
employees.sex, 
salaries.salary
FROM employees
INNER JOIN salaries on
employees.emp_no = salaries.emp_no;

-- 2. List employees who were hired in 1986.
SELECT first_name, 
last_name, 
hire_date, 
EXTRACT (YEAR FROM hire_date) AS YEAR
FROM employees
WHERE hire_date > '1985-12-31'
AND hire_date < '1987-01-01';

--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.
SELECT dm.dept_no,d.dept_name,dm.emp_no,e.first_name,e.last_name
FROM employees as e
INNER JOIN dept_manager as dm 
ON e.emp_no = dm.emp_no
INNER JOIN departments as d
ON dm.dept_no = d.dept_no;

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT de.emp_no,e.last_name,e.first_name,d.dept_name
FROM dept_emp as de
INNER JOIN employees as e 
ON de.emp_no = e.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no;

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name,last_name,sex
FROM employees
WHERE first_name='Hercules' 
AND last_name LIKE 'B%';

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales'
OR dept_name='Development';

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, count(last_name)
FROM employees
GROUP BY last_name
ORDER BY count(last_name) DESC;



