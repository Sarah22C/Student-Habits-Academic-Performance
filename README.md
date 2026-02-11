# Student_Habits_Academic_Performance
An analysis of academic performance based on varying habits. 

## Overview

This project analyzes a large student dataset (~80,000 records) to understand how lifestyle habits, wellbeing factors, and academic behaviors relate to academic 
performance and dropout risk. Using SQL, I built risk-based student segments and compared them to high-performing students to identify patterns that could support 
early intervention strategies. The final results were visualized in Tableau dashboards to highlight key differences between student groups.
This project focuses on answering a central question:
"What differentiates students who are academically successful from those at risk of dropping out — and which factors may help buffer risk?"

## Tools & Technologies
- SQL (SQLite / DBeaver): data cleaning, feature engineering, segmentation, analysis
- Tableau: dashboard design and visual storytelling
- Excel (early exploration) — initial pattern discovery and validation

## Dataset
- 80,000 student records
- Includes:
  > Academic performance (exam scores, GPA)
  > Behavioral habits (study hours, screen time, sleep)
  > Wellbeing metrics (stress, mental health, motivation, anxiety)
  > Support factors (tutoring, parental support, extracurriculars)
  > Demographics (age, gender, major)

(Raw dataset not included dur to size)

## Project Goals
- Identify students most at risk of dropping out
- Determine whether stress and motivation are reliable predictors of performance
- Compare at-risk students to top performers
- Identify potential protective factors (sleep, tutoring, study habits, etc.)
- Translate findings into insights usable for intervention planning

## Student Segments Created
-At Risk Students: Students flagged as likely to drop out. Approximate size: 1582 students
-Failing High Risk: Students who are at risk of dropping out, currently failing exams (<70), very low/low motivation, highly stressed, and high exam anxiety.  Approximate size: 364
-High Achiever At Risk: Students who previously had strong GPAs (>= 3.5), are not at risk of dropping out, and show low motivation and high stress.
-Top Performers: Students who exam score >= 95, previous GPA >=3.5, and not at risk of dropping out. 

## Key Findings
-Stress and motivation alone do not predict success
    Some top performers still reported high stress and low motivation
-Sleep showed one of the clearest performance differences
    Top performers skewed toward 7–8+ hours
-Tutoring access may act as a protective factor
    At-risk students were significantly more likely to lack tutoring support
-Many at-risk students were previously high performers
    Suggests burnout / transition risk patterns
-Exercise and study consistency patterns differed between groups
