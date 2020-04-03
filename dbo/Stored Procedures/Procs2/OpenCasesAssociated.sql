CREATE PROCEDURE [dbo].[OpenCasesAssociated]--[OpenCasesAssociated] '^FH11-81437^,^FH11-86812^,^FH12-93289^,^FH12-93313^,^FH12-93318^,^FH12-93293^,^FH12-93297^,^FH12-93308^,^FH12-93549^,^FH12-93566^',1
(
	@cases nvarchar(3900),
	@chk varchar(10)
)
AS
BEGIN
SET NOCOUNT ON
declare
@sqlst nvarchar(4000)

set @sqlst=''

	if @chk = 1
			begin
			
			set @cases = Replace(@cases,'^','''')
			print @cases
			
			set @sqlst=	'SELECT Case_Id, CONVERT(VARCHAR(10),Date_Opened,101) As DATE_OPENED, INJUREDPARTY_NAME, PROVIDER_NAME, INSURANCECOMPANY_NAME,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=LC.Case_Id AND DOCUMENTID=''11'' and deleteflag=0 and documentid <> ''-1'') AOB,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=LC.Case_Id  AND DOCUMENTID=''13'' and deleteflag=0 and documentid <> ''-1'') BILLS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=LC.Case_Id  AND DOCUMENTID=''29'' and deleteflag=0 and documentid <> ''-1'') MEDICALS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=LC.Case_Id  AND deleteflag=0 and documentid <> ''-1'') as Images
				FROM LCJ_VW_CaseSearchDetails LC where Case_Id in ('+@cases+')
				and (SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=LC.Case_Id  AND deleteflag=0 and documentid <> ''-1'') > 0'
			
			print @sqlst
			exec (@sqlst)
				--SELECT A.*,DATE_OPENED,INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN LCJ_VW_CASESEARCHDETAILS B ON A.CASE_ID=B.CASE_ID where aob > 0 ORDER BY A.Images,B.DATE_OPENED DESC,AOB DESC
			end
		
END

