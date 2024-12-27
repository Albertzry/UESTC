--1.显示过去3年各品牌的销售趋势，按年、月分列。然后将这些数据按购买者的性别和收入范围进行分类。
SELECT
    b.name AS brand_name,
    EXTRACT(YEAR FROM t.date) AS year,
    EXTRACT(MONTH FROM t.date) AS month,
    c.sex AS customer_sex,
    CASE
        WHEN c.income < 50000 THEN 'Low'
        WHEN c.income BETWEEN 50000 AND 100000 THEN 'Medium'
        ELSE 'High'
    END AS income_range,
    SUM(t.cost) AS total_sales
FROM
    transaction t
JOIN car ca ON t.car_id = ca.id
JOIN model m ON ca.model_id = m.id
JOIN brand b ON m.brand_id = b.id
JOIN customer c ON t.customer_id = c.id
WHERE t.date >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY
    brand_name, year, month, customer_sex, income_range
ORDER BY
    brand_name, year, month;

--2. 假设发现供应商“爱信”在两个给定日期之间进行的变速器存在缺陷。找到每辆装有这种变速器的汽车的车辆识别号（VIN）以及向其销售的客户。
SELECT
    ca.id AS car_vin,
    c.name AS customer_name,
    c.phone AS customer_phone
FROM
    component cp
JOIN car ca ON cp.car_id = ca.id
JOIN supplier s ON cp.supplier_id = s.id
JOIN transaction t ON t.car_id = ca.id
JOIN customer c ON t.customer_id = c.id
WHERE s.name = 'Aisin Corp.'
    AND cp.created_at BETWEEN '2023-01-01' AND '2023-06-30';

--3. 按过去一年的销售金额找出前两大品牌。
SELECT brand.name, SUM(transaction.cost) "sales"
FROM brand
    LEFT OUTER JOIN model ON model.brand_id = brand.id
    LEFT OUTER JOIN car ON car.model_id = model.id
    LEFT OUTER JOIN transaction ON transaction.car_id = car.id
WHERE transaction.date > NOW() - INTERVAL '1 YEAR'
GROUP BY brand.name
ORDER BY SUM(transaction.cost) DESC
LIMIT 2;

--4. 根据过去一年的单位销售额找出前两大品牌。
SELECT brand.name, AVG(transaction.cost) "sales"
FROM brand
    LEFT OUTER JOIN model ON model.brand_id = brand.id
    LEFT OUTER JOIN car ON car.model_id = model.id
    LEFT OUTER JOIN transaction ON transaction.car_id = car.id
WHERE transaction.date > NOW() - INTERVAL '1 YEAR'
GROUP BY brand.name
ORDER BY AVG(transaction.cost) DESC
LIMIT 2;

--5. 某种车型（例如H4）在哪个月卖得最好？
SELECT
    EXTRACT(YEAR FROM t.date) AS year,
    EXTRACT(MONTH FROM t.date) AS month,
    COUNT(t.id) AS units_sold
FROM
    transaction t
JOIN car ca ON t.car_id = ca.id
JOIN model m ON ca.model_id = m.id
WHERE m.name = 'H4'
GROUP BY
    year, month
ORDER BY
    units_sold DESC
LIMIT 1;

--6. 找到平均库存时间最长的经销商。
SELECT
    d.name AS dealer_name,
    AVG(DATE_PART('day', t.date - ca.created_at)) AS avg_inventory_days
FROM
    transaction t
JOIN car ca ON t.car_id = ca.id
JOIN dealer d ON t.dealer_id = d.id
GROUP BY
    d.name
ORDER BY
    avg_inventory_days DESC
LIMIT 1;


