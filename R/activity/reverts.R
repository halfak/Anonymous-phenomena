source("loader/anon_token_activity.R")
source("loader/anon_token_revisions.R")

token_activity = load_anon_token_activity(reload=T)
token_revisions = load_anon_token_revisions(reload=T)

sample.or_na = function(x, samples){
	if(length(x) == 0){
		NA
	}else{
		sample(x, samples)
	}
}

token_revision.stats = token_revisions[,
	list(
		revisions = length(rev_id),
		main_revisions = sum(page_namespace == 0),
		reverted_main_revisions = sum(page_namespace == 0 & reverted),
		sample_reverted = sample.or_na(reverted[page_namespace == 0], 1)
	),
	list(
		wiki,
		token
	)
]

merged_token_stats = merge(
	token_activity,
	token_revision.stats,
	by=c("wiki", "token"),
	all=T
)
merged_token_stats[is.na(revisions),]$revisions = 0
merged_token_stats[is.na(main_revisions),]$main_revisions = 0
merged_token_stats[is.na(reverted_main_revisions),]$reverted_main_revisions = 0
merged_token_stats$productive_edits = with(
	merged_token_stats,
	main_revisions - reverted_main_revisions
)


bucket_stats = merged_token_stats[,
	list(
		n = length(token),
		main_revisions.sum = sum(main_revisions),
		main_revisions.geo_mean = geo.mean.plus.one(main_revisions),
		main_revisions.geo_se.upper = geo.se.upper.plus.one(main_revisions),
		main_revisions.geo_se.lower = geo.se.lower.plus.one(main_revisions),
		productive_edits.geo_mean = geo.mean.plus.one(productive_edits),
		productive_edits.geo_se.upper = geo.se.upper.plus.one(productive_edits),
		productive_edits.geo_se.lower = geo.se.lower.plus.one(productive_edits),
		reverted_main_revisions.sum = sum(reverted_main_revisions),
		reverted_main_revisions.geo_mean = geo.mean.plus.one(reverted_main_revisions),
		reverted_main_revisions.geo_se.upper = geo.se.upper.plus.one(reverted_main_revisions),
		reverted_main_revisions.geo_se.lower = geo.se.lower.plus.one(reverted_main_revisions),
		productive.k = sum(productive_edits > 0),
		main_editor.k = sum(main_revisions > 0),
		sample_reverted.k = sum(sample_reverted, na.rm=T)
	),
	list(wiki, bucket)
]
bucket_stats$productive.prop = with(
	bucket_stats,
	productive.k/n
)
bucket_stats$productive.se = with(
	bucket_stats,
	sqrt(productive.prop*(1-productive.prop)/n)
)
bucket_stats$reverted_main_revision.prop = with(
	bucket_stats,
	reverted_main_revisions.sum/main_revisions.sum
)
bucket_stats$reverted_main_revision.se = with(
	bucket_stats,
	sqrt(reverted_main_revision.prop*(1-reverted_main_revision.prop)/main_revisions.sum)
)
bucket_stats$sample_reverted.prop = with(
	bucket_stats,
	sample_reverted.k/main_editor.k
)
bucket_stats$sample_reverted.se = with(
	bucket_stats,
	sqrt(sample_reverted.prop*(1-sample_reverted.prop)/main_editor.k)
)

svg("activity/plots/productive_prop.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = productive.prop
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(ymax=productive.prop+productive.se, ymin=productive.prop-productive.se),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Productive editor proportion\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

svg("activity/plots/productive_edits.geo_mean.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = productive_edits.geo_mean
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(ymax=productive_edits.geo_se.upper, ymin=productive_edits.geo_se.lower),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Productive edits (geometric mean)\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

svg("activity/plots/main_revisions.geo_mean.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = main_revisions.geo_mean
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(ymax=main_revisions.geo_se.upper, ymin=main_revisions.geo_se.lower),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Article edits (geometric mean)\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

svg("activity/plots/reverted_main_revisions.geo_mean.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = reverted_main_revisions.geo_mean
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(ymax=reverted_main_revisions.geo_se.upper, ymin=reverted_main_revisions.geo_se.lower),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Reverted article edits (geometric mean)\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

svg("activity/plots/reverted_main_revision_prop.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = reverted_main_revision.prop
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(
		ymax=reverted_main_revision.prop+reverted_main_revision.se, 
		ymin=reverted_main_revision.prop-reverted_main_revision.se
	),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Reverted article edit prop\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

svg("activity/plots/sample_reverted.prop.by_bucket.svg", height=4, width=7)
ggplot(
	bucket_stats,
	aes(
		x = bucket,
		y = sample_reverted.prop
	)
) + 
facet_wrap(~ wiki, nrow=1) + 
geom_point() + 
geom_errorbar(
	aes(
		ymax=sample_reverted.prop+sample_reverted.se, 
		ymin=sample_reverted.prop-sample_reverted.se
	),
	width=0.25
) + 
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Sampled revert prop\n") +
scale_x_discrete("\nExperimental buckets")
dev.off()

