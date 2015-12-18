DECLARE

  @query nvarchar(max),
  @cdcTable nvarchar(max) = '',
  @cdcInstance nvarchar(max) = '',
  @DB nvarchar(max) = ''

BEGIN

  SET @query =
  'select column_name, sum(cnt) as change from (
      select __$update_mask, count(*) cnt, sys.fn_cdc_is_bit_set ( c.column_id , __$update_mask ) isset, c.column_id, c.column_name
    FROM '+@cdctable+'
    CROSS APPLY (select column_id, column_name
  FROM '+@DB+'.cdc.change_tables t
  INNER JOIN '+@DB+'.cdc.captured_columns c on t.Object_id = c.object_id
  where capture_instance = '''+@cdcInstance+''') c
  Group by __$update_mask, sys.fn_cdc_is_bit_set ( c.column_id , __$update_mask ), c.column_id, c.column_name
  having sys.fn_cdc_is_bit_set ( c.column_id , __$update_mask ) = 1
  ) a
  group by column_name
  order by 2 desc'

PRINT (@query)
EXEC (@query)

END
