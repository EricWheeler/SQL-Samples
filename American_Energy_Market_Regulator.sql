-- Energy stability is one of the key themes the AEMR management team cares about. To ensure energy security and reliability, AEMR needs to understand the following:

-- 1. What are the most common outage types and how long do they tend to last?
-- 2. How frequently do the outages occur?
-- 3. Are there any energy providers that have more outages than their peers which may indicate that these providers are unreliable?


-- Count of approved outages by reason for the years 2016 and 2017 
SELECT  COUNT(*) AS Total_Number_Outage_Events,
        Status,
        Reason,
        YEAR(Start_Time) AS Year
FROM AEMR
WHERE status = 'Approved' AND YEAR(Start_Time) IN(2016, 2017)
GROUP BY Reason, Year
ORDER BY Reason;


-- Average outage duration in days for approved outages in 2016 and 2017 
SELECT  Status,
        Reason,
        COUNT(*) AS Total_Number_Outage_Events,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60/24),2) AS Average_Outage_Duration_Time_Days,
        YEAR(Start_Time) AS Year
FROM AEMR 
WHERE Status = 'Approved' AND YEAR(Start_Time) IN(2016,2017)
GROUP BY Year, Reason
ORDER BY Year;


-- Monthly count of all approved outage types for 2016 and 2017
SELECT  Status, 
        Reason, 
        COUNT(*) AS Total_Number_Outage_Events,
        MONTH(Start_Time) AS Month,
        YEAR(Start_Time) AS Year
FROM AEMR 
WHERE Status = 'Approved' AND YEAR(Start_Time) IN(2016, 2017)
GROUP BY Year, Month, Reason;


-- Count of all approved outages by participant code in 2016 and 2017
SELECT  COUNT(*) AS Total_Number_Outage_Events,
        Participant_Code,
        Status,
        YEAR(Start_Time) AS Year 
FROM AEMR 
WHERE Status = 'Approved' AND YEAR(Start_Time) IN (2016, 2017)
GROUP BY Year, Participant_Code;


-- Average outage duration in days per participant code in 2016 and 2017
SELECT  Participant_Code,
        Status,
        YEAR(start_time) AS Year,
        ROUND(AVG(TIMESTAMPDIFF(minute, start_time, end_time)/60/24),2) AS Average_Outage_Duration_Time_Days
FROM AEMR 
WHERE Status = 'Approved' AND YEAR(start_time) IN(2016, 2017)
GROUP BY Year, Participant_Code
ORDER BY Average_Outage_Duration_Time_Days DESC;


-- When an energy provider provides energy to the market, they are making a commitment to the market and saying; “We will supply X amount of energy to the market under a contractual obligation.” However, in a situation where the outages are forced, the energy provider intended to provide energy but is unable to provide energy and is forced offline. If many energy providers are forced offline at the same time, it could cause an energy security risk that AEMR needs to mitigate.

-- To ensure this doesn’t happen, the AEMR is interested in exploring the following questions:

-- 1. Of the outage types in 2016 and 2017, what percent were forced outages?
-- 2. What was the average duration for a forced outage during both 2016 and 2017? Have we seen an increase in the average duration of forced outages?
-- 3.Which energy providers tended to be the most unreliable?


-- Count of approved and forced outages in 2016 and 2017
SELECT  SUM(CASE WHEN Reason = 'Forced' THEN 1 ELSE 0 END) AS Total_Number_Forced_Outage_Events,
        COUNT(*) AS Total_Number_Outage_Events,
        ROUND(Total_Number_Forced_Outage_Events/Total_Number_Outage_Events * 100, 2) AS Forced_Outage_Percentage
        YEAR(Start_Time) AS Year
FROM AEMR
WHERE   Status = 'Approved' AND YEAR(Start_Time) IN (2016, 2017)
GROUP BY Year, Reason
HAVING Reason = 'Forced';


-- Total outages, forced outages, and forced outage percentage in 2016 and 2017
SELECT SUM(CASE WHEN Reason = 'Forced' THEN 1 ELSE 0 END) AS Total_Number_Forced_Outage_Events,
       COUNT(*) AS Total_Number_Outage_Events,
       ROUND(SUM(CASE WHEN Reason = 'Forced' THEN 1 ELSE 0 END)/COUNT(*) * 100,2) AS Forced_Outage_Percentage,
       YEAR(Start_Time) AS Year
FROM AEMR
WHERE Status = 'Approved' AND YEAR(Start_Time) IN (2016, 2017)
GROUP BY Year;


-- Average outage duration and average MW loss from forced outages in 2016 and 2017
SELECT  Status,  
        Reason,
        YEAR(Start_Time) AS Year,
        ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR 
WHERE Status = 'Approved' AND YEAR(Start_Time) IN (2016,2017) 
GROUP BY Year, Reason;


-- Average outage duration per outage reason in 2016 and 2017
SELECT  Status,
        Reason, 
        YEAR(Start_Time) AS Year,
        ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE,Start_Time, End_Time)),2) AS Average_Outage_Duration_Time_Minutes
FROM AEMR
WHERE Status = 'Approved' AND YEAR(Start_Time) IN(2016, 2017)
GROUP BY Year, Reason;


-- Average forced outage duration and average forced MW loss per participant code in 2016 and 2017
SELECT  Participant_Code,
        Status,
        YEAR(Start_Time) AS Year,
        ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, Start_Time, End_Time)/60/24),2) AS Average_Outage_Duration_Time_Days
FROM AEMR
WHERE Status = 'Approved'
      AND Reason = 'Forced'
      AND YEAR(Start_Time) IN (2016,2017)
GROUP BY Year, Participant_Code
ORDER BY Avg_Outage_MW_Loss DESC, Year;


-- Average forced outage MW loss and summed forced MW loss by participant code in 2016 and 2017
SELECT Participant_Code,
       Facility_Code,
       Status,
       YEAR(Start_Time) AS Year,
       ROUND(AVG(Outage_MW),2) AS Avg_Outage_MW_Loss,
       ROUND(SUM(Outage_MW),2) AS Summed_Energy_Lost
FROM AEMR 
WHERE Status = 'Approved' 
      AND YEAR(Start_Time) IN(2016, 2017)
      AND Reason = 'Forced'
GROUP BY Participant_Code, Facility_Code, Year
ORDER BY Year, Summed_Energy_Lost DESC;
