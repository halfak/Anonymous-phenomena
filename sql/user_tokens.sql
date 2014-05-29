SELECT
    token_event.wiki,
    token_event.user_id,
    ssac.timestamp AS registration,
    token_event.token AS token,
    SUM(event = "account creation") AS account_creations,
    SUM(event = "revision") AS revisions,
    COUNT(*) AS total_events
FROM (
        SELECT
            wiki AS wiki,
            event_userId AS user_id,
            event_token AS token,
            "account creation" AS event
        FROM log.SignupExpAccountCreationComplete_8539421
        WHERE wiki IN ("enwiki", "dewiki", "frwiki", "itwiki")
    UNION ALL
        SELECT
            "enwiki" AS wiki,
            IFNULL(rev_user, ar_user) AS user_id,
            event_token AS token,
            "revision" AS event
        FROM (
            SELECT * FROM 
            log.TrackedPageContentSaveComplete_8535426
            WHERE wiki = "enwiki"
            AND event_token IS NOT NULL
            UNION
            SELECT * FROM
            log.TrackedPageContentSaveComplete_7872558
            WHERE wiki = "enwiki"
            AND event_token IS NOT NULL
        ) AS tracked_revisions
        LEFT JOIN enwiki.revision ON rev_id = event_revId
        LEFT JOIN enwiki.archive ON ar_rev_id = event_revId
        WHERE
            wiki = "enwiki" AND
            rev_user IS NOT NULL OR ar_user IS NOT NULL
    UNION ALL
        SELECT
            "dewiki" AS wiki,
            IFNULL(rev_user, ar_user) AS user_id,
            event_token AS token,
            "revision" AS event
        FROM (
            SELECT * FROM 
            log.TrackedPageContentSaveComplete_8535426
            WHERE wiki = "dewiki"
            AND event_token IS NOT NULL
            UNION
            SELECT * FROM
            log.TrackedPageContentSaveComplete_7872558
            WHERE wiki = "dewiki"
            AND event_token IS NOT NULL
        ) AS tracked_revisions
        LEFT JOIN dewiki.revision ON rev_id = event_revId
        LEFT JOIN dewiki.archive ON ar_rev_id = event_revId
        WHERE
            wiki = "dewiki" AND
            rev_user IS NOT NULL OR ar_user IS NOT NULL
    UNION ALL
        SELECT
            "frwiki" AS wiki,
            IFNULL(rev_user, ar_user) AS user_id,
            event_token AS token,
            "revision" AS event
        FROM  (
            SELECT * FROM 
            log.TrackedPageContentSaveComplete_8535426
            WHERE wiki = "frwiki"
            AND event_token IS NOT NULL
            UNION
            SELECT * FROM
            log.TrackedPageContentSaveComplete_7872558
            WHERE wiki = "frwiki"
            AND event_token IS NOT NULL
        ) AS tracked_revisions
        LEFT JOIN frwiki.revision ON rev_id = event_revId
        LEFT JOIN frwiki.archive ON ar_rev_id = event_revId
        WHERE
            wiki = "frwiki" AND
            rev_user IS NOT NULL OR ar_user IS NOT NULL
    UNION ALL
        SELECT
            "itwiki" AS wiki,
            IFNULL(rev_user, ar_user) AS user_id,
            event_token AS token,
            "revision" AS event
        FROM  (
            SELECT * FROM 
            log.TrackedPageContentSaveComplete_8535426
            WHERE wiki = "itwiki"
            AND event_token IS NOT NULL
            UNION
            SELECT * FROM
            log.TrackedPageContentSaveComplete_7872558
            WHERE wiki = "itwiki"
            AND event_token IS NOT NULL
        ) AS tracked_revisions
        LEFT JOIN itwiki.revision ON rev_id = event_revId
        LEFT JOIN itwiki.archive ON ar_rev_id = event_revId
        WHERE
            wiki = "itwiki" AND
            rev_user IS NOT NULL OR ar_user IS NOT NULL
) AS token_event
LEFT JOIN ServerSideAccountCreation_5487345 ssac ON
    ssac.wiki = token_event.wiki AND
    ssac.event_userId = token_event.user_id
GROUP BY 1,2,3;
