select 
 *  
From Netflix;

Question 1: Count the number of movies and TV Shows.

Solution 

Select 
  type,
  Count (*) as "Number of Movies and TV shows"
From Netflix
Group by 1


Question 2: Find the most common rating for movies and Tv shows.
 
 Solutions 
 
SELECT *
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS cnt,
        RANK() OVER (
            PARTITION BY type
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY type, rating
) t
WHERE ranking = 1;




Question 3: List all movies released in a specific year. 

Solution 

Select
    type
  
From Netflix

Where
    type = 'Movie'
	And 
	release_year = 2020



Question 4: Find the top 5 countries with the most content on Netflix.

Solutions


Select 
   unnest(String_to_Array(country, ','))as New_country,
  count(show_id) as Total_content
From Netflix
Group by 1
order by 2 DESC 
limit 5 


select 
  unnest(String_to_Array(country, ','))as New_country
from Netflix



Question 5: Identify the longest-duration movie.

SELECT 
show_id,
duration
FROM netflix
WHERE 
    type = 'Movie'
	And 
	Duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;


Question 6: Find content added in the last 5 years?

Select 
  tittle,
  date_added

FROM Netflix
where
 date_added IS NOT NULL
 And 
 To_date (date_added, 'Month DD, YYYY')>= Current_Date - Interval '5Years';

Question 7: Find all the movies/TV shows directed by Rajiv Chilaka.

Select 
    *
From Netflix
where 
   director Ilike '%Rajiv Chilaka%'

Question 8: List all TV shows with more than 5 seasons.

Select 
   Type,
   Duration 

From Netflix
Where 
   Type = 'TV Show'
   AND 
   CAST(Split_Part(duration, ' ', 1) as  INT)> 5

Question 9: Count the number of content items in each genre.

Select 
    TRIM(listed_on) AS genre,
    COUNT(*) AS total_content
 From Netflix,
 Unnest (String_to_Array(listed_in, ',')) As listed_on
 group by Genre
  Order by total_content DESC;

Question 10: Find each year and the average number of content releases in India on Netflix.

            Return top 5 years with the highest average contact release

Solution

Select 
    Count(show_id) as Number_of_content


From Netflix
 Where 
   date_added Ilike '%2021%'
   And
   country Ilike '%India%'


select 
 *  
From Netflix;


WITH yearly_releases AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
        COUNT(show_id) AS yearly_count
    FROM netflix
    WHERE 
        country ILIKE '%India%'
        AND date_added IS NOT NULL
    GROUP BY year
)
SELECT 
    AVG(yearly_count) AS avg_content_per_year
FROM yearly_releases;

WITH monthly_releases AS (
    SELECT
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
        EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) AS month,
        COUNT(*) AS monthly_count
    FROM netflix
    WHERE country ILIKE '%India%'
      AND date_added IS NOT NULL
    GROUP BY 1, 2
)
SELECT
    year,
    ROUND(AVG(monthly_count), 2) AS avg_yearly_releases
FROM monthly_releases
GROUP BY year
ORDER BY avg_yearly_releases DESC
LIMIT 5;


Question 11: List all movies that are documentaries.

Slution 

Select 
   show_id,
   type
  From Netflix
Where 
   type = 'Movie'
   And 
   listed_in Ilike '%Documentaries%'

Question 12: Find all content with no director.

Solutions

Select * 

    From netflix

Where director is null

Question 13: Find how many movies actor Salman Khan appeared over the last 12 years.

Solution 

Select 
  * 
From Netflix
where casts Ilike '%Salman Khan%'
and type = 'Movie'
and  release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 12;


Question 14: find top 10 actors who have appeared in the highest number of movies produced in India.


Solution 

Select
     TRIM(actor) AS actor_name,
    COUNT(*) AS movie_count
FROM Netflix,
     UNNEST(string_to_array(casts, ',')) AS actor
where country ilike '%India%'
 AND type = 'Movie'
  AND casts IS NOT NULL
group by 1
order by 2 Desc
limit 10

Question 15: categorises the content based on the presence of the words 'kill' and 'violence' in the discription 
field. label content containing these words as 'Bad'and all other content as 'Good', count how many 
items fall under these categories 


With new_table
As
(
Select *,
case 
when discription ilike '%kill%' 
     or discription ilike '%violence%' then 'Bad_content'
	 Else 'Good_content'
	 End Category 
From netflix)

select 
  category,
  count(*) As total_content
from new_table
group by 1

  
where discription ilike '%kill%' 
or discription ilike '%violence%'


















