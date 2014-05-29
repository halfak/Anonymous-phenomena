source("util.R")
source("env.R")

load_sampled_events = tsv_loader(
	paste(DATA_DIR, "sampled_events.tsv", sep="/"),
	"SAMPLED_EVENTS"
)
