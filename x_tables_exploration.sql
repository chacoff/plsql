-- all column names and type for X-tables
SELECT table_name, column_name, data_type, data_length, nullable
FROM all_tab_columns
WHERE table_name IN ('XROLLPROF', 'XROLLPROD', 'XROLLPRODS', 'XROLLPRODRG')
ORDER BY table_name, column_id;
--

-- constraints hierachy
SELECT
    a.table_name AS child_table,
    a.column_name AS child_column,
    c.table_name AS parent_table,
    c.column_name AS parent_column,
    c.constraint_name
FROM all_cons_columns a
JOIN all_constraints b ON a.constraint_name = b.constraint_name
JOIN all_cons_columns c ON b.r_constraint_name = c.constraint_name
WHERE a.table_name IN ('XROLLPROF', 'XROLLPROD', 'XROLLPRODS', 'XROLLPRODRG')
  AND b.constraint_type = 'R'; -- REFERENTIAL INTEGRITY

-- check columns that appears in 2 or more columns:
-- export it as CSV x_table.csv to comprehend all the tables
SELECT column_name,
       COUNT(*) as occurrence_count,
       LISTAGG(table_name, ', ') WITHIN GROUP (ORDER BY table_name) AS found_in_tables
FROM all_tab_columns
WHERE table_name IN ('XROLLPROF', 'XROLLPROD', 'XROLLPRODS', 'XROLLPRODRG')
GROUP BY column_name
HAVING COUNT(*) >= 1 -- delete to get full list
ORDER BY occurrence_count DESC;

-- find specific column in tables
SELECT table_name, column_name
FROM all_tab_columns
WHERE table_name IN ('XROLLPROF', 'XROLLPROD', 'XROLLPRODS', 'XROLLPRODRG')
AND column_name = 'ROLLOUT';
