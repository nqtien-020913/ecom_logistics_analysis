-- DATA CLEANING

-- 1/. Check data type của tất cả các bảng
-- ==> Hợp lệ

-- 2/. Xem qua các dữ liệu
Select top 10*
FROM orders

Select top 10*
FROM product

Select top 10*
FROM [location]

Select top 10*
FROM review

Select *
FROM shipper
-- Phát hiện dữ liệu NULL ở bảng Shipper
-- Tại sao dữ liệu shipper bị NULL? 
-- Giả quyết: Có thể trong dữ liệu orders, các shipper này không giao đơn nào.

-- 3/. Kiểm tra giá trị NULL và giải quyết
-- 3.1/. orders table
SELECT 
    (COUNT(*) - COUNT(order_id)) * 100.0 / COUNT(*) AS NULL_orders
    , (COUNT(*) - COUNT(purchase_time)) * 100.0 / COUNT(*) AS NULL_purchase_time
    , (COUNT(*) - COUNT(seller_confirm_time)) * 100.0 / COUNT(*) AS NULL_seller_confirm_time
    , (COUNT(*) - COUNT(pick_up_time)) * 100.0 / COUNT(*) AS NULL_pick_up_time
    , (COUNT(*) - COUNT(carrier_time)) * 100.0 / COUNT(*) AS NULL_carrier_time
    , (COUNT(*) - COUNT(delivery_time)) * 100.0 / COUNT(*) AS NULL_delivery_time
    , (COUNT(*) - COUNT(estimated_delivery_time)) * 100.0 / COUNT(*) AS NULL_estimated_delivery_time
    , (COUNT(*) - COUNT(product_id)) * 100.0 / COUNT(*) AS NULL_product_id
    , (COUNT(*) - COUNT(seller_id)) * 100.0 / COUNT(*) AS NULL_seller_id
    , (COUNT(*) - COUNT(price)) * 100.0 / COUNT(*) AS NULL_price
    , (COUNT(*) - COUNT(customer_id)) * 100.0 / COUNT(*) AS NULL_customer_id
    , (COUNT(*) - COUNT(location_id)) * 100.0 / COUNT(*) AS NULL_location_id
    , (COUNT(*) - COUNT([status])) * 100.0 / COUNT(*) AS NULL_status
    , (COUNT(*) - COUNT(shipper_id)) * 100.0 / COUNT(*) AS NULL_shipper_id
    , (COUNT(*) - COUNT([month])) * 100.0 / COUNT(*) AS NULL_month
FROM orders;
-- Giá trị NULL
-- seller_confirm_time NULL 6.84%
-- pick_up_time NULL 10.8%
-- carrier_time NULL 10.8%
-- delivery_time NULL 19.8%
-- Shipper_id NULL 14.6%

Select *
FROM orders
WHERE seller_confirm_time IS NULL
-- seller_confirm_time NULL khi đơn đặt hàng bị huỷ trước khi được xác nhận bởi Seller
-- Dữ liệu NULL hợp lệ

Select count(*)
    , [status]
FROM orders
WHERE pick_up_time IS NULL
GROUP BY [status]
-- pick_up_time NULL 10.8%
-- carrier_time NULL 10.8%
-- pick_up_time & carrier_time cùng NULL
-- pick_up_time & carrier_time bị NULL khi 
-- #1/. Đơn hàng bị huỷ ở giai đoạn xác nhận của Seller
-- #2/. Đơn hàng đã được Seller xác nhận nhưng chưa bàn giao cho đơn vị vận chuyển
-- Dữ liệu NULL hợp lệ

Select *
FROM orders
WHERE delivery_time IS NULL
    and [status] = 'delivering'
-- delivery_time bị NULL khi 
-- #1/. Đơn hàng bị huỷ ở giai đoạn xác nhận của Seller
-- #2/. Đơn hàng đã được Seller xác nhận nhưng chưa bàn giao cho đơn vị vận chuyển
-- #3/. Đơn hàng đã được Seller xác nhận, đã được trung chuyển và đang được shipper giao đến khách hàng.
-- Dữ liệu NULL hợp lệ

Select *
FROM orders
WHERE  shipper_id IS NULL
    and delivery_time IS NOT NULL
-- 14.6% shipper_id bị NULL, trong đó bao gồm:
-- 1/. 10.8% bị NULL ở giai đoạn đơn hàng chưa được trung chuyển đến kho để giao đến khách hàng
-- 2/. 3.8% còn lại là những đơn hàng chưa có shipper nhận đơn giao, và trong đó có 1,722 đơn hàng (3,4%) đã giao nhưng lại bị NULL

with table_null as (Select location_id
    , count(*) as order_null
FROM orders
WHERE shipper_id IS NULL
    and delivery_time IS NOT NULL
group BY location_id),
table_total as (Select location_id
    , count(*) as order_total
FROM orders
group BY location_id)
select table_null.location_id
    , order_null
    , order_total
    , province
    , economic_region
FROM table_null
join table_total on table_null.location_id = table_total.location_id
join [location] on table_null.location_id = [location].location_id;
-- 1,722 đơn hàng (3,4%) đã giao nhưng lại bị NULL tập trung cao ở các tỉnh nhất định, nếu xoá sẽ bị ảnh hưởng đến kết quả kinh doanh.
-- Cách xử lý. Đối với những đã giao hàng, những giá trị bị NULL --> shipper_name = "unknown" và exp_year = mean

-- 3.2/. location table
SELECT 
    (COUNT(*) - COUNT(location_id)) * 100.0 / COUNT(*) AS NULL_location_id
    , (COUNT(*) - COUNT(province)) * 100.0 / COUNT(*) AS NULL_province
    , (COUNT(*) - COUNT(economic_region)) * 100.0 / COUNT(*) AS NULL_economic_region
FROM [location]
-- Không có giá trị NULL

-- 3.3/. product table
SELECT 
    (COUNT(*) - COUNT(product_id)) * 100.0 / COUNT(*) AS NULL_product_id
    , (COUNT(*) - COUNT(product_name)) * 100.0 / COUNT(*) AS NULL_product_name
    , (COUNT(*) - COUNT(category)) * 100.0 / COUNT(*) AS NULL_category
FROM product
-- Không có giá trị NULL

-- 3.4/. review
SELECT 
    (COUNT(*) - COUNT(review_id)) * 100.0 / COUNT(*) AS NULL_review_id
    , (COUNT(*) - COUNT(order_id)) * 100.0 / COUNT(*) AS NULL_order_id
    , (COUNT(*) - COUNT(score)) * 100.0 / COUNT(*) AS NULL_score
    , (COUNT(*) - COUNT([description])) * 100.0 / COUNT(*) AS NULL_description
FROM review
-- Không có giá trị NULL

-- 3.5/. shipper table
SELECT 
    (COUNT(*) - COUNT(shipper_id)) * 100.0 / COUNT(*) AS NULL_shipper_id
    , (COUNT(*) - COUNT([name])) * 100.0 / COUNT(*) AS NULL_name
    , (COUNT(*) - COUNT(exp_year)) * 100.0 / COUNT(*) AS NULL_exp_year
    , (COUNT(*) - COUNT(location_id)) * 100.0 / COUNT(*) AS NULL_location_id
FROM shipper

SELECT COUNT(*)
FROM shipper
WHERE location_id is NULL

-- location_id bị NULL 26.3% trên 60/228
-- Giả thuyết: có thể 60 shipper này không có đơn trong orders
with table_null as (
    SELECT *
    FROM shipper
    WHERE location_id is NULL
)
SELECT table_null.*
    , orders.order_id
FROM table_null
JOIN orders on table_null.shipper_id = orders.shipper_id
-- .==> Giả thuyết đúng.

-- 4/. Kiểm tra bảng fact có bị duplicate hay không

select count (order_id) as n_orders
    , count (distinct order_id) as n_unique_orders
from orders
-- Dữ liệu order (Fact_table) không bị Duplicated.

-- Conclusion:
-- 1/. Data Type hợp lệ
-- 2/. Dữ liệu NULL của shipper_id trong bảng orders cần điều chỉnh khi JOIN bảng orders và bảng shipper
-- 3/. Dữ liệu không bị Duplicated.