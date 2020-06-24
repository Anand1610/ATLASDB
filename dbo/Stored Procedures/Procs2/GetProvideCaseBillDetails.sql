--exec GetProvideCaseBillDetails @DomainId=N'BT',@CaseId=N'BT19-100044'
CREATE Procedure [dbo].[GetProvideCaseBillDetails]
@CaseId varchar(50),
@DomainId varchar(40)
as
BEGIN
Select Case_id,ACT_Case_ID,Bill_Number, convert(varchar, DateOfService_Start,101) DateOfService_Start, convert(varchar, DateOfService_End,101) DateOfService_End , Claim_Amount, Fee_schedule, Paid_Amount, SERVICE_TYPE, WriteOFF from tblTreatment with(nolock)
where case_id=@CaseId
and DomainId=@DomainId
END


