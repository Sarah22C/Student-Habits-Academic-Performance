--1. Segmentation of At Risk Groups.
-- Purpose: Explore dropout-risk students, identify a high-risk failing subgroup,
-- and create clear segmentation labels.

--To begin, I created the database, StudentDB and uploaded the CSV file into it. 
--Then did a preliminary query to ensure all the data looked correct.
SELECT COUNT(*)
FROM StPerformance;

SELECT *
FROM StPerformance
LIMIT 5;

-- Count students flagged as at risk of dropping out.
SELECT COUNT(*) AS at_risk_count
FROM StPerformance
WHERE dropout_risk = 'Yes';

-- Of at-risk students, count those who are currently failing based on exam score threshold.
SELECT COUNT(*) AS at_risk_failing_count
FROM StPerformance
WHERE dropout_risk = 'Yes'
  AND exam_score < 70;

-- Look at students that are low/very low motivation + high stress + at risk + failing.
SELECT
  student_id,
  motivation_category,
  exam_anxiety_score,
  stress_category,
  exam_score,
  previous_gpa_category,
  dropout_risk
FROM StPerformance
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND exam_score < 70;

-- Full record view for that same group.
SELECT *
FROM StPerformance
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND exam_score < 70;

-- Breakdown of risk group composition:
-- How motivation/stress/anxiety/GPA categories distribute among at-risk students.
SELECT
  motivation_category,
  stress_category,
  exam_anxiety_score,
  previous_gpa_category,
  COUNT(*) AS num_students
FROM StPerformance
WHERE dropout_risk = 'Yes'
GROUP BY motivation_category, stress_category, exam_anxiety_score, previous_gpa_category
ORDER BY num_students DESC;

-- Attendance distribution for the high-risk failing subgroup.
SELECT attendance_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND exam_score < 70
GROUP BY attendance_category
ORDER BY num_students DESC;

-- Attendance distribution for ALL at-risk students.
SELECT attendance_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE dropout_risk = 'Yes'
GROUP BY attendance_category
ORDER BY num_students DESC;

-- Create a GPA category column.
ALTER TABLE StPerformance ADD COLUMN previous_gpa_category;

-- Categorize previous GPA into groups for easier comparison.
UPDATE StPerformance
SET previous_gpa_category = CASE
  WHEN previous_gpa >= 3.5 THEN 'High (3.5 - 4.0)'
  WHEN previous_gpa >= 3.0 THEN 'Above Avg (3.0 - 3.49)'
  WHEN previous_gpa >= 2.5 THEN 'Average (2.5 - 2.99)'
  WHEN previous_gpa >= 2.0 THEN 'Low (2.0 - 2.49)'
  ELSE 'Very Low (<2.0)'
END;

-- Previous GPA distribution for the high-risk failing subgroup.
SELECT previous_gpa_category, COUNT(*) AS num_students
FROM StPerformance
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND exam_score < 70
GROUP BY previous_gpa_category
ORDER BY num_students DESC;

-- Previous GPA distribution for ALL at-risk students.
SELECT previous_gpa_category, COUNT(*) AS num_students
FROM StPerformance
WHERE dropout_risk = 'Yes'
GROUP BY previous_gpa_category
ORDER BY num_students DESC;

-- Count at-risk students who were previously high GPA performers.
SELECT COUNT(*) AS at_risk_prev_high_gpa
FROM StPerformance
WHERE dropout_risk = 'Yes'
  AND previous_gpa >= 3.5;

-- Create screen time groups.
ALTER TABLE StPerformance ADD COLUMN screen_time_category;

UPDATE StPerformance
SET screen_time_category = CASE
  WHEN screen_time < 2 THEN 'Low (<2 hrs)'
  WHEN screen_time < 4 THEN 'Moderate (2 - 3.9 hrs)'
  WHEN screen_time < 6 THEN 'High (4 - 5.9 hrs)'
  ELSE 'Very High (6+ hrs)'
END;

-- Screen time distribution for the high-risk failing subgroup.
SELECT screen_time_category, COUNT(*) AS num_students
FROM StPerformance
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND exam_score < 70
GROUP BY screen_time_category
ORDER BY num_students DESC;

-- Screen time distribution for ALL at-risk students.
SELECT screen_time_category, COUNT(*) AS num_students
FROM StPerformance
WHERE dropout_risk = 'Yes'
GROUP BY screen_time_category
ORDER BY num_students DESC;

-- Create grouped social media hours.
ALTER TABLE StPerformance ADD COLUMN social_media_hr_grouped TEXT;

UPDATE StPerformance
SET social_media_hr_grouped = CASE
  WHEN social_media_hours < 1 THEN 'Very Low (<1 hr)'
  WHEN social_media_hours < 3 THEN 'Low (1 - 2.9 hrs)'
  WHEN social_media_hours < 5 THEN 'Moderate (3 - 4.9 hrs)'
  ELSE 'High (5+ hrs)'
END;

-- Create grouped Netflix hours.
ALTER TABLE StPerformance ADD COLUMN netflix_hr_grouped;

UPDATE StPerformance
SET netflix_hr_grouped = CASE
  WHEN netflix_hours < 1 THEN 'Very Low (<1 hr)'
  WHEN netflix_hours < 3 THEN 'Low (1 - 2.9 hrs)'
  WHEN netflix_hours < 5 THEN 'Moderate (3 - 4.9 hrs)'
  ELSE 'High (5+ hrs)'
END;

-- Define a risk_group label to separate your the main subgroups.
ALTER TABLE StPerformance ADD COLUMN risk_group;

-- Group 1: Failing High Risk
-- (Low motivation + high stress + max anxiety + at-risk + failing.)
UPDATE StPerformance
SET risk_group = 'Failing High Risk'
WHERE motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND exam_anxiety_score = 10
  AND dropout_risk = 'Yes'
  AND exam_score < 70;

-- Check Group 1 size.
SELECT COUNT(*) AS failing_high_risk_count
FROM StPerformance
WHERE risk_group = 'Failing High Risk';

-- Group 2: High Achiever At Risk
-- Previously high GPA, now at dropout risk, with low motivation + high stress.
UPDATE StPerformance
SET risk_group = 'High Achiever At Risk'
WHERE previous_gpa >= 3.5
  AND motivation_category IN ('Very Low Motivation', 'Low Motivation')
  AND stress_category = 'Highly Stress'
  AND dropout_risk = 'Yes'
  AND risk_group IS NULL;

-- Check Group 2 size.
SELECT COUNT(*) AS high_achiever_at_risk_count
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk';

-- Create grouped exercise frequency.
ALTER TABLE StPerformance ADD COLUMN exercise_category;

UPDATE StPerformance
SET exercise_category = CASE
  WHEN exercise_frequency >= 6 THEN 'Very Active'
  WHEN exercise_frequency >= 4 THEN 'Active'
  WHEN exercise_frequency >= 2 THEN 'Moderate'
  ELSE 'Inactive'
END;

-- Create grouped time management scores.
ALTER TABLE StPerformance ADD COLUMN time_management_category;

UPDATE StPerformance
SET time_management_category = CASE
  WHEN time_management_score >= 9 THEN 'Excellent'
  WHEN time_management_score >= 7 THEN 'Good'
  WHEN time_management_score >= 5 THEN 'Average'
  WHEN time_management_score >= 3 THEN 'Poor'
  ELSE 'Very Poor'
END;

-- Create grouped parental support levels.
ALTER TABLE StPerformance ADD COLUMN parental_support_category;

UPDATE StPerformance
SET parental_support_category = CASE
  WHEN parental_support_level >= 9 THEN 'Excellent'
  WHEN parental_support_level >= 7 THEN 'Good'
  WHEN parental_support_level >= 5 THEN 'Average'
  WHEN parental_support_level >= 3 THEN 'Poor'
  ELSE 'Very Poor'
END;

-- Compare subgroup distributions across key factors (sleep, mental health, tutoring, time management, etc.)

-- Sleep by subgroup.
SELECT risk_group, 
	sleep_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, sleep_category
ORDER BY risk_group, sleep_category;

-- Mental health by subgroup.
SELECT risk_group, 
	mental_health_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, mental_health_category
ORDER BY risk_group, mental_health_category;

-- Job status by subgroup.
SELECT risk_group, 
	part_time_job, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, part_time_job
ORDER BY risk_group, part_time_job;

-- Tutoring access by subgroup.
SELECT risk_group, 
	access_to_tutoring, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, access_to_tutoring
ORDER BY risk_group, access_to_tutoring;

-- Parental support by subgroup.
SELECT risk_group, 
	parental_support_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, parental_support_category
ORDER BY risk_group, parental_support_category;

-- Exercise by subgroup.
SELECT risk_group, 
	exercise_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, exercise_category
ORDER BY risk_group, exercise_category;

-- Time management by subgroup.
SELECT risk_group, 
	time_management_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, time_management_category
ORDER BY risk_group, time_management_category;

-- Study hours by subgroup.
SELECT risk_group, 
	hours_studied_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, hours_studied_category
ORDER BY risk_group, hours_studied_category;

-- Family income by subgroup.
SELECT risk_group, 
	family_income_range, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, family_income_range
ORDER BY risk_group, family_income_range;

-- Gender by subgroup.
SELECT risk_group, 
	gender, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IS NOT NULL
GROUP BY risk_group, gender
ORDER BY risk_group, gender;

