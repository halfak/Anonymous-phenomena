
conn_user = --defaults-file=~/.my.research.cnf -u research

dbstore = $(conn_user) -h analytics-store.eqiad.wmnet
staging = $(conn_user) -h s1-analytics-slave.eqiad.wmnet

start_date_1 = \"20140519180800\"
end_date_1 = \"20140526180800\"

start_date_2 = \"20140710000000\"
end_date_2 = \"20140717000000\"

datasets/tables/study_1/user_tokens.create_load: sql/tables/user_tokens.create_load.sql
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/tables/user_tokens.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_1/user_tokens.create_load

datasets/tables/study_2/user_tokens.create_load: sql/tables/user_tokens.create_load.sql
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/tables/user_tokens.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_2/user_tokens.create_load

datasets/tables/study_1/token_stats.loaded: sql/tables/token_stats.create_load.sql
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/tables/token_stats.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_1/token_stats.loaded

datasets/tables/study_2/token_stats.loaded: sql/tables/token_stats.create_load.sql
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/tables/token_stats.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_2/token_stats.loaded


datasets/tables/study_1/token_info.loaded: sql/tables/token_info.create_load.sql \
                                           datasets/tables/study_1/token_stats.loaded \
                                           datasets/tables/study_1/user_tokens.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/tables/token_info.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_1/token_info.loaded


datasets/tables/study_2/token_info.loaded: sql/tables/token_info.create_load.sql \
                                           datasets/tables/study_2/token_stats.loaded \
                                           datasets/tables/study_2/user_tokens.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/tables/token_info.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_2/token_info.loaded

datasets/study_1/token_class_events.tsv: sql/token_class_events.sql \
                                         datasets/tables/study_1/token_info.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/token_class_events.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/token_class_events.tsv

datasets/study_2/token_class_events.tsv: sql/token_class_events.sql \
                                         datasets/tables/study_2/token_info.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/token_class_events.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/token_class_events.tsv


datasets/tables/study_1/token_flow_start.loaded: sql/tables/study_1/token_flow_start.create_load.sql
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/tables/token_flow_start.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_1/token_flow_start.loaded


datasets/tables/study_2/token_flow_start.loaded: sql/tables/study_2/token_flow_start.create_load.sql
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/tables/token_flow_start.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_2/token_flow_start.loaded

datasets/study_1/token_flows.tsv: sql/token_flows.sql \
                                  datasets/tables/study_1/token_flow_start.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/token_flows.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/token_flows.tsv

datasets/study_2/token_flows.tsv: sql/token_flows.sql \
                                  datasets/tables/study_2/token_flow_start.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/token_flows.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/token_flows.tsv

datasets/study_1/experimental_users.tsv: sql/study_1/experimental_users.sql \
										datasets/tables/study_1/token_info.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - cat sql/experimental_users.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/experimental_users.tsv

datasets/study_2/experimental_users.tsv: sql/study_2/experimental_users.sql \
										datasets/tables/study_2/token_info.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - cat sql/experimental_users.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/experimental_users.tsv

datasets/study_1/experimental_user_stats.tsv: datasets/study_1/experimental_users.tsv \
											anon/new_user_stats.py
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - cat datasets/study_1/experimental_users.tsv | \
	./new_user_stats $(conn_user) > \
	datasets/study_1/experimental_user_stats.tsv

datasets/study_2/experimental_user_stats.tsv: datasets/study_2/experimental_users.tsv \
											anon/new_user_stats.py
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - cat datasets/study_2/experimental_users.tsv | \
	./new_user_stats $(conn_user) > \
	datasets/study_2/experimental_user_stats.tsv

datasets/tables/experimental_user_stats.created: sql/tables/experimental_user_stats.create.sql
	cat sql/tables/experimental_user_stats.create.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/experimental_user_stats.created

datasets/tables/study_1/experimental_user_stats.loaded: datasets/tables/experimental_user_stats.created \
														datasets/study_1/experimental_user_stats.tsv
	mysql $(dbstore) -e \
	"DELETE FROM staging.experimental_user_stats WHERE first_event BETWEEN $(start_date_1) AND $(end_date_1);" | \
	ln -sf experimental_user_stats.tsv datasets/study_1/experimental_user_stats && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/study_1/experimental_user_stats && \
	rm datasets/study_1/experimental_user_stats && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.experimental_user_stats;" > \
	datasets/tables/study_1/experimental_user_stats.loaded

datasets/tables/study_2/experimental_user_stats.loaded: datasets/tables/experimental_user_stats.created \
														datasets/study_2/experimental_user_stats.tsv
	mysql $(dbstore) -e \
	"DELETE FROM staging.experimental_user_stats WHERE first_event BETWEEN $(start_date_2) AND $(end_date_2);" | \
	ln -sf experimental_user_stats.tsv datasets/study_2/experimental_user_stats && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/study_2/experimental_user_stats && \
	rm datasets/study_2/experimental_user_stats && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.experimental_user_stats;" > \
	datasets/tables/study_2/experimental_user_stats.loaded

datasets/tables/study_1/token_revisions.loaded: sql/tables/token_revisions.create_load.sql \
												datasets/tables/study_1/token_info.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/tables/study_1/token_revisions.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_1/token_revisions.loaded

datasets/tables/study_2/token_revisions.loaded: sql/tables/token_revisions.create_load.sql \
												datasets/tables/study_2/token_info.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/tables/study_2/token_revisions.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/study_2/token_revisions.loaded

datasets/study_1/anon_token_activity.tsv: sql/anon_token_activity.sql \
								datasets/tables/study_1/token_info.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/anon_token_activity.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/anon_token_activity.tsv

datasets/study_2/anon_token_activity.tsv: sql/anon_token_activity.sql \
								datasets/tables/study_2/token_info.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/anon_token_activity.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/anon_token_activity.tsv


datasets/study_1/anon_token_revisions.tsv: sql/anon_token_revisions.sql \
							datasets/tables/study_1/token_revisions.loaded \
							datasets/tables/study_1/token_info.loaded
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/anon_token_revisions.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/anon_token_revisions.tsv
	
datasets/study_2/anon_token_revisions.tsv: sql/anon_token_revisions.sql \
								datasets/tables/study_2/token_revisions.loaded \
								datasets/tables/study_2/token_info.loaded
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/anon_token_revisions.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/anon_token_revisions.tsv

datasets/study_1/anon_token_revisions.with_revert.tsv: datasets/study_1/anon_token_revisions.tsv
	cat datasets/study_1/anon_token_revisions.tsv | \
	./revision_status >
	datasets/study_1/anon_token_revisions.with_revert.tsv

datasets/study_2/anon_token_revisions.with_revert.tsv: datasets/study_2/anon_token_revisions.tsv
	cat datasets/study_2/anon_token_revisions.tsv | \
	./revision_status >
	datasets/study_2/anon_token_revisions.with_revert.tsv

datasets/study_1/blocked_tokens.tsv: sql/blocked_tokens.sql
	echo "SET @start_date = $(start_date_1), @end_date = $(end_date_1);" | \
	cat - sql/blocked_tokens.sql | \
	mysql $(dbstore) staging > \
	datasets/study_1/blocked_tokens.tsv

datasets/study_2/blocked_tokens.tsv: sql/blocked_tokens.sql
	echo "SET @start_date = $(start_date_2), @end_date = $(end_date_2);" | \
	cat - sql/blocked_tokens.sql | \
	mysql $(dbstore) staging > \
	datasets/study_2/blocked_tokens.tsv
