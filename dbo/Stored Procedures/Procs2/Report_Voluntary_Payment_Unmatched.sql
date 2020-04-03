
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_Voluntary_Payment_Unmatched]
-- [Voluntary_Payment_Report] 'amt',@dt_a_invFromDate ='02/01/2019',@dt_a_invToDate ='02/01/2019'
	@s_a_DomainId varchar(50),
	@s_a_status nvarchar(200)='',
	@dt_a_FromDate varchar(50)='',
	@dt_a_ToDate varchar(50)='',
	@i_a_PortfolioId int=0,
	@dt_a_invFromDate nvarchar(50)='',
	@dt_a_invToDate nvarchar(50)='',
	@dt_a_ToclearDate nvarchar(50)='',
	@dt_a_FromclearDate nvarchar(50)=''
AS
BEGIN
	SET NOCOUNT ON;

	If @dt_a_FromDate =''
	 BEGIN
	   Set @dt_a_FromDate = @dt_a_ToDate
	 END
	 Else If @dt_a_ToDate = ''
	 BEGIN
	  Set @dt_a_ToDate = @dt_a_FromDate
	 END

	 If @dt_a_invFromDate =''
	 BEGIN
	   Set @dt_a_invFromDate = @dt_a_invToDate
	 END
	 Else If @dt_a_invToDate = ''
	 BEGIN
	  Set @dt_a_invToDate = @dt_a_invFromDate
	 END

	 If @dt_a_FromclearDate =''
	 BEGIN
	   Set @dt_a_FromclearDate = @dt_a_ToclearDate
	 END
	 Else If @dt_a_ToclearDate = ''
	 BEGIN
	  Set @dt_a_ToclearDate = @dt_a_FromclearDate
	 END

	Select 
	  pf.Description [Project_Code]
	, cpt.CPT_Pay_Id
	, pf.Name as portfolio_name
	, p.Case_Id
	, p.check_no AS check_no
	, ISNULL(cpt.Current_Paid,0.00) AS Total_Collection
	, ISNULL(cpt.Current_Deductible,0.00) AS Deductible
	, ISNULL(cpt.Current_Interest,0.00) AS Pre_Interest
	, ISNULL(cpt.Current_AttorneyFee,0.00) AS Voluntary_AF
	, ((ISNULL(cpt.Current_Paid,0.00)+ISNULL(cpt.Current_Interest,0.00))-(ISNULL(cpt.Current_Deductible,0.00)+ISNULL(cpt.Current_AttorneyFee,0.00))) as Net_Voluntary
	, Payment_Type
	, CONVERT(VARCHAR(10),CONVERT(DATETIME,p.Check_Date), 120) as Check_Date
	, Check_No
	, CONVERT(VARCHAR(10),CONVERT(DATETIME,p.Transaction_Date), 120) as Transaction_Date
	, Transaction_Description
    , InjuredParty_FirstName 
	, InjuredParty_LastName
	, LTRIM(RTRIM(LEFT(i.InsuranceCompany_Name,15))) AS InsuranceCompany_Name
	, b.Code as CPT_Code
	, CONVERT(VARCHAR(10),CONVERT(DATETIME,b.DOS), 120) as DOS
	, b.MOD as MOD
	, CONVERT(VARCHAR(10),CONVERT(DATETIME,cpt.VAL_PAY_Freeze_Date), 120) as InvDate 
	, CASE WHEN FirstParty_Litigation = 1 THEN 'Yes'
            ELSE 'No' END AS FirstParty_Litigation 
	, p.Transaction_Description
	,CONVERT(VARCHAR(10),CONVERT(DATETIME,p.Transaction_Date), 120) as Reconciling_Date
	,CONVERT(VARCHAR(10),CONVERT(DATETIME,cpt.VAL_Cleared_Date), 120) as Cleared_Date
	,cas.Initial_Status
	,iif(cpt.VAL_Cleared_Date is null,'Open','Cleared') as PayStatus
    from tbl_CPT_Payment_Details cpt (NOLOCK) 
	left join tbl_Voluntary_Payment p (NOLOCK) on p.Voluntary_Pay_Id = cpt.Transaction_Id
	left join tblCase cas (NOLOCK) on p.Case_Id=cas.Case_Id 
	left join tblCase_Date_Details cad (NOLOCK) on cad.Case_Id=cas.Case_Id 
	left join BILLS_WITH_PROCEDURE_CODES b (NOLOCK) on b.CPT_ATUO_ID = cpt.CPT_ATUO_ID
    left join tblInsuranceCompany i (NOLOCK) on i.InsuranceCompany_Id=cas.InsuranceCompany_Id
    left join tblTransactions t (NOLOCK) on t.Transactions_Id = p.Transactions_Id
    left outer join tblClientAccount act (NOLOCK) on t.invoice_id= act.account_id
	LEFT OUTER JOIN tbl_Portfolio pf (NOLOCK) on pf.Id = cas.PortfolioId
	where
	p.DomainId = @s_a_DomainId 
	and Payment_Type = 'V'
	AND (@s_a_status = '' OR cas.Status = @s_a_status)
	and ((@dt_a_FromDate = '' and @dt_a_ToDate = '') or Transaction_Date between CONVERT(datetime,@dt_a_FromDate) and CONVERT(datetime,@dt_a_ToDate))
	AND (
		  (@dt_a_invFromDate='' AND @dt_a_invToDate='')
		OR
	     (@dt_a_invFromDate<>'' AND @dt_a_invToDate<>'' AND cpt.VAL_PAY_Freeze_Date BETWEEN CONVERT(datetime,@dt_a_invFromDate) AND CONVERT(datetime,@dt_a_invToDate))
		)		
	AND ( @i_a_PortfolioId = 0 OR cas.PortfolioId = @i_a_PortfolioId)
    AND ISNULL(b.CollectedAmount,0.00) > 0
	AND (
		  (@dt_a_ToclearDate='' AND @dt_a_FromclearDate='')
		OR
	     (@dt_a_FromclearDate<>'' AND @dt_a_ToclearDate<>'' AND cpt.VAL_Cleared_Date BETWEEN CONVERT(datetime,@dt_a_FromclearDate) AND CONVERT(datetime,@dt_a_ToclearDate))
		)	
	AND cas.Initial_Status='Unmatched'
    AND (ISNULL(cpt.Current_Paid,0.00) > 0 or ISNULL(cpt.Current_Deductible,0.00) > 0 or ISNULL(cpt.Current_Interest,0.00) > 0 or ISNULL(cpt.Current_AttorneyFee,0.00) > 0)

END
