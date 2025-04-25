

-- D1: What has been the employee turnover situation of the company in the past five years?
SELECT 
  attrition AS status, 
  COUNT(*) AS employee_count
FROM attrition_status
GROUP BY attrition;



-- D2: What is the distribution of employees in each department?

SELECT 
  d.department_name, 
  COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_employees DESC;



-- D3: What is the distribution of employee backgrounds?
SELECT 
  ef.education_field_name AS education_field,
  COUNT(*) AS employee_count
FROM education e
JOIN education_fields ef ON e.education_field_id = ef.education_field_id
GROUP BY ef.education_field_name
ORDER BY employee_count DESC;



-- D4: How many employees are there now for each job role?
SELECT 
  jr.job_role_name, 
  COUNT(*) AS total_employees
FROM work_assignments a
JOIN job_roles jr ON a.job_role_id = jr.job_role_id
GROUP BY jr.job_role_name
ORDER BY total_employees DESC;



-- D5: Which departments are overworked?
SELECT d.department_name, j.job_role_name,
       COUNT(CASE WHEN w.overtime = 'Yes' THEN 1 END)::float / COUNT(*) AS overtime_ratio
FROM employees e
JOIN work_assignments a ON e.employee_number = a.employee_number
JOIN work_schedule w ON e.employee_number = w.employee_number
JOIN job_roles j ON a.job_role_id = j.job_role_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name, j.job_role_name
HAVING COUNT(*) >= 10
ORDER BY overtime_ratio DESC
LIMIT 5;



-- D6: Can salary adjustments reduce the employee turnover rate?
SELECT
  CASE 
    WHEN i.percent_salary_hike < 10 THEN 'Low (<10%)'
    WHEN i.percent_salary_hike BETWEEN 10 AND 15 THEN 'Medium (10%-15%)'
    ELSE 'High (>15%)'
  END AS salary_hike_group,

  COUNT(*) AS total_employees,
  SUM(CASE WHEN a.attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
  ROUND(
    SUM(CASE WHEN a.attrition = 'Yes' THEN 1 ELSE 0 END)::numeric / COUNT(*), 3) AS attrition_rate

FROM income i
JOIN attrition_status a ON i.employee_number = a.employee_number

GROUP BY salary_hike_group
ORDER BY attrition_rate DESC;



-- D7: Which jobs have more stable turnover?
SELECT j.job_role_name,
       ROUND(AVG(w.years_at_company), 1) AS avg_years_at_company,
       COUNT(*) AS employee_count
FROM work_experience w
JOIN work_assignments a ON w.employee_number = a.employee_number
JOIN job_roles j ON a.job_role_id = j.job_role_id
GROUP BY j.job_role_name
ORDER BY avg_years_at_company DESC;


-- D8: What is the average promotion cycle for each position?

SELECT j.job_role_name,
       ROUND(AVG(w.years_since_last_promotion), 2) AS avg_years_to_promotion,
       COUNT(*) AS employee_count
FROM work_experience w
JOIN work_assignments a ON w.employee_number = a.employee_number
JOIN job_roles j ON a.job_role_id = j.job_role_id
GROUP BY j.job_role_name
ORDER BY avg_years_to_promotion ASC;


-- D9: What is the internal turnover rate of different positions?

SELECT 
    jr.job_role_name,
    COUNT(*) AS num_employees,
    ROUND(
        AVG(
          (w.years_at_company - w.years_in_current_role)::numeric / NULLIF(w.years_at_company, 0)),2
    ) AS avg_internal_mobility_ratio
FROM work_experience w
JOIN work_assignments a ON w.employee_number = a.employee_number
JOIN job_roles jr ON a.job_role_id = jr.job_role_id
GROUP BY jr.job_role_name
ORDER BY avg_internal_mobility_ratio DESC;


--D10: Which employees have not been promoted for a long time?
SELECT e.employee_number,
       w.years_at_company,
       w.years_since_last_promotion,
       j.job_role_name
FROM work_experience w
JOIN employees e ON w.employee_number = e.employee_number
JOIN work_assignments a ON e.employee_number = a.employee_number
JOIN job_roles j ON a.job_role_id = j.job_role_id
WHERE w.years_at_company >= 5 AND w.years_since_last_promotion >= 5
ORDER BY w.years_since_last_promotion DESC;


-- D11: What is the relationship between business trip frequency and turnover rate?

SELECT 

    wa.business_travel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN a.attrition = 'Yes' THEN 1 ELSE 0 END) AS num_leavers,
    ROUND(
        SUM(CASE WHEN a.attrition = 'Yes' THEN 1 ELSE 0 END)::numeric 
        / COUNT(*), 2) AS attrition_rate
FROM attrition_status a
JOIN work_assignments wa ON a.employee_number = wa.employee_number
GROUP BY wa.business_travel
ORDER BY attrition_rate DESC;





