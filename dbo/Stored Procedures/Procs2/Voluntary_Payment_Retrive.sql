-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Voluntary_Payment_Retrive]
	@s_a_DomainId varchar(50),
	@s_a_CaseId varchar(50),
	@s_a_Payment_Type varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	Select p.Case_Id,
     Voluntary_Pay_Id
	,Total_Collection
	,Deductible
	,Pre_Interest
	,Voluntary_AF
	,((Total_Collection+Pre_Interest)-(Deductible+Voluntary_AF)) as Net_Voluntary
	,Payment_Type
	,Litigated_Collection
	,Litigated_Interest
	,Litigation_Fees
	,Court_Fees
	,((Litigated_Collection+Litigated_Interest)-(Litigation_Fees+Court_Fees)) as Net_Litigation
	,Convert(varchar(50), Check_Date, 101) as Check_Date
	,Check_No
	,Convert(varchar(50), Transaction_Date, 101) as Transaction_Date
	,Transaction_Description
    ,(InjuredParty_FirstName + ' ' + InjuredParty_LastName) as Patient_Name
	,InsuranceCompany_Name
	--,Convert(varchar(50), DateOfService_Start, 101) as DOS
	,DOS=(SELECT top 1 cod.DOS FROM tbl_CPT_Payment_Details cptpd INNER JOIN BILLS_WITH_PROCEDURE_CODES cod ON cptpd.CPT_ATUO_ID=cod.CPT_ATUO_ID  
		WHERE cptpd.Case_ID=@s_a_CaseId AND cptpd.Domainid=@s_a_DomainID AND cptpd.Transaction_Id=  P.Voluntary_Pay_Id and Current_Paid <> '0.00')
	,Convert(varchar(50), Account_Date, 101) as InvDate  
	,CASE WHEN FirstParty_Litigation = 1 THEN 'Yes'
            ELSE 'No' END AS FirstParty_Litigation
    from tbl_Voluntary_Payment p left join tblCase c on p.Case_Id=c.Case_Id 
    left join tblInsuranceCompany i on i.InsuranceCompany_Id=c.InsuranceCompany_Id
    left join tblTransactions t on t.Transactions_Id = p.Transactions_Id
    left outer join tblClientAccount act on t.invoice_id= act.account_id
	where
	p.Case_Id = @s_a_CaseId and p.DomainId = @s_a_DomainId and Payment_Type = @s_a_Payment_Type

END
