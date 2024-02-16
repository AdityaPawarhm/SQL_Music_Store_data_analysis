--1.Who is the senior most employee based on job title?
select * from employee
select Top 1 * from employee
order by levels desc


--2. Which countries have the most Invoices?
--we can check all the columns with
select * from invoice
--now we need count of any column. I am taking billing_country
select billing_country, Count(billing_country) Countb from invoice
group by billing_country
order by Countb desc
--here result for all countries are arranged in descending order

--3. What are top 3 values of total invoice?
select Top 3 total from invoice
order by total desc

--4. Which city has the best customers? We would like to throw a promotional Music 
--Festival in the city we made the most money. Write a query that returns one city that 
--has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select * from invoice

select TOP 1 billing_city,sum(total) citysale from invoice
group by billing_city
order by citysale desc
--5. Who is the best customer? The customer who has spent the most money will be 
--declared the best customer. Write a query that returns the person who has spent the 
--most money

select * from customer
--here there is every detail about customer but no spending details

select * from invoice
order by total desc
--and we need total of invoice.
--so we join customer table with invoice table
select Top 1 C.customer_id, C.first_name, C.last_name, SUM(I.total) spenttotal from customer C
Join Invoice I on C.customer_id=I.customer_id
group by C.first_name, C.last_name, C.customer_id
order by spenttotal desc;

-----Moderate difficult questions
--1. Write query to return the email, first name, last name, & Genre of all Rock Music 
--listeners. Return your list ordered alphabetically by email starting with A
--ANSWER- Here we need to join multiple tables

select * from customer
--from customer we choose first name,last name,email
select * from invoice
-- now invoice table can be connected with customer table via customer_id 
select * from invoice_line
-- now invoice_line table can be connected with invoice table via invoice_id
select * from track
-- now track table can be connected with invoice_line table via track_id
select * from genre
--now we need to connect genre with track table via genre_id
select * from track where genre_id=1
--now genre_id of rock is 1. we need to use where condition to have this genre_id
select Distinct(C.email),C.first_name,C.last_name,GR.name from customer  C
Join invoice II on C.customer_id=II.customer_id
Join  invoice_line IL on II.invoice_id=IL.invoice_id
Join track TK on IL.track_id=TK.track_id
Join genre GR on TK.genre_id=GR.genre_id
where GR.genre_id=1
Order by C.email
-- here we connected all the tables using join and used where clause
-- in order to get results alphabetically we ordered by email

--we can also solve it like this
SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--2. Let's invite the artists who have written the most rock music in our dataset. Write a 
--query that returns the Artist name and total track count of the top 10 rock bands
select * from artist
--here we can find artist name
select * from album
----artist and album table are connected by artist_id
select * from track
--track table will connect with album via album_id
select * from genre
--here we need genre rock
--below we will join all four tables and get details
select TOP 10 A.artist_id,A.name,count(A.artist_id) as Total_tracks from artist A
JOIN album AB on A.artist_id=AB.artist_id
Join track TK on tk.album_id=AB.album_id
Join genre G on G.genre_id=TK.genre_id
Where G.genre_id=1
--or you can use Where G.name LIKE 'Rock'
group by A.name,A.artist_id
order by Total_tracks desc


--3. Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the 
--longest songs listed first

select* from track
--here in milliseconds we can find track length

select name,milliseconds from track
where milliseconds>(select AVG(milliseconds) as AVG_track_length from track)
order by milliseconds desc;


------advanced questions
--1. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent

--ANSWER- Here basically the person wants to find who is the astist on which maximum
--amount is spent by customers
--Then he wants the amount spent by each customer in descending order
select * from artist
--gives us astist id and name and connected to album table via artist_id
select * from album
--album table connects to track table via album_id
select * from track
--connects to invoice_line table via track_id
select * from invoice_line
--connects to invoice via invoice_id
select * from invoice
--finally connects to customer via customer_id
select * from customer

--first we find the artist with highest spent
With tab1 AS (
Select Top 1 
A.artist_id as artistid,A.name as artistname, 
SUM(IL.unit_price*IL.quantity) as SPENT from invoice_line IL
Join invoice INV on IL.invoice_id=INV.invoice_id
Join track TK on TK.track_id=IL.track_id
Join album AL on AL.album_id=TK.album_id
Join artist A on A.artist_id=AL.artist_id
group by  A.artist_id,A.name
order by SPENT desc) 
---then we join it with customers to get final answer
Select C.customer_id, C.first_name,C.last_name,tab1.artistname, 
SUM(IL.unit_price*IL.quantity) as Total_Spent from customer C
join invoice INV on C.customer_id=INV.customer_id
Join invoice_line IL on INV.invoice_id=IL.invoice_id
Join track TK on TK.track_id=IL.track_id
Join album AL on AL.album_id=TK.album_id
Join tab1 on AL.artist_id=tab1.artistid
group by C.customer_id,C.first_name,C.last_name,tab1.artistname
order by Total_spent desc



--2. We want to find out the most popular music Genre for each country. We determine the 
--most popular genre as the genre with the highest amount of purchases. Write a query 
--that returns each country along with the top Genre. For countries where the maximum 
--number of purchases is shared return all Genres

--Answer- here we can connect below 4 tables
select * from genre
--genre table connects with track table via genre_id
select * from track
--track table connects with invoice-line via track_id
select * from invoice_line
--invoice_line table connects with invoice table via invoice_id
select * from invoice;

--to find all the popular genre in all the countries
WITH popular_genre AS 
(SELECT COUNT(IL.quantity) AS purchases, 
C.country, G.name, G.genre_id, 
ROW_NUMBER() OVER(PARTITION BY C.country ORDER BY COUNT(IL.quantity) DESC) 
AS RowNo FROM invoice_line IL
JOIN invoice I ON I.invoice_id = IL.invoice_id
JOIN customer C ON C.customer_id = I.customer_id
JOIN track TK ON TK.track_id = IL.track_id
JOIN genre G ON G.genre_id = TK.genre_id
GROUP BY C.country, G.name, G.genre_id)
SELECT * FROM popular_genre WHERE RowNo = 1
Order by 2 ASC, 1 DESC;




--3. Write a query that determines the customer that has spent the most on music for each 
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all 
--customers who spent this amount

WITH CPC AS 
(Select C.customer_id,C.first_name,C.last_name, 
I.billing_country,Sum(I.total) as total_spending, 
ROW_NUMBER() OVER(PARTITION BY I.billing_country ORDER BY SUM(I.total) DESC) 
AS RowNo FROM invoice I
JOIN customer C ON C.customer_id = I.customer_id
GROUP BY C.customer_id,C.first_name,C.last_name, 
I.billing_country)
SELECT * FROM CPC WHERE RowNo = 1
Order by 4 ASC, 5 DESC;

