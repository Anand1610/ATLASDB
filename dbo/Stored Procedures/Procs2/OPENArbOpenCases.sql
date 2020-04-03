CREATE PROCEDURE [dbo].[OPENArbOpenCases]--[OPENArbOpenCases]'1','2012','0'
(
	@month varchar(10),
	@year varchar(10),
	@chk varchar(10)
)
AS
BEGIN
SET NOCOUNT ON
	if @month = 0 and @year = 0 
	begin
		if @chk = 1
			begin
				SELECT Case_Id, CONVERT(VARCHAR(10),Date_Opened,101) As DATE_OPENED,ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')  
				AS INJUREDPARTY_NAME, PROVIDER_NAME, INSURANCECOMPANY_NAME,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id AND DOCUMENTID='11' and deleteflag=0 and documentid <> '-1') AOB,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='13' and deleteflag=0 and documentid <> '-1') BILLS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='29' and deleteflag=0 and documentid <> '-1') MEDICALS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') as Images
				FROM tblcase cas 
				INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
				INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
				where status='AAA Open' AND  ISNULL(cas.IsDeleted,0) = 0
				and (SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') > 0
			
				--SELECT A.*,DATE_OPENED,INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN LCJ_VW_CASESEARCHDETAILS B ON A.CASE_ID=B.CASE_ID where aob > 0 ORDER BY A.Images,B.DATE_OPENED DESC,AOB DESC
			end
		else
			begin
				SELECT Case_Id, CONVERT(VARCHAR(10),Date_Opened,101) As DATE_OPENED, 
				ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')  as INJUREDPARTY_NAME, PROVIDER_NAME, INSURANCECOMPANY_NAME,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id AND DOCUMENTID='11' and deleteflag=0 and documentid <> '-1') AOB,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='13' and deleteflag=0 and documentid <> '-1') BILLS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='29' and deleteflag=0 and documentid <> '-1') MEDICALS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') as Images
				FROM tblcase cas 
				INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
				INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
				where status='AAA Open' AND  ISNULL(cas.IsDeleted,0) = 0
				--SELECT A.*,DATE_OPENED,INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN LCJ_VW_CASESEARCHDETAILS B ON A.CASE_ID=B.CASE_ID ORDER BY A.Images,B.DATE_OPENED DESC,AOB DESC 
			end
	end
	else
	begin
		if @chk = 1
			begin
				SELECT Case_Id, CONVERT(VARCHAR(10),Date_Opened,101) As DATE_OPENED, 
				ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')  as INJUREDPARTY_NAME, PROVIDER_NAME, INSURANCECOMPANY_NAME,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id AND DOCUMENTID='11' and deleteflag=0 and documentid <> '-1') AOB,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='13' and deleteflag=0 and documentid <> '-1') BILLS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='29' and deleteflag=0 and documentid <> '-1') MEDICALS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') as Images
				FROM tblCase cas 
				
				INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
				INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
				where status='AAA Open' AND  ISNULL(cas.IsDeleted,0) = 0 and year(date_opened) = @year and month(date_opened) = @month 
				and (SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') > 0
				
				--SELECT A.*,DATE_OPENED,INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN LCJ_VW_CASESEARCHDETAILS B ON A.CASE_ID=B.CASE_ID 
				--where year(date_opened) = @year and month(date_opened) = @month and aob > 0 ORDER BY A.Images,B.DATE_OPENED,AOB DESC
			end
		else
			begin
				SELECT Case_Id, CONVERT(VARCHAR(10),Date_Opened,101) As DATE_OPENED, 
				ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')  as INJUREDPARTY_NAME, PROVIDER_NAME, INSURANCECOMPANY_NAME,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id AND DOCUMENTID='11' and deleteflag=0 and documentid <> '-1') AOB,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='13' and deleteflag=0 and documentid <> '-1') BILLS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND DOCUMENTID='29' and deleteflag=0 and documentid <> '-1') MEDICALS,
				(SELECT COUNT(*) FROM TBLIMAGES WHERE CASE_ID=cas.Case_Id  AND deleteflag=0 and documentid <> '-1') as Images
				FROM tblCase cas  
				INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
				INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
				where status='AAA Open' AND  ISNULL(cas.IsDeleted,0) = 0 and year(date_opened) = @year and month(date_opened) = @month 
				
				--SELECT A.*,DATE_OPENED,INJUREDPARTY_NAME,PROVIDER_NAME,INSURANCECOMPANY_NAME FROM #TEMP A INNER JOIN LCJ_VW_CASESEARCHDETAILS B ON A.CASE_ID=B.CASE_ID where year(date_opened) = @year and month(date_opened) = @month ORDER BY A.Images,B.DATE_OPENED,AOB DESC
			end
	end

END

