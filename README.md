# Netflix movies and TV shows Data Analysis project
![Netflix logo](https://github.com/Vishal0601ish/Netflix-SQL-project-/blob/main/Netflix%20logo.jpg)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyse the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyse content based on release years, countries, and durations.
- Explore and categorise content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:

-**Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Schema
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
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
Business Problems and Solutions
## Question 1: Count the number of movies and TV Shows.

 
```sql
 Select 
  type,
  Count (*) as "Number of Movies and TV shows"
From Netflix
Group by 1
```

## Question 2: Find the most common rating for movies and Tv shows.
 
```sql
 
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

```


## Question 3: List all movies released in a specific year. 

```sql 

Select
    type
  
From Netflix

Where
    type = 'Movie'
	And 
	release_year = 2020
```


## Question 4: Find the top 5 countries with the most content on Netflix.

```sql

Select 
   unnest(String_to_Array(country, ','))as New_country,
  count(show_id) as Total_content
From Netflix
Group by 1
order by 2 DESC 
limit 5 
```


## Question 5: Identify the longest-duration movie.

```sql
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
```

## Question 6: Find content added in the last 5 years?

```sql
Select 
  tittle,
  date_added

FROM Netflix
where
 date_added IS NOT NULL
 And 
 To_date (date_added, 'Month DD, YYYY')>= Current_Date - Interval '5Years';
```

## Question 7: Find all the movies/TV shows directed by Rajiv Chilaka.

```sql
Select 
    *
From Netflix
where 
   director Ilike '%Rajiv Chilaka%'
```

## Question 8: List all TV shows with more than 5 seasons.

```sql
Select 
   Type,
   Duration 

From Netflix
Where 
   Type = 'TV Show'
   AND 
   CAST(Split_Part(duration, ' ', 1) as  INT)> 5
```
## Question 9: Count the number of content items in each genre.

```sql
Select 
    TRIM(listed_on) AS genre,
    COUNT(*) AS total_content
 From Netflix,
 Unnest (String_to_Array(listed_in, ',')) As listed_on
 group by Genre
  Order by total_content DESC;
```

## Question 10: Find each year and the average number of content releases in India on Netflix. Return the top 5 years with the highest average contact release

```sql

WITH yearly_releases AS (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
        COUNT(show_id) AS avg_content_released
    FROM netflix
    WHERE country ILIKE '%India%'
      AND date_added IS NOT NULL
    GROUP BY year
)
SELECT
    year,
    avg_content_released
FROM yearly_releases
ORDER BY avg_content_released DESC
LIMIT 5;
```


## Question 11: List all movies that are documentaries.

```sql

Select 
   show_id,
   type
  From Netflix
Where 
   type = 'Movie'
   And 
   listed_in Ilike '%Documentaries%'
```

## Question 12: Find all content with no director.

```sql
Select * 

    From netflix

Where director is null
```

## Question 13: Find how many movies actor Salman Khan appeared in over the last 12 years.

```sql

Select 
  * 
From Netflix
where casts Ilike '%Salman Khan%'
and type = 'Movie'
and  release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 12;
```


## Question 14: Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
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
```

## Question 15: categorises the content based on the presence of the words 'kill' and 'violence' in the description field. label content containing these words as 'Bad'and all other content as 'Good', and count how many items fall under these categories.

```sql
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
```

## Findings and Conclusion
- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorisation: Categorising content based on specific keywords helps in understanding the nature of content available on Netflix.
- This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.
