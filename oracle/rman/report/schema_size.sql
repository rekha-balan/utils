set lines 200

select 
   owner,
   sum(bytes)/1024/1024/1024 schema_size_gig,
   sum(bytes)/1024/1024 schema_size_mb
from 
   dba_segments 
group by 
   owner
order by schema_size_gig;
