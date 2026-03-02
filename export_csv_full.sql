--
DECLARE
    c_filename   VARCHAR2(100) := 'export.csv';
    c_folder     VARCHAR2(100) := 'DATAPUMP_DIR_PES';
    v_file       UTL_FILE.FILE_TYPE;
    v_cursor     INTEGER;
    v_col_cnt    INTEGER;
    v_desc_tab   DBMS_SQL.DESC_TAB;
    v_val        VARCHAR2(4000);
    v_line       VARCHAR2(32767);
    v_header     VARCHAR2(32767);
    v_status     INTEGER;
    v_sql        VARCHAR2(4000) := 'SELECT * FROM XROLLPRODRG t1
                                    WHERE VERSION = (
                                    SELECT MAX(VERSION)
                                    FROM XROLLPRODRG t2
                                    WHERE t2.PROFILEID = t1.PROFILEID
                                    AND t2.PRODUCTID = t1.PRODUCTID
                                    AND t2.ROLLGRADE = t1.ROLLGRADE)';

BEGIN
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
    DBMS_SQL.DESCRIBE_COLUMNS(v_cursor, v_col_cnt, v_desc_tab);

    v_file := UTL_FILE.FOPEN(c_folder, c_filename, 'W');

    FOR i IN 1..v_col_cnt LOOP
        v_header := v_header || v_desc_tab(i).col_name || CASE WHEN i < v_col_cnt THEN ',' END;
        DBMS_SQL.DEFINE_COLUMN(v_cursor, i, v_val, 4000);
    END LOOP;
    UTL_FILE.PUT_LINE(v_file, v_header);

    v_status := DBMS_SQL.EXECUTE(v_cursor);

    WHILE DBMS_SQL.FETCH_ROWS(v_cursor) > 0 LOOP
        v_line := NULL;
        FOR i IN 1..v_col_cnt LOOP
            DBMS_SQL.COLUMN_VALUE(v_cursor, i, v_val);
            v_line := v_line || v_val || CASE WHEN i < v_col_cnt THEN ',' END;
        END LOOP;
        UTL_FILE.PUT_LINE(v_file, v_line);
    END LOOP;

    -- UTL_FILE..FFLUSH(v_file);
    UTL_FILE.FCLOSE(v_file);
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;
--
