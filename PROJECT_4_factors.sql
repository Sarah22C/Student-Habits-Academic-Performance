--4. Combination Analysis.
--Purpose: Combine factors to spot riskier combinations and look for buffer habits.

--Now that I explored the top performers and those at high risk, I will do a little more in depth analysis by combining factors to spot risky combinations

--Among Top Performers, I want to see the relationship between screen time and study time 
--and whether top performers tend to pair high studying with lower screen time.
SELECT screen_time_category, 
hours_studied_category, 
COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY screen_time_category, hours_studied_category
ORDER BY num_students DESC;


--Now I want to look at students with low parental support and poor time management in our high risk group.
SELECT parental_support_category, 
	time_management_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group IN ('Failing High Risk', 'High Achiever At Risk')
GROUP BY parental_support_category, time_management_category
ORDER BY num_students DESC;

--Now lets compare that same combo among the top performers.
SELECT parental_support_category, 
	time_management_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE top_group = 'Top Performer'
GROUP BY parental_support_category, time_management_category
ORDER BY num_students DESC;

--Now I am looking at groups that have high stress, poor sleep and poor time management with and without access to tutoring
--to see whether tutoring access relates to exam outcomes within this high strain group.
SELECT access_to_tutoring, 
	exam_score, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE stress_category = 'Highly Stress'
  AND sleep_category IN ('5 Hrs', '5-6 Hrs')
  AND time_management_category IN ('Poor', 'Very Poor')
GROUP BY access_to_tutoring, exam_score
ORDER BY num_students DESC;

--Looking at high risk students who are still performing well and exploring what other supports could be put in place to lower their dropout risk
SELECT sleep_category, 
	time_management_category, 
	access_to_tutoring, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group ='High Achiever At Risk'
GROUP BY sleep_category, time_management_category, access_to_tutoring
ORDER BY num_students DESC;

--Now lets look at how parental support, time management, and sleep impact these at risk high achievers
SELECT parental_support_category, 
	time_management_category, 
	sleep_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk'
GROUP BY parental_support_category, time_management_category, sleep_category
ORDER BY num_students DESC;

--Lets explore at how extracurriculars, sleep, and time managment impact the high risk achievers
SELECT extracurricular_participation, 
	sleep_category, 
	time_management_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE risk_group = 'High Achiever At Risk'
GROUP BY extracurricular_participation, sleep_category, time_management_category
ORDER BY num_students DESC;

--Lastly, I am intersted in the question, can you outstudy bad habits? So I am looking at exam scores.
--Look at average exam score by study level among students with at least one "risk habit"
--(low sleep OR poor time mgmt OR very high screen time).
SELECT hours_studied_category, 
	round(AVG(exam_score)) AS avg_exam_score, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE sleep_category IN ('5 Hrs', '5-6 Hrs') 
OR time_management_category IN ('Poor', 'Very Poor') 
OR screen_time_category = ('Very High (6+ hrs)')
GROUP BY hours_studied_category
ORDER BY avg_exam_score DESC;

--Do extreme study habits and poor habits lead to higher stress or mental health issues? 
SELECT hours_studied_category, 
	round(AVG(CAST(stress_level AS FLOAT))) AS avg_stress_score, 
	round(AVG(CAST(mental_health_rating AS FLOAT))) AS avg_mental_health_score,
	COUNT(*) AS num_students
FROM StPerformance
WHERE sleep_category IN ('5 Hrs', '5-6 Hrs')
OR time_management_category IN ('Poor', 'Very Poor')
OR screen_time_category = ('Very High (6+ hrs)')
GROUP BY hours_studied_category
ORDER BY avg_stress_score DESC;

--Lastly, I want to dig deeper into factors that the 'extreme' studiers have that maybe buffer them from burnout or stress
SELECT time_management_category, 
	access_to_tutoring, 
	sleep_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE hours_studied_category = 'Extreme'
GROUP BY time_management_category, access_to_tutoring, sleep_category
ORDER BY num_students DESC;

--Additional potential buffer factors for extreme studiers (parental support and extracurriculars and exercise).
SELECT parental_support_category, 
	extracurricular_participation, 
	exercise_category, 
	COUNT(*) AS num_students
FROM StPerformance
WHERE hours_studied_category = 'Extreme'
GROUP BY parental_support_category, extracurricular_participation, exercise_category
ORDER BY num_students DESC;