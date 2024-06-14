-- pull organic search, direct type in, and paid brand search sessions by months and show those session as a % of paid search nonbrand

SELECT 
    yr,
    mnth,
    nonbrand,
    brand,
    brand / nonbrand AS brand_pct_nonbrand,
    direct,
    direct / nonbrand AS direct_pct_nonbrand,
    organic,
    organic / nonbrand AS direct_pct_nonbrand
FROM
    (SELECT 
        YEAR(created_at) AS yr,
            MONTH(created_at) AS mnth,
            COUNT(CASE
                WHEN utm_campaign = 'nonbrand' THEN website_session_id
                ELSE NULL
            END) AS nonbrand,
            COUNT(CASE
                WHEN utm_campaign = 'brand' THEN website_session_id
                ELSE NULL
            END) AS brand,
            COUNT(CASE
                WHEN
                    utm_campaign IS NULL
                        AND http_referer IS NULL
                THEN
                    website_session_id
            END) AS direct,
            COUNT(CASE
                WHEN
                    utm_campaign IS NULL
                        AND http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com')
                THEN
                    website_session_id
            END) AS organic
    FROM
        website_sessions
    WHERE
        created_at < '2012-12-23'
    GROUP BY 2 , 1) AS A