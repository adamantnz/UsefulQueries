
/* 
-- Super useful way to identity where a table/view/column etc are being used in stored procs, functions etc
-- credit: http://www.kodyaz.com/articles/where-used-list-search-sql-database-objects-text.aspx
*/
USE [DB_Name]
DECLARE 
 @SearchString nvarchar(max) = 'SearchString'
BEGIN

SELECT
 USER_NAME(uid) [user],
 name,
 CASE xtype
  WHEN 'FN' THEN 'Function'
  WHEN 'P' THEN 'Stored procedure'
  WHEN 'TF' THEN 'Function'
  WHEN 'TR' THEN 'Trigger'
  WHEN 'V' THEN 'View'
  ELSE xtype
 END [type],
 'sp_helptext ''' + USER_NAME(uid) + '.' + name + ''''
   AS 'sp_helptext command'
FROM sysobjects (NoLock)
WHERE Id IN (
 SELECT
  DISTINCT id
 FROM syscomments (NoLock)
 WHERE [text] LIKE '%' + @SearchString + '%'
)

END