use mavenfuzzyfactory;

SELECT 
    YEAR(a.created_at) AS yr,
    MONTH(a.created_at) AS mnth,
    COUNT(DISTINCT a.website_session_id) AS sessions,
    COUNT(DISTINCT b.order_id) AS orders
FROM
    website_sessions a
        LEFT JOIN
    orders b ON a.website_session_id = b.website_session_id
WHERE
    a.created_at < '2013-01-01'
GROUP BY 1 , 2;
    
-----------------------------------------------------------------------------------------
SELECT 
    min(date(a.created_at)) as week_startdate,
    COUNT(DISTINCT a.website_session_id) AS sessions,
    COUNT(DISTINCT b.order_id) AS orders
FROM
    website_sessions a
        LEFT JOIN
    orders b ON a.website_session_id = b.website_session_id
WHERE
    a.created_at < '2013-01-01'
GROUP BY week(a.created_at);

------------------------------------------------------------------------------------------

select hr,
    avg(case when weekdayss = 0 then website_sessions else null end) as Mon,
    avg(case when weekdayss = 1 then website_sessions else null end) as tue,
    avg(case when weekdayss = 2 then website_sessions else null end) as wed,
    avg(case when weekdayss = 3 then website_sessions else null end) as thru,
    avg(case when weekdayss = 4 then website_sessions else null end) as fri,
    avg(case when weekdayss = 5 then website_sessions else null end) as sat,
    avg(case when weekdayss = 6 then website_sessions else null end) as sun
from
(
select
	date(created_at) as created_at,
	hour(created_at) as hr,
    weekday(created_at) as weekdayss,
    count(distinct website_session_id) as website_sessions
from website_sessions
where created_at > '2012-09-15' and created_at < '2012-11-15'
group by 1,2,3
order by 1) as A
group by 1



-- count(case when weekday(created_at) = 0 then website_session_id else null end) as Mon,
--     count(case when weekday(created_at) = 1 then website_session_id else null end) as tue,
--     count(case when weekday(created_at) = 2 then website_session_id else null end) as wed,
--     count(case when weekday(created_at) = 3 then website_session_id else null end) as thru,
--     count(case when weekday(created_at) = 4 then website_session_id else null end) as fri,
--     count(case when weekday(created_at) = 5 then website_session_id else null end) as sat,
--     count(case when weekday(created_at) = 6 then website_session_id else null end) as sun








