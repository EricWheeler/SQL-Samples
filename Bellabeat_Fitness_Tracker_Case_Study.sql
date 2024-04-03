-- Create a table that unions sleep day data from one time frame with sleep minute data from another time frame. 
CREATE TABLE `tidy-way-285818.bellabeat_case_study.day_sleep_total` AS
SELECT
  Id,
  SleepDay,
  SUM(value) AS TotalMinutesAsleep
FROM (
  SELECT
    Id,
    DATE(date) AS SleepDay,
    value
  FROM
    `tidy-way-285818.bellabeat_case_study.minute_sleep_1`
)
GROUP BY
  Id,
  SleepDay
UNION ALL
SELECT
  Id,
  SleepDay,
  TotalMinutesAsleep
FROM
  `tidy-way-285818.bellabeat_case_study.day_sleep_2`



-- Create a table that joins daily activity data with daily sleep data
CREATE TABLE `tidy-way-285818.bellabeat_case_study.full_daily_table` AS
SELECT  CAST(activity.Id AS NUMERIC) AS Id,
        activity.ActivityDate,
        activity.TotalSteps,
        activity.TotalDistance,
        activity.VeryActiveDistance,
        activity.ModeratelyActiveDistance,
        activity.LightActiveDistance,
        activity.VeryActiveMinutes,
        activity.FairlyActiveMinutes,
        activity.LightlyActiveMinutes,
        activity.SedentaryMinutes,
        activity.Calories,
        CAST(sleep.TotalMinutesAsleep AS NUMERIC) AS TotalMinutesAsleep
FROM `tidy-way-285818.bellabeat_case_study.daily_activity_total` AS activity
LEFT JOIN `tidy-way-285818.bellabeat_case_study.day_sleep_total` AS sleep
ON activity.Id = sleep.Id
AND activity.ActivityDate = sleep.SleepDay


-- Create a table that joins 3 tables to retrieve hourly data on calories, intensities, and steps.
CREATE TABLE `tidy-way-285818.bellabeat_case_study.full_hourly_table` AS
SELECT  CAST(calories.Id AS NUMERIC) AS Id,
        calories.ActivityHour,
        calories.Calories,
        intensities.TotalIntensity,
        intensities.AverageIntensity,
        steps.StepTotal
FROM `tidy-way-285818.bellabeat_case_study.hourly_calories_total` AS calories
INNER JOIN `tidy-way-285818.bellabeat_case_study.hourly_intensities_total` AS intensities
ON calories.Id = intensities.Id AND calories.ActivityHour= intensities.ActivityHour
INNER JOIN `tidy-way-285818.bellabeat_case_study.hourly_steps_total` AS steps
ON calories.Id = steps.Id AND calories.ActivityHour = steps.ActivityHour
