source("loader/anon_token_activity.R")

token_activity = load_anon_token_activity(reload=T)

svg("activity/plots/revisions_density.by_experiment.svg", height=15, width=7)
ggplot(
	token_activity,
	aes(
		x = experimental_revisions+1,
		group = bucket,
		fill = bucket
	)
) + 
geom_density(alpha = 0.2, size=0, adjust=3, bw="SJ") +
geom_line(aes(y = ..density..), stat="density", adjust=3, size=0.2, bw="SJ") + 
facet_wrap(~ wiki, ncol=1) + 
scale_x_log10("Revisions saved.", breaks=c(1, 2, 4, 10, 20, 40, 100, 1000)) + 
theme_bw()
dev.off()


token_activity.stats = token_activity[,
	list(
		revs.geo_mean = geo.mean.plus.one(experimental_revisions),
		revs.geo_se.upper = geo.se.upper.plus.one(experimental_revisions),
		revs.geo_se.lower = geo.se.lower.plus.one(experimental_revisions),
		editing.k = sum(experimental_revisions > 0),
		editing.prop = sum(experimental_revisions > 0)/length(experimental_revisions),
		n = length(experimental_revisions)
	),
	list(
		wiki,
		bucket
	)
]
token_activity.stats$editing.se = with(
	token_activity.stats,
	sqrt(editing.prop*(1-editing.prop)/n)
)

svg("activity/plots/revisions_geo_mean.by_experiment.svg", height=4, width=7)
ggplot(
	token_activity.stats,
	aes(
		x = bucket,
		y = revs.geo_mean
	)
) + 
geom_point() + 
geom_errorbar(
	aes(
		ymax=revs.geo_se.upper,
		ymin=revs.geo_se.lower
	),
	width=0.25
) + 
facet_wrap(~ wiki, nrow=1) +
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Revisions (geometric mean)\n") + 
scale_x_discrete("\nCondition")
dev.off()

svg("activity/plots/edit_completed_prop.by_experiment.svg", height=4, width=7)
ggplot(
	token_activity.stats,
	aes(
		x = bucket,
		y = editing.prop
	)
) + 
geom_point() + 
geom_errorbar(
	aes(
		ymax=editing.prop + editing.se,
		ymin=editing.prop - editing.se
	),
	width=0.25
) + 
facet_wrap(~ wiki, nrow=1) +
theme_bw() + 
theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
scale_y_continuous("Proportion of completed edits\n") + 
scale_x_discrete("\nCondition")
dev.off()

svg("activity/plots/cta_impressions_histogram.by_experiment.svg", height=5, width=7)
ggplot(
	token_activity[bucket != "control" & cta_impressions > 0,],
	aes(
		x = cta_impressions
	)
) + 
geom_histogram() + 
facet_wrap(~ bucket) + 
scale_x_log10(breaks=c(1, 2, 3, 4, 5, 10, 100)) + 
theme_bw()
dev.off()
