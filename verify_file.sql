DECLARE
    v_exists      BOOLEAN;
    v_file_length NUMBER;
    v_block_size  NUMBER;
    v_dir         CONSTANT VARCHAR2(100) := 'DATAPUMP_DIR_PES';
    filename      CONSTANT VARCHAR2(100) := 'export.csv';
BEGIN
    UTL_FILE.FGETATTR(
        location    => v_dir,
        filename    => filename,
        fexists     => v_exists,
        file_length => v_file_length,
        block_size  => v_block_size
    );

    IF v_exists THEN
        RAISE_APPLICATION_ERROR(-20000, 'SUCCESS: File exists. Size: ' || v_file_length);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: File not found.');
    END IF;
END;
/
