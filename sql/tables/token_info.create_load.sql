DROP TABLE IF EXISTS staging.token_info;
CREATE TABLE staging.token_info

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
GROUP BY 1,2;

CREATE UNIQUE INDEX wiki_token ON staging.token_info (wiki, token);
SELECT COUNT(*), NOW() FROM staging.token_info;
