select
	year(a.created_at) as yr,
    month(a.created_at) as mnth,
    count(b.order_id) as no_of_sales,
    sum(items_purchased*price_usd) as total_revenue,
    sum(items_purchased*price_usd-cogs_usd) as total_margin
from website_sessions a 
join orders b on a.website_session_id = b.website_session_id
where a.created_at < '2013-01-04'
group by 1, 2;

--------------------------------------------------------------------------------------------------

select 
	year(a.created_at) as yr,
    month(a.created_at) as mnth,
    count(b.order_id) as orders,
    count(b.order_id)/count(a.website_session_id) as conv_rate,
    sum(b.price_usd)/count(a.website_session_id) as revenue_per_session,
    count(case when b.primary_product_id = 1 then b.order_id else null end) as  product_one_orders,
    count(case when b.primary_product_id = 2 then b.order_id else null end) as  product_two_orders
from website_sessions a
left join orders b on a.website_session_id = b.website_session_id
where a.created_at > '2012-04-01' and a.created_at <= '2013-04-05'
group by 1, 2;


------------------------------------------------------------------------------------------------------
# Product level website analysis
-- finding the product page view we care about
create temporary table products_pageview
select 
	website_session_id,
    website_pageview_id,
    created_at,
    case 
		when created_at < '2013-01-06' then 'A. preproduct_2'
		when created_at >= '2013-01-06' then 'A. posproduct_2'
		else 'check logic plzz'
	end as time_period
from website_pageviews
where created_at < '2013-04-06' and created_at > '2012-10-06' and pageview_url = '/products';

-- finding the next next pageview id which occurs after product pageview
create temporary table with_next_pageview_id
select 
	a.time_period,
    a.website_session_id,
    min(b.website_pageview_id) as next_pageview_id
from
products_pageview a 
left join website_pageviews b 
on a.website_session_id = b.website_session_id and b.website_pageview_id > a.website_pageview_id
group by 1, 2;

-- getting pageview url associated with the pageview id
create temporary table sessions_with_next_pageview_url
select 
	a.time_period as time_period,
    a.website_session_id as website_session_id,
    a.next_pageview_id as next_pageview_id,
    b.pageview_url as pageview_url
from with_next_pageview_id a 
left join website_pageviews b on a.next_pageview_id = b.website_pageview_id;

-- summarize the data and getting all the values
select 
	time_period,
    count(website_session_id) as sessions,
    count(case when next_pageview_id is not null then website_session_id else null end) as w_nxt_pg,
    count(case when next_pageview_id is not null then website_session_id else null end)/count(website_session_id) as pct_w_nxt_pg,
    count(case when pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as to_mrfuzzy,
    count(case when pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end)/count(website_session_id) as pct_to_mrfuzzy,
    count(case when pageview_url = '/the-forever-love-bear' then website_session_id else null end) as to_bear,
    count(case when pageview_url = '/the-forever-love-bear' then website_session_id else null end)/count(website_session_id) as pct_to_bear
from sessions_with_next_pageview_url
group by time_period
    






    











