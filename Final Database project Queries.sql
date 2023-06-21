-- Q1). Top 5 customers who spent the most cash in the store? 
Select customercart.customerId, customercart.customername, sum(TotalAmount) as cash_Spent from customercart
	Join transactions
    on customercart.CustomerID=transactions.CustomerCart_CustomerID
group by CustomerCart_CustomerID
order by sum(TotalAmount) desc
Limit 5;

-- Q2). What is the annual value and quantity of products sold also taxes Paid?
select year(transaction_date), sum(Quantity) as No_of_Items_Sold, sum(TotalAmount) as Value_of_Products_Sold, sum(Taxes) as TaxesPaid 
from transactions
group by year(transaction_date)
order by Value_of_Products_Sold desc;

-- Q3). What are the top ten most popular items in terms of price and quantity?(Product Performance Report)
-- a) By Price
Select transactions.Products_ProductID, products.ProductName, Sum(transactions.TotalAmount) as Value from transactions
 join products
 on products.ProductID=transactions.Products_ProductID
Group by transactions.Products_ProductID
order by value desc
Limit 10;
-- B) By Quantity
Select transactions.Products_ProductID, products.ProductName, Sum(transactions.Quantity) as TotalQuantity from transactions
 join products
 on products.ProductID=transactions.Products_ProductID
Group by transactions.Products_ProductID
order by TotalQuantity desc
Limit 10;

-- Q4). Which cashier has attended most no of customers.
Select  Cashier.CashierName as Cashier, Count(Distinct transactions.CustomerCart_CustomerID) as CustomerAttended from cashier
Join transactions
On cashier.CashierID=transactions.Cashier_CashierID
Group By Cashier_CashierID
Order by CustomerAttended desc;

-- Q5). How many products are there in each category and What is value of stock inHand?
Select Category, SubCategory, Count(ProductName)as ProductCount,sum(ProductStock*Price) as Value  
from category join products
ON category.CategoryID=products.Category_CategoryID
Group by Category,SubCategory
Order By Category, ProductCount desc;

-- Q6). Which Payment method is used to pay according to Product category? 
Select Payment_Method,Category ,  Count(Payment_Method) as Transaction_Count 
 from transactions Join (Products Join category
	On category.CategoryID=products.Category_CategoryID)
 on transactions.Products_ProductID=products.ProductID
Group By category,Payment_Method
order by Payment_Method;

-- Q7). sales report for past 7 days
Select Transaction_date,count(quantity) as ItemsSold,Sum(TotalAmount) as Todaysales,sum(Taxes) as Taxes,Sum(DiscountPrice) as Discount, Count(Distinct CustomerCart_CustomerID) As CustomerCount
FROM transactions
Where Transaction_date  between  '2016-01-20' and '2016-01-27'  
Group by Transaction_date;
 
-- Q8). Five Most selling products by month?
Select Month, Products_ProductID, ProductName, TotalQuantity from (
Select month(transaction_date) As Month, transactions.Products_ProductID, products.ProductName, Sum(transactions.Quantity) as TotalQuantity, 
rank() over (partition by month(transaction_date) order by Sum(transactions.Quantity) desc) as Max_Quant
	from transactions
	join products
	on products.ProductID=transactions.Products_ProductID
	Group by transactions.Products_ProductID
	order by month , TotalQuantity desc) as tmp 
    where max_quant<=5;