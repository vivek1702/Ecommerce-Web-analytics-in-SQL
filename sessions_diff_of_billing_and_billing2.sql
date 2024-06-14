-- with billing2 as 
-- (select * from website_pageviews where pageview_url = '/billing-2')
-- select * from billing2;

select 
	pageview_url, 
    count(website_session_id) as sessions,
	count(order_id) as orders,
    count(order_id)/count(website_session_id) as order_click_rate
from
(
select 
	order_id,
	b.pageview_url as pageview_url,
	b.website_session_id as website_session_id
from orders a
right join website_pageviews b on a.website_session_id = b.website_session_id
where b.website_pageview_id >= 53550 and b.created_at < '2012-11-10' and pageview_url in ('/billing','/billing-2')
) as A
group by pageview_url





		









