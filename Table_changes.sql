--I have imported flatfiles so below tables can appear for this project on the database
select * from dbo.album
select * from dbo.album2
select * from dbo.artist
select * from dbo.customer
select * from dbo.employee
select * from dbo.genre
select * from dbo.invoice
--limit float in invoice to 2 decimals
UPDATE dbo.invoice
SET total = ROUND(total, 2);

select * from dbo.invoice_line
--limit unit price to 2 decimals
UPDATE dbo.invoice_line
SET unit_price = ROUND(unit_price, 2)


select * from dbo.media_type
select * from dbo.playlist
select * from dbo.playlist_track
select * from dbo.track
--convert unit price to 2 decimals
UPDATE dbo.track
SET unit_price = ROUND(unit_price, 2)

---Table link ups and connections
--Below we are altering and connecting tables according to the schema

--epoloyee_id made primary key 
Alter Table employee
ADD CONSTRAINT ep_emplid  PRIMARY KEY (employee_id); 
select * from employee


--customer(support_rep_id) is Foreign key dependent on employee(employee_id)
select * from customer
ALTER TABLE customer
ADD CONSTRAINT sp_repid  
FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id);

--Creating customer_id as primary key in customer table
Alter table Customer
ADD CONSTRAINT cu_iddd  PRIMARY KEY (customer_id); 

--customer(customer_id) is FK in invoice(customer_id)
Select * from customer
Select * from invoice
Alter Table invoice
Add constraint cu_id
Foreign Key (customer_id) References customer(customer_id);

--creating invoice_id as primary key 
Select * from invoice
Alter Table invoice
Add Constraint inv_id Primary Key (invoice_id);

--creating invoice(invoice_id) FK invoice_line(invoice_id)
Alter table invoice_line
Add Constraint inv_idf
Foreign Key (invoice_id) References invoice(invoice_id);

--creating invoice_line_id as primary key in invoice_line 
Select * from invoice_line
Alter Table invoice_line
Add Constraint inv_linid Primary Key (invoice_line_id);

--creating media_type_id as primary key in media_type
select * from media_type
Alter Table media_type
Add Constraint media_id Primary Key (media_type_id);

---creating genre_id as primary key in genre table
Alter Table genre
Add Constraint gen_id Primary Key (genre_id);

---creating track_id as primary key in track table
Alter Table track
Add Constraint tk_id Primary Key (track_id);

--creating album_id as primary key in album table
Alter Table album
Add Constraint alb_id Primary Key (album_id);

--creating track(track_id) FK invoice_line(track_id)
Alter table invoice_line
Add Constraint trk_idf
Foreign Key (track_id) References track(track_id);

-- creating FK album_id,media_type_id,genre_id in track table wrt respective tables
Alter table track
Add Constraint albm_idf Foreign Key (album_id) References album(album_id);

Alter table track
Add Constraint med_idf Foreign Key (media_type_id) References media_type(media_type_id);

Alter table track
Add Constraint gen_idf Foreign Key (genre_id) References genre(genre_id);



Alter table track
Add Constraint gen_idf Foreign Key (genre_id) References genre(genre_id);
-- here it showed error as genre_id is tinyint in genre and int in track
-- ichecked the same from below
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'genre';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'track';

alter table track
alter column genre_id tinyint;
-- now we have modified the genre_id fk properly after changing the it from int to tinyint
Alter table track
Add Constraint gen_idf Foreign Key (genre_id) References genre(genre_id);

--changing artist_id to primary key in table artist
Alter Table artist
Add Constraint art_id Primary Key (artist_id);

--creating album(artist_id) FK artist(artist_id)
Alter table album
Add Constraint arti_idf
Foreign Key (artist_id) References artist(artist_id);

--changing playlist_id to primary key in table playlist
Alter Table playlist
Add Constraint play_id Primary Key (playlist_id);
