DROP TABLE IF EXISTS staging.token_stats;
CREATE TABLE staging.token_stats (
    wiki                     VARCHAR(191),
    token                    VARCHAR(255),
    first_event              VARBINARY(14),
    revisions                INT,
    account_creations        INT,
    creation_impressions     INT,
    button_clicks            INT,
    cta_impressions          INT,
    link_clicks              INT,
    edit_link_clicks         INT,
    registration_link_clicks INT,
    total_events             INT,
    PRIMARY KEY(wiki, token)
);