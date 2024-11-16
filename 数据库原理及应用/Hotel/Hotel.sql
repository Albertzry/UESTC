-- 1、查询所有房型的具体信息，包括room_id, Room_name, hotel_id。
SELECT *
FROM room_type;

-- 2、查询所有酒店名称中包含“希尔顿”的酒店，返回酒店名称和酒店id。
SELECT *
FROM hotel
WHERE hotel_name LIKE '%希尔顿%';

-- 3、查询订单总价在9000元及以上的所有订单详情，包括订单编号、酒店编号、房型编号及居住时长。
SELECT hotel_order.order_id,
    hotel.hotel_id,
    hotel_order.room_id,
    (hotel_order.leave_date - hotel_order.start_date) AS period
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE hotel_order.payment >= 9000;

-- 4、查询所有房型的订单情况，包括房型编号，房型名称，订单编号、价格。
SELECT hotel_order.room_id,
    room_type.room_name,
    hotel_order.order_id,
    hotel_order.payment
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id;

-- 5、创建启悦酒店的订单视图。
CREATE OR REPLACE VIEW qiyue_hotel AS
SELECT hotel_order.*
FROM hotel_order
    LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE hotel.hotel_name = '启悦酒店';

-- 6、在订单表的总价字段上创建降序的普通索引。索引名为 orderpayment.  用\di  命令查看创建的索引。
 CREATE INDEX order_payment ON hotel_order(payment DESC);

-- 7、创建函数：查询给定日期，给定酒店所有房型的平均价格。执行函数，输入参数为2020-11-14，希尔顿大酒店。
CREATE OR REPLACE FUNCTION get_average_price_on_date_hotel(DATE, VARCHAR(255))
RETURNS DECIMAL(10, 2)
AS $$
    DECLARE average_price DECIMAL(10, 2);

    BEGIN
        SELECT AVG(room_info.price) INTO average_price
        FROM room_info
            LEFT OUTER JOIN room_type ON room_type.room_id = room_info.room_id
            LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
        WHERE room_info.date = $1
            AND hotel.hotel_name = $2;
        RETURN average_price;
    END
$$ LANGUAGE plpgsql;

SELECT get_average_price_on_date_hotel('2020-11-14', '希尔顿大酒店') AS avg_price;

-- 8、创建存储过程：从订单表中统计指定酒店、指定日期的各种房型的预订情况，返回酒店名，房型，预定数量。执行存储过程：统计希尔顿大酒店2020-11-14当天各个房型预定情况。
CREATE OR REPLACE PROCEDURE get_room_type_order_on_date_hotel(DATE, VARCHAR(255))
AS
    CURSOR c IS
        SELECT FIRST(hotel.hotel_name) AS hotel_name,
            hotel_order.room_id,
            FIRST(room_type.room_name) AS room_name,
            SUM(hotel_order.amount) AS amount
        FROM hotel_order
            LEFT OUTER JOIN room_type ON room_type.room_id = hotel_order.room_id
            LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
        WHERE hotel_order.create_date = $1
            AND hotel.hotel_name = $2
        GROUP BY hotel_order.room_id;

    hotel_name VARCHAR(255);
    room_id INT;
    room_name VARCHAR(255);
    amount INT;

    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO hotel_name, room_id, room_name, amount;
            EXIT WHEN c%notfound;
            RAISE INFO 'hotel_name: %', hotel_name;
            RAISE INFO 'room_id:    %', room_id;
            RAISE INFO 'room_name:  %', room_name;
            RAISE INFO 'amount:     %', amount;
            RAISE INFO '';
        END LOOP;
        CLOSE c;
    END
;

CALL get_room_type_order_on_date_hotel('2020-11-14', '希尔顿大酒店');

-- 9、查找同时评价了2次及以上的用户信息。
SELECT *
FROM customer
WHERE uid IN (
    SELECT uid
    FROM rating
    GROUP BY uid
    HAVING COUNT(*) >= 2
);

-- 10、查询评价过所有总统套房的顾客姓名。
SELECT customer.uname
FROM customer
WHERE customer.uid IN (
    SELECT uid
    FROM customer
    WHERE NOT EXISTS (
        SELECT *
        FROM room_type
            LEFT OUTER JOIN hotel_order ON hotel_order.room_id = room_type.room_id
        WHERE room_type.room_name = '总统套房'
            AND NOT EXISTS (
                SELECT *
                FROM rating
                WHERE rating.uid = customer.uid
                    AND rating.order_id = hotel_order.order_id
            )
    )
);

-- 11、若要预定11.14-16日每天房间数量4间。查询满足条件（时间区间，将预定房间数）的房型及其平均价格，并按平均价格从低到高进行排序。查询结果应包含酒店，房型及平均价格信息。
SELECT FIRST(hotel.hotel_name) AS hotel_name,
    FIRST(room_type.room_name) AS room_name,
    AVG(room_info.price) AS average_price
FROM room_info
    LEFT OUTER JOIN room_type ON room_type.room_id = room_info.room_id
    LEFT OUTER JOIN hotel ON hotel.hotel_id = room_type.hotel_id
WHERE room_info.room_id IN (
    SELECT room_id
    FROM room_info
    WHERE room_id IN (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-14'
            AND remain >= 4
    )
    INTERSECT
    (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-15'
            AND remain >= 4
    )
    INTERSECT
    (
        SELECT room_id
        FROM room_info
        WHERE DATE = '2020-11-16'
            AND remain >= 4
    )
)
GROUP BY room_info.room_id;

-- 12、编写触发器：完成预订房间，包括创建订单和更新房型信息。该订单为预订11月14号-15号4号房型4间。
CREATE OR REPLACE PROCEDURE order_room(t_start_date DATE, t_leave_date DATE, t_room_id INT, t_amount INT, t_customer_id INT)
AS
    BEGIN
        INSERT INTO hotel_order
        VALUES (
            (
                SELECT MAX(order_id) + 1
                FROM hotel_order
            ),
            t_room_id,
            t_start_date,
            t_leave_date,
            t_amount,
            (
                SELECT SUM(price) * t_amount
                FROM room_info
                WHERE room_id = t_room_id
                    AND date IN (
                        SELECT a
                        FROM generate_series(
                            t_start_date::DATE,
                            t_leave_date::DATE,
                            '1 day'
                        ) s(a)
                    )
            ),
            NOW(),
            t_customer_id
        );
    END
;
