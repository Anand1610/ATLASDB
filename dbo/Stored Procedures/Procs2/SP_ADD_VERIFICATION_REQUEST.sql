CREATE PROCEDURE [dbo].[SP_ADD_VERIFICATION_REQUEST]
	@DomainID					varchar(50),
	@SZ_CASE_ID					VARCHAR(20),
	@SZ_VERIFICATION_RECEIVED	DATETIME = NULL, 
	@SZ_VERIFICATION_REPLIED	DATETIME = NULL,
	@SZ_USER_ID					VARCHAR(20),
	@SZ_NOTES					VARCHAR(2000) = NULL,
	@I_VERIFICATION_ID			INT=NULL,
	@I_REQUESTIMAGEID			BIGINT=NULL,
	@I_MANUALRESPONSEIMAGEID	VARCHAR(20)=NULL,
	@SZ_RESPONSE_NOTES			VARCHAR(MAX),
	@vr_type_Id					int
AS
BEGIN
-- SELECT * FROM TXN_VERIFICATION_REQUEST 

	DECLARE @s_l_OldStatus VARCHAR(200)
	DECLARE @s_l_NewStatus VARCHAR(200)
	DECLARE @s_l_DESC VARCHAR(200)
	DECLARE @oldStatusHierarchy int
    DECLARE @newStatusHierarchy int

	IF(Convert(varchar(10),@SZ_VERIFICATION_RECEIVED,101) = '01/01/1900' OR @SZ_VERIFICATION_RECEIVED = '')
		SET @SZ_VERIFICATION_RECEIVED = NULL

	IF(Convert(varchar(10),@SZ_VERIFICATION_REPLIED,101) = '01/01/1900' OR @SZ_VERIFICATION_REPLIED = '')
		SET @SZ_VERIFICATION_REPLIED = NULL


	IF EXISTS (SELECT I_VERIFICATION_ID FROM TXN_VERIFICATION_REQUEST
			WHERE I_VERIFICATION_ID = @I_VERIFICATION_ID)
	BEGIN
			UPDATE
				TXN_VERIFICATION_REQUEST
			SET DT_VERIFICATION_RECEIVED	= @SZ_VERIFICATION_RECEIVED,
				DT_VERIFICATION_REPLIED		= @SZ_VERIFICATION_REPLIED,
				SZ_NOTES					= @SZ_NOTES,
				SZ_USER_ID					= @SZ_USER_ID,
				RequestImageID				= CASE WHEN @I_REQUESTIMAGEID IS NULL THEN RequestImageID ELSE @I_REQUESTIMAGEID END,
				ManualResponseImageID		= CASE WHEN ISNULL(@I_MANUALRESPONSEIMAGEID,'') = '' THEN NULL ELSE CAST(@I_MANUALRESPONSEIMAGEID AS BIGINT) END,
				VerificationResponse		= @SZ_RESPONSE_NOTES,
				vr_type_Id                  = @vr_type_Id
			WHERE 
				I_VERIFICATION_ID			= @I_VERIFICATION_ID
	END
	ELSE
	BEGIN
			INSERT INTO TXN_VERIFICATION_REQUEST
			(
				SZ_CASE_ID,
				DT_VERIFICATION_RECEIVED,
				DT_VERIFICATION_REPLIED,
				SZ_NOTES,
				SZ_USER_ID,
				DomainID,
				RequestImageID,
				ManualResponseImageID,
				VerificationResponse,
				vr_type_Id
			)
			VALUES
			(
				@SZ_CASE_ID,
				@SZ_VERIFICATION_RECEIVED,
				@SZ_VERIFICATION_REPLIED,
				@SZ_NOTES,
				@SZ_USER_ID,
				@DomainID,
				CASE WHEN @I_REQUESTIMAGEID IS NULL THEN NULL ELSE @I_REQUESTIMAGEID END,
				CASE WHEN ISNULL(@I_MANUALRESPONSEIMAGEID,'') = '' THEN NULL ELSE CAST(@I_MANUALRESPONSEIMAGEID AS BIGINT) END,
				@SZ_RESPONSE_NOTES,
				@vr_type_Id
			)
			
			
		
			IF Exists(SELECT Status FROM tblCASE WHERE case_id = @SZ_CASE_ID and DomainId IN ('AF' ,'JL','LOCALHOST') and (Initial_Status = 'Active' OR @DomainId ='JL'))
			BEGIN
				IF @SZ_VERIFICATION_RECEIVED IS NOT NULL
				BEGIN 
					SET @s_l_OldStatus = (SELECT Status FROM tblCASE WHERE case_id = @SZ_CASE_ID and DomainId = @DomainId)
	
					IF @DomainID  = 'JL'
						SET @s_l_NewStatus = 'VER REQUESTED'
					ELSE
						SET @s_l_NewStatus = 'BILLING - VERIFICATION'

					SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus

							SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_OldStatus)
							SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_NewStatus)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
					BEGIN
						UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @SZ_CASE_ID
						UPDATE TBLCASE SET Date_Status_Changed = @SZ_VERIFICATION_RECEIVED WHERE Case_Id = @SZ_CASE_ID
						exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@SZ_CASE_ID,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id=@SZ_USER_ID,@applytogroup=0
					END
					ELSE
					BEGIN
					SET @s_l_DESC = 'Can not change the status from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus
					 exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@SZ_CASE_ID,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id=@SZ_USER_ID,@applytogroup=0
					END

					IF @DomainID  = 'JL'
						BEGIN
							UPDATE tblCase_additional_info SET VerificationStatus = @s_l_NewStatus,VerificationDate = @SZ_VERIFICATION_RECEIVED where case_id = @SZ_CASE_ID
						END
					
				END
			END
			
	END




	------------------------------------------------------------------------------------------------------------

	
	--IF @SZ_VERIFICATION_REPLIED IS NOT NULL AND @DomainID IN ('AF','LOCALHOST','JL')
	--BEGIN 
		
	--	IF @DomainID  = 'JL'
	--		SET @s_l_NewStatus = 'VER ANSWERED'
	--	ELSE 
	--		SET @s_l_NewStatus = 'BILLING - VERIFICATION ANSWERED'

	--	UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @SZ_CASE_ID
	--	UPDATE TBLCASE SET Date_Status_Changed = @SZ_VERIFICATION_REPLIED WHERE Case_Id = @SZ_CASE_ID
	--END	

		
	IF Exists(SELECT Status FROM tblCASE WHERE case_id = @SZ_CASE_ID and DomainId IN ('AF' ,'JL','LOCALHOST') and (Initial_Status = 'Active' OR @DomainId ='JL'))
	BEGIN
		IF @SZ_VERIFICATION_REPLIED IS NOT NULL
		BEGIN 
			SET @s_l_OldStatus = (SELECT Status FROM tblCASE WHERE case_id = @SZ_CASE_ID and DomainId = @DomainId)
			IF @DomainID  = 'JL'
				SET @s_l_NewStatus = 'VER ANSWERED'
			ELSE 
				SET @s_l_NewStatus = 'BILLING - VERIFICATION ANSWERED'

			SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus

			--UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @SZ_CASE_ID
			--UPDATE TBLCASE SET Date_Status_Changed = @SZ_VERIFICATION_REPLIED WHERE Case_Id = @SZ_CASE_ID
			SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_OldStatus)
							SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_NewStatus)
					IF(@newStatusHierarchy>=@oldStatusHierarchy)
					BEGIN

						UPDATE TBLCASE SET	STATUS = @s_l_NewStatus,
											Date_Status_Changed = @SZ_VERIFICATION_REPLIED,
											Verification_Request_PostedBy = @SZ_USER_ID,
											Verification_Request_PostedDate = GETDATE()
											WHERE Case_Id = @SZ_CASE_ID

						exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@SZ_CASE_ID,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id=@SZ_USER_ID,@applytogroup=0
					END
					ELSE
					BEGIN
					SET @s_l_DESC = 'Can not change the status from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus
					 exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@SZ_CASE_ID,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id=@SZ_USER_ID,@applytogroup=0
					END

					IF @DomainID  = 'JL'
						BEGIN
							UPDATE tblCase_additional_info SET VerificationStatus = @s_l_NewStatus,VerificationDate = @SZ_VERIFICATION_REPLIED where case_id = @SZ_CASE_ID
						END


		END	
		 
	END
END
