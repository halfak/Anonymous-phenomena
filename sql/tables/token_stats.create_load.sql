DROP TABLE IF EXISTS staging.token_stats;
CREATE TABLE staging.token_stats
ENGINE = InnoDB
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
    COUNT(event) AS total_events
FROM (
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      "revision" AS event
    FROM log.TrackedPageContentSaveComplete_8535426
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      "revision" AS event
    FROM log.TrackedPageContentSaveComplete_7872558
    WHERE wiki IN  ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      "creation complete" AS event
    FROM log.SignupExpAccountCreationComplete_8539421
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      "creation impression" AS event
    FROM log.SignupExpAccountCreationImpression_8539445
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      CONCAT("button click ", event_button) AS event
    FROM log.SignupExpCTAButtonClick_8102619
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      CONCAT("CTA impression ", event_cta) AS event
    FROM log.SignupExpCTAImpression_8101716
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
  UNION ALL
    SELECT
      wiki,
      event_token AS token,
      timestamp,
      CONCAT("link click ", event_link) AS event
    FROM log.SignupExpPageLinkClick_8101692
    WHERE wiki IN ("enwiki", "dewiki", "itwiki", "frwiki")
    AND event_token IS NOT NULL
) AS token_events
GROUP BY 1,2;
ALTER TABLE staging.token_stats MODIFY wiki VARCHAR(32);
ALTER TABLE staging.token_stats MODIFY token VARCHAR(32);
CREATE UNIQUE INDEX wiki_token ON staging.token_stats (wiki, token);
SELECT COUNT(*), NOW() FROM staging.token_stats;