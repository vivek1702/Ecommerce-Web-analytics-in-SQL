-- now with gsearch doing well and the site performing well, we launched a second paid channel, bsearch, around 22 Aug,
-- can you pull weekly trend session volume since then and compare to gsearch nonbrand

select 
	min(date(created_at)) as weekstart,
    count(case when utm_source = 'gsearch' then 1 else null end) as g_session,
    count(case when utm_source = 'bsearch' then 1 else null end) as b_session
from website_sessions
where created_at > '2012-08-22' and created_at < '2012-11-29' and utm_campaign = 'nonbrand'
group by week(created_at);
    

-- now will pull the data of percentage of traffic coming from mobile and compare both gsearch and bsearch
use mavenfuzzyfactory;
SELECT 
    utm_source,
    total_session,
    mobile_session,
    mobile_session / total_session AS pct_mobile
FROM
    (SELECT 
        utm_source,
            COUNT(CASE
                WHEN device_type IN ('mobile' , 'desktop') THEN website_session_id
                ELSE NULL
            END) AS total_session,
            COUNT(CASE
                WHEN device_type = 'mobile' THEN website_session_id
                ELSE NULL
            END) AS mobile_session
    FROM
        website_sessions
    WHERE
        created_at > '2012-08-22'
            AND created_at < '2012-11-30'
            AND utm_campaign = 'nonbrand'
            AND utm_source IN ('gsearch' , 'bsearch')
    GROUP BY utm_source) AS A;

    
########################################################################################
-- Now we need to pull non brand conversion rate from sessions to order for gsearch and bsearch
-- slice the data by device type, date from 22_aug_2012 to 18_sep_2012

(select utm_source, device_type, website_session, orders, orders/website_session as conv_rate
from
(
select 
	utm_source,
    device_type,
	count(a.website_session_id) as website_session,
    count(b.order_id) as orders
from
 website_sessions a 
	left join orders b on a.website_session_id = b.website_session_id
where a.created_at >= '2012-08-22' and a.created_at <= '2012-09-18' and utm_source in ('gsearch' , 'bsearch') and device_type = 'desktop'
group by utm_source) as A)
union
(select utm_source, device_type, website_session, orders, orders/website_session as conv_rate
from
(
select 
	utm_source,
    device_type,
	count(a.website_session_id) as website_session,
    count(b.order_id) as orders
from
 website_sessions a 
	left join orders b on a.website_session_id = b.website_session_id
where a.created_at >= '2012-08-22' and a.created_at <= '2012-09-18' and utm_source in ('gsearch' , 'bsearch') and device_type = 'mobile'
group by utm_source) as B);



-- now will pull down the weekly session volume for gsearch and bsearch, nonbrand, broken down by device
select 
	start_week,
	g_dtop_session, 
	b_dtop_session, 
    b_dtop_session/g_dtop_session as b_pct_of_dtop,
    g_mob_session,
    b_mob_session,
    b_mob_session/g_mob_session as b_pct_of_mob
from
(
select
	min(date(a.created_at)) as start_week,
    count(case when a.utm_source = 'gsearch' and a.device_type = 'desktop' and a.utm_campaign = 'nonbrand' then a.website_session_id else null end) as g_dtop_session,
    count(case when a.utm_source = 'bsearch' and a.device_type = 'desktop' and a.utm_campaign = 'nonbrand' then a.website_session_id else null end) as b_dtop_session,
    count(case when a.utm_source = 'gsearch' and a.device_type = 'mobile' and a.utm_campaign = 'nonbrand' then a.website_session_id else null end) as g_mob_session,
    count(case when a.utm_source = 'bsearch' and a.device_type = 'mobile' and a.utm_campaign = 'nonbrand' then a.website_session_id else null end) as b_mob_session
from
website_sessions a 
left join orders b on a.website_session_id = b.website_session_id
where a.created_at > '2012-11-04' and a.created_at < '2012-12-22' 
group by week(a.created_at)
) as A


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    