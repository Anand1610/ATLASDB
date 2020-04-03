CREATE PROCEDURE [dbo].[F_DDL_Attorney_For_Settlements]
(
	@i_a_Value INT
)	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT  '0' AS Attorney_AutoId, ' ---Select Attorney--- ' AS Attorney_Name
	UNION 
	Select Attorney_AutoId, 
	LTRIM(RTRIM(Upper(ISNULL(Attorney_LastName, '')+ ' '+ISNULL(Attorney_FirstName,'') + ' =>' + 
	'[Att.Ph#: ' + Attorney_Phone +'] / ' + '[Def.: ' + ISNULL(Defendant_Name, '') + ' / ' + 'Def.Ph#: ' + ISNULL(Defendant_Phone,'') + ' / ' + 'Def.Fax#: ' + ISNULL(Defendant_Fax,'') + ']'))) 
	AS Attorney_Name
	FROM tblattorney 
	INNER JOIN tbldefendant on tblattorney.Defendant_id=tbldefendant.Defendant_id 
	WHERE tblattorney.Defendant_Id = @i_a_Value and tbldefendant.Defendant_Id <> '0' and tbldefendant.Defendant_Name NOT LIKE '%select%'
	
	
	--select * from tblattorney
	-- select * from tbldefendant
	SET NOCOUNT OFF ; 


END

