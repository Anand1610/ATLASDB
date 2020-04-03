CREATE PROCEDURE [dbo].[LCJ_getPaymentTreatments] --[LCJ_getPaymentTreatments]178036  
(      
 @DomainId NVARCHAR(50),  
   @Treatment_Id INT=NULL      
)      
AS      
BEGIN      
  SELECT      
    Treatment_Id,      
    Case_Id,      
    convert(nvarchar(20),DateOfService_Start,101) DateOfService_Start,      
    convert(nvarchar(20),DateOfService_End,101) DateOfService_End,      
	convert(nvarchar(20),Refund_Date,101) Refund_Date,   
    Claim_Amount,      
    Paid_Amount,      
    convert(nvarchar(20),Date_BillSent,101) Date_BillSent,     
    SERVICE_TYPE,  
    Account_Number,  
    BILL_NUMBER,  
    Fee_Schedule,  
    DenialReason_ID,  
    convert(nvarchar(20),DenialDate,101) as DenialDate,  
    PeerReviewDoctor_ID,  
    TreatingDoctor_ID,  
    convert(nvarchar(20),IMEDate,101) as IMEDate,  
    Notes,  
    WriteOff,
	ISNULL(DeductibleAmount,0.00) AS DeductibleAmount
    FROM   
  tblTreatment      
  WHERE   
  Treatment_Id=@Treatment_Id      
  and DomainId=@DomainId  
   
  
   
END  
  
