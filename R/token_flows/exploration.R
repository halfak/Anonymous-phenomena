source("loader/token_flows.R")

flows = load_token_flows(reload=T)

dim(flows)
length(unique(flows$token))

################################################################################
#                             Pre Edit                                         #
################################################################################

# section edit --> pre-edit --> edit button --> revision saved
flows[,
	list(
		n = length(token),
		section_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_section_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		edit_button = sum(first_edit_section_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  !is.na(first_edit_button_click), na.rm=T),
		revision_saved = sum(first_edit_section_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_edit_button_click) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n section_edit pre_edit edit_button revision_saved
# 1: dewiki   control  38711        27537        0           0              0
# 2: dewiki post-edit  34783        24880        0           0              0
# 3: dewiki  pre-edit  34441        24866    23763        3410           1037
# 4: enwiki  pre-edit 178741       112789   109137       18004           8961
# 5: enwiki   control 189724       119389        1           0              0
# 6: enwiki post-edit 171517       107376        1           0              0
# 7: frwiki  pre-edit  28411        18063    17526        2321           1226
# 8: frwiki post-edit  27180        17420        0           0              0
# 9: frwiki   control  29962        19246        0           0              0
#10: itwiki  pre-edit  19405        13883    13454        1991           1077
#11: itwiki   control  20361        14482        0           0              0
#12: itwiki post-edit  18626        13039        0           0              0


# page edit --> pre-edit --> edit button --> revision saved
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_page_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		edit_button = sum(first_edit_page_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  !is.na(first_edit_button_click), na.rm=T),
		revision_saved = sum(first_edit_page_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_edit_button_click) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit pre_edit edit_button revision_saved
# 1: dewiki   control  38711     11174        0           0              0
# 2: dewiki post-edit  34783      9903        0           0              0
# 3: dewiki  pre-edit  34441      9575     8884        1847            712
# 4: enwiki  pre-edit 178741     65950    63900       14077           7000
# 5: enwiki   control 189724     70330        0           0              0
# 6: enwiki post-edit 171517     64139        0           0              0
# 7: frwiki  pre-edit  28411     10349    10020        1713            949
# 8: frwiki post-edit  27180      9760        1           0              0
# 9: frwiki   control  29962     10716        0           0              0
#10: itwiki  pre-edit  19405      5522     5324        1281            795
#11: itwiki   control  20361      5879        0           0              0
#12: itwiki post-edit  18626      5587        0           0              0


# section edit --> pre-edit --> dismiss button --> revision saved
flows[,
	list(
		n = length(token),
		section_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_section_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		dismiss_button = sum(first_edit_section_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  !is.na(first_dismiss_button_click), na.rm=T),
		revision_saved = sum(first_edit_section_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_dismiss_button_click) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n section_edit pre_edit dismiss_button revision_saved
# 1: dewiki   control  38711        27537        0              0              0
# 2: dewiki post-edit  34783        24880        0              0              0
# 3: dewiki  pre-edit  34441        24866    23763          13274            376
# 4: enwiki  pre-edit 178741       112789   109137          59432           3278
# 5: enwiki   control 189724       119389        1              0              0
# 6: enwiki post-edit 171517       107376        1              0              0
# 7: frwiki  pre-edit  28411        18063    17526           9652            748
# 8: frwiki post-edit  27180        17420        0              0              0
# 9: frwiki   control  29962        19246        0              0              0
#10: itwiki  pre-edit  19405        13883    13454           6908            565
#11: itwiki   control  20361        14482        0              0              0
#12: itwiki post-edit  18626        13039        0              0              0



# page edit --> pre-edit --> dismiss button --> revision saved
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_page_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		dismiss_button = sum(first_edit_page_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  !is.na(first_dismiss_button_click), na.rm=T),
		revision_saved = sum(first_edit_page_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_dismiss_button_click) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit pre_edit dismiss_button revision_saved
# 1: dewiki   control  38711     11174        0              0              0
# 2: dewiki post-edit  34783      9903        0              0              0
# 3: dewiki  pre-edit  34441      9575     8884           3296            223
# 4: enwiki  pre-edit 178741     65950    63900          22526           2436
# 5: enwiki   control 189724     70330        0              0              0
# 6: enwiki post-edit 171517     64139        0              0              0
# 7: frwiki  pre-edit  28411     10349    10020           4437            511
# 8: frwiki post-edit  27180      9760        1              1              1
# 9: frwiki   control  29962     10716        0              0              0
#10: itwiki  pre-edit  19405      5522     5324           1873            373
#11: itwiki   control  20361      5879        0              0              0
#12: itwiki post-edit  18626      5587        0              0              0

# TODO: Add flow for second edit link click

# section edit --> pre-edit --> signup button --> account created --> revision saved
flows[,
	list(
		n = length(token),
		sec_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_section_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		signup = sum(first_edit_section_click == flow_start & 
		                    !is.na(first_pre_edit_cta_impression) & 
		                    !is.na(first_signup_button_click), na.rm=T),
		acc_created = sum(first_edit_section_click == flow_start & 
		                      !is.na(first_pre_edit_cta_impression) & 
		                      !is.na(first_signup_button_click) &
		                      !is.na(first_account_creation_complete), na.rm=T),
		rev_saved = sum(first_edit_section_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_signup_button_click) &
		                     !is.na(first_account_creation_complete) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n sec_edit pre_edit signup acc_created rev_saved
# 1: dewiki   control  38711    27537        0      0           0         0
# 2: dewiki post-edit  34783    24880        0      0           0         0
# 3: dewiki  pre-edit  34441    24866    23763   1357         195       110
# 4: enwiki  pre-edit 178741   112789   109137   9348        2080      1371
# 5: enwiki   control 189724   119389        1      0           0         0
# 6: enwiki post-edit 171517   107376        1      0           0         0
# 7: frwiki  pre-edit  28411    18063    17526   1224         300       217
# 8: frwiki post-edit  27180    17420        0      0           0         0
# 9: frwiki   control  29962    19246        0      0           0         0
#10: itwiki  pre-edit  19405    13883    13454    644         154       122
#11: itwiki   control  20361    14482        0      0           0         0
#12: itwiki post-edit  18626    13039        0      0           0         0

# page edit --> pre-edit --> signup button --> account created --> revision saved
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_page_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		signup = sum(first_edit_page_click == flow_start & 
		                    !is.na(first_pre_edit_cta_impression) & 
		                    !is.na(first_signup_button_click), na.rm=T),
		acc_created = sum(first_edit_page_click == flow_start & 
		                      !is.na(first_pre_edit_cta_impression) & 
		                      !is.na(first_signup_button_click) &
		                      !is.na(first_account_creation_complete), na.rm=T),
		rev_saved = sum(first_edit_page_click == flow_start & 
		                     !is.na(first_pre_edit_cta_impression) & 
		                     !is.na(first_signup_button_click) &
		                     !is.na(first_account_creation_complete) &
		                     revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit pre_edit signup acc_created rev_saved
# 1: dewiki   control  38711     11174        0      0           0         0
# 2: dewiki post-edit  34783      9903        0      0           0         0
# 3: dewiki  pre-edit  34441      9575     8884    529         130        93
# 4: enwiki  pre-edit 178741     65950    63900   6142        1933      1250
# 5: enwiki   control 189724     70330        0      0           0         0
# 6: enwiki post-edit 171517     64139        0      0           0         0
# 7: frwiki  pre-edit  28411     10349    10020    821         224       161
# 8: frwiki post-edit  27180      9760        1      0           0         0
# 9: frwiki   control  29962     10716        0      0           0         0
#10: itwiki  pre-edit  19405      5522     5324    362         120        87
#11: itwiki   control  20361      5879        0      0           0         0
#12: itwiki post-edit  18626      5587        0      0           0         0


# sec edit --> pre-edit --> edit link (again) --> revision saved
flows[,
	list(
		n = length(token),
		sec_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_section_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		edit_click = sum(first_edit_section_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  is.na(first_dismiss_button_click) &
		                  is.na(first_edit_button_click) &
		                  is.na(first_signup_button_click) &
		                  edit_page_clicks +
		                  edit_section_clicks > 1 & 
		                  !is.na(first_account_creation_complete), na.rm=T),
		rev_saved = sum(first_edit_section_click == flow_start & 
		                !is.na(first_pre_edit_cta_impression) & 
		                is.na(first_dismiss_button_click) &
		                is.na(first_edit_button_click) &
		                is.na(first_signup_button_click) &
		                edit_page_clicks + edit_section_clicks > 1 & 
		                !is.na(first_account_creation_complete) &
		                revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n sec_edit pre_edit edit_click rev_saved
# 1: dewiki   control  38711    27537        0          0         0
# 2: dewiki post-edit  34783    24880        0          0         0
# 3: dewiki  pre-edit  34441    24866    23763          1         1
# 4: enwiki  pre-edit 178741   112789   109137         31        21
# 5: enwiki   control 189724   119389        1          0         0
# 6: enwiki post-edit 171517   107376        1          0         0
# 7: frwiki  pre-edit  28411    18063    17526          5         3
# 8: frwiki post-edit  27180    17420        0          0         0
# 9: frwiki   control  29962    19246        0          0         0
#10: itwiki  pre-edit  19405    13883    13454          1         1
#11: itwiki   control  20361    14482        0          0         0
#12: itwiki post-edit  18626    13039        0          0         0


# page edit --> pre-edit --> edit link (again) --> revision saved
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		pre_edit = sum(first_edit_page_click == flow_start & 
		               !is.na(first_pre_edit_cta_impression), na.rm=T),
		edit_click = sum(first_edit_page_click == flow_start & 
		                  !is.na(first_pre_edit_cta_impression) & 
		                  is.na(first_dismiss_button_click) &
		                  is.na(first_edit_button_click) &
		                  is.na(first_signup_button_click) &
		                  edit_page_clicks + edit_section_clicks > 1 & 
		                  !is.na(first_account_creation_complete), na.rm=T),
		rev_saved = sum(first_edit_page_click == flow_start & 
		                !is.na(first_pre_edit_cta_impression) & 
		                is.na(first_dismiss_button_click) &
		                is.na(first_edit_button_click) &
		                is.na(first_signup_button_click) &
		                edit_page_clicks + edit_section_clicks > 1 & 
		                !is.na(first_account_creation_complete) &
		                revisions_saved > 0, na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit pre_edit edit_click rev_saved
# 1: dewiki   control  38711     11174        0          0         0
# 2: dewiki post-edit  34783      9903        0          0         0
# 3: dewiki  pre-edit  34441      9575     8884          8         6
# 4: enwiki  pre-edit 178741     65950    63900         64        49
# 5: enwiki   control 189724     70330        0          0         0
# 6: enwiki post-edit 171517     64139        0          0         0
# 7: frwiki  pre-edit  28411     10349    10020         11         7
# 8: frwiki post-edit  27180      9760        1          0         0
# 9: frwiki   control  29962     10716        0          0         0
#10: itwiki  pre-edit  19405      5522     5324          5         3
#11: itwiki   control  20361      5879        0          0         0
#12: itwiki post-edit  18626      5587        0          0         0



################################################################################
#                             Post Edit                                        #
################################################################################

# section edit --> revision saved --> post edit --> signup button --> account created
flows[,
	list(
		n = length(token),
		sec_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_section_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_section_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		signup = sum(first_edit_section_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_signup_button_click), na.rm=T),
		acc_created = sum(first_edit_section_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_signup_button_click) & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n sec_edit rev_saved post_edit signup acc_created
# 1: dewiki   control  38711    27537      3336         0      0           0
# 2: dewiki post-edit  34783    24880      2966      1838     53          22
# 3: dewiki  pre-edit  34441    24866      2169         0      0           0
# 4: enwiki  pre-edit 178741   112789     16635         0      0           0
# 5: enwiki   control 189724   119389     22522         0      0           0
# 6: enwiki post-edit 171517   107376     19642     16377    334         192
# 7: frwiki  pre-edit  28411    18063      2593         0      0           0
# 8: frwiki post-edit  27180    17420      3007      2584     72          50
# 9: frwiki   control  29962    19246      3260         0      0           0
#10: itwiki  pre-edit  19405    13883      2048         0      0           0
#11: itwiki   control  20361    14482      2989         0      0           0
#12: itwiki post-edit  18626    13039      2578      2295     57          31


# page edit --> revision saved --> post edit --> signup button --> account created
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_page_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_page_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		signup = sum(first_edit_page_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_signup_button_click), na.rm=T),
		acc_created = sum(first_edit_page_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_signup_button_click) & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#       wiki    bucket     n page_edit rev_saved post_edit signup acc_created
# 1: dewiki   control  38711     11174      2374         0      0           0
# 2: dewiki post-edit  34783      9903      1930      1158     37          20
# 3: dewiki  pre-edit  34441      9575      1677         0      0           0
# 4: enwiki  pre-edit 178741     65950     14594         0      0           0
# 5: enwiki   control 189724     70330     18089         0      0           0
# 6: enwiki post-edit 171517     64139     15779     12662    309         161
# 7: frwiki  pre-edit  28411     10349      2109         0      0           0
# 8: frwiki post-edit  27180      9760      2210      1839     57          33
# 9: frwiki   control  29962     10716      2341         0      0           0
#10: itwiki  pre-edit  19405      5522      1634         0      0           0
#11: itwiki   control  20361      5879      1984         0      0           0
#12: itwiki post-edit  18626      5587      2042      1782     46          27


# section edit --> revision saved --> post edit --> dismiss button --> account created
flows[,
	list(
		n = length(token),
		sec_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_section_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_section_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		dismiss = sum(first_edit_section_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_dismiss_button_click), na.rm=T),
		acc_created = sum(first_edit_section_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_dismiss_button_click) & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n sec_edit rev_saved post_edit dismiss acc_created
# 1: dewiki   control  38711    27537      3336         0       0           0
# 2: dewiki post-edit  34783    24880      2966      1838     913           6
# 3: dewiki  pre-edit  34441    24866      2169         0       0           0
# 4: enwiki  pre-edit 178741   112789     16635         0       0           0
# 5: enwiki   control 189724   119389     22522         0       0           0
# 6: enwiki post-edit 171517   107376     19642     16377    8195          80
# 7: frwiki  pre-edit  28411    18063      2593         0       0           0
# 8: frwiki post-edit  27180    17420      3007      2584    1620          10
# 9: frwiki   control  29962    19246      3260         0       0           0
#10: itwiki  pre-edit  19405    13883      2048         0       0           0
#11: itwiki   control  20361    14482      2989         0       0           0
#12: itwiki post-edit  18626    13039      2578      2295    1184           8


# page edit --> revision saved --> post edit --> dismiss button --> account created
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_page_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_page_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		dismiss = sum(first_edit_page_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_dismiss_button_click), na.rm=T),
		acc_created = sum(first_edit_page_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_dismiss_button_click) & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit rev_saved post_edit dismiss acc_created
# 1: dewiki   control  38711     11174      2374         0       0           0
# 2: dewiki post-edit  34783      9903      1930      1158     791           5
# 3: dewiki  pre-edit  34441      9575      1677         0       0           0
# 4: enwiki  pre-edit 178741     65950     14594         0       0           0
# 5: enwiki   control 189724     70330     18089         0       0           0
# 6: enwiki post-edit 171517     64139     15779     12662    9167         136
# 7: frwiki  pre-edit  28411     10349      2109         0       0           0
# 8: frwiki post-edit  27180      9760      2210      1839    1346          18
# 9: frwiki   control  29962     10716      2341         0       0           0
#10: itwiki  pre-edit  19405      5522      1634         0       0           0
#11: itwiki   control  20361      5879      1984         0       0           0
#12: itwiki post-edit  18626      5587      2042      1782    1230          20


# section edit --> revision saved --> post edit --> account creation link --> account created
flows[,
	list(
		n = length(token),
		sec_edit = sum(first_edit_section_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_section_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_section_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		create_acc = sum(first_edit_section_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_create_account_click) &
		                    first_create_account_click > 
		                    first_post_edit_cta_impression, na.rm=T),
		acc_created = sum(first_edit_section_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_dismiss_button_click) & 
		                      !is.na(first_create_account_click) &
		                      first_create_account_click > 
		                      first_post_edit_cta_impression & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n sec_edit rev_saved post_edit create_acc acc_created
# 1: dewiki   control  38711    27537      3336         0          0           0
# 2: dewiki post-edit  34783    24880      2966      1838         27           5
# 3: dewiki  pre-edit  34441    24866      2169         0          0           0
# 4: enwiki  pre-edit 178741   112789     16635         0          0           0
# 5: enwiki   control 189724   119389     22522         0          0           0
# 6: enwiki post-edit 171517   107376     19642     16377        144          50
# 7: frwiki  pre-edit  28411    18063      2593         0          0           0
# 8: frwiki post-edit  27180    17420      3007      2584         32           6
# 9: frwiki   control  29962    19246      3260         0          0           0
#10: itwiki  pre-edit  19405    13883      2048         0          0           0
#11: itwiki   control  20361    14482      2989         0          0           0
#12: itwiki post-edit  18626    13039      2578      2295         25           5

# page edit --> revision saved --> post edit --> account creation link --> account created
flows[,
	list(
		n = length(token),
		page_edit = sum(first_edit_page_click == flow_start, na.rm=T),
		rev_saved = sum(first_edit_page_click == flow_start &
		                     revisions_saved > 0, na.rm=T),
		post_edit = sum(first_edit_page_click == flow_start &
		                revisions_saved > 0 & 
		                !is.na(first_post_edit_cta_impression), na.rm=T),
		create_acc = sum(first_edit_page_click == flow_start &
		                    revisions_saved > 0 & 
		                    !is.na(first_post_edit_cta_impression) & 
		                    !is.na(first_create_account_click) &
		                    first_create_account_click > 
		                    first_post_edit_cta_impression, na.rm=T),
		acc_cr = sum(first_edit_page_click == flow_start &
		                      revisions_saved > 0 & 
		                      !is.na(first_post_edit_cta_impression) &
		                      !is.na(first_dismiss_button_click) & 
		                      !is.na(first_create_account_click) &
		                      first_create_account_click > 
		                      first_post_edit_cta_impression & 
		                      !is.na(first_account_creation_complete), na.rm=T)
	),
	list(
		wiki, bucket
	)
]
#      wiki    bucket      n page_edit rev_saved post_edit create_acc acc_cr
# 1: dewiki   control  38711     11174      2374         0          0      0
# 2: dewiki post-edit  34783      9903      1930      1158         14      2
# 3: dewiki  pre-edit  34441      9575      1677         0          0      0
# 4: enwiki  pre-edit 178741     65950     14594         0          0      0
# 5: enwiki   control 189724     70330     18089         0          0      0
# 6: enwiki post-edit 171517     64139     15779     12662        160     61
# 7: frwiki  pre-edit  28411     10349      2109         0          0      0
# 8: frwiki post-edit  27180      9760      2210      1839         18     10
# 9: frwiki   control  29962     10716      2341         0          0      0
#10: itwiki  pre-edit  19405      5522      1634         0          0      0
#11: itwiki   control  20361      5879      1984         0          0      0
#12: itwiki post-edit  18626      5587      2042      1782         27      9