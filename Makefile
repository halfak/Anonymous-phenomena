
conn_user = --defaults-file=~/.my.research.cnf -u research

s1 = $(conn_user) -h s1-analytics-slave.eqiad.wmnet
s2 = $(conn_user) -h s2-analytics-slave.eqiad.wmnet
s3 = $(conn_user) -h s3-analytics-slave.eqiad.wmnet
s4 = $(conn_user) -h s4-analytics-slave.eqiad.wmnet
s5 = $(conn_user) -h s5-analytics-slave.eqiad.wmnet
s6 = $(conn_user) -h s6-analytics-slave.eqiad.wmnet
s7 = $(conn_user) -h s7-analytics-slave.eqiad.wmnet
dbstore = $(conn_user) -h analytics-store.eqiad.wmnet
staging = $(conn_user) -h s1-analytics-slave.eqiad.wmnet

start_date = 20140519180800
end_date = 20140526180800

datasets/user_tokens.tsv: sql/user_tokens.sql
	cat sql/user_tokens.sql | \
	mysql $(dbstore) log > \
	datasets/user_tokens.tsv

datasets/tables/user_tokens.created: sql/tables/user_tokens.create.sql
	cat sql/tables/user_tokens.create.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/user_tokens.created

datasets/tables/user_tokens.loaded: datasets/tables/user_tokens.created \
                                    datasets/user_tokens.tsv
	mysql $(dbstore) -e "TRUNCATE TABLE staging.user_token;" | \
	ln -sf user_tokens.tsv datasets/user_token && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/user_token && \
	rm datasets/user_token && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.user_token;" > \
	datasets/tables/user_tokens.loaded


datasets/tables/token_stats.loaded: sql/tables/token_stats.create_load.sql
	cat sql/tables/token_stats.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/token_stats.loaded


datasets/tables/token_info.loaded: sql/tables/token_info.create_load.sql \
                                   datasets/tables/token_stats.loaded \
                                   datasets/tables/user_tokens.loaded
	cat sql/tables/token_info.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/token_info.loaded

datasets/token_class_events.tsv: sql/token_class_events.sql \
                                 datasets/tables/token_info.loaded
	cat sql/token_class_events.sql | \
	mysql $(dbstore) staging > \
	datasets/token_class_events.tsv


datasets/tables/token_flow_start.loaded: sql/tables/token_flow_start.create_load.sql
	cat sql/tables/token_flow_start.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/token_flow_start.loaded

datasets/token_flows.tsv: sql/token_flows.sql \
                                      datasets/tables/token_flow_start.loaded
	cat sql/token_flows.sql | \
	mysql $(dbstore) staging > \
	datasets/token_flows.tsv

datasets/experimental_users.tsv: sql/experimental_users.sql \
                                 datasets/tables/token_info.loaded
	cat sql/experimental_users.sql | \
	mysql $(dbstore) staging > \
	datasets/experimental_users.tsv

#datasets/experimental_user_stats.tsv: datasets/experimental_users.tsv \
#                                      anon/new_user_stats.py
#	cat datasets/experimental_users.tsv | \
#	./new_user_stats $(conn_user) > \
#	datasets/experimental_user_stats.tsv

datasets/tables/experimental_user_stats.created: sql/tables/experimental_user_stats.create.sql
	cat sql/tables/experimental_user_stats.create.sql | \
        mysql $(dbstore) staging > \
        datasets/tables/experimental_user_stats.created

datasets/tables/experimental_user_stats.loaded: datasets/tables/experimental_user_stats.created \
                                                datasets/experimental_user_stats.tsv
	mysql $(dbstore) -e "TRUNCATE TABLE staging.experimental_user_stats;" | \
	ln -sf experimental_user_stats.tsv datasets/experimental_user_stats && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/experimental_user_stats && \
	rm datasets/experimental_user_stats && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.experimental_user_stats;" > \
	datasets/tables/experimental_user_stats.loaded

datasets/tables/token_revisions.loaded: sql/tables/token_revisions.create_load.sql \
                                        datasets/tables/token_info.loaded
	cat sql/tables/token_revisions.create_load.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/token_revisions.loaded

datasets/anon_token_activity.tsv: sql/anon_token_activity.sql \
                                  datasets/tables/token_info.loaded
	cat sql/anon_token_activity.sql | \
	mysql $(dbstore) staging > \
	datasets/anon_token_activity.tsv

datasets/anon_token_revisions.tsv: sql/anon_token_revisions.sql \
                                   datasets/tables/token_revisions.loaded \
                                   datasets/tables/token_info.loaded
	cat sql/anon_token_revisions.sql | \
	mysql $(dbstore) staging > \
	datasets/anon_token_revisions.tsv

datasets/blocked_tokens.tsv: sql/blocked_tokens.sql
	cat sql/blocked_tokens.sql | \
	mysql $(dbstore) staging > \
	datasets/blocked_tokens.tsv
