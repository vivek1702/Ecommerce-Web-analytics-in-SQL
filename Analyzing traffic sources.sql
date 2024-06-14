Use mavenfuzzyfactory;


-- where the bulk of website session are coming from ? and sessions before 12 april 2022 
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(user_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY 1 , 2 , 3;


-- Now will drill deeper into gsearch nonbrand campaign traffic to explore potentional optimization opportunuties
-- seesion to order conversion rate
SELECT 
    COUNT(a.user_id) AS sessions,
    COUNT(b.order_id) AS orders,
	COUNT(b.order_id) / COUNT(a.user_id) AS sessions_to_order_conv_rate
FROM
    website_sessions a
        LEFT JOIN
    orders b ON a.website_session_id = b.website_session_id
WHERE
    a.utm_source = 'gsearch'
        AND a.utm_campaign = 'nonbrand'
        AND a.created_at < '2012-04-14';
        
-- after assigment 2 we realize we over bid an dnow we need to moniter the impact of bid reduction
-- analyse the preformnace by device type in order to define biding startegy

-- we need to pull the gsearch, nonbranded trended session volume by week

select 
    min(date(created_at)) as week_started_date,
    count(website_session_id) as session
from website_sessions
where utm_source = 'gsearch' AND utm_campaign = 'nonbrand' and created_at <= '2012-05-15'
group by week(date(created_at));

-- pull the conversion rate from session to order by device type

SELECT 
	a.device_type,
    COUNT(a.user_id) AS sessions,
    COUNT(b.order_id) AS orders,
	COUNT(b.order_id) / COUNT(a.user_id) AS sessions_to_order_conv_rate
FROM
    website_sessions a
        LEFT JOIN
    orders b ON a.website_session_id = b.website_session_id
WHERE
    a.utm_source = 'gsearch'
        AND a.utm_campaign = 'nonbrand'
        AND a.created_at < '2012-05-11'
group by
	device_type;
    
-- pulling the weekly trend for both mobile and desktop

SELECT 
    MIN(DATE(created_at)) AS week_started_date,
    COUNT(CASE
        WHEN device_type = 'desktop' THEN website_session_id
    END) AS dtop_session,
    COUNT(CASE
        WHEN device_type = 'mobile' THEN website_session_id
    END) AS mobile_session
FROM
    website_sessions
WHERE
    utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND created_at BETWEEN '2012-04-15' AND '2012-06-09'
GROUP BY WEEK(DATE(created_at));











