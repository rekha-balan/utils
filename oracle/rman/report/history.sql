select to_char(start_time, 'mm/dd/yy hh24:mi') "Date",
status,
operation,
mbytes_processed
from v$rman_status vs
where start_time >  sysdate -1
order by start_time
/ 
