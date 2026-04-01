

create database HR_DATABASE

USE HR_DATABASE

--section 1: Data Validation and Basic Metrics
--To view the entire table
Select * from HR_DATA

--Check total number of employees
select count(*) as employee_count from HR_DATA

--Check distinct attrition values
select distinct attrition_binary from HR_DATA

--Attrition count and rate
select sum(cast(attrition_binary as int)) as attrition_count, count(*) as total_employees,
round(sum(cast(attrition_binary as int))*100.0/count(*),2) as attrition_rate
from HR_DATA

--Section 2: Department Level Analysis
--Attrition by department (count+rate)
select department, sum(cast(attrition_binary as int)) as attritioncount_dept,
count(*) as totalcount_dept, 
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_dept 
from HR_DATA
Group by Department
order by attritionrate_dept desc

--Rank departments by attrition
select Department,sum(cast(attrition_binary as int)) as attritioncount_dept,
dense_rank() over(order by sum(cast(attrition_binary as int)) desc) as attritionrank_dept
from HR_DATA
Group by Department


--Contribution percentage by department
with dept_attrition as (
select department, sum(cast(attrition_binary as int)) as attritioncount_dept 
from HR_DATA
Group by Department
)
Select *, 
round(attritioncount_dept*100/sum(attritioncount_dept)over(),2) as contribution_percentage_dept,
dense_rank() over(order by attritioncount_dept desc) as dept_rank
from dept_attrition


--Top 3 Job Roles with highest attrition
select top 3 jobrole, sum(cast(attrition_binary as int)) as attritioncount_jobrole, 
dense_rank()over(order by sum(cast(attrition_binary as int)) desc) as attritionrank_jobrole
from HR_DATA
Group by jobrole

--Section 3: Demographic Analysis
--Compare attrition between genders
select gender,count(*) as totalcount_gender, sum(cast(attrition_binary as int)) as attritioncount_gender,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritonrate_gender
from HR_DATA
Group by gender

--Attrition by salary band & tenure band
select salary_band,tenure,count(*) as totalcount, sum(cast(attrition_binary as int)) as attritioncount,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritonrate_salarytenure
from HR_DATA
Group by Salary_Band,Tenure
order by attritonrate_salarytenure desc

--Attrition vs yearssincelastpromotion
select YearsSinceLastPromotion,count(*) as totalcount_YearsSinceLastPromotion, 
sum(cast(attrition_binary as int)) as attritioncount_YearsSinceLastPromotion,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_YearsSinceLastPromotion
from HR_DATA
Group by YearsSinceLastPromotion
order by YearsSinceLastPromotion

--Section 4: Behaviour and Satisfaction Analysis
--Attrition rate by overtime
select overtime,count(*) as totalcount_overtime, sum(cast(attrition_binary as int)) as attritioncount_overtime,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_overtime
from HR_DATA
Group by overtime

--Attrition vs jobsatisfaction
select JobSatisfaction,count(*) as totalcount_jojbsatisfaction, 
sum(cast(attrition_binary as int)) as attritioncount_jobsatisfaction,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_jobsatisfaction
from HR_DATA
Group by JobSatisfaction
order by JobSatisfaction

--Attrition vs worklife balance
select WorkLifeBalance,count(*) as totalcount_worklifebalance, 
sum(cast(attrition_binary as int)) as attritioncount_worklifebalance,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_worklifebalance
from HR_DATA
Group by WorkLifeBalance
order by worklifebalance

--Attrition vs performancerating
select performancerating,count(*) as totalcount_performancerating, 
sum(cast(attrition_binary as int)) as attritioncount_performancerating,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_performancerating
from HR_DATA
Group by performancerating
order by performancerating

--Attrition vs percentsalaryhike
select percentsalaryhike,count(*) as totalcount_percentsalaryhike, 
sum(cast(attrition_binary as int)) as attritioncount_percentsalaryhike,
round(sum(cast(attrition_binary as int))*100/count(*),2) as attritionrate_percentsalaryhike
from HR_DATA
Group by percentsalaryhike
order by percentsalaryhike

--Section 5: Risk Segmentation and Advanced Logic
--Identify high risk employees
Select count(*) as total_highrisk
from HR_DATA
where OverTime=1
and Tenure='Low Tenure'
and Salary_Band='Low'
and JobSatisfaction<=2
and Attrition_BINARY=0

--Classify highrisk mployees
select  employeeNumber, department, salary_band, tenure,
case 
when overtime=1 and Salary_Band= 'Low' and tenure = 'Low Tenure' then 'High Risk'
when overtime=1 and Salary_Band='Medium' and tenure = 'Low Tenure' then 'Medium Risk'
else 'Low Risk'
end as attritionriskcategory
from HR_DATA






