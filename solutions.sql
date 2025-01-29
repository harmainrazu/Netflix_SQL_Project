
create table netflix
(
show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(210),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)

);

-- 15 Business problems

-- 1. count the number of movies vs tv shows

select 
	type,
	count(*) as total_content
from netflix
group by type;


--2. find the common rating for movies and tv shows.

select
	type,
	rating
from	
(select 
	type,
	rating,
	count(*),
	rank()over(PARTITION BY type order by count(*)desc) as ranking
from netflix
group by 1,2
order by 1, 3 desc
) as t1
where 
		ranking=1;

		

--3. List all movies released in a specific year (e.g 2020)

select 
	type,
	title,
	release_year
from netflix
where
	type = 'Movie' and 
	release_year = 2020;


--4. find the top 5 countries with the most content on netflix. 

select
	unnest(string_to_array(country,',')) as new_country,
	count (show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;



--5. Identify the longest movie.

select 
	type,
	title,
	duration
from netflix
where type= 'Movie'
and
duration = (select max(duration) from netflix);


-- 6. find content added in the last 5 years.

select
	*,
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'
from netflix;


--7. Find all the movies/tv shows by director 'Rajiv chilaka'

select * 
from netflix
where director ilike  '%Rajiv Chilaka%' ;


--8. list all tv shows with more then 5 seasons.

select 
	*
from netflix
where
	type = 'TV Show' and 
	split_part(duration, ' ', 1) ::numeric > 5;  

--9. count the number of content items in each genre 

select
	 unnest(string_to_array(listed_in,',')) as genre,
	 count(show_id)as total_content
from netflix
group by 1;

--10. find each year and the average numbers of content release by india on netflix,
--	  return top 5 year with highest avg content release !

select 
	extract(year from to_date(date_added,'Month DD,YYYY')) as date,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country= 'India')::numeric * 100,2) as avg_content_for_year
from netflix
where
	country= 'India'
group by 1;




















