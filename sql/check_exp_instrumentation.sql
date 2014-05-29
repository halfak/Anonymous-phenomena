SELECT 
    wiki, 
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM SignupExpPageLinkClick_8101692
WHERE wiki != "wiki"
GROUP BY wiki, hour
ORDER BY wiki, hour;


<source lang="SQL">
SELECT 
    wiki,
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM SignupExpCTAImpression_8101716
WHERE wiki != "wiki"
GROUP BY wiki, hour
ORDER BY wiki, hour;
<source>
<pre>
+--------+------------+---------+--------+--------------+
| wiki   | hour       | tokened | events | tokened_prop |
+--------+------------+---------+--------+--------------+
| dewiki | 2014051918 |      97 |     97 |       1.0000 |
| dewiki | 2014051919 |     163 |    163 |       1.0000 |
| dewiki | 2014051920 |      85 |     85 |       1.0000 |
| enwiki | 2014051520 |       2 |      2 |       1.0000 |
| enwiki | 2014051918 |     540 |    540 |       1.0000 |
| enwiki | 2014051919 |     670 |    670 |       1.0000 |
| enwiki | 2014051920 |     556 |    556 |       1.0000 |
| frwiki | 2014051918 |     154 |    154 |       1.0000 |
| frwiki | 2014051919 |     164 |    164 |       1.0000 |
| frwiki | 2014051920 |     107 |    107 |       1.0000 |
| itwiki | 2014051918 |     117 |    117 |       1.0000 |
| itwiki | 2014051919 |     155 |    155 |       1.0000 |
| itwiki | 2014051920 |     134 |    134 |       1.0000 |
+--------+------------+---------+--------+--------------+
13 rows in set (0.01 sec)
</pre>


<source lang="SQL">
SELECT 
    wiki, 
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM SignupExpCTAButtonClick_8102619
WHERE wiki != "wiki"
GROUP BY wiki, hour
ORDER BY wiki, hour;
</source>
<pre>
+--------+------------+---------+--------+--------------+
| wiki   | hour       | tokened | events | tokened_prop |
+--------+------------+---------+--------+--------------+
| dewiki | 2014051918 |      62 |     62 |       1.0000 |
| dewiki | 2014051919 |     114 |    114 |       1.0000 |
| dewiki | 2014051920 |      60 |     60 |       1.0000 |
| enwiki | 2014051918 |     255 |    255 |       1.0000 |
| enwiki | 2014051919 |     350 |    350 |       1.0000 |
| enwiki | 2014051920 |     319 |    319 |       1.0000 |
| frwiki | 2014051918 |      46 |     46 |       1.0000 |
| frwiki | 2014051919 |      74 |     74 |       1.0000 |
| frwiki | 2014051920 |      49 |     49 |       1.0000 |
| itwiki | 2014051918 |      54 |     54 |       1.0000 |
| itwiki | 2014051919 |      86 |     86 |       1.0000 |
| itwiki | 2014051920 |      85 |     85 |       1.0000 |
+--------+------------+---------+--------+--------------+
12 rows in set (0.01 sec)
</pre>


<source lang="SQL">
SELECT 
    wiki, 
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM SignupExpAccountCreationComplete_8539421
WHERE wiki IN ("enwiki", "itwiki", "dewiki", "frwiki")
GROUP BY wiki, hour
ORDER BY wiki, hour;
</source>
<pre>
+--------+------------+---------+--------+--------------+
| wiki   | hour       | tokened | events | tokened_prop |
+--------+------------+---------+--------+--------------+
| dewiki | 2014051918 |       9 |     14 |       0.6429 |
| dewiki | 2014051919 |      14 |     19 |       0.7368 |
| dewiki | 2014051920 |       9 |     14 |       0.6429 |
| dewiki | 2014051921 |       4 |      5 |       0.8000 |
| enwiki | 2014051918 |     177 |    251 |       0.7052 |
| enwiki | 2014051919 |     197 |    277 |       0.7112 |
| enwiki | 2014051920 |     164 |    209 |       0.7847 |
| enwiki | 2014051921 |      27 |     33 |       0.8182 |
| frwiki | 2014051918 |      13 |     19 |       0.6842 |
| frwiki | 2014051919 |      31 |     39 |       0.7949 |
| frwiki | 2014051920 |      19 |     25 |       0.7600 |
| frwiki | 2014051921 |       3 |      6 |       0.5000 |
| itwiki | 2014051918 |       8 |     11 |       0.7273 |
| itwiki | 2014051919 |      11 |     11 |       1.0000 |
| itwiki | 2014051920 |      13 |     18 |       0.7222 |
| itwiki | 2014051921 |       1 |      1 |       1.0000 |
+--------+------------+---------+--------+--------------+
16 rows in set (0.01 sec)
</pre>


<source lang="SQL">
SELECT 
    wiki, 
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM SignupExpAccountCreationImpression_8539445
WHERE wiki IN ("enwiki", "itwiki", "dewiki", "frwiki")
GROUP BY wiki, hour
ORDER BY wiki, hour;
</source>
<pre>
+--------+------------+---------+--------+--------------+
| wiki   | hour       | tokened | events | tokened_prop |
+--------+------------+---------+--------+--------------+
| dewiki | 2014051918 |      99 |    236 |       0.4195 |
| dewiki | 2014051919 |     159 |    287 |       0.5540 |
| dewiki | 2014051920 |     131 |    258 |       0.5078 |
| dewiki | 2014051921 |      48 |     67 |       0.7164 |
| enwiki | 2014051918 |     624 |   8572 |       0.0728 |
| enwiki | 2014051919 |     751 |   2696 |       0.2786 |
| enwiki | 2014051920 |     901 |   3628 |       0.2483 |
| enwiki | 2014051921 |     198 |   1074 |       0.1844 |
| frwiki | 2014051918 |      96 |    289 |       0.3322 |
| frwiki | 2014051919 |     152 |    300 |       0.5067 |
| frwiki | 2014051920 |     114 |    328 |       0.3476 |
| frwiki | 2014051921 |      20 |     85 |       0.2353 |
| itwiki | 2014051918 |      51 |     89 |       0.5730 |
| itwiki | 2014051919 |      60 |    100 |       0.6000 |
| itwiki | 2014051920 |      70 |    121 |       0.5785 |
| itwiki | 2014051921 |       7 |     15 |       0.4667 |
+--------+------------+---------+--------+--------------+
16 rows in set (0.24 sec)
</pre>


<source lang="SQL">
SELECT 
    wiki, 
    LEFT(timestamp, 10) AS hour, 
    SUM(event_token IS NOT NULL) AS tokened, 
    COUNT(*) AS events,
    SUM(event_token IS NOT NULL)/COUNT(*) AS tokened_prop
FROM TrackedPageContentSaveComplete_8535426
WHERE wiki IN ("enwiki", "itwiki", "dewiki", "frwiki")
GROUP BY wiki, hour
ORDER BY wiki, hour;
</source>
<pre>
+--------+------------+---------+--------+--------------+
| wiki   | hour       | tokened | events | tokened_prop |
+--------+------------+---------+--------+--------------+
| dewiki | 2014051918 |    1239 |   1476 |       0.8394 |
| dewiki | 2014051919 |    1415 |   1586 |       0.8922 |
| dewiki | 2014051920 |    1369 |   1437 |       0.9527 |
| dewiki | 2014051921 |     367 |    373 |       0.9839 |
| enwiki | 2014051918 |    5241 |   6613 |       0.7925 |
| enwiki | 2014051919 |    5926 |   6879 |       0.8615 |
| enwiki | 2014051920 |    5703 |   6943 |       0.8214 |
| enwiki | 2014051921 |    1221 |   1437 |       0.8497 |
| frwiki | 2014051918 |    1092 |   1565 |       0.6978 |
| frwiki | 2014051919 |    1054 |   1383 |       0.7621 |
| frwiki | 2014051920 |    1241 |   1528 |       0.8122 |
| frwiki | 2014051921 |     258 |    335 |       0.7701 |
| itwiki | 2014051918 |     775 |    827 |       0.9371 |
| itwiki | 2014051919 |     729 |    849 |       0.8587 |
| itwiki | 2014051920 |     760 |   1047 |       0.7259 |
| itwiki | 2014051921 |     153 |    263 |       0.5817 |
+--------+------------+---------+--------+--------------+
16 rows in set (0.11 sec)
</pre>
