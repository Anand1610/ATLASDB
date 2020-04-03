CREATE PROCEDURE [dbo].[Billing_Packet_Update]
(
	@DomainID VARCHAR(40),
	@s_a_PktCaseID VARCHAR(40),
	@s_a_MultipleCase_ID VARCHAR(1024),
	@s_a_UserName NVARCHAR(32)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @i_l_result INT
	DECLARE @s_l_message VARCHAR(512)
	DECLARE @s_l_Existing_Packed_IDS VARCHAR(1024) = NULL
	DECLARE @i_l_user_id INT 

	---Split Cases into table----------------------------------------------------------
	DECLARE @tblcase AS table (CASE_ID VARCHAR(64))

	INSERT INTO @tblcase
	SELECT S FROM dbo.SplitString(@s_a_MultipleCase_ID,',')
	----Get existing packed cases---------------------------------------------------------
	SELECT @s_l_Existing_Packed_IDS= COALESCE(@s_l_Existing_Packed_IDS+',' ,'') + Case_ID
	FROM Billing_Packet (NOLOCK)  
	WHERE DomainID = @DomainID  AND Case_Id  IN (SELECT case_id FROM @tblcase)
	--------------------------------------------------------------------------------------

	IF EXISTS (SELECT tblCase.Case_ID  FROM tblCase WHERE tblCase.DomainID = @DomainID AND tblCase.Case_ID=@s_a_PktCaseID)
	BEGIN 
		IF (@s_l_Existing_Packed_IDS IS NULL)
		BEGIN
				
	      BEGIN TRAN								
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
					ACT_CASE_ID
				)
				SELECT 
					@s_a_PktCaseID,
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
					Case_ID
				FROM 
					tblTreatment
				WHERE 
					DomainID = @DomainID
					AND Case_Id IN (SELECT case_id FROM @tblcase)
				ORDER BY DateOfService_Start

				INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
				SELECT 
					'Bill added for DOS ' + convert(varchar(12),DateOfService_Start,101) + ' - ' + convert(varchar(12),DateOfService_end,101)
					,'Activity',1,@s_a_PktCaseID,getdate(),@s_a_UserName, @DomainID 
				FROM 
					tblTreatment
				WHERE DomainID = @DomainID
					AND Case_Id IN ((SELECT case_id FROM @tblcase))
				ORDER BY DateOfService_Start

				---- Add Documents Please note- Only path is recorded no physical file...
				--DECLARE  @s_l_node_name VARCHAR(500),          
				--		 @s_l_filename VARCHAR(100),          
				--		 @s_l_file_path VARCHAR(100)   ,      
				--		 @i_l_user_id int,    
				--		 @i_l_from_flag int
				-- DECLARE curBillingPacket CURSOR READ_ONLY FOR
				--	SELECT NodeName, Filename, FilePath, loginid, from_flag from dbo.TBLDOCIMAGES I 
				--	inner Join dbo.tblImageTag IT on IT.ImageID=i.ImageID  
				--	inner Join dbo.tblTags T on T.NodeID = IT.TagID 
				--	WHERE T.CaseID IN (SELECT case_id FROM @tblcase) and T.DomainID = @DomainId
				--	OPEN curBillingPacket
 
				--FETCH THE RECORD INTO THE VARIABLES.
				--FETCH NEXT FROM curBillingPacket INTO @s_l_node_name, @s_l_filename, @s_l_file_path, @i_l_user_id, @i_l_from_flag
 
				----LOOP UNTIL RECORDS ARE AVAILABLE.
				--WHILE @@FETCH_STATUS = 0
				--BEGIN

				--		EXEC SP_NEW_FILE_INSERT_ASSOCIATION
				--			@DomainId = @DomainId,       
				--			@s_a_case_id = @s_a_PktCaseID,          
				--			@s_a_node_name = @s_l_node_name,          
				--			@s_a_filename = @s_l_filename,          
				--			@s_a_file_path = @s_l_file_path,      
				--			@i_a_user_id =   @i_l_user_id,
				--			@i_a_BasePathId= 1,
				--			@i_a_from_flag= @i_l_from_flag
				--		FETCH NEXT FROM curBillingPacket INTO @s_l_node_name, @s_l_filename, @s_l_file_path, @i_l_user_id, @i_l_from_flag
				--END
 
				----CLOSE THE CURSOR.
				--CLOSE curBillingPacket
				--DEALLOCATE curBillingPacket
				---- Close the packded cases

				-- Add Documents Please note- Only path is recorded no physical file copied...
			
					INSERT INTO  tblDocImages (Filename,FilePath,Status,from_flag,DomainId, BasePathId,Node_ID, CID, ACT_CASE_ID) 
					SELECT DISTINCT b_I.Filename, b_I.FilePath, b_I.Status, b_I.from_flag, b_I.DomainId, b_I.BasePathId, n_tag.NodeID, n_tag.CaseID,b_tag.CaseID
				from tblTags n_tag
				INNER JOIN tblTags b_tag ON  n_tag.NodeName = b_tag.NodeName and n_tag.DomainId = b_tag.DomainId 
				INNER JOIN tblImageTag b_IT ON  b_tag.NodeID = b_IT.TagID and b_tag.DomainId = b_IT.DomainId
				INNER JOIN dbo.TBLDOCIMAGES b_I ON b_IT.ImageID=b_I.ImageID and b_IT.DomainId=b_I.DomainId 
				WHERE n_tag.DomainId = @DomainId
				and n_tag.CaseID = @s_a_PktCaseID
				and b_tag.CaseID  IN (SELECT case_id FROM @tblcase)


				SELECT TOP 1 @i_l_user_id =  UserId  FROM IssueTracker_Users WHERE DomainId = @DomainId and UserName = @s_a_UserName

				INSERT INTO tblImageTag          
				SELECT I.ImageID, Node_ID, @i_l_user_id, GETDATE(), NULL, NULL, @DomainId
				FROM tblDocImages I  
				WHERE DomainId = @DomainId
				AND CID = @s_a_PktCaseID
				AND ACT_CASE_ID IN (SELECT case_id FROM @tblcase) 



				UPDATE tblCase 
				SET Status = 'IN ARB OR LIT'
				WHERE DomainID =@DomainID AND Case_Id IN (SELECT case_id FROM @tblcase)


				DELETE FROM Auto_Billing_Packet WHERE DomainID =@DomainID AND Case_Id IN (SELECT case_id FROM @tblcase)
				DELETE FROM Auto_Billing_Packet_Info WHERE DomainID =@DomainID AND Case_Id IN (SELECT case_id FROM @tblcase)


				INSERT INTO Billing_Packet(Case_ID, DomainID, Packeted_Case_ID, Notes, created_by_user)
				SELECT Case_ID, @DomainID, @s_a_PktCaseID,'', @s_a_UserName  FROM @tblCase 
			  
			    SET @s_l_message	= 'Case added successfully to PacketID - '+ @s_a_PktCaseID 
				SET @i_l_result		=  0 
			COMMIT TRAN 
		END
		ELSE
		BEGIN
			SET @s_l_message	= 'Packet not created. Case ID is already transferd into '+ @DomainID+ ' => '+ @s_l_Existing_Packed_IDS 
			SET @i_l_result		=  0
		END
	END
	ELSE
	BEGIN
		SET @s_l_message	= 'Packet not updated. Case ID does not belongs to domain '+ @DomainID+ ' => '+ @s_a_PktCaseID 
		SET @i_l_result		=  0
	END

	


	SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]	

END


