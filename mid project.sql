SELECT 
    YEAR(created_at) AS created_year,
    MONTH(created_at) AS created_month,
    COUNT(website_session_id) AS montly_sessions,
    COUNT(order_id) AS monthly_order
FROM
    (SELECT 
        a.created_at AS created_at,
            a.website_session_id AS website_session_id,
            b.order_id AS order_id
    FROM
        website_sessions a
    LEFT JOIN orders b ON a.website_session_id = b.website_session_id
    WHERE
        a.created_at < '2012-11-27'
            AND a.utm_source = 'gsearch') AS A
GROUP BY YEAR(created_at) , MONTH(created_at);

########################################################################################################
    
SELECT 
    YEAR(created_at) AS created_year,
    MONTH(created_at) AS created_month,
    COUNT(case when utm_campaign = 'nonbrand' then website_session_id else null end) AS nonbrand_count,
    COUNT(case when utm_campaign = 'nonbrand' then order_id else null end) AS order_count_nonbrand,
    COUNT(case when utm_campaign = 'brand' then website_session_id else null end) AS brand_count,
    COUNT(case when utm_campaign = 'brand' then order_id else null end) AS order_count_brand
FROM
    (SELECT 
        a.created_at AS created_at,
            a.website_session_id AS website_session_id,
            b.order_id AS order_id,
            a.utm_campaign as utm_campaign
    FROM
        website_sessions a
    LEFT JOIN orders b ON a.website_session_id = b.website_session_id
    WHERE
        a.created_at < '2012-11-27'
            AND a.utm_source = 'gsearch'
            AND utm_campaign in ('nonbrand','brand')
	) AS A
GROUP BY YEAR(created_at) , MONTH(created_at);


###########################################################################################################

SELECT 
    YEAR(created_at) AS created_year,
    MONTH(created_at) AS created_month,
    COUNT(CASE
        WHEN device_type = 'mobile' THEN website_session_id
        ELSE NULL
    END) AS nonbrand_mobile_session_count,
    COUNT(CASE
        WHEN device_type = 'mobile' THEN order_id
        ELSE NULL
    END) AS nonbrand_mobile_order_count_,
    COUNT(CASE
        WHEN device_type = 'desktop' THEN website_session_id
        ELSE NULL
    END) AS nonbrand_desktop_session_count,
    COUNT(CASE
        WHEN device_type = 'desktop' THEN order_id
        ELSE NULL
    END) AS nonbrand_desktop_order_count
FROM
    (SELECT 
        a.created_at AS created_at,
            a.website_session_id AS website_session_id,
            b.order_id AS order_id,
            a.utm_campaign AS utm_campaign,
            a.device_type AS device_type
    FROM
        website_sessions a
    LEFT JOIN orders b ON a.website_session_id = b.website_session_id
    WHERE
        a.created_at < '2012-11-27'
            AND a.utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand') AS A
GROUP BY YEAR(created_at) , MONTH(created_at);
            
########################################################################################################

select 
	year(created_at) as created_year,
    month(created_at) as created_month,
    count(case when utm_source = 'gsearch' then website_session_id end) as gsearch_session,
    count(case when utm_source = 'bsearch' then website_session_id end) as bsearch_session,
    count(case when utm_source is null and http_referer is not null then website_session_id end) as organic_session,
    count(case when utm_source is null and http_referer is null then website_session_id end) as direct_session
from website_sessions
where created_at < '2012-11-27'
group by 1, 2;
    
########################################################################################################
-- Now will pull the data of sessions over order conversion rate by month

select 
	year(a.created_at) as created_year,
    month(a.created_at) as created_month,
    count(distinct a.website_session_id) as all_sessions,
    count(distinct b.order_id) as montly_orders,
    count(distinct b.order_id)/count(distinct a.website_session_id) as order_conversion
from website_sessions a
left join orders b
on a.website_session_id = b.website_session_id
where a.created_at < '2012-11-27'
group by year(a.created_at), month(a.created_at);


#########################################################################################################
-- Q6
-- this is to get lander-1 first instance in data
-- select * from website_pageviews where pageview_url = '/lander-1';

-- now wil find filter according to given condition
create temporary table first_website_pageview
SELECT 
    a.website_session_id AS website_session_id,
    MIN(b.website_pageview_id) AS min_pageview_id
FROM
    website_sessions a
        INNER JOIN
    website_pageviews b ON a.website_session_id = b.website_session_id
WHERE
    b.website_pageview_id > 23504
        AND a.utm_source = 'gsearch'
        AND a.utm_campaign = 'nonbrand'
        AND a.created_at < '2012-07-28'
GROUP BY a.website_session_id;

create temporary table non_brand_sessions
select 
	a.website_session_id as website_session_id,
    b.pageview_url as landing_page,
    c.order_id as order_id
from first_website_pageview a
left join website_pageviews b on a.website_session_id = b.website_session_id
left join orders c on a.website_session_id = c.website_session_id
where b.pageview_url in ('/home', '/lander-1');

#to find difference in conversion rate
select 
	landing_page,
    website_session_total,
    order_total,
    order_total/website_session_total as conv_rate
from
(	
select 
	landing_page,
    count(website_session_id) as website_session_total,
    count(order_id) as order_total
    -- count(order_id)/ount(website_session_id) as conv_rate
from non_brand_sessions
group by landing_page) as A;

-- find the most recent pageview for gsearch nonbrand where traffic was sent to home

select 
	max(a.website_session_id) as max_pageview
from website_sessions a
left join website_pageviews b on a.website_session_id = b.website_session_id
WHERE
    b.pageview_url = '/home'
        AND a.utm_source = 'gsearch'
        AND a.utm_campaign = 'nonbrand'
        AND a.created_at < '2012-11-27';
    
-- max session id is 17145
select 
	count(website_session_id) as sessions_since_test
from website_sessions
where website_session_id > 17145
	AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND created_at < '2012-11-27';
        
-- 22972 website sessions since last
-- now we did simple math and result is .0087 incremental conversion since 7/29
-- roughly 4 months, so roughly 50 extra orders per month

##################################################################################################################
-- more 2 questions left 

    
    


    

    


    
    
    
















