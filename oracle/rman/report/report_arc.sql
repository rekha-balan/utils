-- The following query displays per day the volume in MBytes of archived logs generated,
-- deleted and of those that haven't yet been deleted by RMAN
set pages 200

SELECT SUM_ARCH.DAY,
         SUM_ARCH.GENERATED_MB,
         SUM_ARCH_DEL.DELETED_MB,
         SUM_ARCH.GENERATED_MB - SUM_ARCH_DEL.DELETED_MB "REMAINING_MB"
    FROM (  SELECT TO_CHAR (COMPLETION_TIME, 'DD/MM/YYYY') DAY,
                   SUM (ROUND ( (blocks * block_size) / (1024 * 1024), 2))
                      GENERATED_MB
              FROM V$ARCHIVED_LOG
             WHERE ARCHIVED = 'YES'
          GROUP BY TO_CHAR (COMPLETION_TIME, 'DD/MM/YYYY')) SUM_ARCH,
         (  SELECT TO_CHAR (COMPLETION_TIME, 'DD/MM/YYYY') DAY,
                   SUM (ROUND ( (blocks * block_size) / (1024 * 1024), 2))
                      DELETED_MB
              FROM V$ARCHIVED_LOG
             WHERE ARCHIVED = 'YES' AND DELETED = 'YES'
          GROUP BY TO_CHAR (COMPLETION_TIME, 'DD/MM/YYYY')) SUM_ARCH_DEL
   WHERE SUM_ARCH.DAY = SUM_ARCH_DEL.DAY(+)
ORDER BY TO_DATE (DAY, 'DD/MM/YYYY');
