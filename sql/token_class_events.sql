SELECT
    wiki,
    bucket,
    IF(first_user_id IS NULL,
        "pure anon",
        IF(first_user_registration IS NULL OR first_user_registration <= @start_date,
        "old user",
        IF(first_user_registration <= @end_date,
        "tracked user",
        "experiment user"))) AS editor_class,
    COUNT(*) AS tokens,
    SUM(edit_link_clicks > 0) AS edit_click_tokens
FROM staging.token_info
WHERE link_clicks > 0
AND first_event BETWEEN @start_date AND @end_date
GROUP BY 1,2,3;
