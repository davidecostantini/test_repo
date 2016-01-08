CREATE DATABASE taskize;

\connect taskize

CREATE USER flynn WITH PASSWORD 'test_password';
GRANT ALL PRIVILEGES ON DATABASE  taskize to flynn;

CREATE TABLE taskize (
	id INT PRIMARY KEY     NOT NULL,
	col2	CHAR(50)
);



INSERT INTO taskize VALUES
    (0,'Bananas');
INSERT INTO taskize VALUES
    (1,'Pear');
INSERT INTO taskize VALUES
    (2,'Apple');
INSERT INTO taskize VALUES
    (3,'Ananas');