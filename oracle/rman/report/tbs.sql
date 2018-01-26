set lines 200
col file_name for a60

select TABLESPACE_NAME,FILE_NAME,AUTOEXTENSIBLE from dba_data_files order by TABLESPACE_NAME;
