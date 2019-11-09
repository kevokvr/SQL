--
-- CS 3810 - Principles of Database Systems - Fall 2019
-- DBA03: The "ipps" database
-- Date: Nov 7, 2019
-- Name(s): 
--

CREATE DATABASE ipps2;

USE ipps2;

CREATE TABLE DRGs (
  drgCode INT NOT NULL PRIMARY KEY,
  drgDesc VARCHAR(70) NOT NULL
);

CREATE TABLE HRRs (
  hrrId INT NOT NULL PRIMARY KEY,
  hrrState CHAR(2) NOT NULL,
  hrrName VARCHAR(25) NOT NULL
);

CREATE TABLE Providers (
  prvId INT NOT NULL PRIMARY KEY,
  prvName VARCHAR(50) NOT NULL,
  prvAddr VARCHAR(50),
  prvCity VARCHAR(20),
  prvState CHAR(2),
  prvZip INT,
  hrrId INT NOT NULL,
  FOREIGN KEY (hrrId) REFERENCES HRRs (hrrId)
);

CREATE TABLE ChargesAndPayments (
  prvId INT NOT NULL,
  drgCode INT NOT NULL,
  PRIMARY KEY (prvId, drgCode),
  FOREIGN KEY (prvId) REFERENCES Providers (prvId),
  FOREIGN KEY (drgCode) REFERENCES DRGs (drgCode),
  totalDischarges INT NOT NULL,
  avgCoveredCharges DECIMAL(10, 2) NOT NULL,
  avgTotalPayments DECIMAL(10, 2) NOT NULL,
  avgMedicarePayments DECIMAL(10, 2) NOT NULL
);

LOAD DATA INFILE '/usr/local/mysql-8.0.17-macos10.14-x86_64/files/DRGs.csv' INTO TABLE DRGs FIELDS TERMINATED BY ',' ENCLOSED BY '"';
LOAD DATA INFILE '/usr/local/mysql-8.0.17-macos10.14-x86_64/files/HRRs.csv' INTO TABLE HRRs FIELDS TERMINATED BY ',' ENCLOSED BY '"';
LOAD DATA INFILE '/usr/local/mysql-8.0.17-macos10.14-x86_64/files/Providers.csv' INTO TABLE Providers FIELDS TERMINATED BY ',' ENCLOSED BY '"';
LOAD DATA INFILE '/usr/local/mysql-8.0.17-macos10.14-x86_64/files/ChargesAndPayments.csv' INTO TABLE ChargesAndPayments FIELDS TERMINATED BY ',' ENCLOSED BY '"';

-- a) List all diagnostic names in alphabetical order (no repetition).
select distinct * from drgs order by drgDesc;

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers in alphabetical order (state first, provider name next, no repetition).
select distinct prvState, prvName from providers;

-- c) List the number of (distinct) providers.
SELECT COUNT(DISTINCT prvId) from Providers;

-- d) List the number of (distinct) providers per state (including Washington D.C.) in alphabetical order (also printing out the state).
SELECT prvState, COUNT(DISTINCT prvId) from Providers GROUP BY prvState;

-- e) List the number of (distinct) hospital referral regions (HRR).
SELECT COUNT(DISTINCT hrrId) from hrrs;

-- f) List the number (distinct) of HRRs per state (also printing out the state).
SELECT hrrState, COUNT(DISTINCT hrrId) from HRRs GROUP By hrrState;

-- g) List all of the (distinct) providers in the state of Pennsylvania in alphabetical order.
SELECT DISTINCT hrrId, hrrName from HRRs WHERE hrrState='PA' ORDER BY hrrName;

-- h) List the top 10 providers (with their correspondent state) that charged  (as described in avgTotalPayments) the most for the diagnose with code 308. 
-- Output should display the provider, their state, and the average charged amount in descending order.
SELECT prvName, prvState, avgTotalPayments FROM Providers INNER JOIN ChargesAndPayments ON Providers.prvId = ChargesAndPayments.prvId WHERE drgCode='308' order by avgTotalPayments DESC limit 10;
-- i) List the average charges (as described in avgTotalPayments) of all providers per state for the clinical condition with code 308. 
-- Output should display the state and the average charged amount per state in descending order (of the charged amount) using only two decimals.
SELECT prvState, ROUND(AVG(avgTotalPayments),2) FROM Providers INNER JOIN ChargesAndPayments ON Providers.prvId = ChargesAndPayments.prvID WHERE drgCode='308' GROUP BY prvState order by AVG(avgTotalPayments) DESC;
-- j) Which hospital and clinical condition pair had the highest difference 
-- between the amount charged  (as described in avgTotalPayments) and the amount covered by Medicare  (as described in avgMedicarePayments)?
SELECT Providers.prvName AS Hospital, DRGs.drgDesc AS ClinicalCondition, avgTotalPayments - avgMedicarePayments AS Diff from ChargesAndPayments
INNER JOIN Providers ON ChargesAndPayments.prvId = Providers.prvId
INNER JOIN HRRs ON Providers.hrrId = HRRs.hrrId
INNER JOIN DRGs ON ChargesAndPayments.drgCode = DRGs.drgCode order by Diff DESC limit 1;

