source("util.R")
source("env.R")

convert_datetimes.token_flows = function(dt){
	cat("Converting datetimes: ")
	dt$first_event = wikits.as.POSIXct(dt$first_event)
	cat(".")
	dt$flow_start = wikits.as.POSIXct(dt$flow_start)
	cat(".")
	dt$first_user_registration = 
			wikits.as.POSIXct(dt$first_user_registration)
	cat(".")
	dt$first_edit_section_click = 
			wikits.as.POSIXct(dt$first_edit_section_click)
	cat(".")
	dt$first_edit_page_click = 
			wikits.as.POSIXct(dt$first_edit_page_click)
	cat(".")
	dt$first_create_account_click = 
			wikits.as.POSIXct(dt$first_create_account_click)
	cat(".")
	dt$first_pre_edit_cta_impression = 
			wikits.as.POSIXct(dt$first_pre_edit_cta_impression)
	cat(".")
	dt$first_post_edit_cta_impression = 
			wikits.as.POSIXct(dt$first_post_edit_cta_impression)
	cat(".")
	dt$first_edit_button_click = 
			wikits.as.POSIXct(dt$first_edit_button_click)
	cat(".")
	dt$first_signup_button_click = 
			wikits.as.POSIXct(dt$first_signup_button_click)
	cat(".")
	dt$first_dismiss_button_click = 
			wikits.as.POSIXct(dt$first_dismiss_button_click)
	cat(".")
	dt$first_account_creation_impression = 
			wikits.as.POSIXct(dt$first_account_creation_impression)
	cat(".")
	dt$first_account_creation_complete = 
			wikits.as.POSIXct(dt$first_account_creation_complete)
	cat(".")
	dt$first_revision_saved = 
			wikits.as.POSIXct(dt$first_revision_saved)
	cat(".")
	dt$last_event = wikits.as.POSIXct(dt$last_event)
	cat("\n")
	
	dt
}
load_token_flows = tsv_loader(
	paste(DATA_DIR, "token_flows.tsv", sep="/"),
	"TOKEN_FLOWS"
)
