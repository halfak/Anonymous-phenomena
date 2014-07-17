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
g = ggplot(
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
print(g)
dev.off()
png("event_tokens/plots/event_and_token_prop.by_brower_family.png",
    height=1024,
    width=1280,
    res=200)
print(g)
dev.off()


ie_events.by_version = events[browser_family == "IE",
	list(
		n = length(tokened),
		tokened = sum(tokened),
		prop = sum(tokened)/length(tokened)
	),
	list(browser_version_major)
]


svg("event_tokens/plots/IE_event_and_token_prop.by_major_version.svg")
g = ggplot(
	rbind(
		ie_events.by_version[n > 100,list(prop, browser_version_major, group="token'd prop"),],
		ie_events.by_version[n > 100,list(prop = n/length(events$tokened), browser_version_major, group="event prop"),]
	),
	aes(
		x = browser_version_major,
		y = prop
	)
) + 
geom_bar(stat="identity", color="#000000", fill="#CCCCCC") +
facet_wrap(~ group, ncol=1) + 
theme_bw() +
theme(
	axis.text.x = element_text(angle = 45, hjust = 1)
)
print(g)
dev.off()
png("event_tokens/plots/IEevent_and_token_prop.by_major_version.png",
    height=1024,
    width=1280,
    res=200)
print(g)
dev.off()
