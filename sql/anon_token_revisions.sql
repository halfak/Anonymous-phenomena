SELECT
    wiki,
    token,
    rev_id,
    page_id,
    page_namespace
FROM token_revision
INNER JOIN token_info USING (wiki, token)
INNER JOIN enwiki.revision USING (rev_id)
INNER JOIN enwiki.page ON page_id = rev_page
WHERE
    wiki = "enwiki" AND
    (first_user_id IS NULL OR first_user_registration > @start_date) AND 
    edit_link_clicks > 0 AND
    timestamp BETWEEN @start_date AND @end_date
UNION ALL
SELECT
    wiki,
    token,
    rev_id,
    page_id,
    page_namespace
FROM token_revision
INNER JOIN token_info USING (wiki, token)
INNER JOIN dewiki.revision USING (rev_id)
INNER JOIN dewiki.page ON page_id = rev_page
WHERE
    wiki = "dewiki" AND
    (first_user_id IS NULL OR first_user_registration > @start_date) AND
    edit_link_clicks > 0 AND
    timestamp BETWEEN @start_date AND @end_date
UNION ALL
SELECT
    wiki,
    token,
    rev_id,
    page_id,
    page_namespace
FROM token_revision
INNER JOIN token_info USING (wiki, token)
INNER JOIN itwiki.revision USING (rev_id)
INNER JOIN itwiki.page ON page_id = rev_page
WHERE
    wiki = "itwiki" AND
    (first_user_id IS NULL OR first_user_registration > @start_date) AND
    edit_link_clicks > 0 AND
    timestamp BETWEEN @start_date AND @end_date
UNION ALL
SELECT
    wiki,
    token,
    rev_id,
    page_id,
    page_namespace
FROM token_revision
INNER JOIN token_info USING (wiki, token)
INNER JOIN frwiki.revision USING (rev_id)
INNER JOIN frwiki.page ON page_id = rev_page
WHERE
    wiki = "frwiki" AND
    (first_user_id IS NULL OR first_user_registration > @start_date) AND
    edit_link_clicks > 0 AND
    timestamp BETWEEN @start_date AND @end_date;
