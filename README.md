# Netflix movies and Tv Shows data analysis using SQL
![Netflix_logo](https://github.com/divyakandi/Netflix_sql_project/blob/main/Netflix_logo.jpeg)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

# Objective
- 	Analyze the distribution of content types (movies vs TV shows).
- 	Identify the most common ratings for movies and TV shows.
- 	List and analyze content based on release years, countries, and durations.
-   explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:
-  Dataset Link : (https://www.kaggle.com/datasets/shivamb/netflix-shows#)

## Schema
```sql
create table netflix
(
  show_id varchar(5),
  type varchar(10),
  title varchar(250),
  director varchar(550),
  casts varchar(1050),
  country varchar(550),
  date_added varchar(55),
  release_year int,
  rating varchar(15),
  duration varchar(15),
  listed_in varchar(250),
  description varchar(550)
);
```
## Business Problems and Solutions
### 1. Count the number of Movies vs TV Shows
```sql
select type,
count(*)
from netflix
group by type;
```
## Objective: Determine the distribution of content types on Netflix
### 2. Find the Most Common Rating for Movies and TV Shows
``` sql
select type, rating from(
select 
rating, type,
count(rating),
rank() over(partition by type order by count(rating) desc) as ranking
from netflix
group by rating,type) as t1
where ranking =1;
```
## Objective: Identify the most frequently occurring rating for each type of content.
### 3.List All Movies Released in a Specific Year (e.g., 2020)
```sql
select * from netflix 
where 
type = 'Movie' and 
release_year =2020;
```
## Objective: Retrieve all movies released in a specific year.
### 4.Find the Top 5 Countries with the Most Content on Netflix
```sql
select 
unnest(string_to_array(country,',')) as new_country,
count(show_id)
from netflix
group by 1
order by 2 desc
limit 5;
```
## Objective: Identify the top 5 countries with the highest number of content items.
### 5. Identify the Longest Movie
```sql
select *from netflix
where type ='Movie' and 
duration =(select max(duration) from netflix);
```
## Objective: Find the movie with the longest duration.
### 6.  Find Content Added in the Last 5 Years
```sql
select *
from netflix
where 
to_date(date_added,'Month DD, YYYY') >= current_date -interval '5 years';
```
## Objective: Retrieve content added to Netflix in the last 5 years.
### 7. Objective: Retrieve content added to Netflix in the last 5 years.
```sql
select * from netflix
where director Ilike '%Rajiv Chilaka%';
```
## Objective: List all content directed by 'Rajiv Chilaka'.
### 8. List All TV Shows with More Than 5 Seasons
```sql
select *
from netflix where
type = 'TV Show' and 
split_part(duration,' ',1)::numeric>5;
```
## Objective: Identify TV shows with more than 5 seasons.
### 9. Count the Number of Content Items in Each Genre
```sql
select 
unnest(string_to_array(listed_in,',')),
count(show_id)
from netflix
group by 1;
```
## Objective: Count the number of content items in each genre.
### 10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
```sql
select 
extract(year from to_date(date_added,'Month DD, YYYY')) as year,
count(*),
round(count(*)::numeric/
(select count(*) from netflix where country ='India')::numeric*100,2) as avg_content_of_India
where country ='India'
group by 1
order by 3 desc;
```
## Objective: Calculate and rank years by the average number of content releases by India.
### 11. List All Movies that are Documentaries
```sql
select * from netflix
where listed_in ilike '%documentaries%';
```
## Objective: Retrieve all movies classified as documentaries.
### 12. Find All Content Without a Director
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```
## Objective: List content that does not have a director.
### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
## Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
## Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.
### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```
## Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
