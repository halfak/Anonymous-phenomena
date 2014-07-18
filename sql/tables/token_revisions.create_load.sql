CREATE TABLE IF NOT EXISTS staging.token_revision (
    wiki  VARCHAR(50),
    token VARCHAR(50),
    timestamp VARBINARY(14),
    rev_id INT,
    PRIMARY KEY(wiki, rev_id),
    KEY(wiki, token)
);


DELETE FROM staging.token_revision
WHERE timestamp BETWEEN @start_date AND @end_date;

SELECT
    wiki,
    event_token as token,
    timestamp,
    event_revId as rev_id
FROM log.TrackedPageContentSaveComplete_8535426
WHERE timestamp BETWEEN @start_date AND @end_date
UNION
SELECT
    wiki,
    event_token as token,
    timestamp,
    event_revId as rev_id
FROM log.TrackedPageContentSaveComplete_7872558
WHERE timestamp BETWEEN @start_date AND @end_date;

SELECT COUNT(*), NOW() FROM staging.token_revision;
