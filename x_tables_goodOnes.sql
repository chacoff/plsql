/*
XROLLPROF: Now contains WIDTH, DIAM parameters, GUIDE, ROLL, and SPD columns.
XROLLPROD: Now contains HEIGHT, THICKSD, and THICKW.
XROLLPRODRG: Retains the AXIAL, PRE, VERT, and OFFSET parameters.

- p. >> from XROLLPROD
- rg. >> From XROLLPRODRG
- f. >> From XROLLPROF

*/

SELECT
    rownum, -- ID
    rg.PROFILEID, -- GRP_MONT
    rg.ROLLGRADE, -- NUAN_TR
    rg.PRODUCTID, -- PROF_LME
    -- rg.VERSION,
    -- rg.DTMODIFIED,
    f.WIDTH * 100, -- LARG_PPL
    p.HEIGHT * 100, -- HAUT_PPL
    p.THICKW * 100, -- DEGAGMT_W
    p.THICKSD * 100, -- EP_AME_SD
    f.SPDIN * 100, -- VITS_ENTR
    f.SPDDRESS * 100, -- VITS_DRESS
    f.TMPDRESSMAX * 100, -- TEMP_MAX_DRESS
    f.R1DIAM1 * 100, -- DIAM_1_R1
    f.R1DIAM2 * 100, -- DIAM_2_R1
    f.R2DIAM1 * 100, -- DIAM_1_R2
    f.R2DIAM2 * 100, -- DIAM_2_R2
    f.R3DIAM1 * 100, -- DIAM_1_R3
    f.R3DIAM2 * 100, -- DIAM_2_R3
    f.R4DIAM1 * 100, -- DIAM_1_R4
    f.R4DIAM2 * 100, -- DIAM_2_R4
    f.R5DIAM1 * 100, -- DIAM_1_R5
    f.R5DIAM2 * 100, -- DIAM_2_R5
    f.R6DIAM1 * 100, -- DIAM_1_R6
    f.R6DIAM2 * 100, -- DIAM_2_R6
    f.R7DIAM1 * 100, -- DIAM_1_R7
    f.R7DIAM2 * 100, -- DIAM_2_R7
    f.R8DIAM1 * 100, -- DIAM_1_R8
    f.R8DIAM2 * 100, -- DIAM_2_R8
    f.R9DIAM1 * 100, -- DIAM_1_R9
    f.R9DIAM2 * 100, -- DIAM_2_R9
    rg.R2VERT * 100, -- SERR_V_R2
    rg.R4VERT  * 100, -- SERR_V_R4
    rg.R6VERT  * 100, -- SERR_V_R6
    rg.R8VERT  * 100, -- SERR_V_R8
    rg.R9VERT  * 100,-- SERR_V_R9
    rg.R2OFFSET * 100, -- OFF_OUV_R2
    rg.R4OFFSET * 100, -- OFF_OUV_R4
    rg.R6OFFSET * 100, -- OFF_OUV_R6
    rg.R8OFFSET * 100, -- OFF_OUV_R8
    rg.R1AXIAL * 100, -- POSIT_A_R1
    rg.R2AXIAL * 100, -- POSIT_A_R2
    rg.R3AXIAL * 100, -- POSIT_A_R3
    rg.R4AXIAL * 100, -- POSIT_A_R4
    rg.R5AXIAL * 100, -- POSIT_A_R5
    rg.R6AXIAL * 100, -- POSIT_A_R6
    rg.R7AXIAL * 100, -- POSIT_A_R7
    rg.R8AXIAL * 100, -- POSIT_A_R8
    rg.R9AXIAL * 100, -- POSIT_A_R9
    f.GUIDEINOP * 100, -- G_ENTR_COP
    f.GUIDEINDRV * 100, -- G_ENTR_CPR
    f.RTIN * 100, -- TABLE_ENTR
    f.ROLLPINCH * 100, -- RLX_PINC
    f.ROLLINOP * 100, -- RLX_ENTR_COP
    f.ROLLINDRV * 100, -- RLX_ENTR_CPR
    f.ROLLOUT * 100, -- RLX_SORTI
    f.HEIGHTSTRGT * 100, -- HAUT_DRESS
    rg.Remark, -- REM
    p.ilmin * 100, -- OUV_GRF_MIN
    p.ilmax * 100, -- OUV_GRF_MAX
    p.ilpairtolmin * 100, -- OUV_COR_MIN
    p.ilpairtolmax * 100, -- OUV_COR_MAX
    p.ilbumpstolmax * 100, -- OUV_COR_MAX_2
    p.ilwidthmin * 100, -- LARG_GRF_MIN
    p.ilwidthmax * 100, -- LARG_GRF_MAX
    p.ilpairwtolmin * 100, -- LARG_COR_MIN
    p.ilpairwtolmax * 100, -- LARG_COR_MAX
    p.miseaumille * 100, -- MIMIL_THEO
    p.lenmin * 100 -- LMIN_VENT
   /*
    rg.R2PRE * 100, -- Prereglage R2
    rg.R4PRE * 100,
    rg.R6PRE * 100,
    rg.R8PRE * 100
   */
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
) AND EXISTS (
  SELECT 1
  FROM XROLLPRODRG
  WHERE Dtmodified >= SYSDATE - (1/24)
);
--AND rg.DTMODIFIED >= SYSDATE - (1/24);
