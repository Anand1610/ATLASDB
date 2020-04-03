
CREATE PROCEDURE [dbo].[LCJ_DDL_SettlementScreen_AttorneyNames]

AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' AS Attorney_AutoId , ' --- Select Attorney --- ' AS Attorney_Name
	UNION
	select Attorney_AutoId, 
	LTRIM(RTRIM(Upper(ISNULL(Attorney_LastName, '')+ ' '+ISNULL(Attorney_FirstName,'') + ' =>' + 
	'[Att.Ph#: ' + Attorney_Phone +'] / ' + '[Def.: ' + ISNULL(Defendant_Name, '') + ' / ' + 'Def.Ph#: ' + ISNULL(Defendant_Phone,'') + ' / ' + 'Def.Fax#: ' + ISNULL(Defendant_Fax,'') + ']'))) 
	AS Attorney_Name
	from tblattorney INNER JOIN
	tbldefendant on tblattorney.Defendant_id=tbldefendant.Defendant_id
	ORDER BY 2

END

