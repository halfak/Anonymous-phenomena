CREATE TABLE staging.user_token (
    wiki              VARCHAR(191),
    user_id           INT,
    registration      VARBINARY(14),
    token             VARCHAR(255),
    account_creations INT,
    revisions         INT,
    total_events      INT,
    PRIMARY KEY(wiki, user_id, token)
);
CREATE INDEX wiki_token ON staging.user_token (wiki, token);
