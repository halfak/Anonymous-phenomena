SELECT
	wiki,
	bucket,
	first_user_id AS user_id,
	first_user_registration AS user_registration,
	first_event
FROM staging.token_info
WHERE
	link_clicks > 0 AND
	first_user_id IS NOT NULL AND
	first_user_registration BETWEEN @start_date AND @end_date;
