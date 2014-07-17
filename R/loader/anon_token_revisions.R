source("util.R")
source("env.R")

load_anon_token_revisions = tsv_loader(
	paste(DATA_DIR, "anon_token_revisions.with_revert.tsv", sep="/"),
	"ANON_TOKEN_REVISIONS",
	function(dt){
		reverted = dt$reverted == "True"
		archived = dt$archived == "True"
		
		dt$reverted = NULL
		dt$reverted = reverted
		dt$archived = NULL
		dt$archived = archived
		
		dt
	}
)
