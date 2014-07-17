source("loader/token_class_events.R")

class_events = load_token_class_events()

class.registration_rate = class_events[
	editor_class == "experiment user" |
	editor_class == "pure anon",
	list(
		k = sum(tokens[editor_class == "experiment user"]),
		n = sum(tokens)
	),
	list(wiki, bucket)
]
class.registration_rate$prop = with(
	class.registration_rate,
	k/n
)
class.registration_rate$se = with(
	class.registration_rate,
	sqrt(prop*(1-prop)/n)
)

svg("registrations/plots/registration_rate.svg", height=5, width=7)
ggplot(
	class.registration_rate,
	aes(
		x = bucket,
		y = prop
	)
) +
geom_point() +
geom_errorbar(aes(ymin=prop-se, ymax=prop+se), width=0.5) +
facet_wrap(~ wiki, nrow=1) +
theme_bw() +
scale_y_continuous(
	"Registration rate",
	limit=c(0, max(class.registration_rate$prop + class.registration_rate$se))
) +
theme(
	axis.text.x = element_text(angle = 45, hjust = 1)
)
dev.off()

edit_link.registration_rate = class_events[
	editor_class == "experiment user" |
	editor_class == "pure anon",
	list(
		k = sum(edit_click_tokens[editor_class == "experiment user"]),
		n = sum(edit_click_tokens)
	),
	list(wiki, bucket)
]
edit_link.registration_rate$prop = with(
	edit_link.registration_rate,
	k/n
)
edit_link.registration_rate$se = with(
	edit_link.registration_rate,
	sqrt(prop*(1-prop)/n)
)

svg("registrations/plots/registration_rate.edit_link.by_condition.svg", height=4, width=7)
ggplot(
	edit_link.registration_rate,
	aes(
		x = bucket,
		y = prop
	)
) +
geom_point() +
geom_errorbar(aes(ymin=prop-se, ymax=prop+se), width=0.25) +
facet_wrap(~ wiki, nrow=1) +
theme_bw() +
scale_y_continuous(
	"Registration rate\n",
	limit=c(0, max(edit_link.registration_rate$prop + edit_link.registration_rate$se))
) +
scale_x_discrete("\nExperimental buckets") +
theme(
	axis.text.x = element_text(angle = 45, hjust = 1)
)
dev.off()

diff_stats = edit_link.registration_rate[,
	list(
		baseline_rate = round((prop[bucket=="control"]) * 100, 3),
		baseline_n_estimate = k[bucket=="control"]*(62/22),
		pre_rate = round(prop[bucket=="pre-edit"] * 100, 3),
		pre_diff = round((prop[bucket=="pre-edit"] - prop[bucket=="control"]) * 100, 3),
		post_rate = round(prop[bucket=="post-edit"] * 100, 3),
		post_diff = round((prop[bucket=="post-edit"] - prop[bucket=="control"]) * 100, 3),
		pre_factor_diff = round((prop[bucket=="pre-edit"]/prop[bucket=="control"]) * 100, 1),
		pre_factor_n = (prop[bucket=="pre-edit"]/prop[bucket=="control"]) * k[bucket=="control"]*(62/22),
		post_factor_diff = round((prop[bucket=="post-edit"]/prop[bucket=="control"]) * 100, 1),
		pre_factor_n = (prop[bucket=="post-edit"]/prop[bucket=="control"]) * k[bucket=="control"]*(62/22)
	),
	wiki
]
wiki.table(diff_stats)
