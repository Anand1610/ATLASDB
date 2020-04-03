CREATE PROCEDURE [dbo].[GetLawFirms]
@DomainId nvarchar(50) = ''
AS
BEGIN
		SELECT AccountDomain,LawFirmId,DomainId,EmailSendTo, LawFirmName FROM DomainAccounts where (@DomainId = '' or DomainId = @DomainId)
		--and domainid='BT'
END

