use mavenfuzzyfactory;
with sessions as
(
select 
	count(distinct website_session_id) as total_session,
    count(case when pageview_url = '/lander-1'  then 1 else null end) as lander_session,
    count(case when pageview_url = '/products'  then 1 else null end) as product_session,
    count(case when pageview_url = '/the-original-mr-fuzzy'  then 1 else null end) as to_mr_fuzzy,
    count(case when pageview_url = '/cart'  then 1 else null end) as cart,
    count(case when pageview_url = '/shipping'  then 1 else null end) as shipping,
    count(case when pageview_url = '/billing'  then 1 else null end) as billing,
    count(case when pageview_url = '/thank-you-for-your-order'  then 1 else null end) as thankyou
from
(
SELECT 
    b.website_pageview_id AS website_pageview_id,
    a.created_at AS created_at,
    a.website_session_id AS website_session_id,
    b.pageview_url AS pageview_url
FROM
    website_sessions a
        LEFT JOIN
    website_pageviews b ON a.website_session_id = b.website_session_id
WHERE
    b.pageview_url IN ('/lander-1' , '/products',
        '/the-original-mr-fuzzy',
        '/cart',
        '/shipping',
        '/billing',
        '/thank-you-for-your-order')
        AND a.created_at BETWEEN '2012-08-5' AND '2012-09-05'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
) as A)
select 
	product_session/total_session as lander_click_rt,
    to_mr_fuzzy/product_session as products_click_rt,
    cart/to_mr_fuzzy as mr_fuzzy_click_rt,
    shipping/cart as cart_click_rt,
    billing/shipping as shipping_rt,
    thankyou/billing as billing_click_rt
from sessions
    
    
    
	




















