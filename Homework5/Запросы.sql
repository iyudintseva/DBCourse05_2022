-- 1. SELECT запрос:
-- отобразить текущие цены на товары в заказе
select ord.orderid, dtl.orderline , 
       p.name as product,
       v.name as vendor,
       pv.unitcost as price
from (((orders.order as ord inner join 
       orders.orderdtl as dtl on
       ord.ordernumber = '12345A' and
       ord.OrderId = dtl.orderid) inner join
       logistic.product as p on
       p.productid = dtl.productid) left join
       logistic.vendor as v on
       v.vendorid = dtl.vendorid) left join
       logistic.productvendor as pv on
       pv.vendorid = dtl.vendorid and
       pv.productid = dtl.productid;

--2. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, 
-- этот запрос возвращает 4 сточки - одна из которых содержит NULL в поле price 
SELECT dtl.orderid, dtl.orderline, b.unitcost as price, c.name as product 
FROM orders.orderdtl as dtl
LEFT JOIN logistic.productvendor as b ON b.vendorid = dtl.vendorid and b.productid = dtl.productid 
LEFT JOIN logistic.product as c ON c.productid = dtl.productid;

-- а этот только 3 
SELECT dtl.orderid, dtl.orderline, b.unitcost as price, c.name as product 
FROM orders.orderdtl as dtl
LEFT JOIN logistic.productvendor as b ON b.productid = dtl.productid 
LEFT JOIN logistic.product as c ON c.productid = dtl.productid
where b.vendorid = dtl.vendorid

--3. запрос на добавление данных с выводом информации о добавленных строках.
INSERT INTO logistic.product(
	productid, name, description, age, size)
VALUES (DEFAULT, 'Artie Шорты для девочки', '97% хлопок, 3% эластан', 3, 98)
RETURNING (productid, name);

--4. запрос с обновлением данные используя UPDATE FROM
--  нужно пересчитать цены в заказе
UPDATE orders.orderdtl AS dtl
SET unitcost = pv.unitcost,
    price = pv.unitcost - dtl.discount
FROM logistic.productvendor as pv, orders.order as o 
WHERE pv.vendorid = dtl.vendorid and
   pv.productid = dtl.productid and
   o.orderid = dtl.orderid and
   o.ordernumber = '12345A'
RETURNING (dtl.orderid, dtl.orderline, dtl.productid, dtl.unitcost, 
   dtl.discount, dtl.price);

--5. запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.
DELETE FROM orders.orderdtl AS dtl USING logistic.product as p
WHERE dtl.productid = p.productid AND p.Name = 'Шапка'
RETURNING (dtl.orderid, dtl.orderline, dtl.productid);

--6. Утилиту COPY можно использовать для выгрузки данных и таблицы 
( COPY TO ) в  файл и заливки данных обратно (COPY FROM)

COPY (SELECT * FROM logistic.productvendor) 
TO '/var/run/archive-dir/copytest.csv'
(DELIMITER ';');

DELETE FROM logistic.productvendor;

COPY logistic.productvendor 
FROM '/var/run/archive-dir/copytest.csv'
(DELIMITER ';');

SELECT * FROM logistic.productvendor;


  

