
CREATE PROCEDURE [dbo].[GreenBillsInsurance_Retrive] -- Report_Statute_Of_Limitation 'AAA_6YR_UNFILED'
(
	@s_a_GB_Insurance   VARCHAR(200),
	@s_a_DomainId		VARCHAR(200)
)
AS
BEGIN
	 
	SET NOCOUNT ON;

    IF(@s_a_GB_Insurance = 'All')
    BEGIN
		 
		SELECT DISTINCT GB.ID,
						GB.INSURANCECOMPANY_ID,
						CompanyName, 
						InsuranceName + ' '+ InsuranceAddress + ' '+InsuranceCity+ ' '+InsuranceZip+ ' '+InsuranceState AS [GB_Insurance],
						--(SELECT TOP 1 InsuranceCompany_Name  +' '+ InsuranceCompany_Local_Address from tblInsuranceCompany 
						--WHERE    InsuranceCompany_Id = GB.INSURANCECOMPANY_ID) AS INSURANCECOMPANY 
						InsuranceCompany_Name AS [INSURACE_COMPANY]
		FROM	 GreenBillsInsurance GB 

		INNER JOIN XN_TEMP_GBB_ALL XN  ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.insurancecompanyid=GB.SZ_INSURANCE_ID and GB.Gbb_Type =XN.GBB_Type AND XN.DomainId =@s_a_DomainId
		LEFT OUTER JOIN tblInsuranceCompany P  ON P.InsuranceCompany_Id = GB.INSURANCECOMPANY_ID  AND  P.DomainId =  @s_a_DomainId
		 
	END
	ELSE IF(@s_a_GB_Insurance = 'UnAssign')
    BEGIN
		 
		SELECT DISTINCT GB.ID,
						GB.INSURANCECOMPANY_ID,
						CompanyName, 
						InsuranceName + ' '+ InsuranceAddress + ' '+InsuranceCity+ ' '+InsuranceZip+ ' '+InsuranceState AS [GB_Insurance],
						--(SELECT TOP 1 InsuranceCompany_Name  +' '+ InsuranceCompany_Local_Address from tblInsuranceCompany,
						InsuranceCompany_Name AS [INSURACE_COMPANY] 
	
		FROM		GreenBillsInsurance GB 

		INNER JOIN XN_TEMP_GBB_ALL XN  ON XN.CompanyId = GB.SZ_COMPANY_ID AND XN.insurancecompanyid=GB.SZ_INSURANCE_ID and GB.Gbb_Type =XN.GBB_Type  AND XN.DomainId =@s_a_DomainId
		LEFT OUTER JOIN tblInsuranceCompany P  ON P.InsuranceCompany_Id = GB.INSURANCECOMPANY_ID  AND  P.DomainId =  @s_a_DomainId
		WHERE InsuranceCompany_Name is null 
		 
	END
	
    
END








