use HR
select * from employee
select * from performance





-------1---How many departments are there in the company, and how many job roles are available within each department?


select department, count(jobrole) as 'num of jobs'
from employee
group by Department

union All
select 'total' as dapartment, sum(count(jobrole)) over () as jobs
from employee






--2-	What is the total number of employees, and how are they distributed by department and job role?


SELECT 
    COALESCE(Department, 'Total') AS Department,
    COALESCE(JobRole, 'Total') AS JobRole,
    COUNT(EmployeeID) AS NumEmployee
FROM Employee
GROUP BY ROLLUP (Department, JobRole)



---3--What is the distribution of the employees across diffrent states ?



select
  State  ,count(EmployeeID) as TotalEmployees
from Employee
group by State
order by TotalEmployees desc



--4 How is education level distributed across departments?




select  educationlevel , count(employeeid) as total_employees
from employee
group by  EducationLevel 
order by total_employees desc






--5-	What is the average age and experience level of employees in each department?



select Department ,
case 
when YearsAtCompany < 3 then 'junior'
when YearsAtCompany between 3 AND 7 then 'Mid_level'
else 'senior' 
end as experience_level ,
count(YearsAtCompany) as NumEmployees,
avg(Age) as 'average age'
from employee
group by Department ,
case 
when YearsAtCompany < 3 then 'junior'
when YearsAtCompany between 3 AND 7 then 'Mid_level'
else 'senior' 
end 
order by department , experience_level






   --6------what is the distribution of employees across diffrent marital statuases?

   

   select MaritalStatus, count(MaritalStatus) as 'num of employees'
   from employee 
   group by MaritalStatus
   order by [num of employees] desc




   
--7----How are employees categorized into three groups based on their distance from work?

   
select
case 
    when [DistanceFromHome_KM] < 5 then 'Very Close'
    when [DistanceFromHome_KM] BETWEEN 5 AND 15 then 'Moderate'
        ELSE 'Far'
   end AS Distance_Group, count(*) as 'num of emoloyees'

   from employee e
   group by 
   CASE 
    when [DistanceFromHome_KM] < 5 then 'Very Close'
    when [DistanceFromHome_KM] BETWEEN 5 AND 15 then 'Moderate'
        ELSE 'Far'
   end


   

---8-- What is the distribution of employees by Stock Option Level?




select Department,
case
when StockOptionLevel = 0 then 'None'
when StockOptionLevel = 1 then 'Low'
when StockOptionLevel = 2 then 'Medium'
when StockOptionLevel = 3 then 'HIgh'
end as StockOptionLevel,
count(*) as employee_count
from employee
group by Department, 
case
when StockOptionLevel = 0 then 'None'
when StockOptionLevel = 1 then 'Low'
when StockOptionLevel = 2 then 'Medium'
when StockOptionLevel = 3 then 'HIgh'
end
order by Department, employee_count



--9 number of employees are hired at last year 5 year
SELECT 
    year(HireDate) as Hire_Year,
    COUNT(*) AS EmployeesHired_LastYear
FROM Employee
WHERE YEAR(HireDate) between 2017 and 2022
group by year(HireDate)
order by Hire_Year;





--10- What is the average salary in each department?



select department, AVG (salary) as average_salary
from employee
group by Department
order by Department, average_salary desc



--11 which job roles have the high average salary

select JobRole,AVG(Salary)AS Avgerage_Salary
from Employee
group by JobRole
order by Avgerage_Salary desc


--12-	What is the overall average job satisfaction score across departments?




SELECT 
    e.Department,
    count(CASE when p.Job_Satisfaction = 'Very Dissatisfied' then 1 end) AS Very_Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Dissatisfied' then 1 end) AS Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Neutral' then 1 end) AS Neutral,
    count(CASE when p.Job_Satisfaction = 'Satisfied ' then 1 end) AS Satisfied,
    count(CASE when p.Job_Satisfaction = 'Very Satisfied' then 1 end) AS Very_Satisfied
FROM employee e
JOIN performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department
ORDER BY e.Department;




   --13-	how does the distance from home affect job satisfaction?
select
case 
    when [DistanceFromHome_KM] < 5 then 'Very Close'
    when [DistanceFromHome_KM] BETWEEN 5 AND 15 then 'Moderate'
        ELSE 'Far'
   end AS Distance_Group,
    count(CASE when p.Job_Satisfaction = 'Very Dissatisfied' then 1 end) AS Very_Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Dissatisfied' then 1 end) AS Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Neutral' then 1 end) AS Neutral,
    count(CASE when p.Job_Satisfaction = 'Satisfied ' then 1 end) AS Satisfied,
    count(CASE when p.Job_Satisfaction = 'Very Satisfied' then 1 end) AS Very_Satisfied
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
GROUP BY 
    CASE 
    when [DistanceFromHome_KM] < 5 then 'Very Close'
    when [DistanceFromHome_KM] BETWEEN 5 AND 15 then 'Moderate'
        ELSE 'Far'
   end;



   
--14-	How does marital status influence employees’ work-life balance levels?


select e.maritalstatus ,
   count(CASE when p.worklifebalance = 'Very Dissatisfied' then 1 end) AS Very_Dissatisfied,
    count(CASE when p.worklifebalance = 'Dissatisfied' then 1 end) AS Dissatisfied,
    count(CASE when p.worklifebalance = 'Neutral' then 1 end) AS Neutral,
    count(CASE when p.worklifebalance = 'Satisfied ' then 1 end) AS Satisfied,
    count(CASE when p.worklifebalance = 'Very Satisfied' then 1 end) AS Very_Satisfied
FROM Employee e
join performance p on e.EmployeeID=p.EmployeeID
group by e.MaritalStatus




--15-	Which departments have the highest number of employees working overtime?


select department , count(*) as over_time_employee
from employee
where OverTime = 1
group by Department
order by over_time_employee



--16-Is there a relationship between overtime and job satisfaction?



select 
    Job_Satisfaction, count(*) as frquency
from employee e
join performance p on e.EmployeeID=p.EmployeeID
where overtime = 1
group by Job_Satisfaction
order by frquency desc






-----17-	How does manager rating affect employee satisfaction levels?**************

select Manager_Rating , 
count(case when manager_rating = 'Exceeds Expectation' then 1 end) as 'Exceeds Expectation' ,
    count(CASE WHEN manager_rating = 'Above and Beyond' THEN 1 END) AS 'Above and Beyond',
    count(CASE WHEN manager_rating = 'Needs Improvement' THEN 1 END) AS 'Needs Improvement',
    count(CASE WHEN manager_rating = 'Meets Expectation' THEN 1 END) AS 'Meets Expectation'
from performance
group by manager_rating



 --18-	Which departments have the highest and lowest Manager Ratings?
 


select 
    e.department , 
    count ( case when p.manager_rating = 'exceeds expectation' then 1 end ) as ' Exceeds Expectation ' ,
    count ( case when p.manager_rating = 'meets expectation' then 1 end ) as ' Meets Expectation '
    from employee e 
    join performance p on e.EmployeeID = p.EmployeeID
    group by e.department 
    order by e.department

    
--19-	is there a relationship between years since last promotion and job satisfaction?

select
    case
       when YearsSinceLastPromotion < 2 then 'Recently Promoted'
       when YearsSinceLastPromotion BETWEEN 2 AND 5 then '2-5 Years'
        ELSE '5+ Years'
   end AS Promotion_Group,
    count(CASE when p.Job_Satisfaction = 'Very Dissatisfied' then 1 end) AS Very_Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Dissatisfied' then 1 end) AS Dissatisfied,
    count(CASE when p.Job_Satisfaction = 'Neutral' then 1 end) AS Neutral,
    count(CASE when p.Job_Satisfaction = 'Satisfied ' then 1 end) AS Satisfied,
    count(CASE when p.Job_Satisfaction = 'Very Satisfied' then 1 end) AS Very_Satisfied
from Employee e
join Performance p on e.EmployeeID = p.EmployeeID
group by
    case 
   when YearsSinceLastPromotion < 2 then 'Recently Promoted'
   when YearsSinceLastPromotion BETWEEN 2 AND 5 then '2-5 Years'
        else '5+ Years'
 end;

 

 
-- 20---- what is the distribution of training opportunities offered vs training opportunities taken?



SELECT 
    e.Department,
    SUM(p.TrainingOpportunitiesTaken) AS Total_Taken,
    SUM(p.TrainingOpportunitiesWithinYear) AS Total_Available
FROM Employee e
JOIN Performance p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Department
ORDER BY e.Department;





--21-	How many employees have not been promoted for more than 5 years?


select 
    ISNULL(Department, 'Total') as Department,
    count(EmployeeID) as num_of_employees
from Employee
where YearsSinceLastPromotion >= 5
group by Department WITH ROLLUP;




 --22-**	What is the relationship between YearsAtCompany and Performance Rating?


select 
    case 
        when e.YearsAtCompany < 3 then 'junior'
        when e.YearsAtCompany between 3 AND 7 then 'Mid_level'
    else 'senior' 
end as experience_level ,
    count ( case when p.manager_rating = 'exceeds expectation' then 1 end ) as ' High performance ' ,
    count ( case when p.manager_rating = 'needs improvement' then 1 end ) as 'low performance '
 from employee e 
 join performance p on e.EmployeeID = p.EmployeeID 
 group by 
   case 
        when e.YearsAtCompany < 3 then 'junior'
        when e.YearsAtCompany between 3 AND 7 then 'Mid_level'
    else 'senior' 
end




--23 how many employees employees who left the company in the last 5 years?


select
    year(HireDate) as Hire_Year,
    count(EmployeeID)as EmployeesLeft
from Employee
where Attrition = 1
 and year(HireDate) between 2018 and 2022
group by year(HireDate)
order by Hire_Year;

--24 which department has the heighest rate of turnover?


select
    Department,
    count(case when Attrition = 1 then 1 end) * 100.0 / count(*) as TurnoverRate
from Employee
group by Department
order by TurnoverRate desc

----25-	Do employees with higher satisfaction levels tend to stay longer at the company?



select job_satisfaction, environment_satisfaction, Relationship_Satisfaction , 
count(case when attrition = 1 then 1 end) as 'turn over'
from performance p 
join employee e on p.EmployeeID=e.employeeid
group by Job_Satisfaction, environment_satisfaction, Relationship_Satisfaction
order by [turn over] desc













    -----------



