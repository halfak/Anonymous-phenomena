source("util.R")
source("env.R")

load_anon_token_activity = tsv_loader(
	paste(DATA_DIR, "anon_token_activity.tsv", sep="/"),
	"ANON_TOKEN_ACTIVITY"
)

