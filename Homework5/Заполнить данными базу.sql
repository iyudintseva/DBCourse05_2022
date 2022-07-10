-- Очистить данные
DELETE FROM orders.orderdtl;
DELETE FROM orders.order;
DELETE FROM orders.customer;
DELETE FROM logistic.productvendor;
DELETE FROM logistic.product;
DELETE FROM logistic.vendor;

VACUUM FULL;

-- Вставка данных
-- Product --
    INSERT INTO logistic.product(
	productid, name, description, age, size)
	VALUES (DEFAULT, 'Брюки синие', 'Хлопок 100%', 2, 92);
    
    INSERT INTO logistic.product(
	productid, name, description, age, size)
	VALUES (DEFAULT, 'Брюки зеленые', 'Хлопок 80% Эластан20%', 3, 98);
    
    INSERT INTO logistic.product(
	productid, name, description, age, size)
	VALUES (DEFAULT, 'Платье желтое', 'Хлопок 80% Эластан20%', 4, 104);

    INSERT INTO logistic.product(
	productid, name, description, age, size)
	VALUES (DEFAULT, 'Куртка', 'Демисезон. Зима-осень. Хлопок 80% Эластан20%', 2, 92);

    INSERT INTO logistic.product(
	productid, name, description, age, size)
	VALUES (DEFAULT, 'Шапка', 'Состав: 95% хлопок 5% эластан', 3, 54);

--Vendor 
    INSERT INTO logistic.vendor(
	vendorid, name, description, address, email, phone)
	VALUES (DEFAULT, 'ООО Трикотаж Профи', 'Трикотаж Профи - это производство трикотажных изделий, на рынке 17 лет.','601900, Владимирская область, Ковров, ул.Либерецкая, 2, 14', 'nosovakatya44@mail.ru', '8-982-383-02-30');
    
    INSERT INTO logistic.vendor(
	vendorid, name, description, address, email, phone)
	VALUES (DEFAULT, 'ООО Баттон Блю','Button Blue — это классная детская одежда с творческим характером!', '107023, г. Москва, Медовый переулок, д. 5, стр. 1, этаж 2, помещение 15Д', 'durakova@button-blue.ru', '+7 (495) 995-11-23 / 24, доб. 523');

    INSERT INTO logistic.vendor(
	vendorid, name, description, address, email, phone)
	VALUES (DEFAULT, 'ООО МОНЭКС ТРЕЙДИНГ', 'ООО МОНЭКС ТРЕЙДИНГ – российская компания, работающая по системе франчайзинга известной торговой мароки: Mothercare.', '125124, Г.Москва, Москва, Правды, 26, XXIX, ком. 1', 'Marketing.Rus@alshaya.com', '+74956489580');

    INSERT INTO logistic.vendor(
	vendorid, name, description, address, email, phone)
	VALUES (DEFAULT, 'ООО МОНЭКС ТРЕЙДИНГ', 'ООО МОНЭКС ТРЕЙДИНГ – российская компания, работающая по системе франчайзинга известной торговой мароки: Mothercare.', '125124, Г.Москва, Москва, Правды, 26, XXIX, ком. 1', 'Marketing.Rus@alshaya.com', '+74956489580');

--ProductVendor  
WITH upd AS (
  Select p.productid, v.vendorid 
    FROM logistic.product as p,
         logistic.vendor as v
    WHERE p.name = 'Платье желтое' and
          v.name = 'ООО Трикотаж Профи'
)
INSERT INTO logistic.productvendor 
SELECT upd.vendorid, upd.productid, 1200 as unitcost FROM upd;


WITH upd AS (
  Select p.productid, v.vendorid 
    FROM logistic.product as p,
         logistic.vendor as v
    WHERE p.name = 'Брюки синие' and
          v.name = 'ООО Баттон Блю'
)
INSERT INTO logistic.productvendor 
SELECT upd.vendorid, upd.productid, 1100 as unitcost FROM upd;

WITH upd AS (
  Select p.productid, v.vendorid 
    FROM logistic.product as p,
         logistic.vendor as v
    WHERE p.name = 'Брюки зеленые' and
          v.name = 'ООО Баттон Блю'
)
INSERT INTO logistic.productvendor 
SELECT upd.vendorid, upd.productid, 1500 as unitcost FROM upd;

WITH upd AS (
  Select p.productid, v.vendorid 
    FROM logistic.product as p,
         logistic.vendor as v
    WHERE p.name = 'Куртка' and
          v.name = 'ООО МОНЭКС ТРЕЙДИНГ'
)
INSERT INTO logistic.productvendor 
SELECT upd.vendorid, upd.productid, 7200 as unitcost FROM upd;
    
--Customer
INSERT INTO orders.customer(
	customerid, name, address, email, phone)
VALUES (DEFAULT, 'Вася', 'Москва, ул. Вятская, д.27', 'vasya@mail.ru', '+74957788999');
    
INSERT INTO orders.customer(
	customerid, name, address, email, phone)
VALUES (DEFAULT, 'Коля', 'Москва, ул. Зой Космедемьянской, д.11, кв.55', 'petya@mail.ru', '+74953334442');
    
INSERT INTO orders.customer(
	customerid, name, address, email, phone)
VALUES (DEFAULT, 'Света', 'Москва, ул. Kоролева, д.11, кв.54', 'sveta@mail.ru', '+74951111111');

--Order
INSERT INTO orders."order"(
    orderid, ordernumber, customerid, needdelivery, 
    deliverydate, deliverytimeinterval, deliverycost, price, promocode)
VALUES (DEFAULT, '12345A', 
(SELECT c.customerid FROM orders.customer AS c WHERE c.name = 'Света'), 
true, '07.07.2022', 'c 14:00 до 18:00', 149, 2849, '');

INSERT INTO orders."order"(
    orderid, ordernumber, customerid, needdelivery, 
    deliverydate, deliverytimeinterval, deliverycost, price, promocode)
VALUES (DEFAULT, '12347BV', 
(SELECT c.customerid FROM orders.customer AS c WHERE c.name = 'Коля'), 
true, '08.07.2022', 'c 14:00 до 18:00', 249, 7449, '');

--OrderDtl
INSERT INTO orders.orderdtl(
orderid, orderline, productid, vendorid, unitcost, discount, price)
VALUES (
(SELECT o.orderid FROM orders.order AS o WHERE o.ordernumber = '12345A'), 
 1, 
(SELECT p.productid FROM logistic.product AS p WHERE p.name = 'Брюки синие'), 
(SELECT v.vendorid FROM logistic.vendor AS v WHERE v.name = 'ООО Баттон Блю'), 
900, 0, 900);
    
INSERT INTO orders.orderdtl(
	orderid, orderline, productid, vendorid, unitcost, discount, price)
VALUES (
(SELECT o.orderid FROM orders.order AS o WHERE o.ordernumber = '12345A'), 
 2, 
(SELECT p.productid FROM logistic.product AS p WHERE p.name = 'Брюки зеленые'), 
(SELECT v.vendorid FROM logistic.vendor AS v WHERE v.name = 'ООО Баттон Блю'), 
1400, 0, 1400); 

INSERT INTO orders.orderdtl(
	orderid, orderline, productid, vendorid, unitcost, discount, price)
VALUES (
(SELECT o.orderid FROM orders.order AS o WHERE o.ordernumber = '12347BV'), 
 1, 
(SELECT p.productid FROM logistic.product AS p WHERE p.name = 'Куртка'), 
(SELECT v.vendorid FROM logistic.vendor AS v WHERE v.name = 'ООО МОНЭКС ТРЕЙДИНГ'), 
7200, 0, 7200);

INSERT INTO orders.orderdtl(
	orderid, orderline, productid, vendorid, unitcost, discount, price)
VALUES (
(SELECT o.orderid FROM orders.order AS o WHERE o.ordernumber = '12347BV'), 
 2, 
(SELECT p.productid FROM logistic.product AS p WHERE p.name = 'Шапка'), 
0, 700, 0, 700); 
    