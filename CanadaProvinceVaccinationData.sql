/*
Canada Vaccination Data
*/

Select *
From PortfolioProject..VaccinationCoverageByAge_Sex
Where prename = 'Canada'
Order by week_end

-- CLEANING DATASET

-- Coverting the Date Format for all Tables

Alter Table PortfolioProject..VaccinationCoverage
Add weekend_converted date;
Update PortfolioProject..VaccinationCoverage
Set weekend_converted = CONVERT(Date, week_end)

Alter Table PortfolioProject..VaccinationCoverageByAge_Sex
Add weekend_converted date;
Update PortfolioProject..VaccinationCoverageByAge_Sex
Set weekend_converted = CONVERT(Date, week_end)

Alter Table PortfolioProject..VaccinationCoverageByVaccineType
Add weekend_converted date;
Update PortfolioProject..VaccinationCoverageByVaccineType
Set weekend_converted = CONVERT(Date, week_end)

-- Age Column

Update PortfolioProject..VaccinationCoverageByAge_Sex
SET age = 
			Case
				When age = '17-Dec' Then '12-17'
				Else age
			End

-- Sex Column
Update PortfolioProject..VaccinationCoverageByAge_Sex
SET sex = 
			Case
				When sex = 'f' Then 'Female'
				When sex = 'm' Then 'Male'
				Else sex
			End


-- PREPAREATION FOR TABLEAU VISUALIZATION

-- Vaccination Overview
Select MAX(numtotal_fully) as TotalFullVaccination, MAX(numtotal_partially) as TotalPartialVaccination
From PortfolioProject..VaccinationCoverage
Where prename = 'Canada'


-- Vaccination Overview By Date, Age and Sex

Select prename, weekend_converted, sex, age, numtotal_atleast1dose, numtotal_partially, numtotal_fully, prop_atleast1dose, prop_partially, prop_fully
From PortfolioProject..VaccinationCoverageByAge_Sex
Where prename <> 'Canada'
Group by prename, weekend_converted, sex, age, numtotal_atleast1dose, numtotal_partially, numtotal_fully, prop_atleast1dose, prop_partially, prop_fully
Order by age

-- Vaccination Overview By Province
Select prename, MAX(numtotal_atleast1dose) as TotalOneDoseVaccination,
MAX(numtotal_partially) as TotalPartialVaccination, MAX(numtotal_fully) as TotalFullVaccination,
MAX(proptotal_atleast1dose) as CumulativePercentOneDoseVaccinated, MAX(proptotal_partially) as CumulativePercentPartiallyVaccinated,
MAX(proptotal_fully) as CumulativePercentFullyVaccinated
From PortfolioProject..VaccinationCoverage
Where prename <> 'Canada'
Group by prename
Order by TotalFullVaccination desc

-- Vaccination Overview By Province and Date
Select weekend_converted, prename, MAX(numtotal_atleast1dose) as TotalOneDoseVaccination, MAX(numtotal_partially) as TotalPartialVaccination, 
MAX(numtotal_fully) as TotalFullVaccination,
MAX(proptotal_atleast1dose) as CumulativePercentOneDoseVaccinated, MAX(proptotal_partially) as CumulativePercentPartiallyVaccinated,
MAX(proptotal_fully) as CumulativePercentFullyVaccinated
From PortfolioProject..VaccinationCoverage
Where prename <> 'Canada'
Group by weekend_converted, prename
Order by prename

-- Vaccination Overview By Vaccine Type
Select prename, weekend_converted, product_name, numtotal_atleast1dose, numtotal_partially, numtotal_fully, prop_atleast1dose, prop_partially, prop_fully
From PortfolioProject..VaccinationCoverageByVaccineType
Where prename <> 'Canada'
Group by prename, weekend_converted, product_name, numtotal_atleast1dose, numtotal_partially, numtotal_fully, prop_atleast1dose, prop_partially, prop_fully
Order by prename
