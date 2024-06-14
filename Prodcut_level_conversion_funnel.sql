with cte as
(
select 
	website_session_id,
    pageview_url,
	row_number() over(partition by website_session_id order by website_session_id) as rnk
from website_pageviews
where pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear','/cart','/shipping','/billing-2','/thank-you-for-your-order')
and created_at between '2013-01-06' and '2013-04-10'),
cte2 as
(
select 
	website_session_id,
	case when rnk = 1 then pageview_url else null end as product_seen,
    case when rnk = 2 then 1 else null end as cart,
    case when rnk = 3 then 1 else null end as shipping,
    case when rnk = 4 then 1 else null end as billing,
    case when rnk = 5 then 1 else null end as thankyou
from cte),
cte3 as
(
select 
	website_session_id,
    product_seen,
    coalesce(cart, max(cart) over(partition by website_session_id)) as cart,
    coalesce(shipping, max(shipping) over(partition by website_session_id)) as shipping,
    coalesce(billing, max(billing) over(partition by website_session_id)) as billing,
    coalesce(thankyou, max(thankyou) over(partition by website_session_id)) as thankyou
from cte2),
cte4 as
(
select * 
from cte3 
where product_seen is not null and product_seen in ('/the-original-mr-fuzzy', '/the-forever-love-bear'))

select
	case when product_seen = '/the-original-mr-fuzzy' then 'mr-fuzzy' else 'love-bear' end as prduct_seen,
    count(cart)/count(distinct website_session_id) as product_page_click_rt,
    count(shipping)/count(cart) as cart_click_rt,
    count(billing)/count(shipping) as shipping_click_rt,
    count(thankyou)/count(billing) as billing_click_rt
from cte4
group by product_seen

	
	

    