SELECT
	userAgent AS user_agent,
	event_token IS NOT NULL as tokened
FROM SignupExpAccountCreationImpression_8539445
WHERE timestamp > "2014051921"
ORDER BY RAND()
LIMIT 100000;
