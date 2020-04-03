CREATE PROCEDURE [dbo].[GET_POM_CASES]
	@POM_ID INT
AS
BEGIN
	select CASE_ID,ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') as Injuredparty_name,
	Provider_name,Insurancecompany_name,Ins_Claim_Number,
	isnull( CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DateOfService_Start), 101),'') as DOS_Start, isnull(CONVERT(NVARCHAR(12), CONVERT(DATETIME,     
                      cas.DateOfService_End), 101),'') as DOS_End, Accident_Date, 
	isnull(claim_amount,0.00) as claim_amount,
	InsuranceCompany_Perm_Address As InsuranceCompany_Address,
	InsuranceCompany_Perm_City As InsuranceCompany_City,
	InsuranceCompany_Perm_State As InsuranceCompany_State,
	InsuranceCompany_Perm_Zip As InsuranceCompany_Zip from tblcase cas with(nolock)
	INNER JOIN  dbo.tblInsuranceCompany INS WITH (NOLOCK) ON cas.InsuranceCompany_Id = INS.InsuranceCompany_Id 
	INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON cas.Provider_Id = pro.Provider_Id 
	WHERE CASE_ID IN(SELECT CASE_ID FROM TBLPOMCASE WITH (NOLOCK)  WHERE POM_ID=@POM_ID) 
	and ISNULL(cas.IsDeleted,0) = 0
END

