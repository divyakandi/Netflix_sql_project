create table netflix(
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
)



select * from netflix

--Count the number of Movies vs TV Shows
select type,
count(*)
from netflix
group by type

--Find the most common rating for movies and TV shows
select type, rating from(
select 
rating, type,
count(rating),
rank() over(partition by type order by count(rating) desc) as ranking
from netflix
group by rating,type) as t1
where ranking =1

--List all movies released in a specific year (e.g., 2020)
select title from(
select type,title,release_year
from netflix
where release_year = 2020) as t1
where type = 'Movie'

select * from netflix 
where 
type = 'Movie' and 
release_year =2020

--Find the top 5 countries with the most content on Netflix

select country,count(show_id)
from netflix
group by country
order by count(show_id) desc
limit 5



select 
unnest(string_to_array(country,',')) as new_country,
-- thids will seperate all the countries into different rows
count(show_id)
from netflix
group by 1
order by 2 desc
limit 5

--Identify the longest movie
select *from netflix
where type ='Movie' and 
duration =(select max(duration) from netflix)


--Find content added in the last 5 years
select *
from netflix
where 
to_date(date_added,'Month DD, YYYY') >= current_date -interval '5 years'
--to_date has changed our date added which is string to date and
-- (current_date -interval '5 years') gives the date 5 year bach from today

--Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director Ilike '%Rajiv Chilaka%'


select *,unnest(string_to_array(director,','))
from netflix
where director = 'Rajiv Chilaka'

--List all TV shows with more than 5 seasons
select *
from netflix where
type = 'TV Show' and 
split_part(duration,' ',1)::numeric>5
--split_part will be in string so we change it to integer

--Count the number of content items in each genre 
select 
unnest(string_to_array(listed_in,',')),
count(show_id)
from netflix
group by 1

--Find each year and the average numbers of content release in India on netflix.,
--return top 5 year with highest avg content release!
select 
extract(year from to_date(date_added,'Month DD, YYYY')) as year,
count(*),
round(count(*)::numeric/(select count(*) from netflix where country ='India')::numeric*100,2) as avg_content_of_India
-- this gives total_yearly_content(333,203,189,142,95,10)/total_content(333+203+189+142+95+10 =972)
from netflix 
where country ='India'
group by 1
order by 3 desc


--List all movies that are documentaries
select * from netflix
where listed_in ilike '%documentaries%'

'
--Find all content without a director
select * from netflix
where director is null

--Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
from netflix
where
casts ilike '%Salman Khan%'
and 
release_year > extract(year from current_date)-10


--Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
cast_names,
count(show_id)
from(
select 
show_id,
casts,
unnest(string_to_array(casts,',')) as cast_names
from netflix 
where country Ilike '%India%'
and type = 'Movie') as t1
group by cast_names
order by 2 desc
limit 10

--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.


with new_table as(
select *,
case when description ILIKE '%Kill%' or
description ILIKE '%violence%' then 'Bad_film'
else 'Good_film'
end category
from netflix)
select category,count(*)
from new_table
group by category













