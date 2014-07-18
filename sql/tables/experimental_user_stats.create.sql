CREATE TABLE staging.experimental_user_stats (
    wiki                         VARCHAR(50),
    bucket                       VARCHAR(15),
    first_event                  VARBINARY(14),
    user_id                      INT,
    user_registration            VARBINARY(14),
    day_revisions                INT,
    day_main_revisions           INT,
    day_reverted_main_revisions  INT,
    day_productive_edits         INT,
    week_revisions               INT,
    week_main_revisions          INT,
    week_reverted_main_revisions INT,
    week_sessions                INT,
    week_session_seconds         INT,
    week_productive_edits        INT
    PRIMARY KEY (wiki, user_id)
);
