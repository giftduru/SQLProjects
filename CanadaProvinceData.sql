/*
Canada Covid Data
*/

Select *
From PortfolioProject..CanadaCovid19
Order by date

-- CLEANING DATASET

-- Coverting the Date Format

Alter Table PortfolioProject..CanadaCovid19
Add date_converted date;

Update PortfolioProject..CanadaCovid19
Set date_converted = CONVERT(Date, date)

-- Filling the Null values of Important Parameters

--- NumDeaths & PercentDeath Null

Update a
SET percentdeath = ISNULL(a.percentdeath, b.numdeaths)
From PortfolioProject..CanadaCovid19 a
JOIN PortfolioProject..CanadaCovid19 b
	On a.pruid = b.pruid
Where a.percentdeath is Null AND a.numtotal = '0' AND b.numtotal = '0'

Update a
SET numdeaths = ISNULL(a.numdeaths, 0),
	percentdeath = ISNULL(a.percentdeath, 0)
From PortfolioProject..CanadaCovid19 a
JOIN PortfolioProject..CanadaCovid19 b
	On a.pruid = b.pruid
Where a.percentdeath is Null AND a.numtotal = b.numrecover


--- NumRecover & PercentRecover Null

Update a
SET numrecover = ISNULL(a.numrecover, a.numtotal - a.numdeaths)
From PortfolioProject..CanadaCovid19 a
JOIN PortfolioProject..CanadaCovid19 b
	On a.pruid = b.pruid
Where a.percentrecover is Null

Update a
SET percentrecover = ISNULL(ISNULL(a.percentrecover, (a.numrecover/NULLIF(a.numtotal,0))*100),0)
From PortfolioProject..CanadaCovid19 a
JOIN PortfolioProject..CanadaCovid19 b
	On a.pruid = b.pruid
Where a.percentrecover is Null

-- Replacing all percentRecovery = '0'  with N/A

Update PortfolioProject..CanadaCovid19
SET percentrecover = Case
						When percentrecover = '0' Then 'N/A'
						Else percentrecover
					End


-- PREPAREATION FOR TABLEAU VISUALIZATION

-- Canada Total Overview
Select MAX(numtotal) as TotalCases, MAX(numdeaths) as TotalDeaths, MAX(numdeaths)/MAX(numtotal)*100 as DeathPercent, 
MAX(Cast(numrecover as int)) as TotalRecovery, MAX(Cast(numrecover as int))/MAX(numtotal)*100 as RecoverPercent 
From PortfolioProject..CanadaCovid19
Where pruid = '1'


-- Provinvcial Numbers
Select prname, MAX(numtotal) as TotalCases, MAX(numdeaths) as TotalDeaths, MAX(numdeaths)/MAX(numtotal)*100 as DeathPercent, 
MAX(Cast(numrecover as int)) as TotalRecovery, MAX(Cast(numrecover as int))/MAX(numtotal)*100 as RecoverPercent 
From PortfolioProject..CanadaCovid19
--Where prname <> 'Canada'
Group by prname
Order by TotalCases desc


--  Daily Numbers in Canada
Select date_converted, numtotal, numdeaths, numrecover, percentdeath,percentrecover 
From PortfolioProject..CanadaCovid19
Where prname = 'Canada'
Group by date_converted, numtotal, numdeaths, numrecover, percentdeath, percentrecover 
Order by date_converted


-- Daily Numbers by Provinces
Select date_converted, prname, numtotal, numdeaths, numrecover, percentdeath,percentrecover 
From PortfolioProject..CanadaCovid19
Where prname <> 'Canada'
Group by date_converted, prname, numtotal, numdeaths, numrecover, percentdeath, percentrecover 
Order by prname