
CREATE FUNCTION [dbo].[fncGetAccountNumber](@Case_id varchar(40))
returns varchar(MAX) as
BEGIN


	DECLARE @OutputString VARCHAR(8000)
		DECLARE @tbl AS TABLE (Account_Number VARCHAR(100))

		INSERT INTO @tbl
		select distinct Account_Number  from tbltreatment (nolock)
		where  case_id= @Case_id and Account_Number IS NOT NULL and Account_Number <> ''
		

	SET @OutputString=(SELECT(SELECT COALESCE(CAST(Account_Number AS VARCHAR(MAX))+', ','')   
	FROM			@tbl  FOR XML PATH('')) AS aaa); 

	if 	len(@OutputString) >1
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

	-- SELECT @denialreason_type AS DenialReason
	Return @OutputString


 --DECLARE @Account_Number VARCHAR(200)
 --DECLARE @OutputString VARCHAR(8000)
 
 --DECLARE CUR_Notes CURSOR
 --FOR select distinct Account_Number from tbltreatment where case_id=@Case_id 
 
 --OPEN CUR_Notes
 
 --set @OutputString = ''
 --FETCH CUR_Notes INTO @Account_Number
 
 --set @OutputString = ''
 --WHILE @@FETCH_STATUS = 0
 -- BEGIN
 --  set @OutputString = @OutputString +  @Account_Number + convert(varchar(200),',')
 --  FETCH CUR_Notes INTO @Account_Number
 -- END
 -- CLOSE CUR_Notes
 --DEALLOCATE CUR_Notes

	--if 	len(@OutputString) >0
	--	set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 --RETURN @OutputString 
END
