CREATE PROCEDURE [dbo].[F_DDL_DefendantNames]
AS
BEGIN
	SELECT    DISTINCT Defendant_Id, Upper(ISNULL(Defendant_DisplayName, '')) AS Defendant_Name
	FROM         tblDefendant
	WHERE     (1 = 1) AND (ACTIVE=1) 
ORDER BY defendant_name
END

