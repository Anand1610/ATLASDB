CREATE PROCEDURE [dbo].[OPENCASESTOBEPRINTED]--'9','2010','0'
(
@month varchar(10),
@year varchar(10),
@chk varchar(10)
)
AS
BEGIN
SET NOCOUNT ON
CREATE TABLE #TEMP(CASE_ID VARCHAR(50),AOB INT, BILLS INT, MEDICALS INT)

declare
@cid varchar(50)
DECLARE MYCUR CURSOR LOCAL FOR
select case_id from tblCase where ISNULL(IsDeleted,0) = 0 and  status='OPEN' ORDER BY DATE_OPENED

open MYCUR
fetch next from MYCUR into @cid
while @@fetch_status=0
begin
INSERT INTO #TEMP
SELECT @CID,(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=@CID AND DOCUMENTID='11' and deleteflag=0 and documentid <> '-1'),
(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=@CID AND DOCUMENTID='13' and deleteflag=0 and documentid <> '-1'),
(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=@CID AND DOCUMENTID='29' and deleteflag=0 and documentid <> '-1')

fetch next from MYCUR into @cid
end
CLOSE MYCUR
DEALLOCATE MYCUR
if @month = 0 and @year = 0 
begin
	if @chk = 1
		begin
			SELECT A.*,DATE_OPENED, ISNULL(B.InjuredParty_FirstName, N'') + N'  ' + ISNULL(B.InjuredParty_LastName, N'') as INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME 
			FROM #TEMP A INNER JOIN tblcase B with(nolock) ON A.CASE_ID=B.CASE_ID  
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON B.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON B.Provider_Id = dbo.tblProvider.Provider_Id where aob > 0 AND ISNULL(B.IsDeleted,0) = 0
			ORDER BY AOB DESC,B.DATE_OPENED
		end
	else
		begin
			SELECT A.*,DATE_OPENED,ISNULL(B.InjuredParty_FirstName, N'') + N'  ' + ISNULL(B.InjuredParty_LastName, N'') as INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME 
			FROM #TEMP A INNER JOIN 
			tblcase B with(nolock) ON A.CASE_ID=B.CASE_ID 
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON B.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON B.Provider_Id = dbo.tblProvider.Provider_Id
			WHERE ISNULL(B.IsDeleted,0) = 0
			ORDER BY AOB DESC,B.DATE_OPENED
		end
end
else
begin
	if @chk = 1
		begin
			SELECT A.*,DATE_OPENED,ISNULL(B.InjuredParty_FirstName, N'') + N'  ' + ISNULL(B.InjuredParty_LastName, N'') as INJUREDPARTY_NAME,PROVIDER_NAME,
			INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN 
			tblcase B with(nolock) ON A.CASE_ID=B.CASE_ID  
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON B.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON B.Provider_Id = dbo.tblProvider.Provider_Id
			where year(date_opened) = @year and month(date_opened) = @month and aob > 0 AND  ISNULL(B.IsDeleted,0) = 0
			ORDER BY AOB DESC,B.DATE_OPENED
		end
	else
		begin
			SELECT A.*,DATE_OPENED,ISNULL(B.InjuredParty_FirstName, N'') + N'  ' + ISNULL(B.InjuredParty_LastName, N'') as INJUREDPARTY_NAME,
			PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A 
			INNER JOIN tblcase B with(nolock) ON A.CASE_ID=B.CASE_ID 
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON B.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON B.Provider_Id = dbo.tblProvider.Provider_Id
			where year(date_opened) = @year and month(date_opened) = @month  AND  ISNULL(B.IsDeleted,0) = 0
			
			ORDER BY AOB DESC,B.DATE_OPENED
		end
end
DROP TABLE #TEMP
END

