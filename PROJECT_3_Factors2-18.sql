--2. Demographics by group
--Purpose: Compare stress patterns across demographics and across student segments.

--Stress by major (all students).
SELECT stress_category, 
	major, 
	COUNT(*) AS num_students
FROM StPerformance
GROUP BY stress_category, major;
ORDER BY num_students DESC;

--Stress by major (Top Performers).
SELECT stress_category, 
	major, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY stress_category, major;

--Stress by major (High Achiever At Risk).
SELECT stress_category, 
	major, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk'
GROUP BY stress_category, major;

--Stress by major (Failing High Risk).
SELECT stress_category, 
	major, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'Failing High Risk'
GROUP BY stress_category, major;

--Stress by gender (all students).
SELECT stress_category, 
	gender, 
	COUNT(*) AS num_students
FROM StPerformance
GROUP BY stress_category, gender;
ORDER BY num_students DESC;

--Stress by gender (Top Performers).
SELECT stress_category, 
	gender, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY stress_category, gender;

--Stress by gender (High Achiever At Risk).
SELECT stress_category, 
	gender, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk'
GROUP BY stress_category, gender;

--Stress by gender (Failing High Risk).
SELECT stress_category, 
	gender, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'Failing High Risk'
GROUP BY stress_category, gender;

--Stress by age (all students).
SELECT stress_category, 
	age, 
	COUNT(*) AS num_students
FROM StPerformance
GROUP BY stress_category, age;
ORDER BY num_students DESC;

--Stress by age (Top Performers).
SELECT stress_category, 
	age, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY stress_category, age;

--Stress by age (High Achiever At Risk).
SELECT stress_category, 
	age, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk'
GROUP BY stress_category, age;

--Stress by age (Failing High Risk).
SELECT stress_category, 
	age, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'Failing High Risk'
GROUP BY stress_category, age;

--Anxiety distribution.
SELECT exam_anxiety_category,  
	COUNT(*) AS num_students
FROM StPerformance
GROUP BY exam_anxiety_score;

(SELECT * 
FROM StPerformance
WHERE top_group = 'Top Performer'
AND stress_category = 'Highly Stress';
GROUP BY hours_studied_category
ORDER BY num_students DESC;

SELECT age, gender, major, Count(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
AND stress_category = 'Highly Stress'
GROUP BY age, gender, major
ORDER BY num_students DESC;)






