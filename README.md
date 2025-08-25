# Netflix movies and Tv Shows data analysis using SQL
![Netflix_logo](https://github.com/divyakandi/Netflix_sql_project/blob/main/Netflix_logo.jpeg)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objective
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
