--TEST
--Q1
CREATE TABLE transactions
(
 transaction_id INT PRIMARY KEY,
 merchant_id INT,
 credit_card_id INT,
 amount INT,
 transaction_timestamp TIMESTAMP
);
INSERT INTO transactions
VALUES
(1, 101, 1, 100, '2022-09-25 12:00:00'),
(2, 101, 1, 100, '2022-09-25 12:08:00'),
(3, 101, 1, 100, '2022-09-25 12:28:00'),
(4, 102, 2, 300, '2022-09-25 12:00:00'),
(6, 102, 2, 400, '2022-09-25 14:00:00');

select Count(*) as payment_count from transactions as t
where 
(select count(*) from transactions 
where  transaction_timestamp 
between t.transaction_timestamp and t.transaction_timestamp+'00:10:00'
and t.credit_card_id=credit_card_id
)>1

--Q2
CREATE TABLE user_actions 
( 
user_id INT, 
event_id INT, 
event_type VARCHAR(20), 
event_date TIMESTAMP 
); 

INSERT INTO user_actions 
VALUES 
(445, 7765, 'sign-in', '2022-06-05 12:00:00'), 
(742, 6458, 'sign-in', '2022-06-10 12:00:00'), 
(648, 3124, 'like',    '2022-06-18 12:00:00'), 
(445, 3634, 'like',    '2022-07-05 12:00:00'), 
(742, 1374, 'comment', '2022-07-15 12:00:00'), 
(999, 5555, 'sign-in', '2022-07-20 12:00:00');

select 7,count(*) from user_actions as u
where u.event_date between '2022-07-01 12:00:00' and '2022-07-31 12:00:00'
and (u.event_type='like' or u.event_type='comment')
and exists (select 1 from user_actions
where event_type='sign-in' and event_date<u.event_date);


--Q3
CREATE TABLE Submissions ( 
sub_id INT, 
parent_id INT 
); 
INSERT INTO Submissions (sub_id, parent_id) VALUES  
(1, NULL), 
(2, NULL), 
(1, NULL), 
(12, NULL), 
(3, 1), 
(5, 2), 
(3, 1), 
(4, 1), 
(9, 1), 
(10, 2), 
(6, 7);

select distinct sub_id,(
select count(distinct sub_id) from submissions 
where s.sub_id=parent_id
) from submissions as s where 
parent_id is null;
