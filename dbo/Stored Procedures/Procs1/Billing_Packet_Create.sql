
CREATE PROCEDURE [dbo].[Billing_Packet_Create] 
(
	@DomainID VARCHAR(40),
	@s_a_caption VARCHAR(1024),
	@s_a_MultipleCase_ID VARCHAR(1024),
	@s_a_UserName VARCHAR(32),
	@s_a_ARBType VARCHAR(16),
	@DeductibleAmount decimal(19,2)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @i_l_result INT
	DECLARE @s_l_message VARCHAR(512)
	DECLARE @s_l_Existing_Packed_IDS NVARCHAR(1024) = NULL
	DECLARE @s_l_ARBType VARCHAR(16) = ''
	DECLARE @i_l_user_id INT 

	DECLARE @tblcase AS table (CASE_ID VARCHAR(64))

	INSERT INTO @tblcase
	SELECT S FROM dbo.SplitString(@s_a_MultipleCase_ID,',')
	--SELECT s=cast(s as varchar(50)) into #caseids FROM dbo.SplitString(@s_a_MultipleCase_ID,',')
	--CREATE CLUSTERED INDEX cidx_caseids on #caseids(s)

	
	SELECT @s_l_Existing_Packed_IDS= COALESCE(@s_l_Existing_Packed_IDS+',' ,'') + Case_ID
	FROM 
	Billing_Packet (NOLOCK)  
	WHERE DomainID = @DomainID  AND Case_Id  IN (SELECT case_id FROM @tblcase)
	

	IF (@s_l_Existing_Packed_IDS IS NULL)
	BEGIN
		 DECLARE @MaxCase_ID VARCHAR(64)
		 DECLARE @MaxCaseAuto_ID INTEGER
		 DECLARE @Case_Id AS varchar(64) 

		SET @MaxCase_ID=(SELECT top 1 tblCase.Case_ID FROM tblCase (NOLOCK) WHERE DomainId = @DomainID AND  CASE_ID NOT LIKE 'ACT%' ORDER BY Case_AUTOID DESC)

		IF (@MaxCase_ID IS NULL)
			SET @MaxCase_ID = '100000'
		
		SET @MaxCaseAuto_ID = (SELECT top 1 items + 1 FROM dbo.[STRING_SPLIT](@MaxCase_ID,'-') Order by autoid desc)
		SET @Case_Id  = UPPER(@DomainID) + FORMAT(GETDATE(),'yy') + '-' + CAST(@MaxCaseAuto_ID AS varchar)

			IF @DomainID = 'mcm'
			BEGIN
				SET @s_l_ARBType='NEW CASE ENTERED'
			END
			ELSE IF(@s_a_ARBType = 'ARB')
			BEGIN
				SET @s_l_ARBType='ARB PREP'
			END
			ELSE IF(@s_a_ARBType = 'LIT')
			BEGIN
				SET @s_l_ARBType='LIT PREP'
			END
		
	      BEGIN TRAN
				-- Add New Case
				INSERT INTO tblcase
				(
					DomainId,
					Case_Id, 
					Provider_Id,  
					InsuranceCompany_Id,  
					InjuredParty_LastName,  
					InjuredParty_FirstName,  
					InjuredParty_Address, 
					InjuredParty_City, 
					InjuredParty_State, 
					InjuredParty_Zip, 
					InsuredParty_LastName,  
					InsuredParty_FirstName,
					InsuredParty_Address, 
					InsuredParty_City, 
					InsuredParty_State, 
					InsuredParty_Zip,   
					Accident_Date,  
					Policy_Number,  
					Ins_Claim_Number,  
					IndexOrAAA_Number,  
					Status,  
					Date_Opened,  
					--Last_Status,  
					Initial_Status,  
					Memo, 
					opened_by,	
					GB_CASE_ID,
					GB_COMPANY_ID,
					GB_CASE_NO,
					Bit_FromGB,
					gbb_type,
					GB_LawFirm_ID,
					IsDuplicateCase,
					PortfolioId
				)
				SELECT TOP  1
					DomainId,
					@Case_Id, 
					Provider_Id,  
					InsuranceCompany_Id,  
					InjuredParty_LastName,  
					InjuredParty_FirstName,  
					InjuredParty_Address, 
					InjuredParty_City, 
					InjuredParty_State, 
					InjuredParty_Zip, 
					InsuredParty_LastName,  
					InsuredParty_FirstName,
					InsuredParty_Address, 
					InsuredParty_City, 
					InsuredParty_State, 
					InsuredParty_Zip,   
					Accident_Date,  
					Policy_Number,  
					Ins_Claim_Number,  
					IndexOrAAA_Number,  
					@s_l_ARBType AS Status,  
					GetDate(),  
					--Last_Status,  
					--'ARB' AS Initial_Status, 
						CASE WHEN @DomainID = 'GLF' THEN Initial_Status 
					--START Change done by Tushar Chandgude 29 APRIL 2020--
					when  @DomainID = 'AF' AND @s_l_ARBType='LIT PREP' THEN 'LIT'  
					--END Change done by Tushar Chandgude 29 APRIL 2020--
					
					ELSE 'ARB' END,   
					Memo,  
					'Admin' AS opened_by,	
					GB_CASE_ID,
					GB_COMPANY_ID,
					GB_CASE_NO,
					Bit_FromGB ,
					gbb_type,
					GB_LawFirm_ID,
					IsDuplicateCase,
					PortfolioId
				FROM
					tblCAse  (NOLOCK)
				WHERE 
					Case_ID IN (SELECT case_id FROM @tblcase)
					AND DomainID = @DomainID
				ORDER BY CASE_ID

				SET @s_l_message	=  'Packet created successfully - New Case ID : ' + @Case_Id
				--SET @i_l_result    =  SCOPE_IDENTITY()
				
				
				-- Add Bills
				
				INSERT INTO tblTreatment
				(
					Case_Id,
					DateOfService_Start,
					DateOfService_End,
					Claim_Amount,
					Paid_Amount,
					Date_BillSent,
					SERVICE_TYPE,
					Account_Number,
					BILL_NUMBER,
					Fee_schedule,
					DenialReason_Id,
					PeerReviewDoctor_ID,
					TreatingDoctor_ID,
					DomainId,
					ACT_CASE_ID,
					DeductibleAmount,
					pom_created_date,
					pom_id
				)
				SELECT 
					@Case_Id,
					DateOfService_Start,
					DateOfService_End,
					Claim_Amount,
					Paid_Amount,
					Date_BillSent,
					SERVICE_TYPE,
					Account_Number,
					BILL_NUMBER,
					Fee_schedule,
					DenialReason_Id,
					PeerReviewDoctor_ID,
					TreatingDoctor_ID,
					DomainId,
					Case_ID,
					DeductibleAmount,
					pom_created_date,
					pom_id
				FROM 
					tblTreatment (NOLOCK)
				WHERE 
					DomainID = @DomainID
					AND	( @DomainID <> 'BT' OR ( @DomainID = 'BT' AND (Claim_Amount - Paid_Amount) > 0 ) )
					AND Case_Id IN (SELECT case_id FROM @tblcase)
				ORDER BY DateOfService_Start


				     if exists(select top 1 * from tbltreatment where case_id=@Case_Id and DenialReason_Id is not null)
					 BEGIN
					 EXEC Update_Denial_Case @Caseid =@Case_Id
					 END


				--Remove Deductible Amount For AF

				If(@DomainID = 'AF' AND @DeductibleAmount > 0.00)
					BEGIN

						DECLARE @RowsToProcess INT = 0
						DECLARE @CurrentRow INT = 0
						DECLARE @tblTreatmentDeductibleAmt AS table 
						(
						ID INT IDENTITY(1,1),
						Treatment_Id int,
						Claim_Amount numeric(19,2),
						Paid_Amount numeric(19,2),
						WriteOff numeric(19,2),
						DeductibleAmount decimal(19,2)
						)

						INSERT INTO @tblTreatmentDeductibleAmt			
						SELECT		Treatment_Id,
									Claim_Amount,
									Paid_Amount,
									WriteOff,
									DeductibleAmount
						FROM		tblTreatment (NOLOCK)
						WHERE		DomainID = 'AF'
						AND			Case_Id = @case_id
						AND			Claim_Amount > 0
						AND			(Claim_Amount-Paid_Amount) > 0

						SET @RowsToProcess=@@ROWCOUNT
						DECLARE @ROW_AMT NUMERIC(19,2)
						DECLARE @OldDeductibleAmount NUMERIC(19,2)
						DECLARE @ROW_TREATMENT_ID INT
								WHILE(@DeductibleAmount > 0.00 AND @CurrentRow < @RowsToProcess)
									BEGIN
										SET @CurrentRow=@CurrentRow+1									

										SELECT  @ROW_AMT = CASE WHEN (ISNULL(Claim_Amount,0.00) - ISNULL(Paid_Amount,0.00) - ISNULL(WriteOff,0.00) - ISNULL(DeductibleAmount,0.00)) > 0.00 THEN
																	 (ISNULL(Claim_Amount,0.00) - ISNULL(Paid_Amount,0.00) - ISNULL(WriteOff,0.00) - ISNULL(DeductibleAmount,0.00)) 
																	 ELSE 0.00 
																	 END,
												@ROW_TREATMENT_ID = Treatment_Id,
												@OldDeductibleAmount = ISNULL(DeductibleAmount,0.00)
										FROM	@tblTreatmentDeductibleAmt 
										WHERE	ID = @CurrentRow

										If(@ROW_AMT - @DeductibleAmount >= 0.00)
										BEGIN
											UPDATE	tblTreatment
											SET		DeductibleAmount = @OldDeductibleAmount + @DeductibleAmount
											WHERE	Treatment_Id = @ROW_TREATMENT_ID

											SET		@DeductibleAmount = 0.00
										END
										ELSE
										BEGIN
											UPDATE	tblTreatment
											SET		DeductibleAmount = @OldDeductibleAmount + @ROW_AMT
											WHERE	Treatment_Id = @ROW_TREATMENT_ID

											SET		@DeductibleAmount = @DeductibleAmount - @ROW_AMT
										END
									END						
					END

				-- Add Notes
				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
				SELECT 'Case Opened', 'Activity',1, @case_id, getdate(), @s_a_UserName, @DomainId
				-----------------
				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
				SELECT @s_a_caption, 'General',1, @case_id, getdate(), @s_a_UserName, @DomainId WHERE @s_a_caption <> ''
				-------------------
				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
				SELECT 
					'Bill added for DOS ' + convert(varchar(12),DateOfService_Start,101) + ' - ' + convert(varchar(12),DateOfService_end,101)
					,'Activity',1,@Case_Id,getdate(),@s_a_UserName, @DomainID 
				FROM 
					tblTreatment  (NOLOCK)
				WHERE DomainID = @DomainID
					AND ( @DomainID <> 'BT' OR ( @DomainID = 'BT' AND (Claim_Amount - Paid_Amount) > 0 ) )
					AND Case_Id IN ((SELECT case_id FROM @tblcase))
				ORDER BY DateOfService_Start
				

				EXEC sp_createDefaultDocTypesForTree  @DomainId,  @case_id, @case_id


				-- Add Documents Please note- Only path is recorded no physical file copied...
				INSERT INTO  tblDocImages (Filename,FilePath,Status,from_flag,DomainId, BasePathId,Node_ID, CID, ACT_CASE_ID) 
				SELECT DISTINCT b_I.Filename, b_I.FilePath, b_I.Status, b_I.from_flag, b_I.DomainId, b_I.BasePathId, n_tag.NodeID, n_tag.CaseID, b_tag.CaseID
				from tblTags n_tag
				LEFT OUTER JOIN tblImageTag n_IT ON  n_tag.NodeID = n_IT.TagID and n_tag.DomainId = n_IT.DomainId
				LEFT OUTER JOIN dbo.TBLDOCIMAGES n_I ON n_IT.ImageID=n_I.ImageID and n_IT.DomainId=n_I.DomainId 
				INNER JOIN tblTags b_tag ON  n_tag.NodeName = b_tag.NodeName and n_tag.DomainId = b_tag.DomainId 
				INNER JOIN tblImageTag b_IT ON  b_tag.NodeID = b_IT.TagID and b_tag.DomainId = b_IT.DomainId
				INNER JOIN dbo.TBLDOCIMAGES b_I ON b_IT.ImageID=b_I.ImageID and b_IT.DomainId=b_I.DomainId 
				WHERE n_tag.DomainId = @DomainId
				and n_tag.CaseID = @case_id
				and b_tag.CaseID IN (SELECT case_id FROM @tblcase) 
				and n_I.Filename IS NULL
				AND n_I.FilePath IS NULL
				


				SELECT TOP 1 @i_l_user_id =  UserId  FROM IssueTracker_Users WHERE DomainId = @DomainId and UserName = @s_a_UserName

				INSERT INTO tblImageTag (ImageID,TagID,LoginID,DateInserted,DateModified,DateScanned,DomainId)        
				SELECT I.ImageID, Node_ID, @i_l_user_id, GETDATE(), NULL, NULL, @DomainId
				FROM tblDocImages I  
				WHERE DomainId = @DomainId
				AND CID = @case_id
				AND ACT_CASE_ID IN (SELECT case_id FROM @tblcase)

				---- Add Documents Please note- Only path is recorded no physical file...
				--DECLARE  @s_l_node_name VARCHAR(500),          
				--		 @s_l_filename VARCHAR(100),          
				--		 @s_l_file_path VARCHAR(100)   ,      
				--		 @i_l_user_id int,    
				--		 @i_l_from_flag int,
				--		 @i_l_BasePathId int

				-- DECLARE curBillingPacket CURSOR READ_ONLY FOR
				--	SELECT NodeName, Filename, FilePath, loginid, from_flag , BasePathId
				--	from dbo.TBLDOCIMAGES I (NOLOCK)
				--	inner Join dbo.tblImageTag IT on IT.ImageID=i.ImageID  
				--	inner Join dbo.tblTags T on T.NodeID = IT.TagID 
				--	WHERE T.CaseID IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) and T.DomainID = @DomainId
				--	OPEN curBillingPacket
 
				----FETCH THE RECORD INTO THE VARIABLES.
				--FETCH NEXT FROM curBillingPacket INTO @s_l_node_name, @s_l_filename, @s_l_file_path, @i_l_user_id, @i_l_from_flag, @i_l_BasePathId
 
				----LOOP UNTIL RECORDS ARE AVAILABLE.
				--WHILE @@FETCH_STATUS = 0
				--BEGIN

				--		EXEC SP_NEW_FILE_INSERT_ASSOCIATION
				--			@DomainId = @DomainId,       
				--			@s_a_case_id = @case_id,          
				--			@s_a_node_name = @s_l_node_name,          
				--			@s_a_filename = @s_l_filename,          
				--			@s_a_file_path = @s_l_file_path,      
				--			@i_l_user_id =   @i_l_user_id,
				--			@i_a_BasePathId = @i_l_BasePathId,
				--			@i_a_from_flag= @i_l_from_flag
				--		FETCH NEXT FROM curBillingPacket INTO @s_l_node_name, @s_l_filename, @s_l_file_path, @i_l_user_id, @i_l_from_flag, @i_l_BasePathId
				--END
 
				----CLOSE THE CURSOR.
				--CLOSE curBillingPacket
				--DEALLOCATE curBillingPacket
				---- Close the packded cases
				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
				SELECT  'Status Chnaged from '+tblCase.status+' to IN ARB OR LIT', 'Activity',1, tblCase.Case_Id, getdate(), @s_a_UserName, @DomainId
				from tblCase
				WHERE DomainID =@DomainID AND Case_Id IN (SELECT case_id FROM @tblcase)

				UPDATE	tcd
				SET		tcd.Packeted_Status_Date = tblcase.Date_Status_Changed
				FROM	[dbo].[tblCase_Date_Details] tcd
				JOIN	tblCase ON tblCase.Case_Id = tcd.Case_Id
				WHERE	tcd.DomainID =@DomainID 
				AND		tcd.Case_Id IN (SELECT case_id FROM @tblcase)

				UPDATE tblCase 
				SET Status = 'IN ARB OR LIT'
				WHERE DomainID =@DomainID AND Case_Id IN (SELECT case_id FROM @tblcase)


				DELETE FROM Auto_Billing_Packet WHERE DomainID =@DomainID  AND Case_Id IN (SELECT case_id FROM @tblcase)
				DELETE FROM Auto_Billing_Packet_Info WHERE DomainID =@DomainID  AND Case_Id IN (SELECT case_id FROM @tblcase)


				INSERT INTO Billing_Packet(Case_ID, DomainID, Packeted_Case_ID, Notes, created_by_user)
				SELECT  Case_ID, @DomainID, @Case_Id, @s_a_caption, @s_a_UserName  FROM @tblcase
			  
			    SET @s_l_message	= 'New case created successfully - '+ @Case_Id 
				SET @i_l_result		=  0 
			COMMIT TRAN 
	END
	ELSE
	BEGIN
		SET @s_l_message	= 'Packet not created. Case ID is already transferd into '+ @DomainID+ ' => '+ @s_l_Existing_Packed_IDS 
		SET @i_l_result		=  0
	END
	SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]	

END

