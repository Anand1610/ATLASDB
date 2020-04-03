-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_Over_Due]
	-- Add the parameters for the stored procedure here
	@DomainID nvarchar(50),
	@ProviderID int,
	@dt_From VARCHAR(20) = '',
	@dt_To VARCHAR(20) = '',
	@Param NVARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@Param = 'NoIndex')
	BEGIN
		select Case_Id,Pr.Provider_Name,CONCAT(cas.InjuredParty_FirstName, ' , ',cas.InjuredParty_LastName) as InjuredParty_Name,
		CONVERT(VARCHAR(10), cas.DateOfService_Start, 101) +' - '+ CONVERT(VARCHAR(12),cas.DateOfService_End, 101) AS DOS_Range,cas.Claim_Amount,
		CONVERT(VARCHAR(10), cas.Date_Opened, 101) as Date_Opened,
		CONVERT(VARCHAR(10),cas.Date_BillSent,101) AS Date_BillSent ,
		Ins.InsuranceCompany_Name, cas.Paid_Amount,
		CONVERT(VARCHAR(10), cas.Accident_Date, 101) as Accident_Date
		from tblcase cas inner join tblProvider Pr ON cas.Provider_Id=pr.Provider_Id
		inner join tblInsuranceCompany Ins ON Ins.InsuranceCompany_Id=cas.InsuranceCompany_Id
		where cas.domainid=@DomainID 
		AND (ISNULL(IndexOrAAA_Number,'')='')
		AND (@dt_From  = '' OR (cas.Date_Opened BETWEEN CONVERT(DATETIME,@dt_From) AND CONVERT(DATETIME,@dt_To) + 1))
		AND (@ProviderID = 0 OR cas.Provider_Id=@ProviderID)
	END

	ELSE IF(@Param = 'NoPayment-C')
	BEGIN
			select cas.Case_Id,Pr.Provider_Name,CONCAT(cas.InjuredParty_FirstName, ' , ',cas.InjuredParty_LastName) as InjuredParty_Name,
		CONVERT(VARCHAR(10), cas.DateOfService_Start, 101) +' - '+ CONVERT(VARCHAR(12),cas.DateOfService_End, 101) AS DOS_Range,cas.Claim_Amount,
		CONVERT(VARCHAR(10), cas.Date_Opened, 101) as Date_Opened,
		CONVERT(VARCHAR(10),cas.Date_BillSent,101) AS Date_BillSent ,
		Ins.InsuranceCompany_Name, cas.Paid_Amount,
		CONVERT(VARCHAR(10), cas.Accident_Date, 101) as Accident_Date
		from tblcase cas inner join tblProvider Pr ON cas.Provider_Id=pr.Provider_Id	
		inner join tblInsuranceCompany Ins ON Ins.InsuranceCompany_Id=cas.InsuranceCompany_Id	
		inner join tblSettlements St ON St.Case_Id=cas.Case_Id		
		where cas.domainid=@DomainID 
		AND (@dt_From  = '' OR (cas.Date_Opened BETWEEN CONVERT(DATETIME,@dt_From) AND CONVERT(DATETIME,@dt_To) + 1))
		AND (@ProviderID = 0 OR(cas.Provider_Id=@ProviderID))
		AND cas.Case_Id NOt IN(select Case_Id from tblTransactions where DomainId=@DomainID AND transactions_Type='C')
	END

	ELSE IF(@Param = 'NoPayment-AF')
	BEGIN
			select cas.Case_Id,Pr.Provider_Name,CONCAT(cas.InjuredParty_FirstName, ' , ',cas.InjuredParty_LastName) as InjuredParty_Name,
		CONVERT(VARCHAR(10), cas.DateOfService_Start, 101) +' - '+ CONVERT(VARCHAR(12),cas.DateOfService_End, 101) AS DOS_Range,cas.Claim_Amount,
		CONVERT(VARCHAR(10), cas.Date_Opened, 101) as Date_Opened,
		CONVERT(VARCHAR(10),cas.Date_BillSent,101) AS Date_BillSent ,
		Ins.InsuranceCompany_Name, cas.Paid_Amount,
		CONVERT(VARCHAR(10), cas.Accident_Date, 101) as Accident_Date
		from tblcase cas inner join tblProvider Pr ON cas.Provider_Id=pr.Provider_Id
		inner join tblInsuranceCompany Ins ON Ins.InsuranceCompany_Id=cas.InsuranceCompany_Id		
		inner join tblSettlements St ON St.Case_Id=cas.Case_Id		
		where cas.domainid=@DomainID 
		AND (@dt_From  = '' OR (cas.Date_Opened BETWEEN CONVERT(DATETIME,@dt_From) AND CONVERT(DATETIME,@dt_To) + 1))
		AND (@ProviderID = 0 OR(cas.Provider_Id=@ProviderID))
		AND cas.Case_Id NOt IN(select Case_Id from tblTransactions where DomainId=@DomainID AND transactions_Type='AF')
	END

END
