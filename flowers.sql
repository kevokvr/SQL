--Principles of Database Systems
--Instructor: Thyago Mota
--Database Assignment 01
--Student: Kevin Valenzuela
--September 21, 2019

create database flowers;

use flowers;

create table Zones(
id int PRIMARY KEY,
lowerTemp int NOT NULL,
higherTemp int NOT NULL);

INSERT INTO Zones
  (id, lowerTemp, higherTemp)
  VALUES
  (2, -50, -40),
  (3,-40, -30),
  (4, -30, -20),
  (5, -20, -10),
  (6, -10, 0),
  (7,   0, 10),
  (8,  10, 20),
  (9,  20, 30),
  (10,  30, 40);


create table Deliveries(
id int PRIMARY KEY,
categ char(5),
delSize numeric(18,3));

INSERT INTO Deliveries
    (id, categ, delSize)
    VALUES
    (1, 'pot', 1.500),
    (2, 'pot', 2.250),
    (3, 'pot', 2.625),
    (4, 'pot', 4.250),
    (5, 'plant', NULL),
    (6, 'bulb', NULL),
    (7, 'hedge', 18.000),
    (8, 'shrub', 24.000),
    (9, 'tree', 36.000);


create table FlowersInfo(
id int(3) PRIMARY KEY,
comName char(30),
latName char(35),
cZone int,
hZone int,
deliver int,
sunNeeds char(5));

INSERT INTO FlowersInfo
    (id, comName, latName, cZone, hZone, deliver, sunNeeds)
VALUES
    (101, 'Lady Fern', 'Atbyrium filix-femina', 2,  9, 5, 'SH'),
    (102, 'Pink Caladiums', 'C.x bortulanum',10, 10, 6, 'PtoSH'),
    (103, 'Lily-of-the-Valley', 'Convallaria majalis', 2,  8, 5, 'PtoSH'),
    (105, 'Purple Liatris', 'Liatris spicata', 3,  9, 6, 'StoP'),
    (106, 'Black Eyed Susan', 'Rudbeckia fulgida var. specios', 4, 10, 2, 'StoP'),
    (107, 'Nikko Blue Hydrangea', 'Hydrangea macrophylla', 5,  9, 4, 'StoSH'),
    (108, 'Variegated Weigela', 'W. florida Variegata', 4,  9, 8, 'StoP'),
    (110, 'Lombardy Poplar', 'Populus nigra Italica', 3,  9, 9, 'S'),
    (111, 'Purple Leaf Plum Hedge', 'Prunus x cistena', 2,  8, 7, 'S'),
    (114, 'Thorndale Ivy', 'Hedera belix Thorndale', 3, 9, 1, 'StoSH');

--a) the total number of zones. 
SELECT COUNT(id) AS TotalZones FROM Zones;

--b) the number of flowers per cool zone. 
SELECT cZone, COUNT(comName) AS Total FROM FlowersInfo GROUP BY cZone;

--c) common names of the plants that have delivery sizes less than 5. 
SELECT comName FROM FlowersInfo WHERE deliver > 5;

--d) common names of the plants that require full sun (i.e., sun needs contains ‘S’). 
SELECT comName FROM FlowersInfo WHERE sunNeeds LIKE '%S%' AND sunNeeds NOT LIKE '%SH%';

--e) all delivery category names order alphabetically (without repetition). 
SELECT DISTINCT categ FROM Deliveries ORDER BY categ;

--f) the exact output (note that it is order by Name):
SELECT comName as Name, lowerTemp as 'Cool Zone(low)', higherTemp as 'Cool Zone (high)', categ as 'Delivery Category' 
FROM FlowersInfo 
INNER JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id
JOIN Zones ON Zones.id = FlowersInfo.cZone 
ORDER BY comName;

--g) plant names that have the same hot zone as “Pink Caladiums” (your solution MUST get the hot zone of “Pink Caladiums” in a variable). 
SET @var1 = (SELECT hZone FROM FlowersInfo WHERE comName = 'Pink Caladiums');
SELECT comName FROM FlowersInfo WHERE hzone = @var1;

--h) the total number of plants, the minimum delivery size, the maximum delivery size, 
--and the average size based on the plants that have delivery sizes (note that the average value should be rounded using two decimals). 
-- ** Note: AVG function ignores NULL values by default
SELECT COUNT(DISTINCT categ) AS Total, MIN(delSize) as Min, MAX(delSize) as Max, AVG(CAST(delSize AS DECIMAL(4,2))) AS Average FROM Deliveries;

--i) the Latin name of the plant that has the word ‘Eyed’ in its name (you must use LIKE in this query to get full credit). 
SELECT latName FROM FlowersInfo WHERE comName LIKE '%eyed%';

--j) the exact output (ordered by Category and then by Name):
SELECT categ as 'Category', comName as Name FROM FlowersInfo
INNER JOIN Deliveries ON FlowersInfo.deliver = Deliveries.id ORDER BY categ, comName;





