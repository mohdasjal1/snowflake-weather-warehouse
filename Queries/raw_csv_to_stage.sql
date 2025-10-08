
-- Create a new database
CREATE DATABASE data_design;

-- Switch to the newly created database
USE DATABASE data_design;

-- Create a schema for staging data
CREATE SCHEMA staging;

-- Switch to the staging schema
USE SCHEMA staging;

-- 1. Create a file format for CSV
CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null')
    DATE_FORMAT = 'YYYYMMDD';  -- Fix: correctly handles date format

-- 2. Create a stage using CSV format
CREATE OR REPLACE STAGE csv_stage 
    FILE_FORMAT = csv_format;

list @csv_stage;
-- 3. Create table for precipitation data
CREATE OR REPLACE TABLE lv_precipitation (
    date DATE,
    precipitation STRING,
    precipitation_normal STRING
);

-- 4. Create table for temperature data
CREATE OR REPLACE TABLE lv_temperature (
    date DATE,
    min DOUBLE,
    max DOUBLE,
    normal_min DOUBLE,
    normal_max DOUBLE
);

-- Load precipitation data
COPY INTO lv_precipitation
FROM @csv_stage/USW00093134-LOS_ANGELES_DOWNTOWN_USC-precipitation-inch.csv.gz
FILE_FORMAT = (FORMAT_NAME = csv_format);

-- Load temperature data
COPY INTO lv_temperature
FROM @csv_stage/USW00093134-temperature-degreeF.csv.gz
FILE_FORMAT = (FORMAT_NAME = csv_format);

select * from lv_temperature;
select * from lv_precipitation;
