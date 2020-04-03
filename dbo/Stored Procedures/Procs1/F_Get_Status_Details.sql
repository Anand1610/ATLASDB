CREATE PROCEDURE [dbo].[F_Get_Status_Details]   --[dbo].[F_Get_Status_Details] 'CLOSED-VOLUNTARY-PAID'     
(
	@s_a_Status VARCHAR(200)
)
AS  
	BEGIN
			select Case_Id,(InjuredParty_LastName+','+InjuredParty_FirstName) as Patient,Provider_Name,
			InsuranceCompany_Name AS INSURANCE_NAME,Ins_Claim_Number,convert(varchar,Date_Opened,101) as Date_Opened,
			convert(varchar,Accident_Date,101) as Accident_Date,
			convert(varchar,ISNULL    
                          ((SELECT     TOP (1) DateOfService_Start    
                              FROM         dbo.tblTreatment AS tblTreatment_1 with(nolock)     
                              WHERE     cas.DomainId = tblTreatment_1.DomainId AND (Case_Id = cast(cas.Case_Id as nvarchar(50)))    
                              ORDER BY DateOfService_Start), N''),101)+'-'+convert(varchar,convert(datetime,cas.DateOfService_End),101) as DOS,
			Fee_Schedule,
		    IndexOrAAA_Number,CONVERT(money, ISNULL(cas.Claim_Amount, 0))    - CONVERT(float, ISNULL(cas.Paid_Amount, 0)) as Balance_Amount  
			from tblcase cas with(nolock) 
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
			INNER JOIN  dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
			where Status like @s_a_Status AND ISNULL(cas.IsDeleted,0) = 0
	END

