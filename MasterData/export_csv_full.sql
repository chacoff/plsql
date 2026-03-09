--
DECLARE
    c_filename   VARCHAR2(100) := 'BDC_DRESS.csv';
    c_folder     VARCHAR2(100) := 'DATAPUMP_DIR_PES';
    v_file       UTL_FILE.FILE_TYPE;
    v_cursor     INTEGER;
    v_col_cnt    INTEGER;
    v_desc_tab   DBMS_SQL.DESC_TAB;
    v_val        VARCHAR2(4000);
    v_line       VARCHAR2(32767);
    v_header     VARCHAR2(32767);
    v_status     INTEGER;
    v_sql        VARCHAR2(4000) := 'SELECT 
    rownum AS ID,
    rg.PROFILEID AS GRP_MONT,
    rg.ROLLGRADE AS NUAN_TR,
    rg.PRODUCTID AS PROF_LME,
    f.WIDTH * 100 AS LARG_PPL,
    p.HEIGHT * 100 AS HAUT_PPL,
    p.THICKW * 100 AS DEGAGMT_W,
    p.THICKSD * 100 AS EP_AME_SD,
    f.SPDIN * 100 AS VITS_ENTR,
    f.SPDDRESS * 100 AS VITS_DRESS,
    f.TMPDRESSMAX * 100 AS TEMP_MAX_DRESS,
    f.R1DIAM1 * 100 AS DIAM_1_R1,
    f.R1DIAM2 * 100 AS DIAM_2_R1,
    f.R2DIAM1 * 100 AS DIAM_1_R2,
    f.R2DIAM2 * 100 AS DIAM_2_R2, 
    f.R3DIAM1 * 100 AS DIAM_1_R3, 
    f.R3DIAM2 * 100 AS DIAM_2_R3, 
    f.R4DIAM1 * 100 AS DIAM_1_R4,  
    f.R4DIAM2 * 100 AS DIAM_2_R4, 
    f.R5DIAM1 * 100 AS DIAM_1_R5, 
    f.R5DIAM2 * 100 AS DIAM_2_R5, 
    f.R6DIAM1 * 100 AS DIAM_1_R6, 
    f.R6DIAM2 * 100 AS DIAM_2_R6,  
    f.R7DIAM1 * 100 AS DIAM_1_R7, 
    f.R7DIAM2 * 100 AS DIAM_2_R7,  
    f.R8DIAM1 * 100 AS DIAM_1_R8,  
    f.R8DIAM2 * 100 AS DIAM_2_R8, 
    f.R9DIAM1 * 100 AS DIAM_1_R9, 
    f.R9DIAM2 * 100 AS DIAM_2_R9,
    rg.R2VERT * 100 AS SERR_V_R2,
    rg.R4VERT  * 100 AS SERR_V_R4, 
    rg.R6VERT  * 100 AS SERR_V_R6, 
    rg.R8VERT  * 100 AS SERR_V_R8,
    rg.R9VERT  * 100 AS SERR_V_R9,
    rg.R2OFFSET * 100 AS OFF_OUV_R2,
    rg.R4OFFSET * 100 AS OFF_OUV_R4,
    rg.R6OFFSET * 100 AS OFF_OUV_R6,
    rg.R8OFFSET * 100 AS OFF_OUV_R8,        
    rg.R1AXIAL * 100 AS POSIT_A_R1,
    rg.R2AXIAL * 100 AS POSIT_A_R2,
    rg.R3AXIAL * 100 AS POSIT_A_R3,
    rg.R4AXIAL * 100 AS POSIT_A_R4,
    rg.R5AXIAL * 100 AS POSIT_A_R5,
    rg.R6AXIAL * 100 AS POSIT_A_R6,
    rg.R7AXIAL * 100 AS POSIT_A_R7,
    rg.R8AXIAL * 100 AS POSIT_A_R8,
    rg.R9AXIAL * 100 AS POSIT_A_R9,
    f.GUIDEINOP * 100 AS G_ENTR_COP,
    f.GUIDEINDRV * 100 AS G_ENTR_CPR,
    f.RTIN * 100 AS TABLE_ENTR, 
    f.ROLLPINCH * 100 AS RLX_PINC,
    f.ROLLINOP * 100 AS RLX_ENTR_COP,
    f.ROLLINDRV * 100 AS RLX_ENTR_CPR,
    f.ROLLOUT * 100 AS RLX_SORTI,
    f.HEIGHTSTRGT * 100 AS HAUT_DRESS, 
    rg.Remark AS REM,
    p.ilmin * 100 AS OUV_GRF_MIN,
    p.ilmax * 100 AS OUV_GRF_MAX,
    p.ilpairtolmin * 100 AS OUV_COR_MIN,
    p.ilpairtolmax * 100 AS OUV_COR_MAX,
    p.ilbumpstolmax * 100 AS OUV_COR_MAX_2,
    p.ilwidthmin * 100 AS LARG_GRF_MIN,
    p.ilwidthmax * 100 AS LARG_GRF_MAX,
    p.ilpairwtolmin * 100 AS LARG_COR_MIN,
    p.ilpairwtolmax * 100 AS LARG_COR_MAX,
    p.miseaumille * 100 AS MIMIL_THEO,
    p.lenmin * 100 AS LMIN_VENT 
FROM XROLLPRODRG rg
JOIN XROLLPROD p  ON rg.PROFILEID = p.PROFILEID 
                 AND rg.PRODUCTID = p.PRODUCTID 
                 AND rg.VERSION   = p.VERSION
JOIN XROLLPROF f  ON rg.PROFILEID = f.PROFILEID 
                 AND rg.VERSION   = f.VERSION
WHERE rg.VERSION = (
    SELECT MAX(VERSION)
    FROM XROLLPRODRG t2
    WHERE t2.PROFILEID = rg.PROFILEID
      AND t2.PRODUCTID = rg.PRODUCTID
      AND t2.ROLLGRADE = rg.ROLLGRADE
)';

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

    UTL_FILE.FCLOSE(v_file);
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;
--
