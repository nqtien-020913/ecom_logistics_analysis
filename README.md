# 📈ECOMMERCE LOGISTICS ANALYSIS

## 1. Project Background

### 1.1. Situation

The **e-commerce industry** is experiencing rapid growth, and **delivery efficiency** plays a crucial role in **customer satisfaction** and **competitive advantage**. However, many e-commerce companies face challenges in optimizing their delivery process due to high costs, inconsistent delivery times, and external factors such as geography and weather conditions.

Imagine you are a **data analyst** at an **e-commerce logistics company**. The company is **implementing a strategy to enhance overall delivery service quality**. To achieve this, it must leverage **business data** to identify key issues affecting delivery performance and **develop effective solutions**.

### 1.2. Objective
- **Comprehensively evaluate the company’s delivery performance.**
- **Analyze the key factors impacting delivery efficiency** and **provide data-driven recommendations** to support future strategic improvements.

> 📊The ecom_logistics_db.bacpac can be downloaded [here](https://drive.google.com/file/d/1y3K9Xfnw5U071UXy_VwFf0s8EGuDerse/view?usp=sharing).

> 📊The SQL queries utilized to inspect and perform quality checks can be found [here](https://github.com/nqtien-020913/ecom_logistics_analysis/blob/main/SQL_ecom_logistic_cleaning.sql).

> 📊Targeted SQL queries regarding various business questions can be found [here](https://github.com/nqtien-020913/ecom_logistics_analysis/blob/main/SQL_ecom_logistic_analyzing.sql).

## 2. Data Structure and Related Metrics

### 2.1. Data Structure

Ecommerce logistic database as seen below consists of five tables: _orders, review, product, shipper & location_, with a total row count of **49,996 records**.

![image](https://github.com/user-attachments/assets/75cea9ce-071f-49f3-b6ba-947d801e4d2c)

Prior to beginning the analysis, a variety of checks were conducted for quality control and familiarization with the datasets. The SQL queries utilized to inspect and perform quality checks can be found [here](https://github.com/nqtien-020913/ecom_logistics_analysis/blob/main/SQL_ecom_logistic_cleaning.sql).

### 2.2. Data Metrics and Definitions

During the analysis process, various terms have been defined to ensure consistency in information and facilitate analysis. Below is a summary of all the terms used.

**Order Metrics**

| Data Metrics | Definitions |
|-------|-------|
| n_orders  | Total number of orders placed by customers.  |
| n_orders_completed | Total number of orders successfully delivered to customers.   |
| n_orders_ontime | Total number of orders delivered within the promised time frame. |
| n_orders_late | Total number of orders delivered beyond the expected delivery time. |

**Delivery Time Breakdown**

| Data Metrics | Definitions |
|-------|-------|
| total_delivery_time | The total time taken from order placement to successful delivery. |
| seller_time | The time from order placement to seller confirmation. |
| pickup_time | The time from seller confirmation to package pickup by the shipping provider. |
| transit_time | The time from package pickup to its arrival at a distribution center near the customer. |
| delivering_time | The time from the distribution center to the final delivery to the customer. |
| time_required | The estimated time frame for order fulfillment. Any order exceeding this time is considered late. |

**Customer Feedback Metrics**

| Data Metrics | Definitions |
|-------|-------|
| review_rate | The percentage of orders that received customer reviews out of the total orders. |
| avg_score | The average rating given by customers for an order. |
| negative_rate | The percentage of orders that received negative reviews. Distribution of customer ratings from 5 and below. |
| positive_rate | The percentage of orders that received positive reviews. Distribution of customer ratings from 8 to 10. |
| neutral_rate | The percentage of orders that received neutral reviews. Distribution of customer ratings from 6 to 7. |

## 3. Executive Summary

Overall, the company's delivery performance remains suboptimal, and there has been no significant improvement in overall delivery efficiency over time (see **Figures 1 and 2**). Specifically:

- The number of orders placed in 2023 decreased by **13%** compared to 2022 (**calculated based on the time range from May 1 to December 31 for both years, as full-year data for 2022 is unavailable**).

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/0471a1e0-2af8-40e2-a773-9a0ac9c361a1)
  
  **Figure 1:** Comparison of total orders in 2022 and 2023

</div>

- The **order completion rate** remains at an average of **80%**, with no signs of improvement.
- The **on-time delivery rate** is only around **40%** on average, with no significant enhancements.
- The **average delivery time** per order is **113 hours** (equivalent to **4.7 days**).
- On average, **36%** of orders receive customer reviews, with **21%** of them being **negative**.
- The average customer rating is around **5/10**, with only minimal improvement over time.
- Worse still, during peak periods, order volume surges by **2-3 times**, significantly impacting overall performance (See **Figures 3**).

<div align="center">
  
  ![decrease 13% (3)](https://github.com/user-attachments/assets/b623f801-97e5-409d-b587-5f0316546b53)
  
  **Figure 2:** Comparison of delivery performance metrics in 2022 and 2023

  ![image](https://github.com/user-attachments/assets/14357c9e-b9b4-4b5a-91cf-1d62078b21ae)

  **Figure 3:** Trends in n_orders, n_orders_completed, and n_orders_ontime

</div>

> 📊Targeted SQL queries regarding various business questions can be found [here](https://github.com/nqtien-020913/ecom_logistics_analysis/blob/main/SQL_ecom_logistic_analyzing.sql).

## 4. Insight Deep-Dive

After an in-depth analysis of the data, we identified **two key issues** behind the company's poor performance and lack of growth: **(1) No strategy to attract new customers**, and **(2) High customer churn** (as shown in **Figure 4**).

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/5a31c510-3b7a-4acc-8137-4b723f2d60c9)

  **Figure 4:** Customer Cohort Analysis for 2022 and 2023

</div>

- **Lack of New Customer Acquisition (Refer to the "New Customer" Column):**
Throughout both 2022 and 2023, the number of new customers acquired declined significantly. Additionally, the 2023 trend shows a much lower new customer acquisition rate compared to 2022.
- **High Customer Churn (Refer to Columns ‘1’ and Beyond):**
The customer retention rate remained low, ranging only from **13% to 21%** across most months. The only exception was during major shopping events in November and December, when retention temporarily increased to **33% to 47%**.
- **Key Reasons for Low Customer Retention:**
Several factors contribute to poor retention, with four critical reasons negatively impacting customer experience and brand loyalty (See **Figure 5**):
  - The delivery process is not optimized
  - Product quality issues
  - Subpar customer service
  - Inability to manage sudden order surges (**2–3x normal volume**) effectively (see **Section 4.4** for details).
 
<div align="center">
  
  ![decrease 13% (2)](https://github.com/user-attachments/assets/54dc0a0b-6ab8-4cf9-afe8-7e4782e68ecb)

  **Figure 5:** Negative issues highlighted in customer reviews

</div>

## 4.1. In-Depth Analysis of the Delivery Process

The delivery process has three main issues causing customer dissatisfaction (see **Figure 6**):
1. **Packaging stage:** Poor packaging quality and unappealing presentation.
2. **Transit stage:** Product damage due to handling between warehouses.
3. **Delivery time:** Slow delivery times negatively impacting the shopping experience.

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/5ed13d81-3c81-47e5-bb07-c50487d1bdd1)

  **Figure 6:** Customer Negative Feedback

</div>

There is **insufficient data** to analyze **packaging and transit issues** in detail. Therefore, **this section focuses on the reasons behind late deliveries**. Out of **40,077** completed orders, **19,812** were delayed.

**Key Reasons for Delivery Delays:**

1. **Inefficient transit process:** The transfer of products from stores to warehouses near customers takes excessive time, **causing 46% of total late orders**. Specifically:

    - **3,064 orders** were already delayed before reaching the **delivery stage**.
    - **6,039 orders** required shipping **within 24 hours** but were delayed, likely due to operational inefficiencies.

2. **Low delivery efficiency among shippers:** 149 out of 155 shippers handled fewer than two orders per day. The average delivery time per order was **at least 52 hours** (**more than two days**) (see **Figure 7**).

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/48fec5ed-24e2-4c8f-9c5a-afd29bd1884a)

  **Figure 7:** Shipper delivery time distribution for those handling fewer than two orders per day

</div>

3. **The company's delivery operations are inefficient:** Orders with longer delivery time requirements (**high time_required**) are prioritized for early delivery (**very low delivering_time**), while orders with tighter deadlines (**low time_required**) are delayed (**very high delivering_time**). As a result, on-time orders (**n_orders_ontime**) are delivered too early, whereas late orders (**n_orders_late**) experience significant delays. This pattern is clearly illustrated in **Figure 8** below.

<div align="center">
  
  ![decrease 13% (4)](https://github.com/user-attachments/assets/8b8d1f17-4afd-465e-b273-20320f1983d7)

  **Figure 8:** Comparison of time_required and delivering_time for on-time and late orders.

</div>

### 4.2. In-Depth Analysis of Product Quality

The following product quality issues need to be addressed:
- Poor product appearance
- Products not matching descriptions
- Extremely low product quality

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/65bb1474-0870-4359-94c0-21797015b2a1)

  **Figure 9:** Customer Negative Feedback

</div>

These issues are most prevalent in the Fashion, Beauty, and Home categories, which are also the company's top revenue-generating product lines. The company must pay close attention to customer feedback to develop better product strategies (see **Figure 10**).

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/4ca15b45-b662-410d-bc92-fc01336313c2)

  **Figure 10:** Distribution of Negative Customer Feedback by Product Category

</div> 

### 4.3/. Analysis of Customer Service

While customer service issues account for a small percentage of total orders (around 3.1%), improving this area will enhance the company's overall service quality and create a long-term competitive advantage.

### 4.4/. Analysis of Order Volume Risk Management

The overall efficiency of the delivery process is significantly impacted when order volumes surge **2-3 times** higher than usual.

<div align="center">
  
  ![decrease 13% (6)](https://github.com/user-attachments/assets/3a35cd66-4538-4b98-8b67-756e16bdd768)
  
  **Figure 11:** Trends of Key Metrics from May 2022 to December 2023

</div> 

During November, December 2022, and early January 2023, order volumes spiked due to major shopping events. November saw high demand during **"Double-Eleven" Day (11/11)** and **Black Friday sales (see Figure 12)**. In December and January, orders surged in preparation for Lunar New Year.

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/d28bec1f-0a4d-4fb5-83b4-624bf5533735)

  **Figure 12:** Order Volume Fluctuations in November 2022

</div> 

During these **peak periods**, consumer purchasing activity increases sharply. However, the company lacked **strategies and risk management solutions** to handle the demand surges. As a result, nearly all key delivery performance indicators deteriorated significantly.

## 5. Recommendation

### 5.1. Enhancing Delivery Efficiency

Optimizing all stages of the overall delivery process:
- **Packaging Process:** Conduct training sessions for staff to improve both speed and quality in packaging.
- **Transportation Process:** Improve or redesign sorting procedures, optimize delivery routes, and, if necessary, expand the fleet to increase transportation capacity.
- **Last-Mile Delivery:** Prioritize orders with tighter delivery deadlines, optimize order allocation to shippers, train delivery personnel on efficient routes, and implement motivation programs to boost their performance.

### 5.2. Improving Product Quality

Collaborate with stores to identify product issues and support them in enhancing product quality to better align with customer needs and expectations.

### 5.3. Risk Management
- Develop risk management strategies, especially for peak seasons when order volumes surge 2-3 times higher than usual.
- Build a data analytics system to forecast order spikes in advance.
- Implement solutions for temporary staffing to handle short-term order surges efficiently.

### 5.4. Enhancing Customer Service

Although customer service is not a critical issue at present, it will be a key factor in long-term customer retention. The company should proactively consider improvements in this area for future growth.

