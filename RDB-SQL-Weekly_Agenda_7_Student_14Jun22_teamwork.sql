/* ===== RDB&SQL Exercise-2 Student (14 Jun 22) ===== */

----1. By using view get the average sales by staffs and years using the AVG() aggregate function.

CREATE VIEW avg_sales_staff_1 AS
SELECT	S.staff_id, 
		YEAR(O.order_date) AS order_year,
		AVG(I.quantity * I.list_price * (1- I.discount)) AS avg_sales
FROM sale.order_item I, sale.staff S, sale.orders O
WHERE I.order_id = O.order_id AND S.staff_id = O.staff_id
GROUP BY S.staff_id, YEAR(O.order_date)
;

SELECT *
FROM avg_sales_staff_1
ORDER BY order_year DESC
;

----2. Select the annual amount of product in stock according to brands (use window functions).

SELECT	PP.brand_id, PP.model_year, SUM(PS.quantity) AS total_quantity
FROM	product.product PP, product.stock PS
WHERE	PS.product_id = PP.product_id
GROUP BY PP.brand_id, PP.model_year
ORDER BY PP.brand_id;


----3. Select the least 3 products (min quantity) in stock according to stores.

SELECT *
FROM
(
SELECT PP.product_name, SS.store_name,
		SUM(PS.quantity) AS product_quantity,
		ROW_NUMBER() OVER(PARTITION BY SS.store_name ORDER BY SUM(PS.quantity) ASC) min_3
FROM product.stock PS, product.product PP, sale.store SS
WHERE PS.product_id = PP.product_id AND PS.store_id = SS.store_id
GROUP BY PP.product_name, SS.store_name
HAVING SUM (PS.quantity) > 0 
) Q
WHERE Q.min_3 < 4
;

--solution
SELECT  *
FROM    (
        select ss.store_name, p.product_name, SUM(s.quantity) product_quantity,
        row_number() over(partition by ss.store_name order by SUM(s.quantity) ASC) least_3
        from [sale].[store] ss
        inner join [product].[stock] s
        on ss.store_id=s.store_id
        inner join [product].[product] p
        on s.product_id=p.product_id
        GROUP BY ss.store_name, p.product_name
        HAVING SUM(s.quantity) > 0
        ) A
WHERE   A.least_3 < 4


----4. Return the average number of sales orders in 2020 sales
----4. Return  average quantity of orders in 2020

-- couldn't understand the problem statement

SELECT	I.product_id, SUM(I.quantity),
		ROW_NUMBER () OVER(PARTITION BY I.order_id ORDER BY I.product_id)
FROM	sale.orders O, sale.order_item I
WHERE	O.order_id = I.order_id AND YEAR
GROUP BY I.product_id
;

----5. Assign a rank to each product by list price in each brand and get products with rank less than or equal to three.

CREATE VIEW ranking_products_2 AS
SELECT	P.product_name, B.brand_name, P.list_price
FROM	product.product P, product.brand B
WHERE	P.brand_id = B.brand_id
GROUP BY	P.product_name, B.brand_name, P.list_price
;

SELECT *
FROM ranking_products_2
ORDER BY brand_name, list_price
;

CREATE VIEW ranking_products_3 AS
SELECT
	DENSE_RANK() OVER (PARTITION BY brand_name ORDER BY list_price ASC) AS DenseRank#,
	ROW_NUMBER () OVER (PARTITION BY brand_name ORDER BY list_price ASC) AS Row#,
	RANK() OVER (PARTITION BY brand_name ORDER BY list_price ASC) AS Rank#, 	
	product_name, brand_name, list_price
FROM ranking_products_2
;

SELECT *
FROM ranking_products_3
WHERE Row# <= 3
;
-- most expensive product from each brand
CREATE VIEW ranking_products_4 AS
SELECT
	--DENSE_RANK() OVER (PARTITION BY brand_name ORDER BY list_price ASC) AS DenseRank#,
	ROW_NUMBER () OVER (PARTITION BY brand_name ORDER BY list_price DESC) AS Row#,
	--RANK() OVER (PARTITION BY brand_name ORDER BY list_price ASC) AS Rank#, 	
	product_name, brand_name, list_price
FROM ranking_products_2
;

SELECT *
FROM ranking_products_4
WHERE Row# = 1
;