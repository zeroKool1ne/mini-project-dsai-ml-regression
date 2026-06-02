-- ============================================================
-- Mini Project: House Price Regression — SQL Solutions
-- ============================================================

-- Q1: Create a database called house_price_regression
CREATE DATABASE house_price_regression;
USE house_price_regression;

-- Q2: Create a table house_price_data with the same columns as the csv file.
--     Make sure you use the correct data types for the columns.
CREATE TABLE t_house_price_data(
    id BIGINT PRIMARY KEY,
    date VARCHAR(10),
    price INT,
    bedrooms INT,
    bathrooms FLOAT,
    sqft_living INT,
    sqft_lot INT,
    floors FLOAT,
    waterfront BOOLEAN,
    `view` INT,
    `condition` INT,
    grade INT,
    sqft_above INT,
    sqft_basement INT,
    yr_built INT,
    yr_renovated INT,
    zipcode INT,
    lat FLOAT,
    `long` FLOAT,
    sqft_living15 INT,
    sqft_lot15 INT
);

-- Q3: Import the data from the csv file into the table.
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/dv/Desktop/schule/classes/week_27/04_mini_project_ml/mini-project-dsai-ml-regression/data/regression_data.csv'
INTO TABLE t_house_price_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(id, `date`, bedrooms, bathrooms, sqft_living, sqft_lot, floors,
        waterfront, `view`, `condition`, grade, sqft_above, sqft_basement,
        yr_built, yr_renovated, zipcode, lat, `long`, sqft_living15, sqft_lot15, price);

-- Q4: Select all the data from table house_price_data to check if the data was imported correctly.
SELECT * FROM t_house_price_data;

-- Q5: Use the alter table command to drop the column date from the database.
--     Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE t_house_price_data DROP COLUMN `date`;
SELECT * FROM t_house_price_data LIMIT 10;

-- Q6: Use a sql query to find how many rows of data you have.
SELECT COUNT(id) FROM t_house_price_data;

-- Q7: Find the unique values in the following columns:
--     bedrooms, bathrooms, floors, condition, grade
SELECT DISTINCT bedrooms FROM t_house_price_data;
SELECT DISTINCT bathrooms FROM t_house_price_data;
SELECT DISTINCT floors FROM t_house_price_data;
SELECT DISTINCT `condition` FROM t_house_price_data;
SELECT DISTINCT grade FROM t_house_price_data;

-- Q8: Arrange the data in decreasing order by price.
--     Return only the IDs of the top 10 most expensive houses.
SELECT id, price FROM t_house_price_data
ORDER BY price DESC
LIMIT 10;

-- Q9: What is the average price of all the properties in your data?
SELECT AVG(price) FROM t_house_price_data;

-- Q10a: What is the average price of the houses grouped by bedrooms?
SELECT bedrooms, AVG(price) AS average_price
FROM t_house_price_data
GROUP BY bedrooms;

-- Q10b: What is the average sqft_living of the houses grouped by bedrooms?
SELECT bedrooms, AVG(sqft_living) AS average_sqft_living
FROM t_house_price_data
GROUP BY bedrooms;

-- Q10c: What is the average price of houses with and without a waterfront?
SELECT waterfront, AVG(price) AS average_price
FROM t_house_price_data
GROUP BY waterfront;

-- Q10d: Is there any correlation between condition and grade?
SELECT `condition`, AVG(grade) AS avg_grade
FROM t_house_price_data
GROUP BY `condition`
ORDER BY `condition`;
-- Result: Positive correlation — as condition increases, avg_grade also increases.

-- Q11: A customer is only interested in houses with:
--      3 or 4 bedrooms, bathrooms > 3, 1 floor, no waterfront,
--      condition >= 3, grade >= 5, price < 300000
SELECT * FROM t_house_price_data
WHERE bedrooms IN (3,4)
AND bathrooms > 3
AND floors = 1
AND waterfront = 0
AND `condition` >= 3
AND grade >= 5
AND price < 300000;

-- Q12: Find all properties whose prices are twice more than the average of all properties.
SELECT * FROM t_house_price_data
WHERE price > 2 * (SELECT AVG(price) FROM t_house_price_data);

-- Q13: Create a view of the same query from Q12.
CREATE VIEW expensive_houses AS
SELECT * FROM t_house_price_data
WHERE price > 2 * (SELECT AVG(price) FROM t_house_price_data);

-- Q14: What is the difference in average prices between 3 and 4 bedroom properties?
SELECT
    AVG(CASE WHEN bedrooms = 4 THEN price END) -
    AVG(CASE WHEN bedrooms = 3 THEN price END) AS price_difference
FROM t_house_price_data;

-- Q15: What are the different locations (distinct zip codes) where properties are available?
SELECT DISTINCT zipcode FROM t_house_price_data ORDER BY zipcode;

-- Q16: Show the list of all properties that were renovated.
SELECT * FROM t_house_price_data WHERE yr_renovated > 0;

-- Q17: Provide the details of the property that is the 11th most expensive.
SELECT * FROM t_house_price_data
ORDER BY price DESC
LIMIT 10, 1;
