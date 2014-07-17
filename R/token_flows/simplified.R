source("loader/token_flows.R")

flows = load_token_flows(reload=T)

dim(flows)
length(unique(flows$token))


flows[,
	list(
		n = length(token)
	),
	list(
		wiki
	)
]
#      wiki      n
# 1: dewiki 107935
# 2: enwiki 539982
# 3: frwiki  85553
# 4: itwiki  58392



flows[,
	list(
		n = length(token),
		edit_link = sum(first_edit_section_click == flow_start |
		                first_edit_page_click == flow_start, na.rm=T),
		pre_edit = sum((first_edit_section_click == flow_start |
		                first_edit_page_click == flow_start) &
		               !is.na(first_pre_edit_cta_impression), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n edit_link pre_edit
# 1: dewiki   control  38711     38711        0
# 2: dewiki post-edit  34783     34783        0
# 3: dewiki  pre-edit  34441     34441    32647
# 4: enwiki  pre-edit 178741    178741   173040
# 5: enwiki   control 189724    189724        1
# 6: enwiki post-edit 171517    171517        1
# 7: frwiki  pre-edit  28411     28411    27545
# 8: frwiki post-edit  27180     27180        1
# 9: frwiki   control  29962     29962        0
#10: itwiki  pre-edit  19405     19405    18778
#11: itwiki   control  20361     20361        0
#12: itwiki post-edit  18626     18626        0


flows[,
	list(
		n = sum((first_edit_section_click == flow_start |
		         first_edit_page_click == flow_start) &
		         !is.na(first_pre_edit_cta_impression), na.rm=T),
		edit_button = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   !is.na(first_edit_button_click), na.rm=T),
		signup_button = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   !is.na(first_signup_button_click), na.rm=T),
		dismiss_button = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   !is.na(first_dismiss_button_click), na.rm=T),
		edit_link = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   is.na(first_dismiss_button_click) &
		                   (edit_section_clicks + edit_page_clicks) > 1,
		                   na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n edit_button signup_button dismiss_button edit_link
# 1: dewiki   control      0           0             0              0         0
# 2: dewiki post-edit      0           0             0              0         0
# 3: dewiki  pre-edit  32647        5257          1746          16147      1349
# 4: enwiki  pre-edit 173040       32082         14288          78421     10384
# 5: enwiki   control      1           0             0              0         1
# 6: enwiki post-edit      1           0             0              0         0
# 7: frwiki  pre-edit  27545        4034          1854          13616      1643
# 8: frwiki post-edit      1           0             0              1         0
# 9: frwiki   control      0           0             0              0         0
#10: itwiki  pre-edit  18778        3272           874           8472      1274
#11: itwiki   control      0           0             0              0         0
#12: itwiki post-edit      0           0             0              0         0


flows[,
	list(
		ed_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   !is.na(first_edit_button_click) &
		                   revisions_saved > 0, na.rm=T),
		dis_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   !is.na(first_dismiss_button_click) &
		                   revisions_saved > 0, na.rm=T),
		el_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   is.na(first_dismiss_button_click) &
		                   (edit_section_clicks + edit_page_clicks) > 1 &
		                   revisions_saved > 0,
		                   na.rm=T),
		sig_reg = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   !is.na(first_signup_button_click) &
		                   !is.na(first_account_creation_complete), na.rm=T),
		sig_reg_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   !is.na(first_signup_button_click) &
		                   !is.na(first_account_creation_complete) &
		                   revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket edit_edit dismiss_edit el_edit signup_acc sig_acc_edit
# 1: dewiki   control         0            0       0          0            0
# 2: dewiki post-edit         0            0       0          0            0
# 3: dewiki  pre-edit      1749          531     254        307          189
# 4: enwiki  pre-edit     15961         4673    3954       3872         2510
# 5: enwiki   control         0            0       1          0            0
# 6: enwiki post-edit         0            0       0          0            0
# 7: frwiki  pre-edit      2175         1096     556        496          355
# 8: frwiki post-edit         0            1       0          0            0
# 9: frwiki   control         0            0       0          0            0
#10: itwiki  pre-edit      1872          801     442        264          199
#11: itwiki   control         0            0       0          0            0
#12: itwiki post-edit         0            0       0          0            0

flows[,
	list(
		other_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   !is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   revisions_saved > 0, na.rm=T),
		no_cta_edit = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   is.na(first_post_edit_cta_impression) &
		                   is.na(first_pre_edit_cta_impression) &
		                   is.na(first_edit_button_click) &
		                   is.na(first_signup_button_click) &
		                   revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket other_edit no_cta_edit
# 1: dewiki   control          0        5710
# 2: dewiki post-edit          0        1900
# 3: dewiki  pre-edit       1113         561
# 4: enwiki  pre-edit      10577         315
# 5: enwiki   control          1       40610
# 6: enwiki post-edit          0        6378
# 7: frwiki  pre-edit       1880          71
# 8: frwiki post-edit          1         793
# 9: frwiki   control          0        5601
#10: itwiki  pre-edit       1423          59
#11: itwiki   control          0        4973
#12: itwiki post-edit          0         542

################################################################################
#                           Post-edit
################################################################################

flows[,
	list(
		n = length(token),
		edit_link = sum(first_edit_section_click == flow_start |
		                first_edit_page_click == flow_start, na.rm=T),
		revision = sum((first_edit_section_click == flow_start |
		                first_edit_page_click == flow_start) &
		                revisions_saved > 0, na.rm=T),
		post_edit = sum((first_edit_section_click == flow_start |
		                first_edit_page_click == flow_start) &
		                revisions_saved > 0 &
		                !is.na(first_post_edit_cta_impression), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n edit_link revision post_edit
# 1: dewiki   control  38711     38711     5710         0
# 2: dewiki post-edit  34783     34783     4896      2996
# 3: dewiki  pre-edit  34441     34441     3846         0
# 4: enwiki  pre-edit 178741    178741    31229         0
# 5: enwiki   control 189724    189724    40611         0
# 6: enwiki post-edit 171517    171517    35423     29042
# 7: frwiki  pre-edit  28411     28411     4702         0
# 8: frwiki post-edit  27180     27180     5217      4423
# 9: frwiki   control  29962     29962     5601         0
#10: itwiki  pre-edit  19405     19405     3682         0
#11: itwiki   control  20361     20361     4973         0
#12: itwiki post-edit  18626     18626     4620      4077


flows[,
	list(
		signup = sum((first_edit_section_click == flow_start |
		              first_edit_page_click == flow_start) &
		              revisions_saved > 0 &
		              !is.na(first_post_edit_cta_impression) &
		              !is.na(first_signup_button_click), na.rm=T),
		sig_reg = sum((first_edit_section_click == flow_start |
		              first_edit_page_click == flow_start) &
		              revisions_saved > 0 &
		              !is.na(first_post_edit_cta_impression) &
		              !is.na(first_signup_button_click) &
		              account_creation_completes > 0, na.rm=T),
		dismiss = sum((first_edit_section_click == flow_start |
		               first_edit_page_click == flow_start) &
		               revisions_saved > 0 &
		               !is.na(first_post_edit_cta_impression) &
		               is.na(first_signup_button_click) &
		               !is.na(first_dismiss_button_click), na.rm=T),
		dis_reg = sum((first_edit_section_click == flow_start |
		               first_edit_page_click == flow_start) &
		               revisions_saved > 0 &
		               !is.na(first_post_edit_cta_impression) &
		               is.na(first_signup_button_click) &
		               !is.na(first_dismiss_button_click) &
		               account_creation_completes > 0, na.rm=T),
		cr_acc = sum((first_edit_section_click == flow_start |
		               first_edit_page_click == flow_start) &
		               revisions_saved > 0 &
		               !is.na(first_post_edit_cta_impression) &
		               is.na(first_signup_button_click) &
		               is.na(first_dismiss_button_click) &
		               !is.na(first_create_account_click), na.rm=T),
		cr_reg = sum((first_edit_section_click == flow_start |
		               first_edit_page_click == flow_start) &
		               revisions_saved > 0 &
		               !is.na(first_post_edit_cta_impression) &
		               is.na(first_signup_button_click) &
		               is.na(first_dismiss_button_click) &
		               !is.na(first_create_account_click) &
		               account_creation_completes > 0, na.rm=T),
		none_reg = sum((first_edit_section_click == flow_start |
		               first_edit_page_click == flow_start) &
		               revisions_saved > 0 &
		               !is.na(first_post_edit_cta_impression) &
		               is.na(first_signup_button_click) &
		               is.na(first_dismiss_button_click) &
		               is.na(first_create_account_click) &
		               account_creation_completes > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket signup sig_reg dismiss dis_reg cr_acc cr_reg none_reg
# 1: dewiki   control      0       0       0       0      0      0        0
# 2: dewiki post-edit     90      42    1703      11     18      5        3
# 3: dewiki  pre-edit      0       0       0       0      0      0        0
# 4: enwiki  pre-edit      0       0       0       0      0      0        0
# 5: enwiki   control      0       0       0       0      0      0        0
# 6: enwiki post-edit    643     353   17257     192     93     54       79
# 7: frwiki  pre-edit      0       0       0       0      0      0        0
# 8: frwiki post-edit    129      83    2950      25     17      5        7
# 9: frwiki   control      0       0       0       0      0      0        0
#10: itwiki  pre-edit      0       0       0       0      0      0        0
#11: itwiki   control      0       0       0       0      0      0        0
#12: itwiki post-edit    103      58    2394      21     18      9        5



flows[,
	list(
		reg = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   revisions_saved > 0 &
		                   account_creation_completes > 0, na.rm=T),
		cta_reg = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   revisions_saved > 0 &
		                   !is.na(first_post_edit_cta_impression) &
		                   account_creation_completes > 0, na.rm=T),
		otherwise_reg = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   revisions_saved > 0 &
		                   is.na(first_post_edit_cta_impression) &
		                   account_creation_completes > 0, na.rm=T),
		cta_click_reg = sum((first_edit_section_click == flow_start |
		                   first_edit_page_click == flow_start) &
		                   revisions_saved > 0 &
		                   is.na(first_post_edit_cta_impression) &
		                   (
		                       !is.na(first_signup_button_click) |
		                       !is.na(first_dismiss_button_click)
		                   ) &
		                   account_creation_completes > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket acc_created cta_acc_created otherwise_acc_created
# 1: dewiki   control         147               0                   147
# 2: dewiki post-edit         171              61                   110
# 3: dewiki  pre-edit         290               0                   290
# 4: enwiki  pre-edit        3371               0                  3371
# 5: enwiki   control        1410               0                  1410
# 6: enwiki post-edit        1638             678                   960
# 7: frwiki  pre-edit         474               0                   474
# 8: frwiki post-edit         231             120                   111
# 9: frwiki   control         153               0                   153
#10: itwiki  pre-edit         258               0                   258
#11: itwiki   control          74               0                    74
#12: itwiki post-edit         141              93                    48
