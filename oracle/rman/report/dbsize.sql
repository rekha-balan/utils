set lines 200
select sum(bytes/(1024*1024)) as "DB SIZE IN MB", sum(bytes/(1024*1024*1024)) as "DB SIZE IN GB" from dba_data_files;
