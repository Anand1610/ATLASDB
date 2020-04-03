
CREATE FUNCTION [dbo].[fncGetBillNumber](@Case_id varchar(50))
returns varchar(MAX) as
BEGIN


	DECLARE @OutputString VARCHAR(8000)
		DECLARE @tbl AS TABLE (BILL_NUMBER VARCHAR(100))

		INSERT INTO @tbl
		select distinct BILL_NUMBER  from tbltreatment (nolock)
		where  case_id= @Case_id and BILL_NUMBER IS NOT NULL and BILL_NUMBER <> ''
		

	SET @OutputString=(SELECT(SELECT COALESCE(CAST(BILL_NUMBER AS VARCHAR(MAX))+', ','')   
	FROM			@tbl  FOR XML PATH('')) AS aaa); 

	if 	len(@OutputString) >1
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

	-- SELECT @denialreason_type AS DenialReason
	Return @OutputString


 --DECLARE @Bill_Number VARCHAR(200)
 --DECLARE @OutputString VARCHAR(8000)
 
 --DECLARE CUR_Notes CURSOR
 --FOR select distinct Bill_Number from tbltreatment where case_id=@Case_id 
 
 --OPEN CUR_Notes
 
 --set @OutputString = ''
 --FETCH CUR_Notes INTO @Bill_Number
 
 --set @OutputString = ''
 --WHILE @@FETCH_STATUS = 0
 -- BEGIN
 --  set @OutputString = @OutputString +  @Bill_Number + convert(varchar(200),',')
 --  FETCH CUR_Notes INTO @Bill_Number
 -- END
 -- CLOSE CUR_Notes
 --DEALLOCATE CUR_Notes

	--if 	len(@OutputString) >0
	--	set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 --RETURN @OutputString 
END
