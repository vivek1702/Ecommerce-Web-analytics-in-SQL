use mavenfuzzyfactory;

create temporary table session_seeeing_carts
select 
	website_session_id as cart_session_id,
    website_pageview_id as cart_pageview_id,
	case 
		when created_at < '2013-09-25' then 'pre_product_crosssell'
		when created_at >= '2013-01-06' then 'post_product_crosssell' end as timeperiod
from website_pageviews 
where pageview_url = '/cart' and created_at between '2013-08-25' and '2013-10-25';

-----------------------------------------------------------------------------------------------------

create temporary table cart_session_seeing_another_page
select
	a.timeperiod as timeperiod,
    a.cart_session_id as cart_session_id,
    min(b.website_pageview_id) as next_pageview_after_cart
from session_seeeing_carts a
left join website_pageviews b 
on b.website_session_id = a.cart_session_id and b.website_pageview_id > a.cart_pageview_id
group by 1, 2
having min(b.website_pageview_id) is not null;

------------------------------------------------------------------------------------------------------

create temporary table pre_post_session_orders
select
	a.timeperiod as timeperiod,
    a.cart_session_id as cart_session_id,
    b.order_id as order_id,
    b.items_purchased as items_purchased,
    b.price_usd as price_usd
from session_seeeing_carts a 
join orders b on a.cart_session_id = b.website_session_id;

-------------------------------------------------------------------------------------------------------
select
	timeperiod,
    count(distinct cart_session_id) as cart_sessions,
    sum(clicked_to_another_page) as clickthrough,
    sum(clicked_to_another_page)/count(distinct cart_session_id) as cart_ctr,
    sum(items_purchased)/sum(placed_order) as products_per_order,
    sum(price_usd)/sum(placed_order) as aov,
    sum(price_usd)/count(distinct cart_session_id) as rev_per_cart_session
from
(
select
	a.timeperiod as timeperiod,
    a.cart_session_id as cart_session_id,
    case when b.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
    case when c.order_id is null then 0 else 1 end as placed_order,
    c.items_purchased as items_purchased,
    c.price_usd as price_usd
from 
	session_seeeing_carts a 
left join cart_session_seeing_another_page b
on a.cart_session_id = b.cart_session_id
left join pre_post_session_orders c
on a.cart_session_id = c.cart_session_id) as A
group by 1

    



