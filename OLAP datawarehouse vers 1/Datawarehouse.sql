CREATE TABLE "CUSTOMER"(
"CUSTOMER_ID" INT NOT NULL PRIMARY KEY,
"FIRST_NAME" VARCHAR(20) NOT NULL,
"LAST_NAME" VARCHAR(20) NOT NULL,
"PHONE_NUMBER" VARCHAR(10) NOT NULL,
"EMAIL" VARCHAR(20),
"COUNTRY" VARCHAR(10) NOT NULL,
"CITY" VARCHAR(100) NOT NULL,
"ZIP_CODE" VARCHAR(10) NOT NULL,
"STREET" VARCHAR(100) NOT NULL,
"NUMBER" VARCHAR(10) NOT NULL,
);



CREATE TABLE "EMPLOYEE"(
"EMPLOYEE_ID" INT NOT NULL PRIMARY KEY,
"LAST_NAME" VARCHAR(20) NOT NULL,
"FIRST_NAME" VARCHAR(20) NOT NULL,
"MANAGER_ID" INT null,
"managerFirstName" varchar(20)null,
"managerLastName" varchar(20) null
);



CREATE TABLE "dimTIME"(
"TIME_id" int not null identity(1,1) primary key,
"Day" int not null,
"Month" int not null,
"Quarter" int not null,
"Year" int not null
)





CREATE TABLE "ORDER_FACT"(
"ORDER_ID" INT NOT NULL,
"CUSTOMER_ID" INT NOT NULL FOREIGN KEY REFERENCES CUSTOMER(CUSTOMER_ID),
"STATUS" VARCHAR(20) NOT NULL,
"acceptDate_ID" int NOT NULL FOREIGN KEY REFERENCES dimTIME(TIME_id),
"returnDate_ID" int FOREIGN KEY REFERENCES dimTIME(TIME_id),
"acceptEmployee_ID" INT NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EMPLOYEE_ID),
"returnEmployee_ID" INT NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EMPLOYEE_ID),
"DEVICE_TYPE" varchar(20) NOT NULL,
"SERIAL_NUMBER" varchar(20) not null,
"MANUFACTURER_NAME" VARCHAR(50) NOT NULL,
"COST" MONEY NOT NULL,
"DISCOUNT" DECIMAL NULL,
"number_of_problems" int not null,
"average_complexity" int not null,
CONSTRAINT UN_ORDER UNIQUE (ORDER_ID,CUSTOMER_ID,SERIAL_NUMBER,MANUFACTURER_NAME)
);
CREATE CLUSTERED INDEX IX_tblordp
ON ORDER_FACT(ORDER_ID,CUSTOMER_ID ASC)


---------------------------------INSERTING CUSTOMERS-------------------------------------------------
INSERT INTO CUSTOMER(CUSTOMER_ID,FIRST_NAME,LAST_NAME,PHONE_NUMBER,EMAIL,COUNTRY,CITY,ZIP_CODE,STREET,NUMBER) 
select c.CUSTOMER_ID,c.FIRST_NAME,c.LAST_NAME,c.PHONE_NUMBER,c.EMAIL,a.COUNTRY,a.CITY,a.ZIP_CODE,a.STREET,a.NUMBER from HomeWWW.dbo.CUSTOMER c
join HomeWWW.dbo.CUSTOMER_ADRESS  ca on ca.CUSTOMER_ID=c.CUSTOMER_ID
join HomeWWW.dbo.ADRESS a on a.ADRESS_ID=ca.ADRESS_ID
--------------------------------------------------------------------------------------------------



--------------==============================INSERTING EMPLOYEES========================================================
INSERT INTO EMPLOYEE(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,MANAGER_ID,managerFirstName,managerLastName)
select m.EMPLOYEE_ID,m.FIRST_NAME,m.LAST_NAME,e.EMPLOYEE_ID as managerID,e.FIRST_NAME as managerFirstName,e.LAST_NAME as managerLastName from HomeWWW.dbo.EMPLOYEE e
right join HomeWWW.dbo.EMPLOYEE m on m.MANAGER_ID=e.EMPLOYEE_ID
--========================================================================================

--================================================INSERTING ORDER FACT============================================================
;with order_fact_pre(ORDER_ID,CUSTOMER_ID,STATUS,acceptDate,returnDate,acceptEmployee,returnEmployee,device_type,serial_number,manufacturer_Name,cost,discount,problems,average_complexity) as
(
select  so.ORDER_ID,max(so.CUSTOMER_ID) as customer_id,max(STATUS_TYPE)as 'status',max(so.acceptDate)as acceptDate,max(so.returnDate) as returnDate,
max(so.acceptEmployee_ID)as acceptEmployee,max(so.returnEmployee_ID) as returnEmplyoee,
max(dt.DEVICE_TYPE) as device_type,max(md.PRODUCT_SERIAL_NUMBER) as serial_number,
max(m.MANUFACTURER_NAME) as manufacturer_Name,
MAX(odd.COST) as cost,max(odd.DISCOUNT) as discount , COUNT(p.COMPLEXITY) as problems,
avg( p.COMPLEXITY)  as average_complexity  from HomeWWW.dbo.ORDER_DEVICE_DETAIL odd
left join HomeWWW.dbo.SERVICE_ORDER so on so.ORDER_ID=odd.ORDER_ID
left join HomeWWW.dbo.ORDER_STATUS os on os.STATUS_ID=so.STATUS_ID
left join HomeWWW.dbo.DEVICE d on d.DEVICE_ID=odd.DEVICE_ID
left join HomeWWW.dbo.DEVICE_TYPES dt on dt.DEVICE_TYPES_ID=d.DEVICE_TYPES_ID
left join HomeWWW.dbo.MANUFACTURER_DEVICE md on md.DEVICE_ID = d.DEVICE_ID
left join HomeWWW.dbo.MANUFACTURER m on m.MANUFACTURER_ID=md.MANUFACTURER_ID
left join HomeWWW.dbo.ORDER_DEVICE_PROBLEM_DETAIL dpd on dpd.DETAIL_ID=odd.DETAIL_ID
left join HomeWWW.dbo.PROBLEM p on p.PROBLEM_ID =dpd.PROBLEM_ID
group by dpd.DETAIL_ID,so.ORDER_ID
),
order_insert_time_id_return 
(ORDER_ID,CUSTOMER_ID,STATUS,acceptDate,returnDate,acceptEmployee,returnEmployee,device_type,serial_number,manufacturer_Name,cost,discount,problems,average_complexity)
as 
(
select ORDER_ID,CUSTOMER_ID,STATUS,acceptDate,d.TIME_id as returnDate,acceptEmployee,returnEmployee,
device_type,serial_number,manufacturer_Name,cost,discount,problems,average_complexity from order_fact_pre o
left join dimTIME d on d.Day =DATEPART(DAY,o.returnDate)
			and d.Month=DATEPART(MONTH,o.returnDate)
			and d.Year=DATEPART(YEAR,o.returnDate)
)
,
order_insert_time_id_accept
(ORDER_ID,CUSTOMER_ID,STATUS,acceptDate,returnDate,acceptEmployee,returnEmployee,device_type,serial_number,manufacturer_Name,cost,discount,problems,average_complexity)
as 
(
select ORDER_ID,CUSTOMER_ID,STATUS,d.TIME_id as acceptDate,returnDate,acceptEmployee,returnEmployee,
device_type,serial_number,manufacturer_Name,cost,discount,problems,average_complexity from order_insert_time_id_return o
left join dimTIME d on d.Day =DATEPART(DAY,o.acceptDate)
			and d.Month=DATEPART(MONTH,o.acceptDate)
			and d.Year=DATEPART(YEAR,o.acceptDate)
)INSERT INTO ORDER_FACT select * from order_insert_time_id_accept
---==========================================================================================================================================


---=====================================================================INSERTING DATE
;with DATES (date) as 
(
select DISTINCT os.acceptDate from HomeWWW.dbo.SERVICE_ORDER os
union all
select so.returnDate from HomeWWW.dbo.SERVICE_ORDER so
where so.returnDate is not null),
dates_group_by 
(Day,Month,Quarter,year)
as(
select DISTINCT DATEPART(DAY,d.date) as day, 
				DATEPART(MONTH,d.date) as month, 
				(case when DATEPART(MONTH,d.date) between 1 and 3 then 1
				 when DATEPART(MONTH,d.date) between 4 and 6 then 2
				 when DATEPART(MONTH,d.date) between 7 and 9 then 3
				 when DATEPART(MONTH,d.date) between 10 and 12 then 4 end) as quarter,
				DATEPART(year,d.date) as year 
from DATES d)
INSERT INTO dimTIME 
select * from dates_group_by dg
group by dg.Day,dg.Month,dg.Quarter,dg.year



