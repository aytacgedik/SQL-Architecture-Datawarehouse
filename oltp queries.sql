--Customer
CREATE TABLE "ADRESS"(
"ADRESS_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"COUNTRY" VARCHAR(10) NOT NULL,
"CITY" VARCHAR(100) NOT NULL,
"ZIP_CODE" VARCHAR(10) NOT NULL,
"STREET" VARCHAR(100) NOT NULL,
"NUMBER" VARCHAR(10) NOT NULL,
 --CONSTRAINT UC_Adress UNIQUE (COUNTRY,CITY,ZIP_CODE,STREET,NUMBER)
);

CREATE TABLE "CUSTOMER"(
"CUSTOMER_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"FIRST_NAME" VARCHAR(20) NOT NULL,
"LAST_NAME" VARCHAR(20) NOT NULL,
"PHONE_NUMBER" VARCHAR(10) NOT NULL,
"EMAIL" VARCHAR(20),
--CONSTRAINT UC_CUSTOMER UNIQUE (FIRST_NAME,LAST_NAME,PHONE_NUMBER)
);

--CREATE TABLE ADRESS_TYPE() lookup table DELETED TO MAKE IT SIMPLE

CREATE TABLE "CUSTOMER_ADRESS"(
"ADRESS_ID" INT NOT NULL,
"CUSTOMER_ID" INT NOT NULL,
CONSTRAINT UC_ADRESS UNIQUE(ADRESS_ID,CUSTOMER_ID),
--ADRESS_TYPE
FOREIGN KEY(ADRESS_ID) REFERENCES ADRESS(ADRESS_ID),
FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)
);


--PROBLEM

--CREATE TABLE "COMPLEXITY"(
--"COMPLEXITY_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--"COMPLEXITY_DEGREE" INT NOT NULL ,
--);

CREATE TABLE "CATEGORY"(
"CATEGORY_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"CATEGORY" varchar(20) NOT NULL
);


CREATE TABLE "PROBLEM"(
"PROBLEM_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"CATEGORY_ID" INT NOT NULL,
"COMPLEXITY" INT NOT NULL,
"DESCRIPTION" TEXT,
CHECK (COMPLEXITY>0 AND COMPLEXITY<=10),
FOREIGN KEY(CATEGORY_ID) REFERENCES CATEGORY(CATEGORY_ID));


--DEVICE



CREATE TABLE "MANUFACTURER"(
"MANUFACTURER_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"MANUFACTURER_NAME" VARCHAR(50) NOT NULL);

CREATE TABLE "DEVICE_TYPES"(
"DEVICE_TYPES_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"DEVICE_TYPE" VARCHAR(20) NOT NULL);


CREATE TABLE "DEVICE"(
"DEVICE_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"DEVICE_TYPES_ID" INT NOT NULL,
FOREIGN KEY(DEVICE_TYPES_ID) REFERENCES DEVICE_TYPES(DEVICE_TYPES_ID)
);

CREATE TABLE "MANUFACTURER_DEVICE"(
"MANUFACTURER_ID" INT NOT NULL,
"DEVICE_ID" INT NOT NULL,
"PRODUCT_SERIAL_NUMBER" VARCHAR(50) NOT NULL,
CONSTRAINT UC_odd UNIQUE (MANUFACTURER_ID,DEVICE_ID,PRODUCT_SERIAL_NUMBER),
FOREIGN KEY(MANUFACTURER_ID) REFERENCES MANUFACTURER(MANUFACTURER_ID),
FOREIGN KEY(DEVICE_ID) REFERENCES DEVICE(DEVICE_ID));

CREATE CLUSTERED INDEX IX_tblordp
ON MANUFACTURER_DEVICE(DEVICE_ID ASC)

--EMPLOYEE

CREATE TABLE "ORDER_STATUS"(
"STATUS_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"STATUS_TYPE" VARCHAR(20) NOT NULL);




CREATE TABLE "EMPLOYEE"(
"EMPLOYEE_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"LAST_NAME" VARCHAR(20) NOT NULL,
"FIRST_NAME" VARCHAR(20) NOT NULL,
"MANAGER_ID" INT,
FOREIGN KEY(MANAGER_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)
);


--CREATE TABLE "Accep_or_return"(
--"Accep_or_return_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
--"EMPLOYEE_ID" INT NOT NULL,
--"DATE_" DATE NOT NULL,
--FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)

--);

--ORDER
--CREATE TABLE PERIOD


CREATE TABLE "SERVICE_ORDER"(
"ORDER_ID" INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
"STATUS_ID" INT NOT NULL,
"acceptEmployee_ID" INT NOT NULL,
"returnEmployee_ID" INT NOT NULL,
"acceptDate" DATE NOT NULL,
"returnDate" date,
"CUSTOMER_ID" INT NOT NULL,
CHECK (acceptEmployee_ID!=returnEmployee_ID),
FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
FOREIGN KEY(STATUS_ID) REFERENCES ORDER_STATUS(STATUS_ID),
FOREIGN KEY(acceptEmployee_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
FOREIGN KEY(returnEmployee_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID));


CREATE TABLE "ORDER_DEVICE_DETAIL"(
"DETAIL_ID" INT NOT NULL IDENTITY(1,1) UNIQUE,
"DEVICE_ID" INT NOT NULL,
"ORDER_ID" INT NOT NULL,
"COST" MONEY NOT NULL,
"DISCOUNT" DECIMAL,
CONSTRAINT UC_odd UNIQUE (ORDER_ID,DEVICE_ID),
FOREIGN KEY(ORDER_ID) REFERENCES SERVICE_ORDER(ORDER_ID),
FOREIGN KEY(DEVICE_ID) REFERENCES DEVICE(DEVICE_ID));

CREATE CLUSTERED INDEX IX_tblordp
ON ORDER_DEVICE_DETAIL(ORDER_ID ASC)


CREATE TABLE "ORDER_DEVICE_PROBLEM_DETAIL"(
"DETAIL_ID" INT NOT NULL,
"PROBLEM_ID" INT NOT NULL,
FOREIGN KEY(DETAIL_ID) REFERENCES ORDER_DEVICE_DETAIL(DETAIL_ID),
FOREIGN KEY(PROBLEM_ID) REFERENCES PROBLEM(PROBLEM_ID));


CREATE CLUSTERED INDEX IX_tblordp
ON ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID ASC, PROBLEM_ID ASC)

--------------PART 2
--INSERT


INSERT INTO MANUFACTURER(MANUFACTURER_NAME) VALUES('Apple');
INSERT INTO MANUFACTURER(MANUFACTURER_NAME) VALUES('Microsoft');
INSERT INTO MANUFACTURER(MANUFACTURER_NAME) VALUES('Amazon');
INSERT INTO MANUFACTURER(MANUFACTURER_NAME) VALUES('pepe');
INSERT INTO MANUFACTURER(MANUFACTURER_NAME) VALUES('kek');

select * from MANUFACTURER

INSERT INTO DEVICE_TYPES(DEVICE_TYPE) VALUES('electric');
INSERT INTO DEVICE_TYPES(DEVICE_TYPE) VALUES('oil');
INSERT INTO DEVICE_TYPES(DEVICE_TYPE) VALUES('battery');
INSERT INTO DEVICE_TYPES(DEVICE_TYPE) VALUES('water');
INSERT INTO DEVICE_TYPES(DEVICE_TYPE) VALUES('uranium');

select * from DEVICE_TYPES

INSERT INTO ADRESS(COUNTRY,ZIP_CODE,CITY,STREET,NUMBER) 
VALUES('POLAND','01-502','WARSAW','NIE','100');
INSERT INTO ADRESS(COUNTRY,ZIP_CODE,CITY,STREET,NUMBER) 
VALUES('POLAND','01-503','KRAKOW','WI','100');
INSERT INTO ADRESS(COUNTRY,ZIP_CODE,CITY,STREET,NUMBER) 
VALUES('POLAND','01-504','WROCLAW','EM','100');
INSERT INTO ADRESS(COUNTRY,ZIP_CODE,CITY,STREET,NUMBER) 
VALUES('POLAND','01-505','WARSAW','ONE','100');
INSERT INTO ADRESS(COUNTRY,ZIP_CODE,CITY,STREET,NUMBER) 
VALUES('USA','506','LUL','TWO','100');


select * from ADRESS

INSERT INTO CUSTOMER(FIRST_NAME,LAST_NAME,PHONE_NUMBER,EMAIL)
VALUES ('CARRY','POTTER','+48888666','email1@email.com');
INSERT INTO CUSTOMER(FIRST_NAME,LAST_NAME,PHONE_NUMBER,EMAIL)
VALUES ('PEPE','LA','+8812245','email2@email.com');
INSERT INTO CUSTOMER(FIRST_NAME,LAST_NAME,PHONE_NUMBER)
VALUES ('ONE','PUNCMMAN','+999999');
INSERT INTO CUSTOMER(FIRST_NAME,LAST_NAME,PHONE_NUMBER)
VALUES ('XD','DX','+48888666');
INSERT INTO CUSTOMER(FIRST_NAME,LAST_NAME,PHONE_NUMBER)
VALUES ('X � A-12','Musk','+48888666');

select * from CUSTOMER
INSERT INTO CUSTOMER_ADRESS(CUSTOMER_ID,ADRESS_ID) VALUES(1,1);
INSERT INTO CUSTOMER_ADRESS(CUSTOMER_ID,ADRESS_ID) VALUES(2,2);
INSERT INTO CUSTOMER_ADRESS(CUSTOMER_ID,ADRESS_ID) VALUES(3,3);
INSERT INTO CUSTOMER_ADRESS(CUSTOMER_ID,ADRESS_ID) VALUES(4,4);
INSERT INTO CUSTOMER_ADRESS(CUSTOMER_ID,ADRESS_ID) VALUES(5,5);

select * from CUSTOMER_ADRESS

INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(1);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(2);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(3);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(4);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(5);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(1);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(2);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(3);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(4);
INSERT INTO DEVICE(DEVICE_TYPES_ID) VALUES(5);

select * from DEVICE

INSERT INTO CATEGORY(CATEGORY) VALUES('repair');
INSERT INTO CATEGORY(CATEGORY) VALUES('maintance');
INSERT INTO CATEGORY(CATEGORY) VALUES('tuning');

select * from CATEGORY

INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID) VALUES(1,1);
INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID,DESCRIPTION) VALUES(5,2,'REEEE');
INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID) VALUES(8,1);
INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID) VALUES(9,3);
INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID) VALUES(10,1);
INSERT INTO PROBLEM(COMPLEXITY,CATEGORY_ID) VALUES(2,2);

select * from PROBLEM
--STATUS
INSERT INTO ORDER_STATUS(STATUS_TYPE) VALUES('Fixed');
INSERT INTO ORDER_STATUS(STATUS_TYPE) VALUES('In progress');
--
select * from ORDER_STATUS

--Employe

INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME) VALUES(NULL,'ceo','andy');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME) VALUES(1,'zoo','mer');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME)VALUES(1,'zoo2','mer2');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME) VALUES(1,'zoo3','mer3');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME) VALUES(3,'koo','mer');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME) VALUES(3,'koo2','mer2');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME)  VALUES(3,'koo3','mer3');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME)  VALUES(3,'koo4','mer4');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME)  VALUES(3,'koo5','mer5');
INSERT INTO EMPLOYEE(MANAGER_ID,FIRST_NAME,LAST_NAME)  VALUES(3,'koo6','mer6');

select * from EMPLOYEE

INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(1,1,'2020-02-05',2,'2020-02-15',1);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,2,'2020-03-05',3,'2020-03-15',1);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(1,3,'2020-04-05',4,'2020-04-15',1);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,4,'2020-05-05',5,'2020-05-15',2);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(1,5,'2020-06-05',6,'2020-06-15',2);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,1,'2020-07-05',7,'2020-07-15',3);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(1,3,'2020-08-05',2,'2020-08-15',4);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,8,'2020-09-05',3,'2020-09-15',5);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,CUSTOMER_ID)
VALUES(1,5,'2020-10-05',2,1);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,CUSTOMER_ID)
VALUES(2,6,'2020-10-05',2,1);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,5,'2020-19-10',6,'2020-10-15',4);
INSERT INTO SERVICE_ORDER(STATUS_ID,acceptEmployee_ID,acceptDate,returnEmployee_ID,returnDate,CUSTOMER_ID)
VALUES(2,5,'2020-10-16',6,'2020-11-15',4);

select * from SERVICE_ORDER

INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(1,1,5000,5.5);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(2,1,10000,10);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(3,1,20000,20);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(4,2,1000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(5,2,500,0.5);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(6,6,700,7);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(7,6,8000,8);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST,DISCOUNT)
VALUES(8,8,9000,9);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(9,4,11000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(10,10,5000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(3,9,5000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(7,6,9000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(7,6,9000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(7,11,9000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(8,13,9000);
INSERT INTO ORDER_DEVICE_DETAIL(DEVICE_ID,ORDER_ID,COST)
VALUES(8,14,9000);

select * from ORDER_DEVICE_DETAIL

INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(1,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(1,2)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(1,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(2,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(3,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(4,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(5,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(6,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(7,2)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(8,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(9,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(10,2)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(10,1)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(10,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(11,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(11,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(11,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(15,3)
INSERT INTO ORDER_DEVICE_PROBLEM_DETAIL(DETAIL_ID,PROBLEM_ID)
VALUES(16,3)

INSERT INTO MANUFACTURER_DEVICE(DEVICE_ID,MANUFACTURER_ID,PRODUCT_SERIAL_NUMBER)
VALUES(1,1,12345)
INSERT INTO MANUFACTURER_DEVICE(DEVICE_ID,MANUFACTURER_ID,PRODUCT_SERIAL_NUMBER)
VALUES(2,2,54321)
INSERT INTO MANUFACTURER_DEVICE(DEVICE_ID,MANUFACTURER_ID,PRODUCT_SERIAL_NUMBER)
VALUES(3,3,23451)
INSERT INTO MANUFACTURER_DEVICE(DEVICE_ID,MANUFACTURER_ID,PRODUCT_SERIAL_NUMBER)
VALUES(4,4,34512)
INSERT INTO MANUFACTURER_DEVICE(DEVICE_ID,MANUFACTURER_ID,PRODUCT_SERIAL_NUMBER)
VALUES(5,5,45123)
select * from ORDER_DEVICE_PROBLEM_DETAIL

--MODIFY PART 3
select DEVICE_ID,CUSTOMER_ID from ORDER_DEVICE_DETAIL d
join SERVICE_ORDER o on d.ORDER_ID=o.ORDER_ID
--1
UPDATE ORDER_DEVICE_DETAIL
SET DEVICE_ID=2,DISCOUNT=NULL
WHERE DETAIL_ID=4;
select * from SERVICE_ORDER
select * from ORDER_DEVICE_DETAIL
UPDATE ORDER_DEVICE_DETAIL
SET DEVICE_ID=2,DISCOUNT=NULL
WHERE DETAIL_ID=4;


UPDATE ORDER_DEVICE_DETAIL
SET ORDER_ID =10,COST =77777, DISCOUNT =5
WHERE DEVICE_ID=9 AND ORDER_ID=4;

SELECT * FROM ORDER_DEVICE_DETAIL

--2
 -------------------------------------------------------
SELECT * FROM EMPLOYEE

UPDATE EMPLOYEE
SET MANAGER_ID=1
WHERE EMPLOYEE_ID=7;

SELECT * FROM EMPLOYEE


--3
SELECT * FROM PROBLEM

UPDATE PROBLEM
SET CATEGORY_ID=3
WHERE PROBLEM_ID=5

SELECT * FROM PROBLEM

------------------------------------------------------
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

---PART 4
select * from ORDER_DEVICE_DETAIL

--first query
 select d.CUSTOMER_ID
		,max(d.numberofdevices) as number_of_devices
from(select p.CUSTOMER_ID,p.ORDER_ID, count(devices_count) as numberofdevices 
	from (select  o.CUSTOMER_ID
				 ,odp.ORDER_ID
				 ,count(odp.DEVICE_ID) as devices_count
		  from ORDER_DEVICE_DETAIL odp 
		  inner join SERVICE_ORDER o on o.ORDER_ID = odp.ORDER_ID
		  group by o.CUSTOMER_ID, odp.ORDER_ID, odp.DEVICE_ID)p
	group by p.CUSTOMER_ID,p.ORDER_ID
	)d
	group by d.CUSTOMER_ID




--2. QU ========================================================================================

select e.EMPLOYEE_ID
		,max(e.FIRST_NAME) FirstName
		,max(e.LAST_NAME) LastName
		,COUNT(o.ORDER_ID) as worked
from EMPLOYEE e
join SERVICE_ORDER o 
on e.EMPLOYEE_ID = o.returnEmployee_ID 
OR EMPLOYEE_ID = o.acceptEmployee_ID
group by e.EMPLOYEE_ID
having count(*)<0.8*(select AVG(1.0*tm.Worked) 
	from(select tmp.EMPLOYEE_ID
		,sum(tmp.cCount) as Worked 
			from(select e.EMPLOYEE_ID
						,COUNT(*) as cCount
					from EMPLOYEE e
					join SERVICE_ORDER o 
					on e.EMPLOYEE_ID=o.acceptEmployee_ID
					group by e.EMPLOYEE_ID
						union ALL
				select e.EMPLOYEE_ID
						,COUNT(*) as cCount
					from EMPLOYEE e
			join SERVICE_ORDER o 
		on e.EMPLOYEE_ID=o.returnEmployee_ID
	group by e.EMPLOYEE_ID)tmp
group by tmp.EMPLOYEE_ID)tm);



---2. QU ALTERNATIVE


select tm.worke,tm.EMPLOYEE_ from(
select tmp.acceptEmployee_ID as EMPLOYEE_, sum(tmp.worked) as worke from (
select acceptEmployee_ID, COUNT(acceptEmployee_ID) as worked from SERVICE_ORDER
group by acceptEmployee_ID
union ALL
select returnEmployee_ID, COUNT(returnEmployee_ID) as worked from SERVICE_ORDER
group by returnEmployee_ID)tmp
group by tmp.acceptEmployee_ID
)tm
where tm.worke <0.8*(

select AVG(1.0*tm.worke) from(
select tmp.acceptEmployee_ID as EMPLOYEE_, sum(tmp.worked) as worke from (
select acceptEmployee_ID, COUNT(acceptEmployee_ID) as worked from SERVICE_ORDER
group by acceptEmployee_ID
union ALL
select returnEmployee_ID, COUNT(returnEmployee_ID) as worked from SERVICE_ORDER
group by returnEmployee_ID)tmp
group by tmp.acceptEmployee_ID
)tm)


--third query
;With mountly (YearMonth,
				Employee_id,
				firstname,
				lastname,
				many_times_worked,
				accepdate)as
(
select  CONCAT(DATEPART(YEAR,  tmp.acceptDate) ,'-',  DATEPART(MONTH,  acceptDate)) AS YearMonth
	  ,tmp.acceptEmployee_ID as Employee_id
      ,max(FIRST_NAME) as firstName
	  ,max(LAST_NAME) as lastName 
	  ,COUNT(tmp.acceptEmployee_ID) as many_times_worked,
	  MAX(acceptDate)
from(select so.acceptEmployee_ID
           ,so.acceptDate 
	from SERVICE_ORDER so
		union all
	select so.returnEmployee_ID
		  ,so.returnDate 
	from SERVICE_ORDER so)tmp
join EMPLOYEE e
on e.EMPLOYEE_ID=tmp.acceptEmployee_ID 
group by tmp.acceptDate,tmp.acceptEmployee_ID
having acceptDate is not null

) select MAX(YearMonth)as 'Monthly Window',MAX(Employee_id)as employee_id,MAX(firstname)as firstName,MAX(lastname)as Lastname,SUM(many_times_worked)as many_times_worken from mountly
group by YearMonth,Employee_id
order by MAX(accepdate)
--4th query


select top(10) odD.ORDER_ID, sum(odD.COST)
as 'TotalPrice' from ORDER_DEVICE_DETAIL odD
group by odD.ORDER_ID 
order by TotalPrice desc

select * from ORDER_DEVICE_DETAIL

--5th query

;WITH ACTIVE_ORDERS (ORDER_ID)
AS
(
select ORDER_ID from SERVICE_ORDER where returnDate is NULL
)
,
--=======================================================================
Details (DETAIL_ID)
AS
(
SELECT DETAIL_ID FROM ORDER_DEVICE_DETAIL odd
join ACTIVE_ORDERS co on co.ORDER_ID=odd.ORDER_ID
)
,
--=======================================================================
hManyProblems (TOTAL_ACTIVE)
AS
(
SELECT COUNT(*) FROM ORDER_DEVICE_PROBLEM_DETAIL odpd
join Details d on d.DETAIL_ID=odpd.DETAIL_ID
group by d.DETAIL_ID
)
--=======================================================================
SELECT count(*) as 'TOTAL NUMBER OFACTIVE ORDERS ATLEAST 3 PROBLEM' FROM hManyProblems
where TOTAL_ACTIVE>=3;
