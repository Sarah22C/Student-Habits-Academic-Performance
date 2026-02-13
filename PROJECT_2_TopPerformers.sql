--Now that I have explored the at risk students in depth, I'd like to contrast them with the top students in the database. To begin, I will
--look at stress/motivation/anxiety for students with a high greade, previous high dropout rate and not at risk of failing.

--1. Segmentation of Top Performers


--Purpose: Define a "Top Performer" segment and explore whether stress/motivation/anxiety are reliable predictors of 
--performance 

--Count of students who meet a "top performer" criteria (exam + GPA + not at dropout risk).
SELECT COUNT(*)
FROM StPerformance
WHERE exam_score >= 90
  AND previous_gpa >= 3.5
  AND dropout_risk = 'No';

--Same count but with a stricter exam score threshold (more selective top performer definition).
SELECT COUNT(*) AS top_candidates_95
FROM StPerformance
WHERE exam_score >= 95
  AND previous_gpa >= 3.5
  AND dropout_risk = 'No';

--See how motivation + stress + test anxiety combinations appear among strong performers (>=90).
--Goal: test whether high performance can coexist with anxiety/stress/low motivation.
SELECT motivation_category, 
	stress_category, 
	exam_anxiety_score, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE exam_score >= 90
  AND previous_gpa >= 3.5
  AND dropout_risk = 'No'
GROUP BY motivation_category, stress_category, exam_anxiety_score
ORDER BY num_students DESC;


-- See how motivation + stress + test anxiety combinations appear among the strongest performers (>=90).
-- Top performers based on strict criteria (>95 exam, >=3.5 GPA, not at risk of dropping out).
SELECT motivation_category, 
	stress_category, 
	exam_anxiety_score, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE exam_score >= 95
  AND previous_gpa >= 3.5
  AND dropout_risk = 'No'
GROUP BY motivation_category, stress_category, exam_anxiety_score
ORDER BY num_students DESC;

--Finally, as I did with high risk students I am creating a group of top performers to look at other factors with. So the top performers are
--those with high GPAs, high exam scores and no dropout risk.
ALTER TABLE StPerformance 
ADD COLUMN top_group

--Label top performers based on strict criteria (>=95 exam, >=3.5 GPA, not at risk).
UPDATE StPerformance
SET top_group = 'Top Performer'
WHERE exam_score>= 95
AND previous_GPA>= 3.5
AND dropout_risk = 'No';

--Verify how many students were labeled as Top Performer.
SELECT COUNT (*) AS top_performer_count
FROM StPerformance
WHERE top_group = 'Top Performer';
 
--Check the presence of "outlier" top performers: low motivation + high stress but still high performance.
SELECT motivation_category, 
	stress_category, 
	exam_score, 
	previous_GPA
FROM StPerformance
WHERE top_group = 'Top Performer'
AND motivation_category IN ('Very Low Motivation', 'Low Motivation')
AND stress_category = 'Highly Stress';


--Count how many of those outlier profiles exist.
SELECT motivation_category, 
	stress_category, 
	exam_score, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
AND motivation_category IN ('Very Low Motivation', 'Low Motivation')
AND stress_category = 'Highly Stress'
GROUP BY motivation_category, stress_category, exam_score
ORDER BY num_students;

--Now I will begin to look at the other factors that might impact the top performers, in contrast to the at risk population.  
--Distribution of sleep among top performers.
SELECT sleep_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY sleep_category
ORDER BY num_students DESC;

--Distribution of mental health categories among top performers.
SELECT mental_health_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY mental_health_category
ORDER BY num_students DESC;

--Distribution of time management among top performers.
SELECT time_management_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY time_management_category
ORDER BY num_students DESC;

--Access to tutoring among top performers.
SELECT access_to_tutoring, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY access_to_tutoring
ORDER BY num_students DESC;

--Study hours among top performers.
SELECT hours_studied_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY hours_studied_category
ORDER BY num_students DESC;

--Screen time among top performers.
SELECT screen_time_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY screen_time_category
ORDER BY num_students DESC;