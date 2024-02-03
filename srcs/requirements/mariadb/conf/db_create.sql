-- Switch to the 'mysql' database
USE mysql;

-- Remove any MySQL user with an empty username
DELETE FROM user WHERE user='';

-- Drop the 'test' database if it exists
DROP DATABASE IF EXISTS test;

-- Change the password for the 'root' user at the 'localhost' host
ALTER USER 'root'@'localhost' IDENTIFIED BY 'DB_ROOT_PW';

-- Create or replace a MySQL user with the specified username and password
CREATE OR REPLACE USER 'DB_USER_NAME' IDENTIFIED BY 'DB_USER_PW';

-- Create a MySQL database if it does not already exist
CREATE DATABASE IF NOT EXISTS DB_NAME;

-- Grant all privileges on the specified database to the specified user
GRANT ALL PRIVILEGES ON DB_NAME.* TO 'DB_USER_NAME';

-- Reload privileges to apply the changes
FLUSH PRIVILEGES;
