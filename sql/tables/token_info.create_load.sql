CREATE TABLE IF NOT EXISTS staging.token_info (
    wiki    VARCHAR(50),
    token   VARCHAR(50),
    bucket  VARCHAR(50),
    first_event VARBINARY(14),
    tokened_revisions INT,
    account_creations INT,
    button_clicks INT,
    cta_impressions INT,
    link_clicks INT,
    edit_link_clicks INT,
    registration_link_clicks INT,
    total_events INT,
    user_accounts INT,
    first_user_id INT,
    first_user_registration INT,
    PRIMARY KEY (wiki, token)
);

DELETE FROM staging.token_info
WHERE first_event BETWEEN @start_date AND @end_date;

INSERT INTO staging.token_info
SELECT
    token_stats.wiki,
    token_stats.token,
    IF(ORD(RIGHT(token, 1)) <= ORD("J"), "pre-edit", IF(ORD(RIGHT(token, 1)) <= ORD("d"), "post-edit", "control")) AS bucket,
    token_stats.first_event,
    token_stats.revisions AS tokened_revisions,
    token_stats.account_creations,
    token_stats.creation_impressions,
    token_stats.button_clicks,
    token_stats.cta_impressions,
    token_stats.link_clicks,
    token_stats.edit_link_clicks,
    token_stats.registration_link_clicks,
    token_stats.total_events,
    SUM(DISTINCT user_id) AS user_accounts,
    MIN(user_id) AS first_user_id,
    MIN(registration) AS first_user_registration
FROM staging.token_stats
LEFT JOIN staging.user_token USING (wiki, token)
WHERE token_stats.first_event BETWEEN @start_date AND @end_date
GROUP BY 1,2;

SELECT COUNT(*), NOW() FROM staging.token_info;
