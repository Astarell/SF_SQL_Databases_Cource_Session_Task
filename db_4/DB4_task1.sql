WITH RECURSIVE subordinate_list AS (
    SELECT 
        emp.employeeid, 
        emp.name,
        emp.managerid,
        emp.departmentid,
        emp.roleid
    FROM employees AS emp
    WHERE emp.employeeid = 1
    
    UNION ALL

    SELECT 
        emp.employeeid, 
        emp.name,
        emp.managerid,
        emp.departmentid,
        emp.roleid
    FROM employees AS emp
    JOIN subordinate_list AS sl 
        ON emp.managerid = sl.employeeid 
),

employee_projects AS (
	SELECT emp.employeeid,
		   STRING_AGG(p.projectname, ', ') AS all_projects
	FROM employees AS emp 
		LEFT JOIN departments AS d ON emp.departmentid = d.departmentid
		LEFT JOIN projects AS p ON d.departmentid = p.departmentid 
	GROUP BY emp.employeeid
),

employee_tasks AS (
	SELECT t.assignedto,
		   STRING_AGG(t.taskname, ', ') AS all_tasks
	FROM tasks AS t
	GROUP BY t.assignedto
)

SELECT sl.employeeid AS EmployeeID, 
     sl.name AS EmployeeName,
     sl.managerid AS ManagerID,
     dep.departmentname AS DepartmentName,
     r.rolename AS RoleName,
     empp.all_projects AS ProjectNames,
     empt.all_tasks AS TaskNames
FROM subordinate_list AS sl	
	JOIN departments AS dep ON dep.departmentid = sl.departmentid
	JOIN roles AS r ON r.roleid = sl.roleid
	LEFT JOIN employee_tasks AS empt ON empt.assignedto = sl.employeeid
	LEFT JOIN employee_projects AS empp ON empp.employeeid = sl.employeeid
ORDER BY sl.name;
