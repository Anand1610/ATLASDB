CREATE PROCEDURE [dbo].[Delete_Denial_Reasons]
	@DomainId NVARCHAR(50),
	@I_txn_Treatment_Id int
as
   declare @caseid varchar(50) 

   select top 1 @caseid= case_id from tbltreatment where 
   treatment_id in (select treatment_id from  TXN_tblTreatment where I_txn_Treatment_Id =@I_txn_Treatment_Id and domainid=@DomainId)

	Delete From TXN_tblTreatment 
	Where I_txn_Treatment_Id =@I_txn_Treatment_Id and DomainId=@DomainId

	EXEC Update_Denial_Case @Caseid =@caseid

