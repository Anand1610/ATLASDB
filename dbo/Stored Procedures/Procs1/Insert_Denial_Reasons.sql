CREATE PROCEDURE [dbo].[Insert_Denial_Reasons]
	@DomainId NVARCHAR(50),
	@Treatment_Id int,
	@DenialReasons_Id int,
	@Action_Type nvarchar(100),
	@DenialReasons_Date datetime = null,
	@IMEDate datetime = null,
    @Note  NVARCHAR(300)=NULL


as
BEGIN
--DECLARE @CASE_ID NVARCHAR(500)
--SET @CASE_ID = (SELECT TOP 1 CASE_ID FROM TBLTREATMENT WHERE Treatment_Id = @Treatment_Id)
IF Not Exists(Select I_txn_Treatment_Id From TXN_tblTreatment (NOLOCK) Where Treatment_Id=@Treatment_Id and DenialReasons_Id=@DenialReasons_Id and DomainId=@DomainId)
	Begin
		
		DECLARE @dt_l_Denial_Posted DATETIME 

		IF(@DenialReasons_Id IS NOT NULL)
			SET @dt_l_Denial_Posted = GETDATE()

			declare @caseid varchar(50) 

			select top 1 @caseid= case_id from tblTreatment where treatment_id =@Treatment_Id and domainid=@DomainId

		INSERT INTO TXN_tblTreatment
		(
			Treatment_Id,
			DenialReasons_Id,
			Action_Type,
			DomainId,
			DenialReasons_Date,
			IMEDate,
			Denial_Posted_Date,
			Notes
		)
		values
		(
			@Treatment_Id,
			@DenialReasons_Id,
			@Action_Type,
			@DomainId,
			@DenialReasons_Date,
			@IMEDate,
			@dt_l_Denial_Posted,
			@Note
		)

		EXEC Update_Denial_Case @Caseid =@caseid

		Return 1
	End
Else
	Begin
		Return -1
	End

END

