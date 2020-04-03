CREATE FUNCTION [dbo].[fncGetDenialReasonsBYid](@id varchar(50))
returns varchar(8000) as
BEGIN
 DECLARE @denialreason VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CUR_Denial CURSOR
 FOR 
	SELECT ISNULL(Reasons.DenialReasons_Type,'')  AS DenialReasons_Type from tblTreatment (nolock)
	LEFT OUTER JOIN tblDenialReasons  Reasons (NOLOCK) on  Reasons.DenialReasons_Id=tblTreatment.DenialReason_ID 
	where Treatment_Id=@id
	UNION
	select  distinct tblDenialReasons.DenialReasons_Type from tblDenialReasons
	INNER JOIN TXN_tblTreatment on tblDenialReasons.DenialReasons_Id = TXN_tblTreatment.DenialReasons_Id
	WHERE TXN_tblTreatment.Treatment_Id = @id
	  
	  
	 
 OPEN CUR_Denial
 
 set @OutputString = ''
 FETCH CUR_Denial INTO @denialreason
 
 set @OutputString = ''
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @denialreason + ', '
   FETCH CUR_Denial INTO @denialreason
  END
  CLOSE CUR_Denial
 DEALLOCATE CUR_Denial

	if 	len(@OutputString) >1
		set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 RETURN @OutputString 
END
