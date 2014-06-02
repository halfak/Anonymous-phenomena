SELECT
    wiki,
    bucket,
    IF(first_user_id IS NULL,
        "pure anon",
        IF(first_user_registration IS NULL OR first_user_registration <= 20140502000000,
        "old user",
        IF(first_user_registration <= 20140519180800,
        "tracked user",
        "experiment user"))) AS editor_class,
    COUNT(*) AS tokens,
    SUM(edit_link_clicks > 0) AS edit_click_tokens
FROM staging.token_info
WHERE link_clicks > 0
GROUP BY 1,2,3;
