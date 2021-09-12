/*
Canada Covid Recovery Data
*/

Select *
From PortfolioProject..CanadaCovid19Rec

-- CLEANING DATASET

-- Coverting the Date Format

Alter Table PortfolioProject..CanadaCovid19Rec
Add date_converted date;
Update PortfolioProject..CanadaCovid19Rec
Set date_converted = CONVERT(Date, date)


-- Updating the Null Values

Update PortfolioProject..CanadaCovid19Rec
Set numrecover = numtotal - numactive - numdeaths
From PortfolioProject..CanadaCovid19Rec
Where numrecover is Null

Update PortfolioProject..CanadaCovid19Rec
Set percentrecover = ISNULL(ROUND(numrecover/NULLIF(numtotal,0)*100, 2),0)
From PortfolioProject..CanadaCovid19Rec
Where percentrecover is Null

Update PortfolioProject..CanadaCovid19Rec
Set percentrecover = 'N/A'
From PortfolioProject..CanadaCovid19Rec
Where numtotal = '0'

Update PortfolioProject..CanadaCovid19Rec
Set numactive = numtotal
From PortfolioProject..CanadaCovid19Rec
Where numrecover is Null

Update PortfolioProject..CanadaCovid19Rec
Set numactive = numtotal-numdeaths-numrecover
From PortfolioProject..CanadaCovid19Rec
Where numactive is Null

Update PortfolioProject..CanadaCovid19Rec
Set percentactive = ISNULL(ROUND(numactive/NULLIF(numtotal,0)*100, 2),0)
From PortfolioProject..CanadaCovid19Rec
Where percentactive is Null

Update PortfolioProject..CanadaCovid19Rec
Set numdeaths = numtotal-numactive
From PortfolioProject..CanadaCovid19Rec
Where numrecover is Null

Update PortfolioProject..CanadaCovid19Rec
Set numdeaths = numtotal-numrecover
From PortfolioProject..CanadaCovid19Rec
Where numdeaths is Null

Update PortfolioProject..CanadaCovid19Rec
Set numtested = ISNULL(numtested, 'N/A')
From PortfolioProject..CanadaCovid19Rec
Where numtested is Null


-- PREPAREATION FOR TABLEAU VISUALIZATION

Select prname, date_converted, numrecover, percentrecover, numactive, percentactive, numtotal,  numtoday, numdeaths, numtested
From PortfolioProject..CanadaCovid19Rec
Where prname <> 'Canada'
Group by prname, date_converted, numrecover, percentrecover, numactive, percentactive, numtotal, numtoday, numdeaths, numtested
Order by prname, date_converted