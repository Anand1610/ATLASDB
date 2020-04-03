CREATE PROCEDURE [dbo].[CPT_Details_Retrive] -- [CPT_Details_Retrive] 'AMT18-102787','AMT'
 -- Add the parameters for the stored procedure here
   
 @s_a_Case_id   NVARCHAR(20) = '',  
 @s_a_DomainID  NVARCHAR(50) = '' 
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

    -- Insert statements for procedure here
 
select 
	CPT_ATUO_ID as TCPT_ATUO_ID,
	Code as TCPT_Code,
	Description as TDescription, 
	DOS,
	ISNULL(b.collectedAmount,0.0) as TPrev_Collected_Amount,
	0.00 AS TCurrent_Paid,
	0.00 AS TEdit_Amount,

	ISNULL(Intrest,0.00) AS TPrev_Intrest,
	0.00 AS TInterest_Paid,
	0.00 AS TEdit_Intrest,
	
	ISNULL(Deductible,0.00) TPrev_Deductible,
	0.00 TDeductible,
	0.00 AS TEdit_Deductible,
	
	ISNULL(b.AttorneyFee,0.00) TPrev_AttorneyFee,
	0.00 TAttorneyFee,
	0.00 AS TEdit_AttorneyFee,

	ISNULL(LITCollectedAmount,0.0) as TPrev_LIT_Collected_Amount,
	0.00 AS TCurrent_LIT_Paid,
	0.00 AS TEdit_LIT_Paid,

	ISNULL(LITIntrest,0.00) AS TPrev_LIT_Intrest,
	0.00 AS TInterest_LIT_Paid,
	0.00 AS TEdit_LIT_Intrest,

	ISNULL(b.LITFees,0.00) TPrev_LIT_Fees,
	0.00 TLITFees,
	0.00 AS TEdit_LITFees,

	ISNULL(b.CourtFees,0.00) TPrev_LIT_CourtFee,
	0.00 TCourtFees,
	0.00 AS TEdit_CourtFees

from BILLS_WITH_PROCEDURE_CODES b
INNER JOIN tblTreatment t ON 
 ((ISNULL(b.BillNumber,'') = ISNULL(t.BILL_NUMBER,'') AND ISNULL(t.BILL_NUMBER,'') <> '')
   OR Treatment_id = ISNULL(fk_Treatment_Id,0)) AND b.DomainID = @s_a_DomainID
where
 t.Case_Id=@s_a_Case_id
 AND b.DomainId=@s_a_DomainID
END

