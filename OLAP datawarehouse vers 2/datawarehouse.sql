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
"ORDER_ID" INT NOT NULL PRIMARY KEY,
"CUSTOMER_ID" INT NOT NULL FOREIGN KEY REFERENCES CUSTOMER(CUSTOMER_ID),
"STATUS" VARCHAR(20) NOT NULL,
"acceptEmployee_ID" INT NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EMPLOYEE_ID),
"returnEmployee_ID" INT NOT NULL FOREIGN KEY REFERENCES EMPLOYEE(EMPLOYEE_ID),
"NUMBER_OF_DEVICES" INT NOT NULL,
"acceptDate_ID" int NOT NULL FOREIGN KEY REFERENCES dimTIME(TIME_id),
"returnDate_ID" int FOREIGN KEY REFERENCES dimTIME(TIME_id),
"COST" MONEY NOT NULL,
"DISCOUNT" DECIMAL NULL,
"number_of_problems" int not null,
"average_complexity" int not null,
);


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
;with order_order (order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,acceptDate,returnDate,cost,discount) as
(
select so.ORDER_ID,MAX(CUSTOMER_ID)as Customer_id,max(os.STATUS_TYPE) as 'status',MAX(acceptEmployee_ID) as acceptEmployeID,
MAX(returnEmployee_ID) as returnEmplyoeeID,COUNT(odd.DEVICE_ID) as number_of_device,
max(so.acceptDate) as acceptDate,MAX(so.returnDate) as returnDate,SUM(odd.COST)as cost,sum(odd.DISCOUNT) as discount
from HomeWWW.dbo.SERVICE_ORDER so
left join HomeWWW.dbo.ORDER_DEVICE_DETAIL odd on odd.ORDER_ID=so.ORDER_ID
left join HomeWWW.dbo.ORDER_STATUS os on os.STATUS_ID=so.STATUS_ID
group by so.ORDER_ID
),
problems (order_id,number_of_problems,average_comlexity) as
(
select odd.ORDER_ID,COUNT(odd.ORDER_ID) as number_of_problems,avg(p.COMPLEXITY) average_complexity  from HomeWWW.dbo.ORDER_DEVICE_DETAIL odd 
left join HomeWWW.dbo.ORDER_DEVICE_PROBLEM_DETAIL odpd on odd.DETAIL_ID=odpd.DETAIL_ID
left join HomeWWW.dbo.PROBLEM p on p.PROBLEM_ID=odpd.PROBLEM_ID
group by odd.ORDER_ID),
mid_order (order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,acceptDate,returnDate,cost,discount,number_of_problems,average_complexity)
as
(
select o.*,p.number_of_problems,p.average_comlexity from order_order o
left join problems p on p.order_id=o.order_id
) 
,accepOrder (order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,acceptDate,returnDate,cost,discount,number_of_problems,average_complexity) as
(
select order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,d.TIME_id as acceptDate
,returnDate,cost,discount,number_of_problems,average_complexity 
from mid_order o
left join dimTIME d on d.Day =DATEPART(DAY,o.acceptDate)
			and d.Month=DATEPART(MONTH,o.acceptDate)
			and d.Year=DATEPART(YEAR,o.acceptDate)
)
,last_one(order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,acceptDate,returnDate,cost,discount,number_of_problems,average_complexity) as
(
select order_id,customer_id,status,acceptEmployeeID,returnEmployeeID,number_of_devices,o.acceptDate,d.TIME_id as returnDate
,cost,discount,number_of_problems,average_complexity 
from accepOrder o
left join dimTIME d on d.Day =DATEPART(DAY,o.returnDate)
			and d.Month=DATEPART(MONTH,o.returnDate)
			and d.Year=DATEPART(YEAR,o.returnDate)
)insert into ORDER_FACT select * from last_one

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



