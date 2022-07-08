CREATE TABLE bitcoin_historical_data(
	`date`		VARCHAR(10) primary key,
	`price`		FLOAT
);

CREATE TABLE gold_historical_data(
	`date`		VARCHAR(10) primary key,
	`price`		FLOAT
);

CREATE TABLE oil_historical_data(
	`date`		VARCHAR(10) primary key,
	`price`		FLOAT
);

CREATE TABLE historical_data(
	`date`		VARCHAR(10) primary key,
	`bitcoin_price`		FLOAT,
	`gold_price`		FLOAT,
	`oil_price`		FLOAT
);

CREATE TABLE prediction(
	`date`	VARCHAR(10) primary key,
	`prediction`	FLOAT
);

CREATE TABLE result(
	`date`		VARCHAR(10) primary key,
	`prediction`	FLOAT,
	`real`	FLOAT
);

INSERT INTO `historical_data`(`date`, `bitcoin_price`, `gold_price`, `oil_price`) 
SELECT	b.date, b.price, g.price, o.price
FROM	`bitcoin_historical_data` as b, `gold_historical_data` as g, `oil_historical_data` as o
WHERE	b.date = '2022-06-14' AND g.date = '2022-06-14' AND o.date = '2022-06-14';

SELECT 	h.date as 'date', date_add(h.date, INTERVAL 7 day) as '7th day'
FROM	`historical_data` as h;

UPDATE	`historical_data` as h
SET		h.bitcoin_price = 
(SELECT 	b.price
FROM	`bitcoin_historical_data` as b
WHERE	b.date <= '2022-06-18'
ORDER BY b.date DESC LIMIT 1)
WHERE h.date = '2022-06-15';

UPDATE `historical_data` as a
INNER JOIN `historical_data` as b 
ON b.date = date_add(a.date, INTERVAL 7 day)
SET a.7th_price = b.bitcoin_price;

SELECT 	p.date as 'date', h.bitcoin_price, h.gold_price, h.oil_price, h.7th_price, h.7th_date '7th_date'
FROM 	`predict` as p
JOIN	`historical_data` as h
ON		p.date = h.7th_date;

UPDATE `historical_data` as a
INNER JOIN `historical_data` as b 
ON b.date = date_add(a.date, INTERVAL 7 day)
SET a.future_price = b.bitcoin_price, a.future_date = b.date
WHERE b.date <= '2022-06-18';

SELECT * FROM `predict` where DATE_SUB(CURDATE(), INTERVAL 30 DAY) <= date(`date`);

SELECT 	h.bitcoin_price as 'bitcoin', h.gold_price as 'gold', h.oil_price as 'oil', date_add(h.date, INTERVAL 7 day) as 'date' 
FROM	`historical_data` as h;

SELECT h.bitcoin_price as 'bitcoin', h.gold_price as 'gold', h.oil_price as 'oil', date_add(h.date, INTERVAL 7 day) as 'date' 
FROM `historical_data` as h
ORDER BY h.date DESC LIMIT 1;

INSERT INTO `result` (`date`, `prediction`, `real`) 
SELECT 	h.date, p.prediction, h.bitcoin_price 
FROM 	`historical_data` as h
JOIN	`prediction` as p
ON		p.date = h.date;

SELECT	b.date as 'b_date', b.price as 'b_price', g.date as 'g_date', g.price as 'g_price', o.date as 'o_date', o.price as 'o_price'
FROM	(
    SELECT	date, price
    FROM	`bitcoin_historical_data`
	WHERE	date <= '2022-07-15'
	ORDER BY date DESC LIMIT 1) as b,
    	(
    SELECT	date, price
    FROM	`gold_historical_data`
	WHERE	date <= '2022-07-15'
	ORDER BY date DESC LIMIT 1) as g,
    	(
    SELECT	date, price
    FROM	`oil_historical_data`
	WHERE	date <= '2022-07-15'
	ORDER BY date DESC LIMIT 1) as o    
    ;

	UPDATE `historical_data` as h
SET 
h.bitcoin_price = (
	SELECT 	price
	FROM	`bitcoin_historical_data`
	WHERE	date <= h.date
	ORDER BY date DESC LIMIT 1
), 
h.gold_price = (
	SELECT 	price
	FROM	`gold_historical_data`
	WHERE	date <= h.date
	ORDER BY date DESC LIMIT 1
), 
h.oil_price = (
	SELECT 	price
	FROM	`oil_historical_data`
	WHERE	date <= h.date
	ORDER BY date DESC LIMIT 1
);