
CREATE FUNCTION [dbo].[fncGetDenialReasons](@Case_id varchar(50))
returns varchar(8000) as
BEGIN
		DECLARE @OutputString VARCHAR(8000)
		DECLARE @tblDenial AS TABLE (DenialReason VARCHAR(500))

		INSERT INTO @tblDenial
		select distinct tblDenialReasons.DenialReasons_Type  from tbltreatment 
		INNER JOIN tblDenialReasons on tbltreatment.DenialReason_ID = tblDenialReasons.DenialReasons_Id
		where  case_id= @Case_id
		UNION
		SELECT Distinct tblDenialReasons.DenialReasons_Type  from tblTreatment 
		INNER JOIN TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
		INNER JOIN tblDenialReasons on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
		where  case_id= @Case_id

	SET @OutputString=(SELECT(SELECT COALESCE(CAST(DenialReason AS VARCHAR(MAX))+', ','')   
	FROM			@tblDenial  FOR XML PATH('')) AS aaa); 

	if 	len(@OutputString) >1
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

	-- SELECT @denialreason_type AS DenialReason
	Return @OutputString

 --DECLARE @denialreason VARCHAR(200)
 --DECLARE CUR_Denial CURSOR
 --FOR 
 
 
	--	select distinct tblDenialReasons.DenialReasons_Type from tbltreatment 
	--	INNER JOIN tblDenialReasons on tbltreatment.DenialReason_ID = tblDenialReasons.DenialReasons_Id
	--	where  case_id= @Case_id
	--UNION
	--	SELECT Distinct  tblDenialReasons.DenialReasons_Type from tblTreatment 
	--	INNER JOIN TXN_tblTreatment on tblTreatment.Treatment_Id = TXN_tblTreatment.Treatment_Id
	--	INNER JOIN tblDenialReasons on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
	--	where  case_id= @Case_id

 --OPEN CUR_Denial
 
 --set @OutputString = ''
 --FETCH CUR_Denial INTO @denialreason
 
 --set @OutputString = ''
 --WHILE @@FETCH_STATUS = 0
 -- BEGIN
 --  set @OutputString = @OutputString +  @denialreason + ', '
 --  FETCH CUR_Denial INTO @denialreason
 -- END
 -- CLOSE CUR_Denial
 --DEALLOCATE CUR_Denial

	--if 	len(@OutputString) >1
	--	set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 --RETURN @OutputString 
END
