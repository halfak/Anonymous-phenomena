CREATE TEMPORARY TABLE staging.tokened_editor
    SELECT
        "enwiki" AS wiki,
        IFNULL(rev_user_text, ar_user_text) AS user_text,
        event_token AS token
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
    WHERE (ar_rev_id IS NOT NULL OR rev_id IS NOT NULL)
UNION ALL
    SELECT
        "dewiki" AS wiki,
        IFNULL(rev_user_text, ar_user_text) AS user_text,
        event_token AS token
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
    WHERE (ar_rev_id IS NOT NULL OR rev_id IS NOT NULL)
UNION ALL
    SELECT
        "frwiki" AS wiki,
        IFNULL(rev_user_text, ar_user_text) AS user_text,
        event_token AS token
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
    WHERE (ar_rev_id IS NOT NULL OR rev_id IS NOT NULL)
UNION ALL
    SELECT
        "itwiki" AS wiki,
        IFNULL(rev_user_text, ar_user_text) AS user_text,
        event_token AS token
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
    WHERE (ar_rev_id IS NOT NULL OR rev_id IS NOT NULL);
CREATE INDEX wiki_idx ON staging.tokened_editor (wiki);


SELECT
    wiki, token, MIN(log_timestamp) AS first_block
FROM tokened_editor te
INNER JOIN enwiki.logging ON
    log_namespace = 2 AND
    log_title = REPLACE(" ", "_", user_text) AND
    log_type = "block" AND
    log_action = "block"
WHERE wiki = "enwiki"
GROUP BY 1,2

UNION ALL

SELECT
    wiki, token, MIN(log_timestamp) AS first_block
FROM tokened_editor te
INNER JOIN dewiki.logging ON
    log_namespace = 2 AND
    log_title = REPLACE(" ", "_", user_text) AND
    log_type = "block" AND
    log_action = "block"
WHERE wiki = "dewiki"
GROUP BY 1,2

UNION ALL

SELECT
    wiki, token, MIN(log_timestamp) AS first_block
FROM tokened_editor te
INNER JOIN frwiki.logging ON
    log_namespace = 2 AND
    log_title = REPLACE(" ", "_", user_text) AND
    log_type = "block" AND
    log_action = "block"
WHERE wiki = "frwiki"
GROUP BY 1,2

UNION ALL

SELECT
    wiki, token, MIN(log_timestamp) AS first_block
FROM tokened_editor te
INNER JOIN itwiki.logging ON
    log_namespace = 2 AND
    log_title = REPLACE(" ", "_", user_text) AND
    log_type = "block" AND
    log_action = "block"
WHERE wiki = "itwiki"
GROUP BY 1,2;
