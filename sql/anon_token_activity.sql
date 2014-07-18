SELECT
    token_info.*,
    IFNULL(experimental_revisions, 0) as experimental_revisions
FROM token_info
LEFT JOIN (
    SELECT
        wiki,
        token,
        COUNT(rev_id) AS experimental_revisions
    FROM staging.token_revision
    WHERE timestamp BETWEEN @start_date AND @end_date
    GROUP BY wiki, token
) AS token_revision_count USING (wiki, token)
WHERE (first_user_id IS NULL OR first_user_registration > @start_date)
AND edit_link_clicks > 0
