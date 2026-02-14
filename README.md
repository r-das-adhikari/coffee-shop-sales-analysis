# ☕ Coffee Shop Sales Analysis

## 📊 Project Overview
Comprehensive SQL analysis of **149,116 transactions** from a NYC-based coffee shop chain to uncover sales patterns, product performance, and operational insights for data-driven decision making.

## 🎯 Objectives
- Analyze revenue trends across stores and product categories
- Identify peak sales hours and days for optimal staffing
- Discover top-performing products and customer preferences
- Segment customers by transaction value
- Forecast future revenue using time-series analysis

## 🛠️ Tech Stack
- **Database:** MySQL 8.0
- **Techniques:** Window Functions, CTEs, Subqueries, Aggregations
- **Concepts:** Customer Segmentation, Cohort Analysis, ABC Classification, Moving Averages

## 📊 Dataset
The dataset contains **149,116 transactions** from January to June 2023, including:
- Transaction details (date, time, quantity)
- Product information (category, type, price)
- Store location data
- Calculated revenue metrics

**File:** `data/coffee-shop-sales-revenue.csv`

**Key Columns:**
- `transaction_id`, `transaction_date`, `transaction_time`
- `store_id`, `store_location`
- `product_category`, `product_type`, `product_detail`
- `unit_price`, `transaction_qty`, `revenue`

## 📁 Repository Structure
```
coffee-shop-sales-analysis/
├── data/
│   └── coffee-shop-sales-revenue.csv       # Raw dataset
├── sql/
│   ├── 01_database_setup_and_cleaning.sql  # Database creation & data prep
│   ├── 02_basic_analysis.sql               # Core business metrics
│   ├── 03_advanced_analysis.sql            # Rankings & product mix
│   ├── 04_window_functions.sql             # Time-series & moving averages
│   ├── 05_strategic_analytics.sql          # Segmentation & forecasting
│   └── 06_dashboard_views.sql              # Reusable SQL views
├── results/                                 # Analysis outputs
└── README.md
```

## 🔍 Key Insights

### 📈 Revenue Performance
- **Total Revenue:** $698,812.33
- **Total Transactions:** 149,116
- **Average Transaction Value:** $4.69

### 🏪 Top Performing Store
- **Lower Manhattan** leads with highest revenue
- Peak hours: **8-10 AM** (morning rush)
- Best day: **Friday**

### ☕ Product Insights
- **Coffee** drives 60% of total revenue
- **Tea** contributes 25% of revenue
- **Bakery** items account for 15%

### 👥 Customer Behavior
- **High-Value Customers:** 15% of transactions generate 45% of revenue
- **Multi-Category Purchases:** 12% of transactions include 2+ product categories
- **Peak Traffic:** Morning hours (7-10 AM) account for 45% of daily sales

## 📈 SQL Techniques Demonstrated

### Basic Analytics
- ✅ Aggregations (SUM, AVG, COUNT, MIN, MAX)
- ✅ GROUP BY with multiple dimensions
- ✅ Subqueries for complex calculations
- ✅ HAVING clause for filtered aggregations

### Advanced Analytics
- ✅ **Window Functions:** RANK(), DENSE_RANK(), ROW_NUMBER()
- ✅ **Moving Averages:** 3-day and 7-day smoothing
- ✅ **CTEs (Common Table Expressions):** Multi-step analysis
- ✅ **PARTITION BY:** Store and category-level rankings
- ✅ **LAG/LEAD:** Month-over-month comparisons

### Business Intelligence
- ✅ **Customer Segmentation:** Low/Medium/High value classification
- ✅ **Cohort Analysis:** Product lifecycle tracking
- ✅ **ABC Analysis:** Pareto 80/20 principle
- ✅ **Forecasting:** Trend-based revenue prediction
- ✅ **Basket Analysis:** Multi-item purchase patterns

## 🚀 How to Use

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/coffee-shop-sales-analysis.git
cd coffee-shop-sales-analysis
```

### 2. Setup Database
```sql
-- Run the setup script
source sql/01_database_setup_and_cleaning.sql
```

### 3. Import Data
- Load `data/coffee-shop-sales-revenue.csv` into the `coffee_shop_sales` table
- Use your SQL tool's import wizard (MySQL Workbench, DBeaver, etc.)

### 4. Run Analysis Queries
Execute SQL files in order:
```sql
source sql/02_basic_analysis.sql
source sql/03_advanced_analysis.sql
source sql/04_window_functions.sql
source sql/05_strategic_analytics.sql
source sql/06_dashboard_views.sql
```

## 📊 Sample Queries

### Top 10 Products by Revenue
```sql
SELECT 
    product_detail,
    SUM(transaction_qty) AS total_sold,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_detail
ORDER BY total_revenue DESC 
LIMIT 10;
```

### Peak Hours Analysis
```sql
SELECT 
    hour,
    COUNT(*) AS transactions,
    ROUND(SUM(revenue), 2) AS revenue
FROM coffee_shop_sales
GROUP BY hour
ORDER BY hour;
```

### Store Performance Ranking
```sql
SELECT 
    store_location,
    product_category,
    RANK() OVER(PARTITION BY store_id ORDER BY SUM(revenue) DESC) AS rank
FROM coffee_shop_sales
GROUP BY store_location, product_category;
```
## 📊 Interactive Power BI Dashboard

Visualized key insights using Power BI for interactive data exploration and stakeholder presentation.

### Dashboard Overview

The dashboard consists of 4 comprehensive pages:

1. **Executive Summary** - KPIs, revenue trends, store and category performance
2. **Product Performance** - Product analysis, top sellers, category breakdown
3. **Time Analysis** - Hourly patterns, daily trends, temporal insights
4. **Store Comparison** - Location-based performance metrics

### Files

- **Power BI File:** [`dashboard/coffee_shop_dashboard.pbix`](dashboard/coffee_shop_dashboard.pbix)
- **PDF Export:** [`dashboard/coffee_shop_dashboard.pdf`](dashboard/coffee_shop_dashboard.pdf)
- **Screenshots:** Available in [`results/`](results/) folder

### Dashboard Preview

#### Page 1: Executive Summary
![Executive Summary](results/dashboard_page1_executive.png)

#### Page 2: Product Performance
![Product Performance](results/dashboard_page2_products.png)

*Download the .pbix file to interact with filters, drill-downs, and explore the data dynamically.*

### Key Features

- ✅ **Interactive Filters:** Date range, store location, product category
- ✅ **Dynamic Visualizations:** Charts update based on user selections
- ✅ **Multiple Views:** 4 comprehensive analytical perspectives
- ✅ **Professional Design:** Coffee-themed color scheme and clean layout
- ✅ **Data-Driven Insights:** Clear metrics and KPIs for decision-making

## 💡 Business Recommendations

### Operational Improvements
1. **Staffing Optimization:** Increase staff during 8-10 AM peak hours
2. **Inventory Management:** Stock 40% more coffee products on Fridays
3. **Promotional Strategy:** Run afternoon specials (3-5 PM) to boost slower periods

### Strategic Initiatives
1. **Expand Coffee Menu:** Focus on high-margin specialty coffee items
2. **Customer Loyalty Program:** Target high-value customer segment (top 15%)
3. **Product Bundling:** Promote coffee + pastry combo deals

### Growth Opportunities
1. **Seasonal Products:** Introduce limited-time seasonal beverages
2. **Off-Peak Promotions:** Create "study hour" deals for 2-4 PM window
3. **Location Expansion:** Replicate Lower Manhattan success model

## 🎓 Skills Demonstrated
- Complex SQL query design and optimization
- Database design and data modeling
- Business metrics calculation and KPI tracking
- Time-series analysis and forecasting
- Customer analytics and segmentation
- Data-driven insights and recommendations

## 📫 Contact
**Your Name**  
📧 Email: rdasadhikari5007@gmail.com  
💼 LinkedIn: www.linkedin.com/in/ramkrishna-dasadhikari-7b0021381 
🌐 Portfolio: [your-website.com](https://your-website.com)

## 📄 License
This project is open source and available under the [MIT License](LICENSE).


---

⭐ **If you found this analysis helpful, please consider starring the repository!**

💬 **Questions or feedback?** Feel free to open an issue or reach out directly.
