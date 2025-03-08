USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping;  		/*  Answer :  3867 */
SELECT COUNT(*) FROM genre;  					/*  Answer :  14662 */
SELECT COUNT(*) FROM movie;  					/*  Answer :  7997 */
SELECT COUNT(*) FROM names;  					/*  Answer :  25735 */
SELECT COUNT(*) FROM ratings;  					/*  Answer :  7997 */
SELECT COUNT(*) FROM role_mapping;  			/*  Answer :  15615 */









-- Q2. Which columns in the movie table have null values?
-- Type your code below:


    
SELECT 
	SUM(CASE WHEN id is null THEN 1 ELSE 0 END) AS NULL_id,
    SUM(CASE WHEN title is null THEN 1 ELSE 0 END) AS NULL_title,
    SUM(CASE WHEN "year" is null THEN 1 ELSE 0 END) AS NULL_year,
    SUM(CASE WHEN date_published is null THEN 1 ELSE 0 END) AS NULL_date_published,
    SUM(CASE WHEN duration is null THEN 1 ELSE 0 END) AS NULL_duration,
    SUM(CASE WHEN country is null THEN 1 ELSE 0 END) AS NULL_country,
    SUM(CASE WHEN worlwide_gross_income is null THEN 1 ELSE 0 END) AS NULL_gross_income,
    SUM(CASE WHEN languages is null THEN 1 ELSE 0 END) AS NULL_languages,
    SUM(CASE WHEN production_company is null THEN 1 ELSE 0 END) AS NULL_company
		FROM movie;

							/*
                            # NULL_id	NULL_title	NULL_year	NULL_date_published	NULL_duration	NULL_country	NULL_gross_income	NULL_languages	NULL_company
							0			0			0			0					0				20				3724				194				528

                            There are total 4 columns having nulls 
                            */


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)




SELECT year, count(title) as number_of_movies
	FROM movie
    GROUP BY year;

							/* 
							year	number_of_movies
							2017	3052
							2018	2944
							2019	2001
							 */


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT MONTH(date_published) as month_num , COUNT(id) AS number_of_movies
	FROM movie
    GROUP BY MONTH(date_published) 
    ORDER BY month_num;
    

							/* 

							month_num	number_of_movies
							1			804
							2			640
							3			824
							4			680
							5			625
							6			580
							7			493
							8			678
							9			809
							10			801
							11			625
							12			438
					March has the highest numbers (824),  while Dec has the lowest number of movies (438) 
							*/







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS US_IND_2019_COUNT
	FROM movie
    WHERE year = 2019
    AND (country like "%India%" OR country like "%USA%");
    
    /* US_IND_2019_COUNT : 1059  */





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT genre, COUNT(genre) AS genre_COUNT
	FROM genre
    GROUP BY genre
    ORDER BY genre_COUNT DESC;

SELECT DISTINCT(genre) AS GENRE
	FROM genre;


							/* 

							Drama
							Fantasy
							Thriller
							Comedy
							Horror
							Family
							Romance
							Adventure
							Action
							Sci-Fi
							Crime
							Mystery
							Others

							*/




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, COUNT(genre) AS genre_COUNT FROM
(
select *
	FROM movie as m
LEFT OUTER JOIN
genre AS g
ON m.id = g.movie_id ) tbl1
GROUP BY genre
ORDER BY genre_COUNT desc;


							/* 
							genre		genre_COUNT
							Drama		4285
							Comedy		2412
							Thriller	1484
							Action		1289
							Horror		1208
							Romance		906
							Crime		813
							Adventure	591
							Mystery		555
							Sci-Fi		375
							Fantasy		342
							Family		302
							Others		100

							*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(genre_count) FROM
	(
	SELECT m.id, Count(m.id) as genre_count from movie m
	JOIN genre g ON m.id = g.movie_id
	GROUP BY id
	HAVING genre_count =1
    ) tbl1 ;

			
            /* Number of movies that belong to only one genre - 3289 */ 



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* Code that includes all movies */

select genre, ROUND(AVG(duration),0) as avg_duration FROM
	(
	select g.genre, m.duration from movie m
	LEFT OUTER JOIN
		genre g
	ON m.id = g.movie_id
	) tbl1
GROUP BY genre
ORDER BY avg_duration desc;


							/* 
							# genre	avg_duration
							Action	113
							Romance	110
							Drama	107
							Crime	107
							Fantasy	105
							Comedy	103
							Thriller	102
							Adventure	102
							Mystery	102
							Family	101
							Others	100
							Sci-Fi	98
							Horror	93
														
                            */





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



SELECT genre, movie_count, genre_rank 
FROM
(
select genre, COUNT(genre) AS movie_count
, RANK() OVER (ORDER BY COUNT(genre) DESC) AS genre_rank
FROM
(
select *
	FROM movie as m
LEFT OUTER JOIN
genre AS g
ON m.id = g.movie_id ) tbl1
GROUP BY genre
ORDER BY genre_rank) tbl2
WHERE genre = 'Thriller';

							/* 
							genre		movie_count			genre_rank
							Drama			4285			1
							Comedy			2412			2
							Thriller		1484			3
							Action			1289			4
							Horror			1208			5
							Romance			906				6
							Crime			813				7
							Adventure		591				8
							Mystery			555				9
							Sci-Fi			375				10
							Fantasy			342				11
							Family			302				12
							Others			100				13


after applying further filter on this, to get the Rank of only "Thriller" , answer is as following:

							genre		movie_count		genre_rank
							Thriller	1484			3

							*/








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
		MIN(avg_rating) AS min_avg_rating , 
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
	FROM ratings;


							/*
								min_avg_rating		max_avg_rating		min_total_votes		max_total_votes		min_median_rating		max_median_rating
								1.0					10.0				100					725138				1						10
							*/





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)


SELECT * FROM
(
	SELECT 
		m.title, r.avg_rating,
		RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
		FROM
			movie m
		LEFT OUTER JOIN
			ratings r
		ON m.id = r.movie_id ) tbl1
WHERE movie_rank <=10;


						/* 
							title	avg_rating	movie_rank
							Kirket	10.0	1
							Love in Kilnerry	10.0	1
							Gini Helida Kathe	9.8	3
							Runam	9.7	4
							Fan	9.6	5
							Android Kunjappan Version 5.25	9.6	5
							Yeh Suhaagraat Impossible	9.5	7
							Safe	9.5	7
							The Brighton Miracle	9.5	7
							Shibu	9.4	10
							Our Little Haven	9.4	10
							Zana	9.4	10
							Family of Thakurganj	9.4	10
							Ananthu V/S Nusrath	9.4	10
						*/



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating, COUNT(median_rating) AS movie_count
	FROM ratings
		GROUP BY median_rating
        ORDER BY median_rating;

/*
# median_rating	movie_count
1	94  - Lowest
2	119
3	283
4	479
5	985
6	1975
7	2257  - Highest
8	1030
9	429
10	346

*/





/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT 
	production_company, COUNT(title) AS movie_count ,
	DENSE_RANK () OVER ( ORDER BY COUNT(title) DESC ) AS prod_company_rank 
    FROM movie m 
		LEFT OUTER JOIN 
		ratings r 
			ON m.id = r.movie_id
			WHERE r.avg_rating >8
            AND m.production_company is not null
			GROUP BY production_company;

							/*
							Dream Warrior Pictures AND National theatre Live are the two production companies AT RANK 1 and Movie_Count of 3 for both (with maximum hit movies (with rating above 8.)
							
							 */ 



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, COUNT(genre) AS movie_count
	FROM (
		SELECT g.genre, title  
			FROM  movie m
				LEFT OUTER JOIN
				genre g
		ON m.id = g.movie_id
		LEFT OUTER JOIN ratings r
		ON m.id = r.movie_id
		WHERE m.country LIKE "%USA%"
		AND DATE_FORMAT(date_published , "%Y-%m") = "2017-03"
		AND total_votes >1000 ) tbl1
	GROUP BY genre
	ORDER BY movie_count DESC;
    
    
								/* 
								Drama	24
								Comedy	9
								Action	8
								Thriller	8
								Sci-Fi	7
								Crime	6
								Horror	6
								Mystery	4
								Romance	4
								Fantasy	3
								Adventure	3
								Family	1
								*/






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating , g.genre
	FROM movie m 
	LEFT OUTER JOIN
		ratings r 
	ON m.id = r.movie_id
    LEFT OUTER JOIN
		genre g
	ON m.id = g.movie_id
		WHERE r.avg_rating >8
        AND m.title like "the%";


							/* 

							The Blue Elephant 2	8.8	Drama
							The Blue Elephant 2	8.8	Horror
							The Blue Elephant 2	8.8	Mystery
							The Brighton Miracle	9.5	Drama
							The Irishman	8.7	Crime
							The Irishman	8.7	Drama
							The Colour of Darkness	9.1	Drama
							Theeran Adhigaaram Ondru	8.3	Action
							Theeran Adhigaaram Ondru	8.3	Crime
							Theeran Adhigaaram Ondru	8.3	Thriller
							The Mystery of Godliness: The Sequel	8.5	Drama
							The Gambinos	8.4	Crime
							The Gambinos	8.4	Drama
							The King and I	8.2	Drama
							The King and I	8.2	Romance


							There are movies that have more than 1 genre that are showing up repeatedly . 

							*/




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(*) 
	FROM movie m
		LEFT OUTER JOIN
         ratings r 
		ON m.id = r.movie_id
			WHERE m.date_published >= '2018-04-01'
            AND m.date_published <= '2019-04-01'
            AND r.median_rating = 8
        ;
        
        
							/* Answer : 361 Movies */


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:



select sum( total_votes) as total_votes_german  
from (
select m.languages ,total_votes
from 
movie as m
left join 
ratings as r
on m.id = r.movie_id
where m.languages like '%German%'
) as temp ;

/* Total Votes for German movies : 4421524 */

select sum( total_votes) as total_votes_italian 
from (
select languages ,total_votes
from 
movie as m
left join 
ratings as r
on m.id = r.movie_id
where languages like '%italian%'
) as temp 
;
/* Total Votes for Italian movies :  2559540 */

/* Conclusion : German Movies are getting more votes than Italian Movies on basis of languages*/


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



select 
	COUNT(*) -COUNT(name) AS name_nulls, 
	COUNT(*) -COUNT(height) AS height_nulls, 
    COUNT(*) -COUNT(date_of_birth) AS date_of_birth_nulls, 
    COUNT(*) -COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;


							/* 
							name_nulls	height_nulls	date_of_birth_nulls		known_for_movies_nulls
							0			17335			13431					15226
                            
                            */




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH HighRatedMovies AS (
    SELECT
        g.genre,
        dm.name_id AS director_id,
        COUNT(*) AS movie_count
    FROM
        genre g
    JOIN
        movie m ON g.movie_id = m.id
    JOIN
        ratings r ON m.id = r.movie_id
    JOIN
        director_mapping dm ON m.id = dm.movie_id
    WHERE
        r.avg_rating > 8
    GROUP BY
        g.genre, dm.name_id
 ),
 TopGenres AS (
    SELECT
        genre,
        SUM(movie_count) AS total_movies
    FROM
        HighRatedMovies
    GROUP BY
        genre
    ORDER BY
        total_movies DESC
    LIMIT 3
),
TopDirectors AS (
    SELECT
        hr.director_id,
        SUM(hr.movie_count) AS movie_count
    FROM
        HighRatedMovies hr
    JOIN
        TopGenres tg ON hr.genre = tg.genre
    GROUP BY
        hr.director_id
    ORDER BY
        movie_count DESC
    LIMIT 3
)
SELECT
    n.name AS director_name,
    td.movie_count
FROM
    TopDirectors td
JOIN
    names n ON td.director_id = n.id
ORDER BY
    td.movie_count DESC;
    
    
							/* 

							# director_name		movie_count
							James Mangold		4
							Joe Russo			3
							Anthony Russo		3

						James Mangold is the top contendor for being a preferred director with maximum number of hits with rating above 4

							*/
    


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/





-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* This can be solved in 2 ways*/

/* Method1 : using CTE */
with Actor_names AS
	(
	SELECT rm.movie_id, rm.name_id, rm.category, n.name AS actor_name 
	FROM role_mapping rm 
	JOIN names n ON rm.name_id = n.id
	WHERE rm.category = 'actor'
	) 
SELECT an.actor_name, COUNT(DISTINCT an.movie_id) AS movie_count
	FROM Actor_names an
	JOIN ratings r ON an.movie_id = r.movie_id
	WHERE r.median_rating >=8
	GROUP BY an.actor_name
	ORDER BY movie_count DESC
	LIMIT 2;

/* Method2 : using simple JOINS */
select n.name as actor_name, count(r.movie_id) as movie_count
from  role_mapping as rm
join names as n
on rm.name_id=n.id
join ratings as r
on rm.movie_id=r.movie_id
where r.median_rating>=8 and rm.category like 'actor'
group by name
order by movie_count DESC
LIMIT 2;

							/* 
							# actor_name	movie_count
							Mammootty	8
							Mohanlal	5

							*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp AS
	(
	select 
		m.production_company AS production_company, SUM(r.total_votes) AS vote_count
	from ratings r
	JOIN movie m ON r.movie_id = m.id
	GROUP BY m.production_company
	ORDER BY vote_count DESC
	)
SELECT * , RANK () OVER (ORDER BY vote_count DESC) AS prod_comp_rank
FROM prod_comp 
LIMIT 3;


							/* 
						#   production_company			vote_count			prod_comp_rank
							Marvel Studios				2656967				1
							Twentieth Century Fox		2411163				2
							Warner Bros.				2396057				3
							
                            Marvel studios stands at rank 1 with more than 2.6 million overall vote count. 
                            */





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT *, RANK () OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 
(
SELECT 
n.name AS actor_name, 
SUM(r.total_votes) AS total_votes, 
 COUNT(m.id) AS movie_count,
ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating 
FROM movie m 
JOIN role_mapping rm ON m.id = rm.movie_id
JOIN names n ON rm.name_id = n.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.country like '%india%'
AND rm.category like '%actor%'
GROUP BY n.name
HAVING movie_count >=5) tbl1
 ;



/* 
Putting top 10 in result

# name	total_votes	movie_count	actor_avg_rating	actor_rank
Vijay Sethupathi	23114	5	8.42	1
Fahadh Faasil	13557	5	7.99	2
Yogi Babu	8500	11	7.83	3
Joju George	3926	5	7.58	4
Ammy Virk	2504	6	7.55	5
Dileesh Pothan	6235	5	7.52	6
Kunchacko Boban	5628	6	7.48	7
Pankaj Tripathi	40728	5	7.44	8
Rajkummar Rao	42560	6	7.37	9
Dulquer Salmaan	17666	5	7.30	10


CONCLUSION : VIJAY SETHUPATHI, with avg weighted rating of 8.42 and total votes 23114 is the highest ranked Indian Actor


*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT *, RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes) AS actress_rank
 FROM
(
select  
n.name  as actress_name, 
sum(r.total_votes) as total_votes , 
count(*) as movie_count , 
round(sum(r.avg_rating * r.total_votes) / sum(r.total_votes) , 2)  as actress_avg_rating
from
movie as m
left join
role_mapping as rm
on m.id = rm.movie_id
left join
names as n
on rm.name_id = n.id
left join
ratings as r
on m.id = r.movie_id
where rm.category like 'actress%' and m.country like '%india%' 
AND m.languages like '%hindi%' 
group by n.name  
HAVING COUNT(*) >=3
LIMIT 5) tbl1 
;


							/* 

							# actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
							Taapsee Pannu	18061	3	7.74	1
							Divya Dutta	8579	3	6.88	2
							Shraddha Kapoor	26779	3	6.63	3
							Kriti Kharbanda	2549	3	4.80	4
							Sonakshi Sinha	4025	4	4.18	5

			Taapsee Pannu tops this chart with avg weighted rating of 7.74 
            
            Since this ranking is based on ONLY HINDI Language actresses, an additional filter for hindi language is also imposed in this query. 
							*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:


SELECT movie_name, 
CASE 
	WHEN avg_rating >8 THEN 'Superhit'
    WHEN avg_rating BETWEEN 7 AND  8 THEN 'Hit'
    WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
	ELSE 'Flop'
    END AS movie_category
FROM
(
select 
	m.title AS movie_name, r.avg_rating AS avg_rating
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE g.genre like '%thriller%'
AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC) tbl1;

/* Total of 84 results appear
Summary : 
		Superhit : 4
        Hit : 18
        One-time-watch : 52
        Flop : 3
        */


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comedy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



#######################################################

SELECT genre, ROUND(AVG(avg_duration),1) AS avg_duration, ROUND(AVG(running_total_duration),1) AS running_total_duration, ROUND(AVG(moving_avg_duration),1) AS moving_avg_duration
FROM (
select genre, avg_duration, 
SUM(duration) OVER (PARTITION BY genre ORDER BY genre) AS running_total_duration ,
ROUND(AVG(duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS moving_avg_duration
FROM
(
select 
g.genre, m.duration as duration, ROUND(AVG(m.duration),2) AS avg_duration
from movie m 
JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre, m.duration
ORDER BY g.genre)
tbl1
ORDER BY genre) tbl2
GROUP BY genre;


							/* 
							# genre			avg_duration	running_total_duration	moving_avg_duration
							Action			120.2			14189.0					89.6
							Adventure		112.2			9649.0					87.5
							Comedy			114.7			12731.0					85.4
							Crime			117.6			10822.0					91.8
							Drama			130.3			17718.0					89.3
							Family			109.7			8557.0					88.3
							Fantasy			120.4			9994.0					89.9
							Horror			106.7			10135.0					81.3
							Mystery			111.4			10135.0					86.6
							Others			104.5			6270.0					78.8
							Romance			120.7			12676.0					92.1
							Sci-Fi			106.7			7792.0					86.1
							Thriller		115.5			12478.0					87.1

							*/



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

SELECT 
    ranked_movies.genre,
    ranked_movies.year,
    ranked_movies.movie_name,
    CONCAT('$', FORMAT(ranked_movies.worldwide_gross_income, 2)) AS worldwide_gross_income,
    ranked_movies.movie_rank
FROM (
    SELECT 
        top_movies.genre,
        top_movies.year,
        top_movies.movie_name,
        top_movies.worldwide_gross_income,
        RANK() OVER (PARTITION BY top_movies.genre, top_movies.year ORDER BY top_movies.worldwide_gross_income DESC) AS movie_rank
    FROM (
        SELECT 
            g.genre,
            m.year,
            m.title AS movie_name,
            CAST(REPLACE(m.worlwide_gross_income, '$', '') AS DECIMAL(15, 2)) AS worldwide_gross_income
        FROM movie m
        JOIN genre g ON m.id = g.movie_id
        JOIN (
            SELECT g_inner.genre
            FROM genre g_inner
            GROUP BY g_inner.genre
            ORDER BY COUNT(*) DESC
            LIMIT 3
        ) AS top_genres ON g.genre = top_genres.genre
        WHERE m.worlwide_gross_income IS NOT NULL
    ) AS top_movies
) AS ranked_movies
WHERE ranked_movies.movie_rank <= 5
ORDER BY ranked_movies.genre, ranked_movies.year, ranked_movies.movie_rank;

							/* 
							# genre	year	movie_name	worldwide_gross_income	movie_rank
							Comedy	2017	Despicable Me 3	$1,034,799,409.00	1
							Comedy	2017	Jumanji: Welcome to the Jungle	$962,102,237.00	2
							Comedy	2017	Guardians of the Galaxy Vol. 2	$863,756,051.00	3
							Comedy	2017	Thor: Ragnarok	$853,977,126.00	4
							Comedy	2017	Sing	$634,151,679.00	5
							Comedy	2018	Deadpool 2	$785,046,920.00	1
							Comedy	2018	Ant-Man and the Wasp	$622,674,139.00	2
							Comedy	2018	Tang ren jie tan an 2	$544,061,916.00	3
							Comedy	2018	Ralph Breaks the Internet	$529,323,962.00	4
							Comedy	2018	Hotel Transylvania 3: Summer Vacation	$528,583,774.00	5
							Comedy	2019	Toy Story 4	$1,073,168,585.00	1
							Comedy	2019	Pokémon Detective Pikachu	$431,705,346.00	2
							Comedy	2019	The Secret Life of Pets 2	$429,434,163.00	3
							Comedy	2019	Once Upon a Time... in Hollywood	$371,207,970.00	4
							Comedy	2019	Shazam!	$364,571,656.00	5
							Drama	2017	Zhan lang II	$870,325,439.00	1
							Drama	2017	Logan	$619,021,436.00	2
							Drama	2017	Dunkirk	$526,940,665.00	3
							Drama	2017	War for the Planet of the Apes	$490,719,763.00	4
							Drama	2017	La La Land	$446,092,357.00	5
							Drama	2018	Bohemian Rhapsody	$903,655,259.00	1
							Drama	2018	Hong hai xing dong	$579,220,560.00	2
							Drama	2018	Wo bu shi yao shen	$451,183,391.00	3
							Drama	2018	A Star Is Born	$434,888,866.00	4
							Drama	2018	Fifty Shades Freed	$371,985,018.00	5
							Drama	2019	Avengers: Endgame	$2,797,800,564.00	1
							Drama	2019	The Lion King	$1,655,156,910.00	2
							Drama	2019	Joker	$995,064,593.00	3
							Drama	2019	Liu lang di qiu	$699,760,773.00	4
							Drama	2019	It Chapter Two	$463,326,885.00	5
							Thriller	2017	The Fate of the Furious	$1,236,005,118.00	1
							Thriller	2017	Zhan lang II	$870,325,439.00	2
							Thriller	2017	xXx: Return of Xander Cage	$346,118,277.00	3
							Thriller	2017	Annabelle: Creation	$306,515,884.00	4
							Thriller	2017	Split	$278,454,358.00	5
							Thriller	2018	Venom	$856,085,151.00	1
							Thriller	2018	Mission: Impossible - Fallout	$791,115,104.00	2
							Thriller	2018	Hong hai xing dong	$579,220,560.00	3
							Thriller	2018	Fifty Shades Freed	$371,985,018.00	4
							Thriller	2018	The Nun	$365,550,119.00	5
							Thriller	2019	Joker	$995,064,593.00	1
							Thriller	2019	Ne Zha zhi mo tong jiang shi	$700,547,754.00	2
							Thriller	2019	John Wick: Chapter 3 - Parabellum	$326,667,460.00	3
							Thriller	2019	Us	$255,105,930.00	4
							Thriller	2019	Glass	$246,985,576.00	5


							*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT * , RANK () OVER ( ORDER BY movie_count DESC) AS prod_comp_rank
FROM 
	(
	SELECT production_company , COUNT(id) AS movie_count 
	FROM
		(
		SELECT * FROM movie m 
		JOIN ratings r ON m.id = r.movie_id
		WHERE languages like '%,%'
		AND r.median_rating >=8
		AND production_company IS NOT NULL)tbl1
	GROUP BY production_company
	ORDER BY movie_count DESC
	LIMIT 2) tbl2 ;
    

/*
# production_company		movie_count		prod_comp_rank
Star Cinema					7				1
Twentieth Century Fox		4				2
*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:


SELECT *, RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes) AS actress_rank
FROM 
(
SELECT 
	name AS actress_name, 
    SUM(total_votes) AS total_votes, 
    COUNT(id) AS movie_count,
    ROUND(sum(avg_rating * total_votes) / sum(total_votes) , 2)  as actress_avg_rating
FROM 
	(
	select  
    n.name , r.total_votes, r.avg_rating, m.id
    from movie m
	JOIN ratings r ON m.id = r.movie_id
	JOIN role_mapping rm ON m.id = rm.movie_id
	JOIN genre g ON m.id = g.movie_id
	JOIN names n ON rm.name_id  = n.id
	AND rm.category like '%actress%'
    AND g.genre like '%drama%'
	)tbl1
GROUP BY name 
HAVING actress_avg_rating >8
) tbl2
LIMIT 3;

							/*
							# actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
							Sangeetha Bhat	1010	1	9.60	1
							Pranati Rai Prakash	897	1	9.40	2
							Fatmire Sahiti	3932	1	9.40	3

							*/



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


SELECT 
        director_id,
        director_name,
        COUNT(*) AS number_of_movies,
        ROUND(AVG(DATEDIFF(date_published, prev_movie_date)),0) AS avg_inter_movie_days,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
    FROM 
(SELECT 
dm.name_id AS director_id , n.name AS director_name, r.avg_rating, dm.movie_id,  r.total_votes, r.median_rating, m.duration, m.date_published,
LAG(m.date_published) OVER (PARTITION BY dm.name_id ORDER BY m.date_published) AS prev_movie_date
FROM movie m 
JOIN director_mapping dm ON dm.movie_id = m.id
JOIN names n ON dm.name_id = n.id
JOIN ratings r ON m.id = r.movie_id) tbl1
GROUP BY director_id, director_name
ORDER BY number_of_movies DESC, avg_rating DESC
LIMIT 9
;


							/*
							# director_id	director_name	number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
							nm1777967	A.L. Vijay	5	177	5.65	1754	3.7	6.9	613
							nm2096009	Andrew Jones	5	191	3.04	1989	2.7	3.2	432
							nm0001752	Steven Soderbergh	4	254	6.77	171684	6.2	7.0	401
							nm0515005	Sam Liu	4	260	6.32	28557	5.8	6.7	312
							nm0814469	Sion Sono	4	331	6.31	2972	5.4	6.4	502
							nm0425364	Jesse V. Johnson	4	299	6.10	14778	4.2	6.5	383
							nm2691863	Justin Price	4	315	4.93	5343	3.0	5.8	346
							nm0831321	Chris Stokes	4	198	4.32	3664	4.0	4.6	352
							nm6356309	Özgür Bakar	4	112	3.96	1092	3.1	4.9	374

							 
							*/

##########################################################################################################################################################

/* ADDITIONAL QUERIES FOR MORE UNDERSTANDING
These queries are not a part of prjoect
*/



SELECT country, COUNT(*) AS movie_count FROM movie
GROUP BY country
order by movie_count DESC;


select * from movie m 
JOIN director_mapping dm ON m.id=dm.movie_id
JOIN names n ON dm.name_id = n.id
WHERE n.name like '%Mangold%';



