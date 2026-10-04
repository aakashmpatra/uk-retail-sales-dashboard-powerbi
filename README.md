# **UK Retail Sales Dashboard (Power BI)**



An interactive four-page Power BI dashboard analysing UK online retail transactions from Dec 2010 to Nov 2011. It answers three questions:

* Where does the revenue come from?
* Which products drive it?
* How does it change over time?



I built this dashboard as a portfolio project to practise data modelling, DAX and dashboard storytelling. It has been built with SQL and Power BI Desktop with Data Modelling and DAX.



### **Dashboard Overview**



!\[Sales Overview](screenshots/sales\_overview.png)



#### **Key Insights**



**At a glance:** \*\* £8.37M revenue \*\*, \*\* 17,754 orders \*\*, \*\* 4.87M units sold \*\*, \*\* 4,297 customers \*\*, \*\* £471.44 average order value \*\*



**Note: Figures marked ≈ are read from the dashboard visuals and rounded.**

##### 

1. ###### **Revenue doubled from August to November, and the jump started in September**
* Monthly revenue held at ≈£0.4M to £0.7M from Dec 2010 to Aug 2011, then rose to ≈£1.0M in Sep and Oct and ≈£1.2M in Nov, double the Aug level.
* September was the biggest step (+47.6% MoM), followed by +8.9% in Oct and +11.6% in Nov. This is a sustained build and not a one-month spike.
* The last three months (Sep to  Nov) brought in ≈£3.2M, roughly 38% of the year's revenue.
* The first half was volatile, with MoM swinging from -21.5% in Feb to +44.6% in May.



###### **2. November's record came from order volume**

* Orders rose from ≈1,000 per month in Jan and Feb to ≈2,650 in Nov. Units sold rose from ≈0.27M (Feb) to ≈0.67M (Nov).
* In Sep and Oct, average order value (AOV) was well above the full-period average of £471, at ≈£540, while orders climbed. In Nov, orders peaked but AOV fell to ≈£435, so the peak month was volume-led, with smaller baskets.
* **So,** peak seasons bring more, smaller orders.



###### **3. The UK is 81% of revenue, but overseas orders are far larger**

* The UK generates £6.81M (81% of the revenue) from 15,940 customers and 3,886 orders, about 90% of all customers an orders. The next largest market (Germany)  has 440 orders and 93 customers.
* Overseas buyers make up only ≈10% of orders but ≈19% revenue.
* The Netherlands has the highest AOV at £3,008 followed by Australia (£2,429) and Japan (£1,969). It ranks second on revenue (£0.27M) from just 91 customers. It doesn't make into top 10 by customers, which means 11 or fewer customers account for the £0.27M.
* **This shows** Overseas customers look like bulk or wholesale buyers, so account management is likely o pay off more than mass marketing. Order counts are low so few large accounts can swing these averages.



###### **4. A reliable core of products drive sales, while some unit leaders are bulk buyers**

* **Best Sellers:** Regency cake stand 3 tier, White hanging heart T-light holder, Jumbo bag red retrospot make top 3 in both  total revenue and total orders, which signals repeat demand from customers.
* **Bulk driven leaders:** Medium Ceramic top storage jar is #1 on units (78k) and #4 on revenue (£81k), yet sits outside the top 10 by orders. The same pattern is followed by World war 2 glider asstd designs. The pattern signals to very large orders of low priced items.
* **Hence,** ranking by order count alongside revenue and units separates dependable products from bulk one-offs while planning inventory.



###### **5. Revenue is spread across a long tail, not concentrated in a few products.**

* The top 10 products total ≈£0.74M, only ≈9% of the total £8.37M. Revenue falls steeply over the first handful of products, then flattens into a long tail.
* **So,** there is low dependence on any single product, which reduces risk. It also means the tail matters collectively, so range cuts should be based on margin and repeat-order data than revenue rank alone.



### **Dashboard Pages**



#### **Sales Overview**



Headline KPIs, the monthly revenue trend, and the top 5 countries and products.



!\[Sales Overview](screenshots/sales\_overview.png)





#### **Geography**



Revenue, orders, customers and average order value by country.



!\[Geography](screenshots/geography.png)





#### **Products**



Total revenue, units sold and orders along with a revenue concentration chart.



!\[Products](screenshots/products.png)





#### **Time Trend**



Monthly revenue with MoM growth, orders, units sold and average order value.



!\[Time Trend](screenshots/time\_trend.png)





#### **Data**



**Source  :** [**Online Retail Dataset**](https://www.kaggle.com/datasets/ulrikthygepedersen/online-retail-dataset)

**Period  : Dec 2010 to Nov 2011. Dec 2011 is excluded because it is an incomplete month and would distort the trend.**

**Currency: GBP (£)**





#### **Cleaning Steps**



* Removed cancellation invoices.
* Handled missing CustomerID, negative prices and duplicates.
* Excluded Nov 2011 (incomplete month).





#### **Data Model**

|**TABLE**|**PURPOSE**|
|-|-|
|retail|Transaction level fact table|
|DateTable|Calendar table used for month-level analysis|
|\_measures|Dedicated table holding all DAX measures|





**A one-to-many relationship relates the DateTable and retail\[InvoiceDate].**





#### **Tools and Skills**



* **Power BI Desktop:** Report design, Page Navigation, formatting
* **DAX:** Time intelligence (MoM growth), ratio measures (AOV), cumulative % for concentration analysis
* **Data Modelling:** Data table, separate measures table
* **Data Storytelling:** Turning visuals into findings with business applications
* **SQL:** Initial data quality checks, data cleaning, anomaly handling, kpi analysis





#### **Key Measures (DAX)**



* **Total Revenue =** SUMX(retail, retail\[Quantity]\*retail\[UnitPrice])
* **Total Orders =** DISTINCTCOUNT(retail\[InvoiceNo])
* **Average Order value =** DIVIDE(\[Total Revenue], \[Total Orders])
* **Cumulative Revenue =** VAR CurrentRevenue=\[Total Revenue]

&#x20;                   RETURN

&#x20;                   CALCULATE(

&#x20;                   \[Total Revenue],

&#x20;                   FILTER(ALL(retail\[Description]), \[Total Revenue] >= CurrentRevenue))

* **Cumulative revenue % =** DIVIDE(\[Cumulative Revenue], CALCULATE(\[Total Revenue], ALL(retail\[Description])))
* **MoM Revenue Growth % =** 

&#x20;           VAR CurrentRevenue = \[Total Revenue]

&#x20;           VAR PreviousRevenue = 

&#x20;               CALCULATE(\[Total Revenue], DATEADD(DateTable\[Date], -1, MONTH))

&#x20;               RETURN

&#x20;          DIVIDE (CurrentRevenue - PreviousRevenue, PreviousRevenue)





#### **Notes and Limitations**



* **Non-merchandise items: "**Postage" and "Manual" appear in the product rankings. They are intentionally left in the data to consider in shipping revenue.
* **Average Order Value by country:** is based on small order counts for non-UK markets, so it is sensitive to a few large orders.
* **Axes:** Some y-axes do not start with zero (Units Sold starts at 0.3M, AOV spans £400 to £500). This improves readability but makes changes look steeper than they are.
* **Seasonality:** With 12 months of data, the autumn surge is consistent with seasonal demand but cannot be confirmed without a second year.
* **Scope:** The insights describe what happened, not why. Promotions and Customer Acquisition data are not in the dataset.





#### **Repository Structure**

* **README.md**
* **dashboard**   #.pbix file
* **screenshots** # PNG of each dashboard page
* **sql**         # SQL files of initial checks, data cleaning and kpi analysis





#### **Author**



Aakash Mohapatra | [LinkedIn](https://www.linkedin.com/in/a-mpatra/) | akpatra1595@gmail.com







