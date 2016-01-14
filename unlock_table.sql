DECLARE
  V_SERIAL     NUMBER;
  V_TABLENAME VARCHAR2(64) := ''; --table name
  V_OWNER     VARCHAR2(64) := ''; --schema name
BEGIN
  V_TABLENAME := UPPER(V_TABLENAME);
  FOR REC IN (SELECT *
                FROM V$LOCK
               WHERE ID1 = (SELECT OBJECT_ID
                              FROM ALL_OBJECTS
                             WHERE OWNER = V_OWNER
                               AND OBJECT_NAME = V_TABLENAME))
  LOOP
    SELECT SERIAL#
      INTO V_SERIAL
      FROM V$SESSION
     WHERE SID = REC.SID;
  
    EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || REC.SID || ',' ||
                      TO_CHAR(V_SERIAL) || '''';
  END LOOP;
END;
