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
WHERE link_clicks > 0
GROUP BY 1,2,3;


SELECT
    wiki,
    IF(ORD(RIGHT(event_token, 1)) <= ORD("J"), "pre-edit", IF(ORD(RIGHT(event_token, 1)) <= ORD("d"), "post-edit", "control")) AS bucket,
    CONCAT("link click ", event_link) AS event,
    count(*)
FROM
    log.SignupExpPageLinkClick_8101692
WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
AND event_token IS NOT NULL
GROUP BY 1,2,3;

SELECT
    wiki,
    IF(ORD(RIGHT(token, 1)) <= ORD("J"), "pre-edit", IF(ORD(RIGHT(token, 1)) <= ORD("d"), "post-edit", "control")) AS bucket,
    total_events > 0,
    count(*)
FROM
    token_stats
GROUP BY 1,2,3;


SELECT
    wiki,
    token,
    MIN(timestamp) AS first_event,
    SUM(event = "revision") AS revisions,
    SUM(event = "creation complete") AS account_creations,
    SUM(event = "creation impression") AS creation_impressions,
    SUM(event LIKE "button click%") AS button_clicks,
    SUM(event = "button click dismiss") AS dismiss_button_clicks,
    SUM(event = "button click signup") AS singup_button_clicks,
    SUM(event = "button click edit") AS edit_button_clicks,
    SUM(event LIKE "CTA impression%") AS cta_impressions,
    SUM(event = "CTA impression pre-edit") AS pre_cta_impressions,
    SUM(event = "CTA impression post-edit") AS post_cta_impressions,
    SUM(event LIKE "link click%") AS link_clicks,
    SUM(event LIKE "link click edit%") AS edit_link_clicks,
    SUM(event LIKE "link click create%") AS registration_link_clicks,
    COUNT(*) AS total_events
FROM (
        SELECT
            wiki,
            event_token AS token,
            timestamp,
            CONCAT("CTA impression ", event_cta) AS event
        FROM
            log.SignupExpCTAImpression_8101716
        WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
        AND event_token IS NOT NULL
    UNION ALL
        SELECT
            wiki,
            event_token AS token,
            timestamp,
            CONCAT("link click ", event_link) AS event
        FROM
            log.SignupExpPageLinkClick_8101692
        WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
        AND event_token IS NOT NULL
) AS token_events
GROUP BY 1,2
LIMIT 10
