create temporary table session_w_repeats
select
	a.session_id,
    a.user_id,
    b.website_session_id
from
(
select 
	website_session_id as session_id,
    user_id
from website_sessions
where created_at >= '2014-01-01' and created_at < '2014-11-01' and is_repeat_session = 0
) as a
left join website_sessions b on a.user_id = b.user_id
and b.website_session_id > a.session_id
and b.is_repeat_session = 1
and b.created_at >= '2014-01-01' and b.created_at < '2014-11-01';

select 
	repeat_user,
    count(user_id) as no_of_users
from
(
	select 
		user_id,
		count(session_id) as new_session,
		count(website_session_id) as repeat_user
	from session_w_repeats
	group by user_id) as A
group by repeat_user
order by repeat_user;

----------------------------------------------------------------------------------------------------------------------
create temporary table users_sessions
select
	a.session_id,
    a.user_id,
    a.first_session_date,
    b.website_session_id as other_sessions,
    date(b.created_at) as other_created_date
from
(
	select 
		website_session_id as session_id,
		user_id,
		date(created_at) as first_session_date
	from website_sessions
	where created_at >= '2014-01-01' and created_at < '2014-11-01' and is_repeat_session = 0
) as a
left join website_sessions b on a.user_id = b.user_id
and b.website_session_id > a.session_id
and b.is_repeat_session = 1
and b.created_at >= '2014-01-01' and b.created_at < '2014-11-01';

select 
	avg(datediff(other_created_date, first_session_date)) as avg_days_bt_first_and_second,
    min(datediff(other_created_date, first_session_date)) as min_days_bt_first_and_second,
    max(datediff(other_created_date, first_session_date)) as max_days_bt_first_and_second
from
(
select 
	user_id,
    first_session_date,
    other_created_date,
    row_number() over(partition by user_id order by other_created_date) as rnk
from users_sessions 
where other_sessions is not null and other_created_date is not null) as A
where rnk = 1

