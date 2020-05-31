/*Question 1 - What was the Total Sales by each Sales Rep for each year?

I wanted to check below 2 questions first:
Prep 1): How many years data have been included in the dataset?*/
SELECT DISTINCT STRFTIME ('%Y',InvoiceDate) Invoice_Date FROM Invoice;

/*Prep 2): How many sales staff have been working for Chinook and who are they?*/
SELECT
    FirstName,
    LastName,
    Title,
    HireDate
FROM Employee
WHERE Title LIKE "%Sales%";

/* Query: Total Sales in USD by Sales Rep by Year */
SELECT
    STRFTIME ('%Y', i.InvoiceDate) Invoice_Date,
    e.FirstName || " " || e.LastName AS Employee_Name,
    SUM(i.Total) Total
FROM
    Employee e
    JOIN Customer c ON e.EmployeeId = c.SupportRepId
    JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 1,2
ORDER BY 1;


/*Question 2 - What are the most popular Genres in Canada?*/
SELECT g.Name GenreName, SUM(il.Quantity) Tol_Qty
FROM
    Invoice i
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
WHERE i.BillingCountry = "Canada"
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


/*Question 3 - What are the Best Customer’s favorite Genres?*/
WITH t1 AS
    (SELECT c.FirstName ||" "||c.LastName AS Custmoer_Name,
    		SUM (il.UnitPrice*il.Quantity) Tot_Spent
    	FROM Customer c JOIN Invoice i ON c.CustomerId = i.CustomerId
    	JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1)

SELECT c.FirstName ||" "||c.LastName AS Customer_Name,
	   r.name AS Artist,
	   SUM(il.Quantity) AS Quantity
FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Album a ON t.AlbumId = a.AlbumId
    JOIN Artist r ON a.ArtistId = r.ArtistId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
WHERE Customer_Name = (SELECT Custmoer_Name FROM t1)
GROUP BY 1,2
HAVING SUM(il.Quantity)>= 2
ORDER BY 3 DESC;


/*Question 4 - What was the share of Media Types in 2013?*/

/*Prep 1): All Media Types in the dataset*/
SELECT * FROM MediaType;

/*Prep 2): Date of the last purchase in the dataset*/
SELECT InvoiceDate FROM Invoice
ORDER BY 1 DESC;

/*Query: The last sale was made on 2013-12-22, I want to check the total number
of tracks sold in each Media Type in the last year of the time series*/
SELECT
    m.Name,
    SUM(il.Quantity) Tol_qty
FROM
    MediaType m
    JOIN Track t ON m.MediaTypeId = t.MediaTypeId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE
    i.InvoiceDate BETWEEN "2013-01-01" AND "2013-12-31"
GROUP BY 1
ORDER BY 2 DESC;
