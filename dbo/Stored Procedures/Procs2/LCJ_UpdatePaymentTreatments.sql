CREATE PROCEDURE [dbo].[LCJ_UpdatePaymentTreatments] --110980,'','01/01/2009','01/01/2009'   
	(
	@DomainId VARCHAR(50)
	,@Treatment_Id INT = NULL
	,@Case_Id VARCHAR(100) = NULL
	,@DateOfService_Start DATETIME = NULL
	,@DateOfService_End DATETIME = NULL
	,@Claim_Amount MONEY = NULL
	,@Paid_Amount MONEY = NULL
	,@WriteOff MONEY = NULL
	,@Date_BillSent DATETIME = NULL
	,@DenialReason_ID VARCHAR(300) = NULL
	,@ServiceType VARCHAR(300) = NULL
	,@PeerReviewDoctor VARCHAR(300) = NULL
	,@UserID VARCHAR(100)
	,@Bill_Number VARCHAR(50)
	,
	--@Operating_doctor VARCHAR(100),  
	@Fee_Schedule NUMERIC(18, 2)
	,@TreatingDoctor_ID VARCHAR(300) = NULL
	,@DenialDate DATETIME = NULL
	,@IMEDate DATETIME = NULL
	,@Note VARCHAR(300) = NULL
	,@RefundDate DATETIME = NULL
	,@DeductibleAmount DECIMAL(19, 2)
	)
AS
BEGIN
	DECLARE @s_l_OldStatus VARCHAR(200)
	DECLARE @s_l_NewStatus VARCHAR(200)
	DECLARE @s_l_DESC VARCHAR(200)
	DECLARE @NOTES VARCHAR(200)
	DECLARE @Claim_Amount_old FLOAT
	DECLARE @Fee_Schedule_old FLOAT

	IF (@DomainId = 'AMT')
	BEGIN
		SELECT @Claim_Amount_old = Claim_Amount
			,@Fee_Schedule_old = Fee_Schedule
		FROM tblTreatment
		WHERE Treatment_Id = @Treatment_Id
	END

	UPDATE tblTreatment
	SET DateOfService_Start = Convert(VARCHAR(15), @DateOfService_Start, 101)
		,DateOfService_End = Convert(VARCHAR(15), @DateOfService_End, 101)
		,Claim_Amount = @Claim_Amount
		,Paid_Amount = @Paid_Amount
		,Date_BillSent = Convert(VARCHAR(10), @Date_BillSent, 101)
		,SERVICE_TYPE = @ServiceType
		,BILL_NUMBER = @Bill_Number
		,Fee_Schedule = @Fee_Schedule
		,DenialReason_Id = @DenialReason_ID
		,PeerReviewDoctor_ID = @PeerReviewDoctor
		,TreatingDoctor_ID = @TreatingDoctor_ID
		,DomainId = @DomainId
		,DenialDate = @DenialDate
		,IMEDate = @IMEDate
		,Notes = @Note
		,WriteOff = @WriteOff
		,refund_date = @RefundDate
		,DeductibleAmount = @DeductibleAmount
	WHERE Treatment_Id = @Treatment_Id

	if @DenialReason_ID is not null
	BEGIN
	 EXEC Update_Denial_Case @Caseid =@Case_Id
	END

	IF (@DomainId = 'AMT')
	BEGIN
		DECLARE @Count INT = (
				SELECT count(fk_Treatment_Id)
				FROM BILLS_WITH_PROCEDURE_CODES
				WHERE fk_Treatment_Id = @Treatment_Id
					AND @DomainId = 'AMT'
				)

		IF @Count = 1
		BEGIN
			UPDATE BILLS_WITH_PROCEDURE_CODES
			SET Amount = @Claim_Amount
				,ins_fee_schedule = @Fee_Schedule
			WHERE fk_Treatment_Id = @Treatment_Id
				AND @DomainId = 'AMT'

			UPDATE tblTreatment
			SET Claim_Amount = @Claim_Amount
				,Fee_Schedule = @Fee_Schedule
			WHERE Treatment_Id = @Treatment_Id
		END
		ELSE IF (@Count > 1)
		BEGIN
			DECLARE @Claim_Amount_diff FLOAT
			DECLARE @Fee_Schedule_diff FLOAT

			SET @Claim_Amount_diff = ((@Claim_Amount_old - @Claim_Amount) / @Count)
			SET @Fee_Schedule_diff = ((@Fee_Schedule_old - @Fee_Schedule) / @Count)

			UPDATE BILLS_WITH_PROCEDURE_CODES
			SET Amount = (Amount - @Claim_Amount_diff)
				,ins_fee_schedule = (ins_fee_schedule - @Fee_Schedule_diff)
			WHERE fk_Treatment_Id = @Treatment_Id
				AND @DomainId = 'AMT'

			UPDATE tblTreatment
			SET Claim_Amount = @Claim_Amount
				,Fee_Schedule = @Fee_Schedule
			WHERE Treatment_Id = @Treatment_Id
		END
	END

	SET @NOTES = 'Bill updated for DOS ' + convert(VARCHAR(20), @DateOfService_Start) + ' - ' + convert(VARCHAR(20), @DateOfService_end)

	EXEC LCJ_AddNotes @DomainId = @DomainId
		,@case_id = @case_id
		,@notes_type = 'Activity'
		,@Ndesc = @NOTES
		,@User_id = @UserID
		,@Applytogroup = 0

	IF EXISTS (
			SELECT STATUS
			FROM tblCASE
			WHERE case_id = @Case_Id
				AND DomainId = @DomainId
				AND case_id LIKE 'ACT%'
				AND STATUS <> 'IN ARB OR LIT'
			)
		AND @DenialDate IS NOT NULL
		AND @DomainID IN (
			'AF'
			 ,'JL'
			,'LOCALHOST'
			)
	BEGIN
		SET @s_l_OldStatus = (
				SELECT STATUS
				FROM tblCASE
				WHERE case_id = @Case_Id
					AND DomainId = @DomainId
				)
		IF(@DomainID = 'JL')
			SET @s_l_NewStatus = 'DENIED'
		ELSE
			SET @s_l_NewStatus = 'BILLING - DENIAL'
		SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus + ' to ' + @s_l_NewStatus

		--UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @Case_Id
		--UPDATE TBLCASE SET Date_Status_Changed = @DenialDate WHERE Case_Id = @Case_Id
		DECLARE @oldStatusHierarchy int
		DECLARE @newStatusHierarchy int
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_OldStatus)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_NewStatus)

		UPDATE TBLCASE
		SET STATUS = case when @newStatusHierarchy>=@oldStatusHierarchy then   @s_l_NewStatus else @s_l_OldStatus end
			,Date_Status_Changed = @DenialDate
			,Denial_Request_PostedBy = @UserID
			,Denial_Request_PostedDate = GETDATE()
		WHERE Case_Id = @Case_Id

		EXEC LCJ_AddNotes @DomainId = @DomainId
			,@case_id = @Case_Id
			,@notes_type = 'Activity'
			,@NDesc = @s_l_DESC
			,@user_id = @UserID
			,@applytogroup = 0
	END
			--IF Exists(SELECT Status FROM tblCASE WHERE case_id = @Case_Id and DomainId = @DomainId and case_id like 'ACT%' and Status <> 'IN ARB OR LIT') and  @DenialDate IS NOT NULL AND @DomainID IN ('AF','LOCALHOST')
			--BEGIN
			--	SET @s_l_OldStatus = (SELECT Status FROM tblCASE WHERE case_id = @Case_Id and DomainId = @DomainId)
			--	SET @s_l_NewStatus = 'BILLING - DENIAL'
			--	SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus
			--	UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @Case_Id
			--	UPDATE TBLCASE SET Date_Status_Changed = @DenialDate WHERE Case_Id = @Case_Id
			--	exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id=@UserID,@applytogroup=0
			--END
END
