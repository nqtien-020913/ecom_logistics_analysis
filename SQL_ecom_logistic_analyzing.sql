-- DATA ANALYZING

-- Assessment Delivery Performance

-- date timerange
Select MIN(purchase_time)
    , MAX(purchase_time)
FROM orders
-- Dữ liệu có timeline từ (01.05.2022 - 31.12.2023)

-- 1/. Business Performance (number of orders)

-- 1.1/. Overview
Select left([month],4) as [year]
    , count(order_id) as n_orders
    , Cast(count(delivery_time) as float)/count(order_id) as rate_orders_completed
    , cast(sum(case when delivery_time is null then 0
        when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 0
        else 1
    end) as float)/count(order_id) as rate_orders_success
from orders
where purchase_time between '2022-05-01' and '2023-01-01'
    or purchase_time >= '2023-05-01 00:00:00'
GROUP by left([month],4)

select 18665.00/21342.00 - 1

Select left([month],4) as [year]
    , count(order_id) as n_orders
    , Cast(count(delivery_time) as float)/count(order_id) as rate_orders_completed
    , cast(sum(case when delivery_time is null then 0
        when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 0
        else 1
    end) as float)/count(order_id) as rate_orders_success
from orders
GROUP by left([month],4)


-- Nhận xét:
-- Năm 2023 có số đơn tăng trường 34% so với năm 2022. Tuy nhiên năm 2022 chỉ tính từ ngày 1 tháng 5 năm 2022
-- Tuy nhiên, tỷ số đơn đã hoàn thành và được giao đúng giờ không có sự thay đổi đáng kể.
-- completed vẫn giữ mức 80%
-- success tăng chưa tới 1%

-- 1.2/. Trendline analytics
Select [month]
    , count(order_id) as n_orders
    , Cast(count(delivery_time) as float)/count(order_id) as rate_orders_completed
    , cast(sum(case when delivery_time is null then 0
        when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 0
        else 1
    end) as float)/count(order_id) as rate_orders_success
from orders
GROUP by [month]
ORDER BY [month]
-- Theo thời gian, rate_orders_completed và rate_orders_success giữ ổn định ở mức trung bình
-- Tuy nhiên, vào thời điểm mua sắp cuối năm đón Tết (tháng 11, 12 và 1) số lượng đơn hàng tăng khiến rate_orders_success giảm đáng kể
-- Từ đa số từ 40-45% giảm còn 34-37%.
-- rate_orders_completed cũng giảm nhẹ tại khoảng thời gian này.
-- về n_orders, cũng khá đều giữa các tháng (trừ thời điểm cuối năm tăng vọt) ==> Chứng tỏ, hiểu quả kinh doanh không tăng.

-- 2/. Assessment ability of leveraging resources

-- 2.1/. Overview
Select left([month],4) as [year]
    , cast(sum(case when delivery_time is null then null
        else datediff(hour,purchase_time,delivery_time)
    end) as float)/count(delivery_time) as avg_total_delivery_time
    , count(distinct shipper_id) as n_shippers
    , Cast(count(delivery_time) as float)/count(distinct shipper_id) as shipper_productive
from orders
GROUP by left([month],4)
-- Thời gian giao hàng trung bình năm 2022 có giảm nhưng không đáng kể ở năm 2023

-- 2.2/. Trendline
Select [month]
    , count(delivery_time) as n_orders_completed
    , cast(sum(case when delivery_time is null then null
        else datediff(hour,purchase_time,delivery_time)
    end) as float)/count(delivery_time) as avg_total_delivery_time
    , count(distinct shipper_id) as n_shippers
    , Cast(count(delivery_time) as float)/count(distinct shipper_id) as shipper_productive
from orders
GROUP by [month]
ORDER BY [month];
-- Nhận xét:
-- Thời gian giao hàng trung bình của các tháng thông thường giao động từ 105-111 hours
-- Thời gian giao hàng trung bình của các tháng cao điểm giao động từ 120-124 hours. Tức chậm hơn 1/2 - 1 ngày.

-- 2.2.1/. 

-- Trung bình thời gian các đơn giao ontime???
with table_time as
    (select [month]
        , case when delivery_time is null then null
            when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 'late'
            else 'ontime'
        end as is_ontime
        , case when delivery_time is null then null
            else cast(datediff(hour,purchase_time,delivery_time) as float)
        end as total_delivery_time
    FROM orders)
select [month]
    , sum(total_delivery_time)/count(total_delivery_time) as avg_total_delivery_time
from table_time
WHERE is_ontime = 'ontime'
group by [month]
ORDER BY [month];
-- Giao hàng đúng giờ trung bình từ 81 - 84 tiếng

-- Trung bình thời gian các đơn giao late???
with table_time as
    (select [month]
        , case when delivery_time is null then null
            when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 'late'
            else 'ontime'
        end as is_ontime
        , case when delivery_time is null then null
            else cast(datediff(hour,purchase_time,delivery_time) as float)
        end as total_delivery_time
        , purchase_time
        , estimated_delivery_time
    FROM orders)
select [month]
    , sum(total_delivery_time)/count(total_delivery_time) as avg_total_delivery_time
from table_time 
WHERE is_ontime = 'late'
group by [month]
ORDER BY [month]
-- Giao hàng đúng giờ trung bình từ 130 - 157 tiếng, hơn giao hàng đúng giờ khoảng 2-3 ngày

with table_time as
    (select [month]
        , case when delivery_time is null then null
            when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 'late'
            else 'ontime'
        end as is_ontime
        , case when delivery_time is null then null
            else cast(datediff(hour,purchase_time,delivery_time) as float)
        end as total_delivery_time
        , purchase_time
        , estimated_delivery_time
    FROM orders)
select [month]
    , sum(total_delivery_time)/count(total_delivery_time) as avg_total_delivery_time
    , sum(cast(DATEDIFF(hour,purchase_time,estimated_delivery_time) as float))/count(total_delivery_time) as time_required
from table_time 
WHERE is_ontime = 'late'
group by [month]
ORDER BY [month];

-- Tính thời gian giao hàng trung bình khi ontime/late
with table_time as
    (select [month]
        , case when delivery_time is null then null
            when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 'late'
            else 'ontime'
        end as is_ontime
        , case when delivery_time is null then null
            else cast(datediff(hour,purchase_time,delivery_time) as float)
        end as total_delivery_time
        , purchase_time
        , estimated_delivery_time
    FROM orders)
select sum(total_delivery_time)/count(total_delivery_time) as avg_total_delivery_time
    , sum(cast(DATEDIFF(hour,purchase_time,estimated_delivery_time) as float))/count(total_delivery_time) as time_required
from table_time 
WHERE is_ontime = 'ontime'
-- Hiện tượng lạ:
-- (1) Khi đơn ontime, time_required trung bình khoảng 130 hours trong khi avg_total_delivery_time khoảng 81 hours
-- (2) Khi đơn late, time_required trung bình khoảng 85 hours trong khi avg_total_delivery_time khoảng 141 hours





-- 3/. Customer Experience

-- 3.1/. score
with table_review as
    (select orders.order_id
        , review_id
        , score
        , [description]
        , [month]
        , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    from orders
    left join review on orders.order_id = review.order_id)
select left([month],4) as [year]
    , avg(cast(score as float)) as avg_score
    , cast(count(review_id) as float)/count(order_id) as review_rate
from table_review
group by left([month],4);
-- Điểm đánh giá trung bình và tỷ lệ KH review 2022 và 2023 không có nhiều sự thay đổi khoảng 36%.

with table_review as
    (select orders.order_id
        , review_id
        , score
        , [description]
        , [month]
        , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    from orders
    left join review on orders.order_id = review.order_id)
select [month]
    , avg(cast(score as float)) as avg_score
    , cast(count(review_id) as float)/count(order_id) as review_rate
from table_review
group by [month]
order by [month];
-- avg_score giao động trung bình 5.0 qua các tháng, ổn định, khong có xu hướng tăng/hoặc giảm
-- review_rate tương tự dao động quanh 36-37%.

-- 3.2/. Review_group
with table_review as
    (select orders.order_id
        , review_id
        , score
        , [description]
        , [month]
        , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    from orders
    left join review on orders.order_id = review.order_id)
select 
    cast(sum(case when review_group = 'negative' then 1 else 0 end) as float)/count(order_id) as negative_rate
    , cast(sum(case when review_group = 'positive' then 1 else 0 end) as float)/count(order_id) as positive_rate
    , cast(sum(case when review_group = 'neutral' then 1 else 0 end) as float)/count(order_id) as neutral_rate
from table_review;
-- So với 2022, 2023 có tăng nhẹ tỷ lệ review tích cực và giảm nhẹ tỷ lệ review tiêu cực

with table_review as
    (select orders.order_id
        , review_id
        , score
        , [description]
        , [month]
        , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    from orders
    left join review on orders.order_id = review.order_id)
select [month]
    , cast(sum(case when review_group = 'negative' then 1 else 0 end) as float)/count(order_id) as negative_rate
    , cast(sum(case when review_group = 'positive' then 1 else 0 end) as float)/count(order_id) as positive_rate
    , cast(sum(case when review_group = 'neutral' then 1 else 0 end) as float)/count(order_id) as neutral_rate
from table_review
group by [month]
order by [month]
-- Tỷ lệ review tích cực và tiêu cực có những chuyển biến ngược nhau.
-- Khi cái này tăng thì cái kia sẽ giảm
-- review tiêu cực trung bình khoản 21%, review tích cực thì chỉ chiếm trung bình 9%, và neutral chỉ trung bình 6%
-- Các tháng cao điểm, review tiêu cực sẽ tăng lên 23-24% và review tích cực và neutral sẽ giảm nhẹ.

-- 3.3/. Retention_rate
with table_cohort as
    (SELECT order_id
        , customer_id
        , purchase_time
        , ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchase_time) AS order_number
        , FORMAT(MIN(purchase_time) OVER (PARTITION BY customer_id), 'yyyy-MM') as first_month
        , FORMAT(purchase_time, 'yyyy-MM') as current_month
        , DATEDIFF(MONTH, MIN(purchase_time) OVER (PARTITION BY customer_id), purchase_time) AS subsequent_month
    FROM orders
    where year(purchase_time) = 2022)
, table_cohort_select AS (
    SELECT 
        first_month, 
        subsequent_month, 
        COUNT(DISTINCT customer_id) AS distinct_customers
    FROM table_cohort
    GROUP BY first_month, subsequent_month)
, table_cohort_to_percent as
    (SELECT * 
    FROM table_cohort_select
    PIVOT (
        SUM(distinct_customers) FOR subsequent_month IN ([0], [1], [2], [3], [4], [5], [6], [7])
    ) AS PivotTable)
SELECT 
    first_month,
    [0],
    CAST([0] AS decimal) / NULLIF([0], null) AS [0],
    CAST([1] AS decimal) / NULLIF([0], null) AS [1],
    CAST([2] AS decimal) / NULLIF([0], null) AS [2],
    CAST([3] AS decimal) / NULLIF([0], null) AS [3],
    CAST([4] AS decimal) / NULLIF([0], null) AS [4],
    CAST([5] AS decimal) / NULLIF([0], null) AS [5],
    CAST([6] AS decimal) / NULLIF([0], null) AS [6],
    CAST([7] AS decimal) / NULLIF([0], null) AS [7]
FROM table_cohort_to_percent
order by first_month;
-- retention_rate của năm 2022, đạt khoản 15-19% ở các tháng thông thường
-- retention_rate của năm 2022, đạt khoản 30-47% ở các tháng cuối năm trước dịp Tết
-- Só lượng acquisition KH mới giảm theo thời gian
-- Tuy nhiên, tháng 11.2022 lại tăng đột ngột, có phải do ngày 11.11

with table_cohort as
    (SELECT order_id
        , customer_id
        , purchase_time
        , ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchase_time) AS order_number
        , FORMAT(MIN(purchase_time) OVER (PARTITION BY customer_id), 'yyyy-MM') as first_month
        , FORMAT(purchase_time, 'yyyy-MM') as current_month
        , DATEDIFF(MONTH, MIN(purchase_time) OVER (PARTITION BY customer_id), purchase_time) AS subsequent_month
    FROM orders
    where year(purchase_time) = 2023)
, table_cohort_select AS (
    SELECT 
        first_month, 
        subsequent_month, 
        COUNT(DISTINCT customer_id) AS distinct_customers
    FROM table_cohort
    GROUP BY first_month, subsequent_month)
, table_cohort_to_percent as
    (SELECT * 
    FROM table_cohort_select
    PIVOT (
        SUM(distinct_customers) FOR subsequent_month IN ([0], [1], [2], [3], [4], [5], [6], [7],[8],[9],[10],[11],[12])
    ) AS PivotTable)
SELECT 
    first_month,
    [0],
    CAST([0] AS decimal) / NULLIF([0], null) AS [0],
    CAST([1] AS decimal) / NULLIF([0], null) AS [1],
    CAST([2] AS decimal) / NULLIF([0], null) AS [2],
    CAST([3] AS decimal) / NULLIF([0], null) AS [3],
    CAST([4] AS decimal) / NULLIF([0], null) AS [4],
    CAST([5] AS decimal) / NULLIF([0], null) AS [5],
    CAST([6] AS decimal) / NULLIF([0], null) AS [6],
    CAST([7] AS decimal) / NULLIF([0], null) AS [7],
    CAST([8] AS decimal) / NULLIF([0], null) AS [8],
    CAST([9] AS decimal) / NULLIF([0], null) AS [9],
    CAST([10] AS decimal) / NULLIF([0], null) AS [10],
    CAST([11] AS decimal) / NULLIF([0], null) AS [11],
    CAST([12] AS decimal) / NULLIF([0], null) AS [12]
FROM table_cohort_to_percent
order by first_month;
-- retention_rate của năm 2023, đạt khoản 15-21% ở các tháng thông thường
-- retention_rate của năm 2023, đạt khoản 35-40% ở các tháng cuối năm trước dịp Tết

-- Tuy nhiên, tháng 11.2022 lại tăng đột ngột KH mới, có phải do ngày 11.11 và friday.
select purchase_time
    , count(distinct customer_id) as n_customers
    , cast(sum(case when delivery_time is null then 0
        when datediff(hour,estimated_delivery_time,delivery_time) > 0 then 0
        else 1
    end) as float)/count(order_id) as rate_orders_success
FROM orders
where [month] = '2022-11'
group by purchase_time
order by purchase_time;
-- Giả thuyết đúng. Tháng 11.2022, hưởng ứng ngày 11.11 và blackfriday, tượng KH tăng lớn.
-- Điều này khiến tỷ lệ giao hàng ontime những ngày này cũng giảm đáng kể
with table_review as
    (select orders.order_id
        , purchase_time
        , review_id
        , score
        , [description]
        , [month]
        , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    from orders
    left join review on orders.order_id = review.order_id)
select [description]
    , count(review_id) as n_reviews
    , cast(count(review_id) as float)/ (select count(order_id) from table_review) as rate_reviews
from table_review
where [description] is not null
group by [description]
order by count(review_id) desc
-- Tổng có 29 loại description về toàn bộ dịch vụ
-- Top 10 số lượng description là những review tiêu cực (chiếm 58% số review)
-- Top 1: Khôn bao giờ quay lại
-- Review về Product: Quá xấu, Sản phẩm tệ nhất mình từng mua, Không giống mô tả
-- Review về Customer Service: Dịch vụ kém
-- Review về Giao hàng: Giao hàng chậm, Đóng gói kém, Hình thức xấu, Sản phẩm bị vỡ, Hàng giao bị hư hỏng

-- III/. Diagnostic Analytics

-- 1/. Tại sao các metrics sau không tăng trưởng:
-- 1.1/. #orders
-- 1.2/. rate_orders_completed
-- 1.3/. rate_orders_ontime hoặc rate_orders_late không giảm
-- 1.4/. positive_rate
-- 1.5/. avg_total_delivery_time
-- 1.6/. score
-- 1.7/. retention_rate

-- 2/. Tại sao việc giao bị quá trễ. (Khâu nào trong quy trình đang làm trễ)

-- 2.1/. Tại sao khâu đó bị trễ --> Từ đó đề xuất hướng giải quyết.

-- 3/. Tại sao các chỉ số tăng/giảm đột ngột đáng kể và tháng 11, 12 và 01
-- Answer: Vì tháng 11, 12 và 01 có nhiều sự kiện lớn như 11/11, Black Friday, Tiêu dùng chuẩn bị cho dịp Tết.

-- 1.1/. Tại sao các metrics sau không tăng trưởng: #orders, score, negative,..
-- Vì:
-- - Không giữ chuân được khách hàng cũ. Vì
--      + Dịch vụ tệ (8%): 
--      + Dản phẩm tệ (17%): 
select 0.0866718455221396 + 0.03922983020752414 + 0.03961824436799467 -- Tỷ lệ các sản phẩm tệ trong các đơn được đánh giá
--      + Lỗi nặng trong khâu giao hàng (25%):
select 0.08273221618022417 + 0.04172677838197758 + 0.039784707579624906 + 0.039285317944734215 + 0.0414493396959272 -- Tỷ lệ khâu giao hàng tệ trong các đơn được đánh giá
-- - Tỷ lệ acquisition khách hàng mới cũng thấp
-- ==> Chưa có chiến lược nào cụ thể thu hút KH mới hay giữ chân KH Cũ.

-- Tổng thể dịch vụ chưa tốt và đang mắc ở ba vấn đề
-- (1) - Khâu giao hàng
-- (2) - Sản phẩm
-- (3) - Dịch vụ chăm sóc KH

-- Khâu Giao hàng: Có 5 vấn đề
-- Về thời gian: Giao hàng chậm.

select orders.order_id
    , purchase_time
    , seller_confirm_time
    , pick_up_time
    , carrier_time
    , delivery_time
    , estimated_delivery_time
    , [month]
    , case when seller_confirm_time is null then null else datediff(hour, purchase_time, seller_confirm_time) end as seller_time
    , case when pick_up_time is null then null else datediff(hour, seller_confirm_time, pick_up_time) end as pickup_time
    , case when carrier_time is null then null else datediff(hour, pick_up_time, carrier_time) end as transit_time
    , case when delivery_time is null then null else datediff(hour, carrier_time, delivery_time) end as delivering_time
    , case when delivery_time is null then null
        when DATEDIFF(hour, estimated_delivery_time, delivery_time) < 0 then null else datediff(hour, estimated_delivery_time, delivery_time) end as late_duration 
    , case when delivery_time is null then null
        when DATEDIFF(hour, estimated_delivery_time, delivery_time) < 0 then 'ontime' else 'late' end as status_completed
    , orders.location_id
    , province
    , economic_region
    , orders.product_id
    , category
    , product_name
    , review_id
    , score
    , case when review_id is null then null
            when score <= 5 then 'negative'
            when score <= 7 then 'neutral'
            else 'positive'
        end as review_group
    , [description]
    , orders.shipper_id
    , [name]
    , exp_year
into table_analysis
from orders
left join [location] as loca on orders.location_id = loca.location_id
left join product on orders.product_id = product.product_id
left join review on orders.order_id = review.order_id
left join shipper on orders.shipper_id = shipper.shipper_id;

-- INSERT INTO table_analysis (order_id, customer_id)
-- SELECT order_id, customer_id FROM orders;

SELECT [month]
    , avg(cast(seller_time as decimal))  as avg_seller_time
    , avg(cast(pickup_time as decimal)) as avg_pickup_time
    , avg(cast(transit_time as decimal)) as avg_transit_time
    , avg(cast(delivering_time as decimal)) as avg_delivering_time
    , avg(cast(late_duration as decimal)) as avg_late_duration
FROM table_analysis
group by [month]
order by [month]
-- 03 khâu seller_time, pickup_time và transit_time về mặt tổng thể các đơn hàng duy trì khá ổn định.
-- khâu delivering_time, biến động cùng với late_duration ==> Cho thấy khâu này đang là nguyên nhân chính gây trễ.

-- So sánh 03 khâu seller_time, pickup_time và transit_time giữa ontime và late
SELECT [month]
    , avg(cast(seller_time as decimal))  as avg_seller_time
    , avg(cast(pickup_time as decimal)) as avg_pickup_time
    , avg(cast(transit_time as decimal)) as avg_transit_time
    , avg(cast(delivering_time as decimal)) as avg_delivering_time
FROM table_analysis
where status_completed = 'ontime'
group by [month]
order by [month]
-- Trung bình đơn giao đúng giờ chỉ mất 40 hours cho khâu giao hàng đến nhà KH

SELECT [month]
    , avg(cast(seller_time as decimal))  as avg_seller_time
    , avg(cast(pickup_time as decimal)) as avg_pickup_time
    , avg(cast(transit_time as decimal)) as avg_transit_time
    , avg(cast(delivering_time as decimal)) as avg_delivering_time
    , avg(cast(late_duration as decimal)) as avg_late_duration
FROM table_analysis
where status_completed = 'late'
group by [month]
order by [month]
-- Trung bình đơn muộn mất đén 90-95 hours cho khâu giao hàng đến nhà KH
-- Có sự khác biệt, nhưng không đáng kể.
-- Sự khác biệt nằm ở transit_time. Chênh lệch khoảng 5 hours

-- Sự khác biệt giữa transit_time và delivering_time là do đâu
-- Late_duration trung bình khoảng 55 hours

-- 1.1/. Sự khác biệt nằm ở sản phẩm???
SELECT category
    , count(order_id) as n_orders_late
FROM table_analysis
where status_completed = 'late'
group by category
order by count(order_id) desc

SELECT category
    , count(order_id) as n_orders_ontime
FROM table_analysis
where status_completed = 'ontime'
group by category
order by count(order_id) desc
-- Chưa nhận ra được lý do...........
-- Nhìn thấy được xu hướng đơn giao đúng giờ sẽ tập trung vào 1-2 loại category

-- 1.2/. Sự khác biệt nằm ở vị trí địa lý???
SELECT economic_region
    , count(order_id) as n_orders_late
FROM table_analysis
where status_completed = 'late'
group by economic_region
order by count(order_id) desc

SELECT economic_region
    , count(order_id) as n_orders_ontime
FROM table_analysis
where status_completed = 'ontime'
group by economic_region
order by count(order_id) desc;
-- Nhìn thấy được xu hướng đơn giao đúng giờ sẽ tập trung vào 1-2 cùng economic_region
-- Cần dive deeper

-- 1.2/. Sự khác biệt nằm ở shipper???
with table_late as
    (SELECT [name]
        , economic_region
        , province
        , exp_year
        , avg(delivering_time) as avg_delivering_time
        , sum(case when status_completed = 'late' then 1 else 0 end) as n_orders_late
        , count(order_id) as n_orders_completed
        , count(distinct estimated_delivery_time) as n_days
    FROM table_analysis
    WHERE delivery_time is not null
    group by [name], exp_year,province , economic_region
)
, table_ontime as
    (SELECT [name]
        , exp_year
        , sum(case when status_completed = 'ontime' then 1 else 0 end) as n_orders_ontime
        , count(order_id) as n_orders_completed
    FROM table_analysis
    WHERE delivery_time is not null
    group by [name], exp_year)
select table_late.[name]
    , table_late.exp_year
    , economic_region
    , province
    , table_late.n_orders_completed
    , n_orders_late
    , n_orders_ontime
    , cast(n_orders_late as decimal)/table_late.n_orders_completed as late_rate
    , n_days
    , cast(table_late.n_orders_completed as decimal)/n_days as n_orders_per_day
    , avg_delivering_time
from table_late
FULL OUTER join table_ontime on table_late.[name] = table_ontime.[name]
where cast(table_late.n_orders_completed as decimal)/n_days < 2 and table_late.[name] is not null
order by late_rate desc;

-- Check: n_orders_completed & late_rate của từng tỉnh
select province
    , sum(case when delivery_time is null then 0 else 1 end) as n_orders_completed
    , sum(case when status_completed = 'late' then 1 else 0 end) as n_orders_late
    , cast(sum(case when status_completed = 'late' then 1 else 0 end) as decimal)/sum(case when delivery_time is null then 0 else 1 end) as late_rate
from table_analysis
group by province
order by sum(case when delivery_time is null then 0 else 1 end) desc
-- Tỷ lệ shipper giao đơn trễ thấp nhất là 30%

select [name]
    , economic_region
    , province
    , category
    , product_name
    , seller_time
    , pickup_time
    , transit_time
    , delivering_time
    , status_completed
from table_analysis
where [name] = N'Vũ Thùy Lan'
    and status_completed = 'late'


select 
    sum(case when status_completed = 'late' then 1 else 0 end) as n_orders_late,
    count(order_id)
from table_analysis
where delivery_time is not null


-- Có 2 vấn đề ở đây
-- 1/. Các shipper ở thành phố lớn (Hà nội ,TP.HCM, Đà Nẵng) tần suất giao đơn 1 ngày nhiều từ 10 - 13 đơn
-- dẫn đến các shipper không giao kịp
-- 2/. Các shipper ở các tỉnh thành khác, dù mỗi ngày chỉ 1-2 đơn, nhưng vẫn giao trễ và số giờ giao gần như luôn
-- ở mức cao trên 100hours, tức là từ 4-5 ngày mới giao tới KH từ lúc nhận đơn từ kho.

select *
from table_analysis
where (status_completed = 'late')
    and (seller_time + pickup_time + transit_time) >= (seller_time + pickup_time + transit_time + delivering_time - late_duration)
-- Có 3,064 chưa đến khâu giao hàng đã trễ, lý do là vì:
-- (1) - khâu pickup và transit ngốn hết thời gian
-- (2) - lỗi do estimated time không phù hợp ??? cái này khó vì tiktok tính mà

select *
from table_analysis
where (status_completed = 'late')
    and (seller_time + pickup_time + transit_time) - (seller_time + pickup_time + transit_time + delivering_time - late_duration) between -24 and 0
-- Có 6,039 bắt giao trong vòng 24 tiếng từ khi nhận đơn, lý do cũng xem là vì khâu vận hành:
-- (1) - khâu pickup và transit ngốn hết thời gian
-- (2) - lỗi do estimated time không phù hợp ??? cái này khó vì tiktok tính mà

-- ==> Hơn 50% là lỗi do Shipper

select datediff(hour, purchase_time, estimated_delivery_time) as time_required
from table_analysis
where (status_completed = 'ontime')
select datediff(hour, purchase_time, estimated_delivery_time) as time_required
from table_analysis
where (status_completed = 'late')
-- Lý do thứ 3 khiến các đơn này giao trễ là vì, time_required để giao tính tính lúc KH đặt đơn đến estimated_delivery_time quá thấp
select delivering_time
from table_analysis
where (status_completed = 'ontime')
select delivering_time
from table_analysis
where (status_completed = 'late')
-- thằng giao đúng giờ thì dư quá nhiều thời gian so với time_required
-- thằng giao trễ thì thiếu quá nhiều quá thời gian so với time_required
-- ==> Phân bổ nguồn lực không phù hợp, nên ưu tiên 





ALTER TABLE table_analysis
ADD estimated_delivery_time DATETIME



-- Về Packaging: Đóng gói kém, Hình thức xấu. ==> Khắc phục khâu Seller

-- Về chất lượng giao hàng: Sản phẩm bị vỡ, Hàng giao bị hư hỏng. ==> Khắc phục khâu transit


-- Về sản phẩm:
-- (1) Quá xấu,
-- (2) Sản phẩm tệ nhất mình từng mua, 
-- (3) Không giống mô tả

select category
    , count(order_id) as n_orders
from table_analysis
where ([description] = N'Quá xấu')
    or ([description] = N'Sản phẩm tệ nhất mình từng mua')
    or ([description] = N'Không giống mô tả')
group by category
order by count(order_id) desc

select category
    , product_name
    , count(order_id)
from table_analysis
where ([description] = N'Quá xấu')
    or ([description] = N'Sản phẩm tệ nhất mình từng mua')
    or ([description] = N'Không giống mô tả')
group by category, product_name
order by count(order_id) desc

select distinct product_name
from table_analysis

-- Về dịch vụ: Dịch vụ kém. Có thể do nhân viên chưa được training tốt để hỗ trợ KH

-- Phân tích sâu: Không bao giờ quay lại. Những KH này đã phải chịu đựng những gì

select *
from table_analysis
where [description] = N'Không bao giờ quay lại'
-- Có thể do dịch vụ Customer service
-- Có thể do sản phẩm lỗi
-- Tỷ lệ giao hàng trễ của nhóm này rất thấp