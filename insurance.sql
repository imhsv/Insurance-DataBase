create database insurance;
use insurance;
-- 1. Show the first 10 rows of the dataset.
select * from insurance_data
limit 10; 
-- 2. Display the average claim amount for patients in each region.
select region, avg(claim) as "Average Amount" from insurance_data
group by region;
-- 3. Select the maximum and minimum BMI values in the table.
select max(bmi),min(bmi) from insurance_data;
-- 4. Select the PatientID, age, and BMI for patients with a BMI between 40 and 50.
select PatientID, age,BMI from insurance_data
where bmi between 40 and 50;
-- 5. Select the number of smokers in each region.
select region ,count(smoker) as "No. of Smoker" from insurance_data where smoker="Yes"
group by region;
-- 6. What is the average claim amount for patients who are both diabetic and smokers?
select PatientID ,smoker,diabetic, avg(claim) as "Average Claim Amount" from insurance_data 
where diabetic like "%Yes%" and smoker like "%Yes%"
group by PatientID,smoker,diabetic;
-- 7. Retrieve all patients who have a BMI greater 
-- than the average BMI of patients who are smokers.
select PatientID,bmi as "BMI Greater than Avg BMI",smoker from insurance_data
where bmi> (select avg(bmi) from insurance_data where smoker="Yes") and smoker="Yes";
-- 8. Select the average claim amount for patients in each age group.
select  
case when age < 18 then "Under 18"
when age between 18 and 30 then "Age 18 - 30"
when age between 31 and 50 then "Age 31 - 50"
else "Over 50"
end as age_group,
avg(claim) as "Avg. Claim Amount"
from insurance_data
-- round(avg(claim),2) as avg_claim
group by age_group
order by age_group;
-- 9. Retrieve the total claim amount for each patient, 
-- along with the average claim amount across all patients.
select * ,sum(claim) over (partition by PatientID) as "Total claim",avg(claim) over() as avg_claim 
from insurance_data;
-- 10. Retrieve the top 3 patients with the highest claim amount, along with their 
-- respective claim amounts and the total claim amount for all patients.
select  PatientID,claim,sum(claim) over () as "Total claim" from insurance_data
order by claim desc limit 3 ;
-- 11. Select the details of patients who have a claim amount 
-- greater than the average claim amount for their region.
select PatientID,region,claim from insurance_data t1 -- t1 is represent table for insurance_data tabel
where claim > (select avg(claim) from insurance_data t2 where t1.region > t2.region)
order by claim desc;
-- 12. Retrieve the rank of each patient based on their claim amount.
select * , rank() over (order by claim desc) as "Rank" from insurance_data;
-- 13. Select the details of patients along with their claim amount, 
-- and their rank based on claim amount within their region.
select * , rank() over (partition by region order by claim desc) as "Rank based on Claim followed by region" from insurance_data;