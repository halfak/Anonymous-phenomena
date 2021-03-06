CREATE TEMPORARY TABLE staging.experimental_wiki_token_events
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
    AND event_token IS NOT NULL;
ALTER TABLE staging.experimental_wiki_token_events MODIFY wiki VARCHAR(50);
CREATE INDEX wiki_token_time ON staging.experimental_wiki_token_events (wiki, token, timestamp);

SELECT
    tfs.wiki,
    tfs.token,
    tfs.timestamp AS flow_start,
    MAX(ewte.timestamp) AS last_event,
    MIN(IF(ewte.event = "link click edit section", ewte.timestamp, NULL)) AS first_edit_section_click,
    MIN(IF(ewte.event = "link click edit page", ewte.timestamp, NULL)) AS first_edit_page_click,
    MIN(IF(ewte.event = "link click create account", ewte.timestamp, NULL)) AS first_create_account_click,
    MIN(IF(ewte.event = "CTA impression pre-edit", ewte.timestamp, NULL)) AS first_pre_edit_cta_impression,
    MIN(IF(ewte.event = "CTA impression post-edit", ewte.timestamp, NULL)) AS first_post_edit_cta_impression,
    MIN(IF(ewte.event = "button click edit", ewte.timestamp, NULL)) AS first_edit_button_click,
    MIN(IF(ewte.event = "button click signup", ewte.timestamp, NULL)) AS first_signup_button_click,
    MIN(IF(ewte.event = "button click dismiss", ewte.timestamp, NULL)) AS first_dismiss_button_click,
    MIN(IF(ewte.event = "creation impression", ewte.timestamp, NULL)) AS first_account_creation_impression,
    MIN(IF(ewte.event = "creation complete", ewte.timestamp, NULL)) AS first_account_creation_complete,
    MIN(IF(ewte.event = "revision", ewte.timestamp, NULL)) AS first_revision_saved,
    SUM(ewte.event = "revision") AS revisions
FROM staging.token_flow_start tfs
LEFT JOIN staging.experimental_wiki_token_events ewte ON 
    tfs.wiki = ewte.wiki AND
    tfs.token = ewte.token AND
    ewte.timestamp BETWEEN 
        tfs.timestamp AND 
        IFNULL(next_flow_start, DATE_FORMAT(DATE_ADD(ewte.timestamp, INTERVAL 10 MINUTE), "%Y%m%d%H%i%S"));