DROP TABLE IF EXISTS staging.token_revision;
CREATE TABLE staging.token_revision

SELECT
    wiki,
    event_token as token,
    timestamp,
    event_revId as rev_id
FROM log.TrackedPageContentSaveComplete_8535426
UNION
SELECT
    wiki,
    event_token as token,
    timestamp,
    event_revId as rev_id
FROM log.TrackedPageContentSaveComplete_7872558;

ALTER TABLE staging.token_revision MODIFY wiki VARCHAR(50);
CREATE INDEX wiki_token ON staging.token_revision (wiki, token);
CREATE UNIQUE INDEX wiki_rev ON staging.token_revision (wiki, rev_id);
SELECT COUNT(*), NOW() FROM staging.token_revision; 