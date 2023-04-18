create database UK_ACCIDENTS_PROJECT
use UK_ACCIDENTS_PROJECT
drop table accident

	CREATE TABLE accident
(
	accident_index VARCHAR(13),
    accident_severity int
);
drop table vehicles
CREATE TABLE vehicles(
	accident_index VARCHAR(13),
    vehicle_type VARCHAR(50)
);

/* First: for vehicle types, create new csv by extracting data from Vehicle Type sheet from Road-Accident-Safety-Data-Guide.xls */
drop table vehicle_types
CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(50)
);

/* -------------------------------- */
/* Load Data */
SET SESSION sql_mode = ''
LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Accidents_2015.csv'
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Vehicles_2015.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;


LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


select * from vehicle_types
select Count(*) from vehicle_types
select * from accident

select * from vehicles


alter table accident
add primary key(accident_index)

alter table vehicles
add foreign key(accident_index) references accident(accident_index)

alter table accident
add primary key(accident_index)

alter table vehicle_types
add primary key(vehicle_code)

 
select * from vehicles
select * from vehicle_types
alter table vehicles
modify vehicle_type int

-- Use aggregate functions in SQL and Python to answer the following sample questions:
-- 1. Evaluate the median severity value of accidents caused by various Motorcycles.
-- 2. Evaluate Accident Severity and Total Accidents per Vehicle Type
-- 3. Calculate the Average Severity by vehicle type.
-- 4. Calculate the Average Severity and Total Accidents by Motorcycle.

select vehicle_code ,vehicle_type from vehicle_types where locate('motorcycle', vehicle_type) > 0 
select * from accident
select * from vehicles
select * from vehicle_types

with motorcycle as
(
select vehicle_code ,vehicle_type from vehicle_types where locate('motorcycle', vehicle_type) > 0 
)
with motor_cycle_index as
(
select v.accident_index ,m.vehicle_type, m.vehicle_code from motorcycle m inner join
vehicles v on v.vehicle_type = m.vehicle_code
)
select a.accident_severity ,mo.accident_index,mo.vehicle_type,mo.vehicle_code 
from motor_cycle_index mo inner join accident a on a.accident_index = mo.accident_index

with motor_median as
(
select vt.vehicle_type,  a.accident_severity
from vehicles v 
inner join accident a on a.accident_index = v.accident_index
INNER join vehicle_types vt on v.vehicle_type = vt.vehicle_code 
WHERE locate('motorcycle', vt.vehicle_type) > 0 
)
SET @index := -1;
 
SELECT
   AVG(m.accident_severity) as Median
FROM
   (SELECT @index:=@index + 1 AS i,
           motor_median.accident_severity AS median_new
    FROM  motor_median
    ORDER BY smotor_median.accident_severity) AS m
WHERE 
m.i IN (FLOOR(@index / 2), CEIL(@index / 2));


select * from accident
select * from vehicles
select * from vehicle_types






-- 3. Calculate the Average Severity by vehicle type

with total_accident_index as
(
select veh.accident_index,ty.vehicle_code, ty.vehicle_type from 
vehicle_types ty inner join vehicles veh
on ty.vehicle_code = veh.vehicle_type
)


select avg(a.accident_severity) as avg_severity, total.vehicle_code,
total.vehicle_type from total_accident_index total
inner join accident a on total.accident_index = a.accident_index
group by total.vehicle_code


-- -- 2. Evaluate Accident Severity and Total Accidents per Vehicle Type 

with total_accident_index as
(
select veh.accident_index,ty.vehicle_code, ty.vehicle_type from 
vehicle_types ty inner join vehicles veh
on ty.vehicle_code = veh.vehicle_type
)


select count(a.accident_index) as total_no_accident, total.vehicle_code,
total.vehicle_type from total_accident_index total
inner join accident a on total.accident_index = a.accident_index
group by total.vehicle_code

-- 4. Calculate the Average Severity and Total Accidents by Motorcycle.

select count(*) from accident
select * from vehicles
select * from vehicle_types

select avg(a.accident_index) as average_severity_mototrcycle, count(a.accident_index) as total_accidents
from vehicles v 
inner join accident a on a.accident_index = v.accident_index
INNER join vehicle_types vt on v.vehicle_type = vt.vehicle_code 
WHERE locate('motorcycle', vt.vehicle_type) > 0 


