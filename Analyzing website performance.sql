use mavenfuzzyfactory;

-- pulling the most viewed website pages, ranked by session volume
select 
	pageview_url,
    count(distinct website_pageview_id) as sessions
from website_pageviews
where created_at < '2012-06-09'
group by pageview_url
order by sessions desc;

-- Now we need to pull a list of top entry pages and rank them on entry volume

select 
	pageview_url,
    count(website_session_id)
from
(
select 
	*,
	row_number() over(partition by website_session_id order by website_session_id) as rank_session
from website_pageviews
where created_at < '2012-06-12') as A
where rank_session = 1
group by pageview_url;

-- Now will calculate the bouns rate of each session

with page_total_session as
(
	select 
		pageview_url,
		count(website_session_id) as total_session
	from
	(
	select 
		*,
		row_number() over(partition by website_session_id order by website_session_id) as rank_session
	from website_pageviews
	where created_at < '2012-06-14') as A
	where rank_session = 1
	group by pageview_url
),
bounce_count as
(
	select count(session_count_by_session_id) as bounnce
    from
    (
	select 
		website_session_id,
        count(website_session_id) as session_count_by_session_id
	from website_pageviews
    where created_at < '2012-06-14'
    group by website_session_id
    ) as A
    where session_count_by_session_id = 1
)

select 
	total_session,
    bounnce,
    (bounnce/total_session) as bounce_rate
from page_total_session, bounce_count;


#find the first instance of lander1 to set the analysis of time frame
select  
	min(created_at) as first_created_at,
    min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url = '/lander-1';

#
create temporary table first_test_pageviews
select 
	a.website_session_id as website_session_id,
    min(a.website_pageview_id) as min_pageview_id
from website_pageviews a
inner join website_sessions b 
on a.website_session_id = b.website_session_id
where a.created_at < '2012-07-28' and a.website_pageview_id > 23504 and b.utm_source = 'gsearch' and b.utm_campaign = 'nonbrand'
group by a.website_session_id;

-- select * from first_test_pageviews


-- Now will bring the landing page to each session, but restrict to home and lander 1 page
create temporary table nonbrand_test_session_w_landing_page
select 
	a.website_session_id AS website_session_id,
    b.pageview_url as landing_page
from first_test_pageviews a 
left join website_pageviews b on b.website_pageview_id = a.min_pageview_id
where b.pageview_url in ('/home','/lander-1');

-- select * from nonbrand_test_session_w_landing_page;

create temporary table nonbrand_test_bounced_sessions
select 
	a.website_session_id as website_session_id,
    a.landing_page as landing_page,
    count(b.website_pageview_id) as website_pageview_id
from nonbrand_test_session_w_landing_page a 
left join website_pageviews b on a.website_session_id = b.website_session_id
group by a.website_session_id, a.landing_page
having count(b.website_pageview_id) = 1;


select 
	a.landing_page,
	count(distinct a.website_session_id) as sessions,
    count(distinct b.website_session_id) as bounced_sessions,
    count(distinct b.website_session_id)/count(distinct a.website_session_id) as bounce_rate
from nonbrand_test_session_w_landing_page a
left join nonbrand_test_bounced_sessions b on a.website_session_id = b.website_session_id
group by a.landing_page
    
    
-- Now will pull the volume of paid search nonbrnad traffic landing on \home and \lander, 
-- trended weekly since june 1st
	



	















	
















