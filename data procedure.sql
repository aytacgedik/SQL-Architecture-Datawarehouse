CREATE PROCEDURE discount_calculator @accept_date DATE,@return_date DATE AS
BEGIN
BEGIN TRANSACTION
--============================================

if OBJECT_ID('dbo.tmpTable') is not null
	drop table tmpTable
CREATE TABLE tmpTable(
"Detail_id" INT not null,
"newDiscount" Decimal not null
)

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH how_many_order_for_one_device (detail_id,number_of_orders,device_id)
AS(
SELECT MAX(odd.DETAIL_ID)as detail_id,
	   count(odd.ORDER_ID) as number_of_orders,
	   MAX(odd.DEVICE_ID) as device_id 
FROM ORDER_DEVICE_DETAIL odd
where odd.ORDER_ID in(select ORDER_ID from SERVICE_ORDER where acceptDate>@accept_date AND returnDate<@return_date and returnDate is not NULL)
group by DEVICE_ID
having count(odd.ORDER_ID)>1)

,forFinalCalculation(detail_id,newDiscount)
as(
select max(dom.detail_id),
	   (case when max(dom.number_of_orders)*4>20 then 20 else max(dom.number_of_orders)*4 end) +(case when COUNT(odpd.PROBLEM_ID)>1 then 1 else 0 end)*10 as newDiscount
from how_many_order_for_one_device dom
join ORDER_DEVICE_PROBLEM_DETAIL odpd on odpd.DETAIL_ID=dom.detail_id
)INSERT INTO tmpTable(Detail_id,newDiscount)
select * from forFinalCalculation;

--====================================
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE ORDER_DEVICE_DETAIL
SET DISCOUNT=tmp.newDiscount
FROM
ORDER_DEVICE_DETAIL ODD JOIN tmpTable tmp ON ODD.DETAIL_ID=tmp.detail_id;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT * FROM ORDER_DEVICE_DETAIL 
where DETAIL_ID in(select Detail_id from tmpTable);
drop table tmpTable;

rollback
END


execute discount_calculator '2020-01-01','2020-12-30'
drop PROCEDURE discount_calculator
