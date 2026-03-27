SELECT col.column_name, 
       COUNT(DISTINCT syn.synonym_name) AS "TABLE_COUNT",
       MIN(syn.synonym_name) AS "SOURCE_1",
       CASE WHEN COUNT(DISTINCT syn.synonym_name) > 1 THEN MAX(syn.synonym_name) END AS "SOURCE_2"
FROM all_synonyms syn
JOIN all_tab_columns col ON syn.table_owner = col.owner 
                        AND syn.table_name = col.table_name
WHERE syn.synonym_name IN ('VU_COULEE', 'VU_STOCK_DP', 'VU_ANAL_NUAN_AC')
GROUP BY col.column_name
ORDER BY 2 DESC;
---

SELECT table_name, column_name
FROM all_tab_columns
WHERE table_name IN ('VU_COULEE', 'VU_STOCK_DP', 'VU_ANAL_NUAN_AC');

-- SEMIS-to-MES
SELECT
       AA_COUL,
       CO_FOURN,
       NUM_COUL,
       NUAN_AC,
       TYPE_DP,
       LONG_STK,
       PDS_THEO,
       LOT
FROM VU_STOCK_DP
WHERE AA_COUL = '2026';