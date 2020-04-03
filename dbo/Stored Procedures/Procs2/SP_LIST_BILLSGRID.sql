
CREATE PROCEDURE [dbo].[SP_LIST_BILLSGRID]  --[SP_LIST_BILLSGRID] 'af', 'AF19-104509'    
@DomainId NVARCHAR(50),    
 @CASE_ID NVARCHAR(50)            
AS            
BEGIN    

select t1.Treatment_Id,sum(ISNULL(t3.RegionIVfeeScheduleAmount,0)) [RegionIVfeeScheduleAmount] into #temp from tblTreatment t1 (nolock)
join BILLS_WITH_PROCEDURE_CODES   t2 (nolock)
on t1.Treatment_Id=t2.fk_Treatment_Id and t1.Case_Id=@CASE_ID
join MST_PROCEDURE_CODES  t3   on t2.Auto_Proc_id=t3.Auto_Proc_id and t3.DomainId=@DomainId
GROUP BY t1.Treatment_Id

  Select rank() OVER (Order by DateOfService_Start,DateOfService_End,tblTreatment.Treatment_Id   asc ) as rank,            
  ISNULL(tblTreatment.Treatment_Id,'N/A')[Treatment_Id],            
  ISNULL(Case_Id,'N/A')[Case_Id],    
  '<TABLE  width="100%" border="0"><TR>'    
    + '<TD width="2px" bgcolor="'    
    + CASE  WHEN ((isnull(Claim_Amount,0.00) - isnull(Paid_Amount,0.00)) <= 0.00    OR ((Reasons.DENIALREASONS_TYPE='PAID IN FULL') ))
     THEN 'RED'    
     ELSE 'YELLOW' END      
    +'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>'    
    + '</TR></TABLE>' [Paid_NotPaid],    
  ISNULL(convert(nvarchar(20),DateOfService_Start,101),'N/A')[DateOfService_Start],            
  ISNULL(convert(nvarchar(20),DateOfService_End,101),'N/A')[DateOfService_End],       
  ISNULL(convert(nvarchar(20),Refund_Date,101),'')[Refund_Date],       
  ISNULL(convert(nvarchar(50),Claim_Amount),'0.00')[Claim_Amount],            
  ISNULL(convert(nvarchar(50),Paid_Amount),'0.00')[Paid_Amount],     
  ISNULL(convert(nvarchar(50),WriteOff),'0.00')[WriteOff],      
  convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)  - convert(float,isnull(WriteOff,0)) - ISNULL(DeductibleAmount,0.00) ))) as Claim_Balance,      
  ISNULL(Fee_Schedule,0.00)  AS Fee_Schedule,          
  CASE WHEN @DomainId = 'AF'
  THEN convert(decimal(38,2),(convert(money,convert(float,Fee_Schedule) - convert(float,Paid_Amount) - convert(float,isnull(WriteOff,0)) - ISNULL(DeductibleAmount,0.00))))
  ELSE convert(decimal(38,2),(convert(money,convert(float,Fee_Schedule) - convert(float,Paid_Amount) - convert(float,isnull(WriteOff,0)))))
  END AS FS_Balance,    
  ISNULL(convert(nvarchar(20),convert(varchar,Date_BillSent),101),'')[Date_BillSent],            
  ISNULL(convert(varchar(max),SERVICE_TYPE),'')[SERVICE_TYPE],       
  CASE WHEN ISNULL(DenialReason_ID,0) = '0' THEN '' ELSE ISNULL(Reasons.DenialReasons_Type,'') END  as DENIALREASONS_TYPE,    
  (SELECT COUNT(*) FROM TXN_TBLTREATMENT WHERE TREATMENT_ID = tblTreatment.TREATMENT_ID) AS DENIAL_COUNT,    
  ISNULL(RDR.Doctor_Name,'') as DOCTOR_NAME ,    
  (SELECT COUNT(*) FROM TXN_CASE_PEER_REVIEW_DOCTOR WHERE TREATMENT_ID=tblTreatment.TREATMENT_ID) AS [DCOUNT],    
   ISNULL(ODR.Doctor_Name,'') as Treating_Doctor,    
  (SELECT COUNT(*) FROM txn_case_treating_doctor WHERE TREATMENT_ID=tblTreatment.Treatment_Id) As [TreatingDoc_COUNT],    
  ISNULL(Account_Number,Isnull(Account_Number,'')) AS Account_Number,    
  ISNULL(Bill_Number,Isnull(Bill_Number,'')) AS Bill_Number,    
  ISNULL(Action_Type,'N/A') AS Action_Type,       
      
  '' as Operating_Doctor,    
  ISNULL(convert(nvarchar(50),Claim_Amount-Paid_Amount),'0.00') [Balance_Amount],    
  ISNULL(ACT_CASE_ID,'') AS ACT_CASE_ID,
  ISNULL(DeductibleAmount,'0.00') [Deductible_Amount],
  ISNULL(convert(nvarchar(50),T.RegionIVfeeScheduleAmount),'0.00')[RegionIVfeeScheduleAmount]
  from tblTreatment  as tblTreatment (NOLOCK)    
  LEFT OUTER JOIN tblDenialReasons  Reasons (NOLOCK) on   Reasons.DenialReasons_Id=tblTreatment.DenialReason_ID     
  LEFT OUTER JOIN TblReviewingDoctor  RDR (NOLOCK) ON RDR.Doctor_id=tblTreatment.PeerReviewDoctor_ID    
  LEFT OUTER JOIN tblOperatingDoctor  ODR (NOLOCK) ON ODR.Doctor_id=tblTreatment.TreatingDoctor_ID 
  LEFT JOIN #temp T ON T.Treatment_Id=  tblTreatment.Treatment_Id 
  where Case_Id=@CASE_ID     
  AND tblTreatment.DomainId=@DomainId    
  Order by rank    
    
    
END    
