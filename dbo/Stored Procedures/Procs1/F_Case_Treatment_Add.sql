CREATE PROCEDURE [dbo].[F_Case_Treatment_Add]
(
	@i_a_TreatmentId	INT,
	@s_a_CaseId		VARCHAR(100),
	@dt_a_DOSStart		DATETIME= NULL,
	@dt_a_DOSEnd		DATETIME= NULL,
	@dt_a_DOSBillSent	DATETIME= NULL,
	@s_a_BillNumber	VARCHAR(100)= NULL,
	@d_a_Claim		NUMERIC(18,4)= NULL,
	@d_a_Paid			NUMERIC(18,4)= NULL,
	@d_a_FeeSchedule	NUMERIC(18,4)= NULL,
	@s_a_ServiceType	VARCHAR(200) = NULL,	
	@s_a_DenialReason	VARCHAR(1000) = NULL,	
	@s_a_ReviewingDoctor	VARCHAR(1000) = NULL,	
	@s_a_TreattingDoctor	VARCHAR(1000) = NULL,
	@s_a_UserName		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result					INT
	DECLARE @s_l_message				NVARCHAR(500)
	DECLARE @s_l_Notes VARCHAR(200)
	
	IF (@d_a_Claim < @d_a_Paid AND @i_a_TreatmentId = 0)
	BEGIN
		SET @s_l_Notes ='Bill Processing Cancelled.Incorrect Bill amount entered for DOS ' + CONVERT(VARCHAR(20),@dt_a_DOSStart) + ' - ' + CONVERT(VARCHAR(20),@dt_a_DOSEnd) + '.  >>XM-005'
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc=@s_l_Notes,@s_a_user_Id='SYSTEM',@i_a_applytogroup=0
		
		SELECT 'Bill Processing Cancelled' AS [MESSAGE], '0' AS [RESULT]	
		
		RETURN
	END

	
	IF(@i_a_TreatmentId = 0)
	BEGIN
		BEGIN TRAN
		INSERT INTO tblTreatment
		(
			Case_Id,
			DateOfService_Start,
			DateOfService_End,
			Date_BillSent,
			Account_Number,
			Claim_Amount,
			Paid_Amount,
			Fee_Schedule,
			SERVICE_TYPE
		)
		VALUES
		(
			@s_a_CaseId,
			@dt_a_DOSStart,
			@dt_a_DOSEnd,
			@dt_a_DOSBillSent,
			@s_a_BillNumber,
			@d_a_Claim,
			@d_a_Paid,
			@d_a_FeeSchedule,
			@s_a_ServiceType
		)
		SET @s_l_message	=  'Bills details saved successfuly'
		SET @i_l_result		=  SCOPE_IDENTITY()
		
		INSERT INTO TXN_tblTreatment(DenialReasons_Id,Treatment_Id)			
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_DenialReason,',')
		
		INSERT INTO TXN_CASE_PEER_REVIEW_DOCTOR(DOCTOR_ID,TREATMENT_ID)
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_ReviewingDoctor,',')
		
		INSERT INTO TXN_CASE_Treating_Doctor(DOCTOR_ID,TREATMENT_ID)
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_TreattingDoctor,',')
		 

		SET @s_l_Notes = 'Bill added for DOS ' + convert(varchar(20),@dt_a_DOSStart) + ' - ' + convert(varchar(20),@dt_a_DOSEnd)
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc=@s_l_Notes,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup=0

		
		COMMIT TRAN
		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		UPDATE tblTreatment
		SET 
			DateOfService_Start = @dt_a_DOSStart,
			DateOfService_End = @dt_a_DOSEnd,
			Date_BillSent = @dt_a_DOSBillSent,
			Account_Number = @s_a_BillNumber,
			Claim_Amount = @d_a_Claim,
			Paid_Amount = @d_a_Paid,
			Fee_Schedule = @d_a_FeeSchedule,
			SERVICE_TYPE = @s_a_ServiceType
		WHERE Treatment_Id = @i_a_TreatmentId
		
		SET @s_l_message	=  'Bills details updated successfuly'
		SET @i_l_result	=  @i_a_TreatmentId
		
		INSERT INTO TXN_tblTreatment(DenialReasons_Id,Treatment_Id)			
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_DenialReason,',') 
		WHERE items not in (SELECT DenialReasons_Id from  TXN_tblTreatment WHERE Treatment_Id = @i_a_TreatmentId)
		
		DELETE FROM TXN_tblTreatment WHERE Treatment_Id = @i_a_TreatmentId 
		and DenialReasons_Id NOT IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReason,','))
		
		
		INSERT INTO TXN_CASE_PEER_REVIEW_DOCTOR(DOCTOR_ID,TREATMENT_ID)
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_ReviewingDoctor,',')
		WHERE items not in (SELECT DOCTOR_ID from  TXN_CASE_PEER_REVIEW_DOCTOR WHERE Treatment_Id = @i_a_TreatmentId)
		
		DELETE FROM TXN_CASE_PEER_REVIEW_DOCTOR WHERE Treatment_Id = @i_a_TreatmentId 
		and DOCTOR_ID NOT IN (SELECT items FROM dbo.SplitStringInt(@s_a_ReviewingDoctor,','))
				
		
		INSERT INTO TXN_CASE_Treating_Doctor(DOCTOR_ID,TREATMENT_ID)
		SELECT items,@i_l_result FROM dbo.SplitStringInt(@s_a_TreattingDoctor,',')
		WHERE items not in (SELECT DOCTOR_ID from  TXN_CASE_Treating_Doctor WHERE Treatment_Id = @i_a_TreatmentId)
		
		DELETE FROM TXN_CASE_Treating_Doctor WHERE Treatment_Id = @i_a_TreatmentId 
		and DOCTOR_ID NOT IN (SELECT items FROM dbo.SplitStringInt(@s_a_TreattingDoctor,','))
		 

		SET @s_l_Notes = 'Bill updated for DOS ' + convert(varchar(20),@dt_a_DOSStart) + ' - ' + convert(varchar(20),@dt_a_DOSEnd)
		exec F_Add_Activity_Notes @s_a_case_id=@s_a_CaseId,@s_a_notes_type='Activity',@s_a_ndesc=@s_l_Notes,@s_a_user_Id=@s_a_UserName,@i_a_applytogroup=0

		
		COMMIT TRAN			
		

	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

