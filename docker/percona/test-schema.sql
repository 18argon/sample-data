-- Create the 'test' schema and a dedicated user
-- NOTE: using this mechanism because MYSQL_DATABASE/USER/PASSWORD does not appear to work as described in
--       https://hub.docker.com/_/percona/

CREATE USER 'test'@'%' IDENTIFIED BY 'test';
CREATE SCHEMA IF NOT EXISTS test;
GRANT ALL ON test.* TO 'test'@'%';

USE test;

