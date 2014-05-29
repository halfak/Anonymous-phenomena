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
    COUNT(*) AS tokens
FROM staging.token_info
GROUP BY 1,2,3;