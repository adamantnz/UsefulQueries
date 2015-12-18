DECLARE

   @query NVARCHAR(max)
	,@cdcTable NVARCHAR(max) = ''
	,@cdcInstance NVARCHAR(max) = ''
	,@DB NVARCHAR(max) = ''

BEGIN
	SET @query = 'SELECT column_name, SUM(cnt) as change FROM (
      SELECT __$update_mask, COUNT(*) as cnt, sys.fn_cdc_is_bit_set
        ( c.column_id , __$update_mask ) isset, c.column_id, c.column_name
    FROM '+@cdctable+'
  CROSS APPLY (select column_id, column_name
  FROM '+@DB+'.cdc.change_tables t
    INNER JOIN '+@DB+'.cdc.captured_columns c on t.Object_id = c.object_id
  WHERE capture_instance = '''+@cdcInstance+''') c
  GROUP BY __$update_mask, sys.fn_cdc_is_bit_set ( c.column_id , __$update_mask ),
    c.column_id, c.column_name
  having sys.fn_cdc_is_bit_set ( c.column_id , __$update_mask ) = 1
  ) a
  group by column_name
  order by 2 desc'

	PRINT @query
	EXEC sp_executesql @query
END
