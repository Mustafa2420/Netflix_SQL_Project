-- Netflix Project

create database netflix_db1;
CREATE TABLE netflix
(
    show_id      VARCHAR(6),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


select * from netflix;


-- 1. Count the number of Movies vs TV Shows
select type, count(show_id) as total_count
	from netflix
group by type
order by  total_count desc;

-- 2. Find the most common rating for movies and TV shows
select type,rating from
(select type, rating,count(*),
	RANK() OVER(partition by type order by count(*)desc) as Ranking
	from netflix
	group by 1,2
order by 1,3) as T1
	where ranking =1;

-- 3. List all movies released in a specific year (e.g., 2020)

select title,release_year from netflix
	where release_year=2020 and type='Movie'
;

select * from netflix
	where release_year=2020 and type='Movie'
	;

-- 4. Find the top 5 countries with the most content on Netflix

select 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	count(show_id) AS total_content
	from netflix
	group by 1
	order by 2 desc limit 5;

	
	5. Identify the longest movie

select title,type,duration from netflix where type='Movie'
		and duration=(select max(duration) from netflix)
		;
		
	
	6. Find content added in the last 5 years
		
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

	
	7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

		select type,title,director from netflix 
where director ilike '%Rajiv Chilaka%'
		
	8. List all TV shows with more than 5 seasons

SELECT *
		from netflix where 
		type ='TV Show' AND 
		split_part(duration,' ',1)::numeric >5; 
	
	9. Count the number of content items in each genre

		SELECT unnest(string_to_array(listed_in, ','))as genre,
		count(show_id)
		from netflix
		group by 1;
	
	10.Find each year and the average numbers of content release in India on netflix.
		return top 5 year with highest avg content release!

select extract(year from to_date(date_added, 'Month dd, yyyy')) as year,
		count(*),
Round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100,2) as avg_content_per_year
		from netflix
		where country= 'India'
		group by 1
		
	11. List all movies that are documentaries

		SELECT * from netflix
		where listed_in ilike '%Documentaries%';
		
12. Find all content without a director

	SELECT * from netflix where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

	SELECT * from netflix where casts ilike '%Salman khan%'
	AND release_year > extract(year from current_date) - 10 ;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

	SELECT UNNEST(string_to_array(casts, ',')) as actors,
     count(*) as total_content
	from netflix
		where country ILIKE '%india%'
	group by 1
	order by 2 desc limit 10;
	
-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
WITH new_table AS (
SELECT *,
CASE
WHEN 
description ilike '%kill%' OR
description ilike '%violence%' THEN 'BAD CONTENT'
ELSE 'GOOD CONTENT'
END CATEGORY
FROM NETFLIX)
select category,count (*) as total_content from new_table
	group by 1;