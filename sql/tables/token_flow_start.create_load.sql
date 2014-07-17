DROP TABLE IF EXISTS staging.token_flow_start;
CREATE TEMPORARY TABLE staging.token_edit_clicks
SELECT
    wiki,
    event_token AS token,
    timestamp
FROM log.SignupExpPageLinkClick_8101692
WHERE
    event_link LIKE "edit%" AND
    timestamp BETWEEN "20140519180800" AND "20140526180800";
ALTER TABLE staging.token_edit_clicks MODIFY wiki VARCHAR(50);
CREATE INDEX wiki_token ON staging.token_edit_clicks (wiki, token);

CREATE TEMPORARY TABLE staging.token_edit_clicks_copy
SELECT * FROM staging.token_edit_clicks;

CREATE TEMPORARY TABLE staging.token_flow_start_pre
SELECT
    tec.wiki,
    tec.token,
    tec.timestamp
FROM staging.token_edit_clicks_copy tec
LEFT JOIN staging.token_edit_clicks recent_clicks ON
    tec.wiki = recent_clicks.wiki AND
    tec.token = recent_clicks.token AND
    recent_clicks.timestamp BETWEEN 
        DATE_FORMAT(DATE_SUB(tec.timestamp, INTERVAL 5 MINUTE), "%Y%m%d%H%i%S") AND
        DATE_FORMAT(DATE_SUB(tec.timestamp, INTERVAL 1 SECOND), "%Y%m%d%H%i%S")
WHERE recent_clicks.token IS NULL;
CREATE INDEX wiki_token_pre ON staging.token_flow_start_pre (wiki, token);


CREATE TEMPORARY TABLE staging.token_flow_start_pre_copy
SELECT * FROM staging.token_flow_start_pre;

CREATE TABLE staging.token_flow_start
SELECT
    tfs.wiki,
    tfs.token,
    tfs.timestamp,
    MIN(next_flow.timestamp) AS next_flow_start
FROM staging.token_flow_start_pre_copy tfs
LEFT JOIN staging.token_flow_start_pre next_flow ON 
    tfs.wiki = next_flow.wiki AND
    tfs.token = next_flow.token AND
    next_flow.timestamp > tfs.timestamp
GROUP BY 1,2,3;
CREATE INDEX wiki_token ON staging.token_flow_start (wiki, token);

SELECT COUNT(*), NOW() FROM staging.token_flow_start;