USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select sum(case when id is null then 1 else 0 end) as null_id,
sum(case when title is null then 1 else 0 end) as null_title,
sum(case when year is null then 1 else 0 end) as null_nation,
sum(case when country is null then 1 else 0 end) as null_country,
sum(case when worlwide_gross_income is null then 1 else 0 end) as null_worlwide_gross_income,
sum(case when languages is null then 1 else 0 end) as null_languages,
sum(case when production_company is null then 1 else 0 end) as null_production_company from movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

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

-- Part one-
SELECT year,count(id) as no_of_movie_released from movie
group by year;

-- Part Two- 
select count(id) as number_of_movies, month(date_published) as month_number from movie group by month_number order by month_number;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT count(year) as No_of_movies_2019 from movie where year = '2019'and (LOWER(country) LIKE '%USA%' OR LOWER(country) LIKE '%INDIA%');


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT distinct(genre) from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,Count(movie_id) as total_no_of_movie from genre group by genre order by total_no_of_movie desc;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT
  COUNT(*) movie_in_one_genre
FROM
  (SELECT movie_id, COUNT(*) movie_one_genre
  FROM genre
  GROUP BY movie_id
  having movie_one_genre=1) as mov;

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

SELECT genre, avg(duration) as avg_duration from genre as gen
inner join movie as mov
on gen.movie_id = mov.id
group by genre
order by avg_duration desc;


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

SELECT gen.genre, count(mov.id) as movie_count, rank() OVER(order by count(mov.id) desc) as `rank`from genre as gen
inner join movie as mov
on gen.movie_id = mov.id
group by gen.genre
order by movie_count desc;

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

SELECT min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes,
 max(total_votes) as max_total_votes, min(median_rating) as min_median_rating, max(median_rating) as max_median_rating from ratings;

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
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT mov.title, rat.avg_rating, rank() OVER(order by avg_rating desc ) as `movie_rank` from movie as mov
inner join ratings as rat
on mov.id= rat.movie_id
order by avg_rating desc limit 10;

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

SELECT rat.median_rating, count(mov.id) as movie_count from ratings as rat
inner join movie as mov
on rat.movie_id = mov.id
group by median_rating
order by median_rating;

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

SELECT mov.production_company, count(mov.id) as movie_count, rank() over(order by count(id) desc) 'prod_company_rank', rat.avg_rating from movie as mov
inner join ratings as rat
on mov.id = rat.movie_id
where avg_rating>8 and mov.production_company IS NOT NULL
group by mov.production_company
order by movie_count desc;


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

SELECT gen.genre, count(mov.id) as movie_count from movie as mov
inner join genre as gen on mov.id = gen.movie_id
inner join ratings as rat on mov.id = rat.movie_id
where year = '2017' and month(date_published) = '3' and country like '%USA%' and total_votes > 1000
group by genre
order by movie_count desc;


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

SELECT mov.title, rat.avg_rating, gen.genre from movie as mov
inner join genre as gen on mov.id = gen.movie_id
inner join ratings as rat on mov.id = rat.movie_id
where title like "The%" and avg_rating > 8
order by rat.avg_rating desc;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(mov.id) as no_of_movies_between_04_2018_04_2019, 
rat.median_rating as median_rating_equal_8 from movie as mov
inner join ratings as rat
on mov.id = rat.movie_id
where mov.date_published between '2018-04-01' and '2019-04-01' and median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT  languages, total_votes from movie as mov
inner join ratings as rat 
on mov.id = rat.movie_id
group by languages
having languages in ('German', 'Italian')
order by total_votes desc;

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

select sum(case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;


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

SELECT nam.name as director_name, count(mov.id) as movie_count, gen.genre, rat.avg_rating from movie as mov
inner join director_mapping as dirmap
on mov.id = dirmap.movie_id
inner join names as nam 
on dirmap.name_id = nam.id
inner join ratings as rat
on mov.id = rat.movie_id
inner join genre as gen
on mov.id = gen.movie_id
where rat.avg_rating>8
group by director_name
order by movie_count desc limit 3;



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

select nam.name as actor_name, count(mov.id) as movie_count,rolmap.category ,rat.median_rating from movie mov
inner join role_mapping rolmap
on mov.id = rolmap.movie_id
inner join names nam
 on rolmap.name_id = nam.id
inner join ratings rat 
on mov.id = rat.movie_id
where rolmap.category = 'actor'and rat.median_rating >= 8
group by actor_name
order by movie_count desc limit 2;


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

SELECT mov.production_company,sum(rat.total_votes) as vote_count,dense_rank() over(order by sum(rat.total_votes) desc) as 'production_company_rank'from movie as mov
inner join ratings as rat
on mov.id = rat.movie_id
group by mov.production_company
order by vote_count desc limit 3;



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

SELECT nam.name as actor_name,sum(rat.total_votes),count(mov.id) as movie_count,round(sum(cast(avg_rating as float) * cast(total_votes as float)) / sum(cast(total_votes as float)),1)
 as actor_avg_rating, rank() over(partition by rolmap.category = 'actor' order by rat.avg_rating desc) 'actor_rank'from movie as mov
inner join role_mapping as rolmap
on mov.id = rolmap.movie_id
inner join names as nam
on rolmap.name_id = nam.id
inner join ratings as rat
on mov.id = rat.movie_id
where country = 'India' and rolmap.category = 'actor'
group by name
having count(mov.id)>=5
order by actor_avg_rating desc, total_votes desc;


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

SELECT nam.name as actress_name,sum(total_votes),count(mov.id) as movie_count,round(sum(cast(avg_rating as float) * cast(total_votes as float)) / sum(cast(total_votes as float)),2)
 as actress_avg_rating, rank() over(partition by rolmap.category = 'actress' order by rat.avg_rating desc) 'actress_rank'from movie as mov
inner join role_mapping as rolmap
on mov.id = rolmap.movie_id
inner join names as nam
on rolmap.name_id = nam.id
inner join ratings as rat
on mov.id = rat.movie_id
where country = 'India' and languages ='Hindi' and rolmap.category = 'actress'
group by name
having count(mov.id)>=3
order by actress_avg_rating desc, total_votes desc limit 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
title as Movie_name ,avg_rating,genre,
CASE
when avg_rating < 5 then 'Flop movies'
when avg_rating between 5 and 7 then 'One-time-watch movies'
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating > 8 then 'Superhit movies'
END 'movie_category'
from movie as mov
inner join ratings as rat
on mov.id = rat.movie_id
inner join genre as gen
on mov.id = gen.movie_id
where LOWER(genre) = 'Thriller'
order by avg_rating desc;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre, round(avg(duration),2) as avg_duration,SUM(round(avg(duration),2)) over(order by genre rows unbounded preceding) AS Running_Total_duration,
avg(round(avg(duration),1)) over (order by genre rows unbounded preceding) as moving_avg_duration from movie as mov
inner join genre as gen 
on mov.id = gen.movie_id
group by genre
order by genre;


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

With temp_table as 
(Select gen.genre,count(mov.id) as movie_count,
dense_rank() over(order by count(mov.id) desc) as 'genre_rank'
 from movie mov
 inner join genre as gen on mov.id = gen.movie_id
 group by genre),
 temp_table_1 as
 (select gen.genre, year, mov.title as movie_name, worlwide_gross_income,
 rank() over (partition by gen.genre, year order by convert(replace(trim(worlwide_gross_income), "$ ",""), unsigned int) desc) as 'movie_rank'
 from movie as mov
 inner join genre as gen on mov.id = gen.movie_id
 WHERE gen.genre in (select distinct genre from temp_table where genre_rank<=3)
)
SELECT *  from temp_table_1 where movie_rank<=5;


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

SELECT production_company, count(mov.id)as movie_count, rank() over(order by count(mov.id) desc) prod_comp_rank from movie as mov
inner join ratings as rat 
on mov.id = rat.movie_id
where median_rating >= 8 and mov.languages like ('%,%') and mov.production_company IS NOT NULL
group by production_company
order by movie_count desc limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT nam.name as actress_name,sum(rat.total_votes),count(mov.id) as movie_count, rat.avg_rating as actress_avg_rating, 
rank() over(order by rat.avg_rating desc) 'actress_rank'from movie as mov
inner join role_mapping as rolmap
on mov.id = rolmap.movie_id
inner join names as nam
on rolmap.name_id = nam.id
inner join ratings as rat
on mov.id = rat.movie_id
inner join genre as gen
on mov.id = gen.movie_id
where rolmap.category = 'actress' and lower(gen.genre) = 'Drama' 
group by name
having avg_rating>8
order by actress_avg_rating desc, movie_count desc limit 3;


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

WITH temp_table as
(
SELECT 
nam.id as director_id, nam.name as director_name, COUNT(mov.id) AS movie_count, rank() over (order by COUNT(mov.id) desc) as director_rank
from names as nam
inner join director_mapping as dirmap on nam.id=dirmap.name_id
inner join movie as mov on dirmap.movie_id = mov.id
group by nam.id
),
temp_table_1 as
(
select nam.id as director_id, nam.name as director_name, mov.id as movie_id, mov.date_published,
rat.avg_rating, rat.total_votes, mov.duration,
LEAD(date_published) over (partition by nam.id ORDER BY mov.date_published) as next_date_published,
DATEDIFF(lead(date_published) over (partition by nam.id ORDER BY mov.date_published),date_published) as inter_movie_days
from  names as nam
inner join director_mapping as dirmap on nam.id=dirmap.name_id
inner join movie as mov on dirmap.movie_id = mov.id
inner join ratings as rat on mov.id=rat.movie_id
where nam.id in (select director_id from temp_table where director_rank<=9)
)
select  director_id, director_name, count(distinct movie_id) as number_of_movies, round(avg(inter_movie_days),0) AS avg_inter_movie_days,avg_rating,
sum(total_votes) as Total_votes,min(avg_rating) as min_rating, max(avg_rating) as max_rating, sum(duration) as total_movie_duration from temp_table_1
group by director_id
order by number_of_movies desc, avg_rating desc;





