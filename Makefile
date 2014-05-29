
s1 = --defaults-file=~/.my.research.cnf -h s1-analytics-slave.eqiad.wmnet -u research
s2 = --defaults-file=~/.my.research.cnf -h s2-analytics-slave.eqiad.wmnet -u research
s3 = --defaults-file=~/.my.research.cnf -h s3-analytics-slave.eqiad.wmnet -u research
s4 = --defaults-file=~/.my.research.cnf -h s4-analytics-slave.eqiad.wmnet -u research
s5 = --defaults-file=~/.my.research.cnf -h s5-analytics-slave.eqiad.wmnet -u research
s6 = --defaults-file=~/.my.research.cnf -h s6-analytics-slave.eqiad.wmnet -u research
s7 = --defaults-file=~/.my.research.cnf -h s7-analytics-slave.eqiad.wmnet -u research
dbstore = --defaults-file=~/.my.research.cnf -h dbstore1001.eqiad.wmnet -u research
staging = --defaults-file=~/.my.research.cnf -h s1-analytics-slave.eqiad.wmnet -u research

start_date = 20140519180800
end_date = 20140526180800

datasets/user_tokens.tsv: sql/user_tokens.sql
	cat sql/user_tokens.sql | \
	mysql $(dbstore) log > \
	datasets/user_tokens.tsv

datasets/tables/user_tokens.created: sql/tables/user_tokens.create.sql
	cat sql/tables/user_tokens.create.sql | \
	mysql $(staging) staging > \
	datasets/tables/user_tokens.created

datasets/tables/user_tokens.loaded: datasets/tables/user_tokens.created \
                                  datasets/user_tokens.tsv
	mysql $(staging) -e "TRUNCATE TABLE staging.user_token;" | \
	ln -sf user_tokens.tsv datasets/user_token && \
	mysqlimport $(staging) --local --ignore-lines=1 staging datasets/user_token && \
	rm datasets/user_token && \
	mysql $(staging) -e "SELECT COUNT(*), NOW() FROM staging.user_token;" > \
	datasets/tables/user_tokens.loaded

datasets/token_stats.tsv: sql/token_stats.sql
	cat sql/token_stats.sql | \
	mysql $(dbstore) log > \
	datasets/token_stats.tsv

datasets/tables/token_stats.created: sql/tables/token_stats.create.sql
	cat sql/tables/token_stats.create.sql | \
	mysql $(staging) staging > \
	datasets/tables/token_stats.created

datasets/tables/token_stats.loaded: datasets/tables/token_stats.created \
                                    datasets/token_stats.tsv
	mysql $(staging) -e "TRUNCATE TABLE staging.token_stats;" && \
	ln -sf token_stats.tsv datasets/token_stats && \
	mysqlimport $(staging) --local --ignore-lines=1 staging datasets/token_stats && \
	rm datasets/token_stats && \
	mysql $(staging) -e "SELECT COUNT(*), NOW() FROM staging.token_stats;" > \
	datasets/tables/token_stats.loaded


datasets/tables/token_info.loaded: sql/tables/token_info.create_load.sql \
                                   datasets/tables/token_stats.loaded \
                                   datasets/tables/user_tokens.loaded
	cat sql/tables/token_info.create_load.sql | \
	mysql $(staging) staging > \
	datasets/tables/token_info.loaded
