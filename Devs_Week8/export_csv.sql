DECLARE
    v_file UTL_FILE.FILE_TYPE;
    v_dir  CONSTANT VARCHAR2(100) := 'DATAPUMP_DIR_PES'; 
BEGIN
    v_file := UTL_FILE.FOPEN(v_dir, 'export.csv', 'W');
    UTL_FILE.PUT_LINE(v_file, 'PROFILEID,PRODUCTID,ROLLGRADE,VERSION');

    FOR r IN (
        SELECT * FROM XROLLPRODRG t1
        WHERE VERSION = (
            SELECT MAX(VERSION)
            FROM XROLLPRODRG t2
            WHERE t2.PROFILEID = t1.PROFILEID
              AND t2.PRODUCTID = t1.PRODUCTID
              AND t2.ROLLGRADE = t1.ROLLGRADE
        )
    ) LOOP
        UTL_FILE.PUT_LINE(v_file, r.PROFILEID || ',' || r.PRODUCTID || ',' || r.ROLLGRADE || ',' || r.VERSION);
    END LOOP;

    UTL_FILE.FFLUSH(v_file);
    UTL_FILE.FCLOSE(v_file);

EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(v_file) THEN
            UTL_FILE.FCLOSE(v_file);
        END IF;
        RAISE;

END;
---

-- see all columns
SELECT LISTAGG(column_name, ',') WITHIN GROUP (ORDER BY column_id)
FROM user_tab_columns
WHERE table_name = 'XROLLPRODRG';

-- see folders i have access
SELECT owner, directory_name, directory_path 
FROM all_directories;
