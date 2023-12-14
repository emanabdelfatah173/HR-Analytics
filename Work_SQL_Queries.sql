USE Work

-- Data Exploration
SELECT * FROM Absenteeism_at_work a
SELECT * FROM Reasons r
SELECT * FROM compensation c

SELECT COUNT(ID) AS Num_employees FROM Absenteeism_at_work
SELECT SUM(Transportation_expense) AS Total_Transportation_Expense FROM Absenteeism_at_work
SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work
SELECT DISTINCT Reason FROM Reasons
SELECT TOP 1
    Month_of_absence AS Month,
    COUNT(*) AS AbsenceCount
FROM Absenteeism_at_work
GROUP BY Month_of_absence
ORDER BY AbsenceCount DESC;

-- Number of Non Smokers
SELECT COUNT(*) AS Non_Smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 0

-- Number of Smokers
SELECT COUNT(*) AS Smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 1

--Create a join table
SELECT * 
FROM Absenteeism_at_work a
LEFT JOIN [dbo].[compensation] c
ON a.ID = c.ID
LEFT JOIN Reasons r
ON a.ID = r.Number;

--- Find the healthiest employees for bonus
--- SELECT COUNT(*)
SELECT *
FROM Absenteeism_at_work
WHERE Social_drinker = 0 AND Social_smoker = 0 AND Body_mass_index < 25
AND Absenteeism_time_in_hours < (SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work)


--- Compensation rate increase for non-smokers / Budget $983.221 so 0.68 increase per hour / $1.414.4 per year.
SELECT COUNT(*) AS Non_Smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 0

--- Total ampunt of hours ther are working:
--- 5 days per week * 8 hours a day * 52 week in year = 2.080 amount of hours that 686 employees are working in year.
--- 2.080 / 686 = 1.426.880 amount of hours that an employee are working in year.
--- $983.221 / 1.426.880 = 0.68 increase per hour
--- 5 days per week * 8 hours a day * 52 week in year * 0.68 increase per hour = 1.414.4 cent per year


--- Optimize the Query
SELECT a.ID,
r.Reason, r.Number
a.Body_mass_index,
CASE WHEN a.Body_mass_index < 18.5 THEN 'UnderWeight'
	 WHEN a.Body_mass_index BETWEEN 18.5 AND 25 THEN 'Healthy Weight'
	 WHEN a.Body_mass_index BETWEEN 25 AND 30 THEN 'Overweight'
	 WHEN a.Body_mass_index > 18.5 THEN 'Obese'
	 ELSE 'Unknown' END AS BIM_Category,

CASE WHEN a.Month_of_absence IN (12,1,2) THEN 'Winter' 
	 WHEN a.Month_of_absence IN (3,4,5) THEN 'Spring'
	 WHEN a.Month_of_absence IN (6,7,8) THEN 'Summer'
	 WHEN a.Month_of_absence IN (9,10,11) THEN 'Fall'
	 ELSE 'Unknown' END AS Season_Names,
Month_of_absence,
Day_of_the_week,
Transportation_expense,
Education,
Son,
Social_drinker,
Social_smoker,
Pet,
Disciplinary_failure,
Age,
Work_load_Average_day,
Absenteeism_time_in_hours,
Distance_from_Residence_to_Work,
Height,
Hit_target,
Service_time
FROM Absenteeism_at_work a
LEFT JOIN [dbo].[compensation] c
ON a.ID = c.ID
LEFT JOIN Reasons r
ON a.ID = r.Number;
