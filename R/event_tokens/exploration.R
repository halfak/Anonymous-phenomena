source("loader/sampled_events.R")

events = load_sampled_events()

events.by_browser_family = events[,
	list(
		n = length(tokened),
		tokened = sum(tokened),
		prop = sum(tokened)/length(tokened)
	),
	list(browser_family)
]

svg("event_tokens/plots/event_and_token_prop.by_brower_family.svg")
ggplot(
	rbind(
		events.by_browser_family[n > 100,list(prop, browser_family, group="token'd prop"),],
		events.by_browser_family[n > 100,list(prop = n/length(events$tokened), browser_family, group="event prop"),]
	),
	aes(
		x = browser_family,
		y = prop
	)
) + 
geom_bar(stat="identity", color="#000000", fill="#CCCCCC") +
facet_wrap(~ group, ncol=1) + 
theme(
	axis.text.x = element_text(angle = 45, hjust = 1)
)
dev.off()
