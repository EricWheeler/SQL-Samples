-- This case study works with the Lown Hospital Index for Equity 2022. 
-- It includes ranks and grades for over 4,000 US hospitals for 2022 and focuses on measures for:
-- Pay Equity (ratio of executive compensation to worker wages), 
-- Community Benefit (charity care spending, other community benefit spending, and Medicaid revenue as a share of patient revenue), 
-- and Inclusivity (income inclusivity, racial inclusivity, and education inclusivity). 

-- The method I used to import data into PostgreSQL require the use of Python to first import a CSV file to a pandas dataframe, 
-- and then connect the data set with PostgreSQL. This method works very well when bulk importing multiple CSV files into the database, 
-- but in this case there is only one file to be added. 

-- The column names in the original CSV file were not standaradized and required cleaning using SQL
ALTER TABLE lown_equity
ALTER RENAME COLUMN "RECORD_ID" TO id

ALTER TABLE lown_equity
RENAME COLUMN "HOSPITAL_SYSTEM" TO system

ALTER TABLE lown_equity
RENAME COLUMN "Name" TO name

ALTER TABLE lown_equity
RENAME COLUMN "State" TO state

ALTER TABLE lown_equity
RENAME COLUMN "City" TO city

ALTER TABLE lown_equity
RENAME COLUMN "Address" TO address

ALTER TABLE lown_equity
RENAME COLUMN "Zip" TO zip

ALTER TABLE lown_equity
RENAME COLUMN "Size" TO size 

ALTER TABLE lown_equity
RENAME COLUMN "Type_For Profit" TO type_for_profit

ALTER TABLE lown_equity
RENAME COLUMN "Type_NonProfit" TO type_non_profit

ALTER TABLE lown_equity
RENAME COLUMN "Type_Church Affiliated" TO type_church

ALTER TABLE lown_equity
RENAME COLUMN "Type_Urban" TO type_urban

ALTER TABLE lown_equity
RENAME COLUMN "Type_Rural" TO type_rural

ALTER TABLE lown_equity
RENAME COLUMN "Tier 1_Lown Composite Overall Rank" TO overall_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 1_Lown Composite Overall Grade" TO overall_grade

ALTER TABLE lown_equity
RENAME COLUMN "Tier 2_Equity Overall Rank" TO equity_overall_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 2_Equity Overall Grade" TO equity_overall_grade

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Pay Equity Rank" TO pay_equity_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Pay Equity Grade" TO pay_equity_grade

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Community Benefit Rank" TO community_benefit_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Community Benefit Grade" TO community_benefit_grade

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Inclusivity Rank" TO inclusivity_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 3_Inclusivity Grade" TO inclusivity_grade

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Pay Equity_Exec Comp to Worker Wages Rank" TO wage_comparison_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Comm Benefit_Charity Care Spending Rank" TO charity_care_spending_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Comm Benefit_Other Benefit Spending Rank" TO other_care_benefit_spending_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Comm Benefit_Medicaid Rev Share of Patient Rev Rank" TO medicaid_patient_rev_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Inclusivity_Income Rank" TO inclusivity_income_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Inclusivity_Racial Rank" TO inclusivity_racial_rank

ALTER TABLE lown_equity
RENAME COLUMN "Tier 4_Inclusivity_Education Rank" TO inclusivity_education_rank

-- The import of the data from Python also led to some unexpected data types being associated with a number of numerical columns.
-- I used SQL to convert all of the data types to INT
ALTER TABLE lown_equity
ALTER COLUMN zip TYPE INT,
ALTER COLUMN type_for_profit TYPE INT,
ALTER COLUMN type_non_profit TYPE INT,
ALTER COLUMN type_church TYPE INT,
ALTER COLUMN type_urban TYPE INT,
ALTER COLUMN type_rural TYPE INT,
ALTER COLUMN overall_rank TYPE INT,
ALTER COLUMN equity_overall_rank TYPE INT,
ALTER COLUMN pay_equity_rank TYPE INT,
ALTER COLUMN community_benefit_rank TYPE INT,
ALTER COLUMN inclusivity_rank TYPE INT,
ALTER COLUMN wage_comparison_rank TYPE INT,
ALTER COLUMN charity_care_spending_rank TYPE INT,
ALTER COLUMN other_care_benefit_spending_rank TYPE INT,
ALTER COLUMN medicaid_patient_rev_rank TYPE INT,
ALTER COLUMN inclusivity_income_rank TYPE INT,
ALTER COLUMN inclusivity_racial_rank TYPE INT,
ALTER COLUMN inclusivity_education_rank TYPE INT;

-- Once this was completed I began my exploratory data analysis

-- 1. How many hospitals are in the dataset?
SELECT DISTINCT COUNT(name) AS hospital_count
FROM lown_equity;


-- 2. How many hospitals are there in each state in the Lown Index?
SELECT 	
    state,
	  COUNT(*) as hospital_count
FROM lown_equity
GROUP BY state
ORDER BY hospital_count DESC;


-- 3. How many hospitals are there of each size?
SELECT 	
    size,
	  COUNT(*) AS hospital_count
FROM lown_equity
GROUP BY size;


-- 4. How many hospitals are there in each hospital system?
SELECT 	
    SUM(type_for_profit) AS for_profit_hospitals,
	  SUM(type_non_profit) AS non_profit_hospitals,
	  SUM(type_church) AS church_hospitals,
	  SUM(type_urban) AS urban_hospitals,
	  SUM(type_rural) AS rural_hospitals
FROM lown_equity;


-- 5. How many church hospitals are for-profit vs. non-profit?
SELECT 	
    SUM(type_for_profit) AS for_profit_church_hospitals,
	  SUM(type_non_profit) AS non_profit_church_hospitals
FROM lown_equity
WHERE type_church = 1;


-- 6. What are the 4 for-profit church hospitals?
SELECT 
	  name,
	  city,
	  state
FROM lown_equity
WHERE type_church = 1 AND type_for_profit = 1

  
-- 7. How many hospitals are there by each grade?
SELECT 	
    overall_grade,
	  COUNT(*) AS hospital_count
FROM lown_equity
WHERE overall_grade IS NOT NULL
GROUP BY overall_grade
ORDER BY overall_grade ASC;


-- 8. Which hospital has the highest Lown Composite Overall Rank?
SELECT	
    name,
	  address,
	  city,
	  state,
    zip
FROM lown_equity
ORDER BY overall_rank ASC
LIMIT 1;


-- 9. Which cities have the most hospitals with Lown Composite Overall Grades of 'A'?
SELECT 	
    city,
	  state,
    COUNT(overall_grade) AS grade_a_count
FROM lown_equity
WHERE overall_grade = 'A' AND city IS NOT NULL
GROUP BY city, state
ORDER BY grade_a_count DESC, city ASC
LIMIT 30;


-- 10. Which states have more than 5 hospitals with a Lown Composite Overall Grade of 'D'?
SELECT 	
    state,
	  COUNT(overall_grade) AS grade_d_count
FROM lown_equity
WHERE overall_grade ='D' AND city IS NOT NULL 
GROUP BY state
HAVING COUNT(overall_grade) > 5
ORDER BY grade_d_count DESC;


-- 11. Does the size of hospital appear to have a connection to overall grade?
SELECT 	
    m.size,
	  m.overall_grade,
	  m.size_grade_count,
	  s.total_count,
	  ROUND((m.size_grade_count * 100.0 / s.total_count), 2) AS size_grade_percentage
FROM
	    (SELECT 
          size,
			    overall_grade,
		  COUNT(overall_grade) as size_grade_count
	    FROM lown_equity
	     WHERE overall_grade IS NOT NULL
	    GROUP BY size, overall_grade) AS m
INNER JOIN
	    (SELECT 
          size,
		      COUNT(*) AS total_count
	    FROM lown_equity
	    GROUP BY size) AS s
ON m.size = s.size
ORDER BY m.size DESC, m.overall_grade;


-- 12. Was the fact that the hospital was a non profit effect it's community benefit grade?
SELECT 	
    cbg1.community_benefit_grade,
	  for_profit_count,
    non_profit_count
FROM 
	    (SELECT 
          community_benefit_grade,
			    COUNT(*) AS for_profit_count
	    FROM lown_equity
	    WHERE type_for_profit = 1 AND community_benefit_grade IS NOT NULL
	    GROUP BY community_benefit_grade) AS cbg1
INNER JOIN
	    (SELECT 
          community_benefit_grade,
			    COUNT(*) AS non_profit_count
	    FROM lown_equity
	    WHERE type_non_profit = 1 AND community_benefit_grade IS NOT NULL
	    GROUP BY community_benefit_grade) AS cbg2
ON cbg1.community_benefit_grade = cbg2.community_benefit_grade;


-- 13. Are there any hospitals where the Pay Equity Grade is worse than the Community Benefit Grade?
SELECT 
    name,
    city,
    state,
    community_benefit_grade,
    pay_equity_grade,
    (CASE community_benefit_grade
        WHEN 'A' THEN 4
        WHEN 'B' THEN 3
        WHEN 'C' THEN 2
        WHEN 'D' THEN 1
        ELSE 0
        END) -
    (CASE pay_equity_grade
        WHEN 'A' THEN 4
        WHEN 'B' THEN 3
        WHEN 'C' THEN 2
        WHEN 'D' THEN 1
        ELSE 0
        END) AS discrepancy
FROM lown_equity
WHERE community_benefit_grade > pay_equity_grade
ORDER BY discrepancy, state;


-- 14. For the top 100 ranking hospitals for pay equity regarding executive compensation to 
-- worker wages, are there more hospitals in urban or rural areas?
SELECT 	
    urban_count,
		rural_count
FROM 
      (SELECT COUNT(type_urban) AS urban_count
      FROM lown_equity 
      WHERE type_urban = 1 AND wage_comparison_rank <= 100) AS le1
CROSS JOIN
      (SELECT COUNT(type_rural) AS rural_count
      FROM lown_equity
      WHERE type_rural = 1 AND wage_comparison_rank <= 100) AS le2;


-- 15. Are there any hospitals where the Inclusivity Racial Rank is significantly lower compared 
-- to other hospitals in the same state?
SELECT 	
    m.name,
		m.state,
		m.inclusivity_racial_rank,
		s.state_avg_racial_inclusivity_rank,
		(s.state_avg_racial_inclusivity_rank - m.inclusivity_racial_rank) AS rank_difference
FROM lown_equity AS m
INNER JOIN 
	    (SELECT 
          state,
			    ROUND(AVG(inclusivity_racial_rank),0) AS state_avg_racial_inclusivity_rank
	    FROM lown_equity
	    WHERE LENGTH(state) < 3
	    GROUP BY state) AS s
ON m.state = s.state
WHERE m.inclusivity_racial_rank IS NOT NULL
ORDER BY rank_difference ASC
