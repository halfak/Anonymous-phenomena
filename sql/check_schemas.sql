SET @token = "TcjQiedcb6GJF0RzzkB8MoWoqPkKS5dR";
SELECT * FROM (
    SELECT timestamp, "button click" as event, CONCAT(event_namespace, ": ", event_button) AS details 
    FROM SignupExpCTAButtonClick_8102619 WHERE timestamp > "20140514" AND event_token = @token
    UNION
    SELECT timestamp, "CTA impression" as event, CONCAT(event_namespace, ": ", event_cta) AS details 
    FROM SignupExpCTAImpression_8101716 WHERE timestamp > "20140514" AND event_token = @token
    UNION
    SELECT timestamp, "page link click" as event, CONCAT(event_namespace, ": ", event_link) AS details
    FROM SignupExpPageLinkClick_8101692 WHERE timestamp > "20140514" AND event_token = @token
    UNION
    SELECT tracked.timestamp, "edit" as event, CONCAT(event_revId, ": ", event_revId) AS details
    FROM TrackedPageContentSaveComplete_7872558 tracked
    INNER JOIN PageContentSaveComplete_5588433 complete ON
        complete.event_revisionId = tracked.event_revId AND
        tracked.wiki = complete.wiki
    WHERE tracked.timestamp > "20140514" AND event_token = @token
) AS events
ORDER BY timestamp;
