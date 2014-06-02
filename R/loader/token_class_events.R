source("util.R")
source("env.R")

load_token_class_events = tsv_loader(
	paste(DATA_DIR, "token_class_events.tsv", sep="/"),
	"TOKEN_CLASS_EVENTS"
)
