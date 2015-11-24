/* used as an alternative to DBCC openTran() when don't have permissions */
select s.dbid, s.spid,s.loginame, s.status,d.name,s.last_batch,datediff(minute,s.last_batch,GETDATE()) as IdleTimeInMin, 
    s.open_tran,t.text 
from sys.sysprocesses s 
join sys.databases d on d.database_id = s.dbid 
cross apply sys.dm_exec_sql_text (s.sql_handle) t 
where d.name like '%XXX%'
order by s.last_batch 
