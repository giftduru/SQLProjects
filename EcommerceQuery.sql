/*

Sales Performance Analysis

*/

Select SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits, SUM(Sales-Profit) as TotalExpense
From PortfolioProject..Sales
Order by TotalSales Desc


Select [Product Category], SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits, 
SUM(Sales)/(Select SUM(Sales) From PortfolioProject..Sales)*100 as SalesPercentageByCategory,
SUM(Profit)/(Select SUM(Profit) From PortfolioProject..Sales)*100 as ProfitPercentageByCategory
From PortfolioProject..Sales
Group by [Product Category]
Order by [Product Category]


Select [Product Category], SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits, SUM(Sales-Profit) as TotalExpense
From PortfolioProject..Sales
Group by [Product Category]
Order by TotalSales Desc


Select Region, Country, State, City, [Product Category], SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits
From PortfolioProject..Sales
Group by Region, Country, State, City, [Product Category]
Order by Region, Country


Select [Order Date], Country, State, [Product Category], SUM(Sales) as TotalSales, SUM(Profit) as TotalProfits
From PortfolioProject..Sales
Group by [Order Date], Country, State, City, [Product Category]
Order by [Order Date], Country


Select [Order Date], Segment, [Product Category], Product, Sales
From PortfolioProject..Sales
Order by [Order Date], Segment, [Product Category]


Select [Order Date], [Product Category], SUM(Quantity) as Quantity, SUM(Profit)/SUM(Sales) as [Profit Ratio]
From PortfolioProject..Sales
Group by [Order Date], [Product Category]
Order by [Product Category], [Order Date]


Select ss.Country, ss.State, ss.City, ss.Segment, ss.[Product Category], ss.Product, 
COUNT(ss.Product) as ProductsReturnedNum, SUM(ret.[Sales Amount]) as RefundAmount
From PortfolioProject..Sales ss
JOIN PortfolioProject..Returns ret
	ON ss.[Order ID] = ret.[Order ID]
Group by ss.Country, ss.State, ss.City, ss.Segment, ss.[Product Category], ss.Product
Order by ProductsReturnedNum Desc


Select (Select COUNT(Product) From PortfolioProject..Sales) as TotalQty,
COUNT(ss.Product) as SOHQty, (Select COUNT(Product) From PortfolioProject..Sales)-COUNT(ss.Product)  as ActualQty,
SUM(ret.[Sales Amount]) as RefundAmount, 
SUM(ret.[Sales Amount])/(Select SUM(Sales) From PortfolioProject..Sales)*100 as RefundRatio
From PortfolioProject..Sales ss
JOIN PortfolioProject..Returns ret
	ON ss.[Order ID] = ret.[Order ID]
