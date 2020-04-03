CREATE PROCEDURE [dbo].[LCJ_DDL_DefendantNames]
(
@DomainId NVARCHAR(50)
)
AS
begin

	SELECT '0' as Defendant_Id,' --- Select Adversary Attorney Name --- ' as Defendant_Name
	Union
	SELECT    DISTINCT Defendant_Id, Upper(ISNULL(Defendant_DisplayName, '')) AS Defendant_Name
	FROM         tblDefendant
	WHERE     (1 = 1) AND (ACTIVE=1) and DomainId=@DomainId
	order by defendant_name

end

