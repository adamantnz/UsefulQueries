DECLARE @shard VARCHAR(100)
	,@shardname VARCHAR(100)
	,@sql VARCHAR(max)

DECLARE myCursor INSENSITIVE CURSOR
FOR
SELECT substring(NAME, 8, len(NAME))
	,NAME
FROM sys.servers
WHERE 1 = 1
	AND NAME NOT IN ('condition')

OPEN myCursor

FETCH NEXT
FROM myCursor
INTO @shard
	,@shardName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sql = 'SELECT *  
	FROM OPENQUERY(' + @shardName + ',''Select ' + @shard + ',max(sequence) from  [XeroV3_' + @shard + '].dbo.TableName'')'

	-- PRINT (@sql)
	-- EXEC (@sql)

	--select @shard
	FETCH NEXT
	FROM myCursor
	INTO @shard
		,@shardName
END

CLOSE myCursor

DEALLOCATE myCursor
