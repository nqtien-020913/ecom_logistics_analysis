# ECOMMERCE LOGISTICS ANALYSIS

## 1. Project Background

### 1.1. Situation

The **e-commerce industry** is experiencing rapid growth, and **delivery efficiency** plays a crucial role in **customer satisfaction** and **competitive advantage**. However, many e-commerce companies face challenges in optimizing their delivery process due to high costs, inconsistent delivery times, and external factors such as geography and weather conditions.

Imagine you are a **data analyst** at an **e-commerce logistics company**. The company is **implementing a strategy to enhance overall delivery service quality**. To achieve this, it must leverage **business data** to identify key issues affecting delivery performance and **develop effective solutions**.

### 1.2. Objective
- **Comprehensively evaluate the company’s delivery performance.**
- **Analyze the key factors impacting delivery efficiency** and **provide data-driven recommendations** to support future strategic improvements.

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

Customer Feedback Metrics

| Data Metrics | Definitions |
|-------|-------|
| review_rate | The percentage of orders that received customer reviews out of the total orders. |
| avg_score | The average rating given by customers for an order. |
| negative_rate | The percentage of orders that received negative reviews. Distribution of customer ratings from 5 and below. |
| positive_rate | The percentage of orders that received positive reviews. Distribution of customer ratings from 8 to 10. |
| neutral_rate | The percentage of orders that received neutral reviews. Distribution of customer ratings from 6 to 7. |

## 3. Executive Summary

Overall, the company's delivery performance remains suboptimal, and there has been no significant improvement in overall delivery efficiency over time (see **Figures 1 and 2**). Specifically:

- The number of orders placed in 2023 decreased by 13% compared to 2022 (**calculated based on the time range from May 1 to December 31 for both years, as full-year data for 2022 is unavailable**).

<div align="center">
  
  ![image](https://github.com/user-attachments/assets/0471a1e0-2af8-40e2-a773-9a0ac9c361a1)
  
  **Figure 1:** So sánh tổng số đơn hàng 2022 và 2023

</div>

- The order completion rate remains at an average of 80%, with no signs of improvement.
- The on-time delivery rate is only around 40% on average, with no significant enhancements.
- The average delivery time per order is 113 hours (equivalent to 4.7 days).
- On average, 36% of orders receive customer reviews, with 21% of them being negative.
- The average customer rating is around 5/10, with only minimal improvement over time.
- Worse still, during peak periods, order volume surges by 2-3 times, significantly impacting overall performance.
