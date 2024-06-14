use mavenfuzzyfactory;    
-- Now will pull the volume of paid search nonbrnad traffic landing on \home and \lander, 
-- trended weekly bwtween 1st june 2012 and 31 sep 2012
with session_w_minimum_previewid_and_viewcount as
(
SELECT 
    a.website_session_id AS website_session_id,
    MIN(a.website_pageview_id) AS first_pageview_id,
    COUNT(a.website_pageview_id) AS count_pageviews
FROM
    website_pageviews a
        RIGHT JOIN
    website_sessions b ON a.website_session_id = b.website_session_id
WHERE
    b.created_at > '2012-06-01'
        AND b.created_at < '2012-08-31'
        AND b.utm_source = 'gsearch'
        AND b.utm_campaign = 'nonbrand'
GROUP BY a.website_session_id
),
session_with_count_lander_and_created_at as 
(
SELECT 
    a.website_session_id AS website_session_id,
    a.first_pageview_id AS first_pageview_id,
    a.count_pageviews AS count_pageviews,
    b.created_at AS created_at,
    b.pageview_url AS pageview_url
FROM
    session_w_minimum_previewid_and_viewcount a
        LEFT JOIN
    website_pageviews b ON a.website_session_id = b.website_session_id
)
SELECT 
    MIN(DATE(created_at)) AS week_startdate,
    COUNT(DISTINCT CASE
            WHEN count_pageviews = 1 THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE
            WHEN pageview_url = '/home' THEN website_session_id
            ELSE NULL
        END) AS home_session,
    COUNT(DISTINCT CASE
            WHEN pageview_url = '/lander-1' THEN website_session_id
            ELSE NULL
        END) AS lander_session
FROM
    session_with_count_lander_and_created_at
GROUP BY WEEK(DATE(created_at));


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
)
