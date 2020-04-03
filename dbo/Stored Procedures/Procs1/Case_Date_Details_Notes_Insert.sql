CREATE PROCEDURE [dbo].[Case_Date_Details_Notes_Insert] 
	@Auto_Id											int,
	@Case_Id											varchar(50),
	@DomainId											varchar(50),
	--@Complaint_Print_Date								DateTime = null,
	@Date_Summons_Expires								DateTime = null,
	@Date_Filed											DateTime = null,
	@Proof_of_Service_Date								DateTime = null,
	@Date_Answer_Received								DateTime = null,
	@Scheduling_Order_Issue_Date						DateTime = null,
	@Witness_list_Due_Date								DateTime = null,
	@Motion_Cutoff_Date									DateTime = null,
	@Discovery_Cutoff_Date								DateTime = null,
	@Pretrial_Statement_Due_Date						DateTime = null,
	@Pretrial_Conf_Date									DateTime = null,
	@Defense_Discovery_Receipt_Date						DateTime = null,
	@Plaintiff_Propounded_Discovery_Sent_Date			DateTime = null,
	@Discovery_Stip_Sent_Date							DateTime = null,
	@Plaintiff_Discovery_Responses_Completed_Date		DateTime = null,
	@Defense_Deposition_Date							DateTime = null,
	@Plaintiff_Deposition_Date							DateTime = null,
	@Settlement_Date									DateTime = null,
	@Settlement_FU_letter_Date_1						DateTime = null,
	@Settlement_FU_letter_Date_2						DateTime = null,
	@Client_Release_Execution_Request_Date				DateTime = null,
	@Release_FU_Date									DateTime = null,
	@Case_Evaluation_Date								DateTime = null,
	@Case_Evaluation_Summary_Due_Date					DateTime = null,
	@Case_Evaluation_Status								int = 0,
	@Case_Evaluation_Status_Date						DateTime = null,
	@Facilitation_Date									DateTime = null,
	@Facilitation_Summary_Due_Date						DateTime = null,
	@Settlement_Conference_Date							DateTime = null,
	@Final_Pretrial_Statement_Trial_Notebook_Sent_Date	DateTime = null,
	@Trial_Date											DateTime = null,
	@Appeal_Date										DateTime = null,
	@Closing_Statement_Date								DateTime = null,
	@Dismissal_Date										DateTime = null,
	@Complaint_Amended_Print_Date						Datetime = null,
	@Release_Received_Date								Datetime = null,
	@Adjuster_Depo_Date									Datetime = null,
    @Defense_Answer_To_Discovery_Due_Date				Datetime = null,
	@Defense_Answers_to_our_Discovery_Completed_Date	Datetime = null,
	@Payment_Received_Date								Datetime = null,
	@CreatedBy											varchar(100)
AS
BEGIN
DECLARE @newStatusHierarchy int
DECLARE @oldStatusHierarchy int

	SET NOCOUNT ON;
	        Declare @NotesType varchar(50) = 'Workflow';

			Declare @Old_Status varchar(150);
			Select  @Old_Status = Status from tblcase(NOLOCK) where Case_Id = @Case_Id and DomainId = @DomainId
			--Declare @Status_DomainId varchar(50) = 'amt';
			Declare @Company_Type varchar(150);
			SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
			Select TOP 1 @Company_Type = CompanyType from tbl_Client(NOLOCK) where DomainId = @DomainId

			--Declare @OldComplaint_Print_Date Datetime = null;
			--Select @OldComplaint_Print_Date = Complaint_Print_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId

			--IF @OldComplaint_Print_Date is null and @Complaint_Print_Date is not null
			--  BEGIN
			--	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	Values('Complaint Print Date Added '+Convert(varchar(20),@Complaint_Print_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--  END
			--Else IF  (@OldComplaint_Print_Date is not null and @Complaint_Print_Date is not null AND CONVERT(VARCHAR,@OldComplaint_Print_Date,101) <> CONVERT(VARCHAR,@Complaint_Print_Date,101))
			--	BEGIN
			--		Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('Complaint Print Date Updated From '+Convert(varchar(20),@OldComplaint_Print_Date,101)+' To '+Convert(varchar(20),@Complaint_Print_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END
			--Else IF  @OldComplaint_Print_Date is not null and @Complaint_Print_Date is null
			--	BEGIN
			--	    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('Complaint Print Date Updated From '+Convert(varchar(20),@OldComplaint_Print_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END 

			Declare @OldDate_Summons_Expires Datetime = null;
			Select @OldDate_Summons_Expires = Date_Summons_Expires from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId

			IF @OldDate_Summons_Expires is null and @Date_Summons_Expires is not null 
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Date Summons Expires Added : '+Convert(varchar(20),@Date_Summons_Expires,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
			Else IF(@OldDate_Summons_Expires is not null and @Date_Summons_Expires is not null AND CONVERT(VARCHAR,@OldDate_Summons_Expires,101) <> CONVERT(VARCHAR,@Date_Summons_Expires,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Summons Expires Updated : From '+Convert(varchar(20),@OldDate_Summons_Expires,101)+' To '+Convert(varchar(20),@Date_Summons_Expires,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldDate_Summons_Expires is not null and @Date_Summons_Expires is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Summons Expires Updated : From '+Convert(varchar(20),@OldDate_Summons_Expires,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

            Declare @OldDate_Filed Datetime = null;
			Select @OldDate_Filed = Date_Filed from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldDate_Filed is null and @Date_Filed is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Date Filed Added : '+Convert(varchar(20),@Date_Filed,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)

				IF lower(@Old_Status) !='complaint filed' and lower(@Company_Type) = 'funding'
				BEGIN
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Complaint Filed')
			    --IF (@newStatusHierarchy>=@oldStatusHierarchy)
				if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                BEGIN
						Update tblcase set Status = 'Complaint Filed' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Complaint Filed', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Complaint Filed';
				END
				ELSE
				BEGIN
				EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'can not change the status to Complaint Filed', @user_Id=@CreatedBy, @ApplyToGroup = 0  
				END
			
				END
			  END
			Else IF(@OldDate_Filed is not null and @Date_Filed is not null AND CONVERT(VARCHAR,@OldDate_Filed,101) <> CONVERT(VARCHAR,@Date_Filed,101)) 
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Filed Updated : From '+Convert(varchar(20),@OldDate_Filed,101)+' To '+Convert(varchar(20),@Date_Filed,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldDate_Filed is not null and @Date_Filed is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Filed Updated : From '+Convert(varchar(20),@OldDate_Filed,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		    Declare @OldProof_of_Service_Date Datetime = null;
			Select @OldProof_of_Service_Date = Proof_of_Service_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldProof_of_Service_Date is null and @Proof_of_Service_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Proof of Service(POS) Date Added : '+Convert(varchar(20),@Proof_of_Service_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			    
				IF lower(@Old_Status) !='pos' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				        SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='POS')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                        BEGIN
						Update tblcase set Status = 'POS' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : POS', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'POS';
						END
				 END
			 
			 END
		   Else IF(@OldProof_of_Service_Date is not null and @Proof_of_Service_Date is not null AND CONVERT(VARCHAR,@OldProof_of_Service_Date,101) <> CONVERT(VARCHAR,@Proof_of_Service_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Proof of Service(POS) Date Updated : From '+Convert(varchar(20),@OldProof_of_Service_Date,101)+' To '+Convert(varchar(20),@Proof_of_Service_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				     
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter')
				END
			Else IF  @OldProof_of_Service_Date is not null and @Proof_of_Service_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Proof of Service(POS) Date Updated : From '+Convert(varchar(20),@OldProof_of_Service_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)

					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter')
				END 

            Declare @OldDate_Answer_Received Datetime = null;
			Select @OldDate_Answer_Received = Date_Answer_Received from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldDate_Answer_Received is null and @Date_Answer_Received is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Date Answer Received Added : '+Convert(varchar(20),@Date_Answer_Received,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)

				IF lower(@Old_Status) !='answer received' and lower(@Company_Type) = 'funding'
				   BEGIN
				   SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Answer Received')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN
						Update tblcase set Status = 'Answer Received' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Answer Received', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Answer Received';
				    END
				 END

			  END
            Else IF(@OldDate_Answer_Received is not null and @Date_Answer_Received is not null AND CONVERT(VARCHAR,@OldDate_Answer_Received,101) <> CONVERT(VARCHAR,@Date_Answer_Received,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Answer Received Updated : From '+Convert(varchar(20),@OldDate_Answer_Received,101)+' To '+Convert(varchar(20),@Date_Answer_Received,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter')
				END
			Else IF  @OldDate_Answer_Received is not null and @Date_Answer_Received is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Date Answer Received Updated : From '+Convert(varchar(20),@OldDate_Answer_Received,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Answer Settlement Demand Letter')
				END 

			Declare @OldPretrial_Conf_Date Datetime = null;
			Select  @OldPretrial_Conf_Date = Pretrial_Conf_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldPretrial_Conf_Date is null and @Pretrial_Conf_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Pre-trial Conf. Date Added : '+Convert(varchar(20),@Pretrial_Conf_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			 
			    IF lower(@Old_Status) !='ptc' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='PTC')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN
						Update tblcase set Status = 'PTC' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : PTC', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'PTC';
				    ENd
				 END
			 END
           Else IF(@OldPretrial_Conf_Date is not null and @Pretrial_Conf_Date is not null AND CONVERT(VARCHAR,@OldPretrial_Conf_Date,101) <> CONVERT(VARCHAR,@Pretrial_Conf_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Pre-trial Conf. Date Updated : From '+Convert(varchar(20),@OldPretrial_Conf_Date,101)+' To '+Convert(varchar(20),@Pretrial_Conf_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Plaintiff Discovery Package')
				END
			Else IF  @OldPretrial_Conf_Date is not null and @Pretrial_Conf_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Pre-trial Conf. Date Updated : From '+Convert(varchar(20),@OldPretrial_Conf_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Plaintiff Discovery Package')
				END 

			Declare @OldScheduling_Order_Issue_Date Datetime = null;
			Select @OldScheduling_Order_Issue_Date = Scheduling_Order_Issue_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldScheduling_Order_Issue_Date is null and @Scheduling_Order_Issue_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Scheduling Order Issue Date Added : '+Convert(varchar(20),@Scheduling_Order_Issue_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			 
			    IF lower(@Old_Status) !='scheduling order' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Scheduling Order')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN
						Update tblcase set Status = 'Scheduling Order' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Scheduling Order', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Scheduling Order';
				  END
				 END
			  END
			 Else IF(@OldScheduling_Order_Issue_Date is not null and @Scheduling_Order_Issue_Date is not null AND CONVERT(VARCHAR,@OldScheduling_Order_Issue_Date,101) <> CONVERT(VARCHAR,@Scheduling_Order_Issue_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Scheduling Order Issue Date Updated : From '+Convert(varchar(20),@OldScheduling_Order_Issue_Date,101)+' To '+Convert(varchar(20),@Scheduling_Order_Issue_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				  
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Witness List Pending Cases', 'Notice of Deposition'))
				END
			Else IF  @OldScheduling_Order_Issue_Date is not null and @Scheduling_Order_Issue_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Scheduling Order Issue Date Updated : From '+Convert(varchar(20),@OldScheduling_Order_Issue_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Witness List Pending Cases', 'Notice of Deposition'))
				END 

			Declare @OldWitness_list_Due_Date Datetime = null;
			Select  @OldWitness_list_Due_Date = Witness_list_Due_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldWitness_list_Due_Date is null and @Witness_list_Due_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Witness List Due Date Added : '+Convert(varchar(20),@Witness_list_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
			Else IF(@OldWitness_list_Due_Date is not null and @Witness_list_Due_Date is not null AND CONVERT(VARCHAR,@OldWitness_list_Due_Date,101) <> CONVERT(VARCHAR,@Witness_list_Due_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Witness List Due Date Updated : From '+Convert(varchar(20),@OldWitness_list_Due_Date,101)+' To '+Convert(varchar(20),@Witness_list_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldWitness_list_Due_Date is not null and @Witness_list_Due_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Witness List Due Date Updated : From '+Convert(varchar(20),@OldWitness_list_Due_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

            Declare @OldMotion_Cutoff_Date Datetime = null;
			Select  @OldMotion_Cutoff_Date = Motion_Cutoff_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldMotion_Cutoff_Date is null and @Motion_Cutoff_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Motion Cutoff Date Added : '+Convert(varchar(20),@Motion_Cutoff_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
            Else IF(@OldMotion_Cutoff_Date is not null and @Motion_Cutoff_Date is not null AND CONVERT(VARCHAR,@OldMotion_Cutoff_Date,101) <> CONVERT(VARCHAR,@Motion_Cutoff_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Motion Cutoff Date Updated : From '+Convert(varchar(20),@OldMotion_Cutoff_Date,101)+' To '+Convert(varchar(20),@Motion_Cutoff_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldMotion_Cutoff_Date is not null and @Motion_Cutoff_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Motion Cutoff Date Updated : From '+Convert(varchar(20),@OldMotion_Cutoff_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 
   
            Declare @OldDiscovery_Cutoff_Date Datetime = null;
			Select  @OldDiscovery_Cutoff_Date = Discovery_Cutoff_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
			IF @OldDiscovery_Cutoff_Date is null and @Discovery_Cutoff_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Discovery Cutoff Date Added : '+Convert(varchar(20),@Discovery_Cutoff_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
             Else IF(@OldDiscovery_Cutoff_Date is not null and @Discovery_Cutoff_Date is not null AND CONVERT(VARCHAR,@OldDiscovery_Cutoff_Date,101) <> CONVERT(VARCHAR,@Discovery_Cutoff_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Discovery Cutoff Date Updated : From '+Convert(varchar(20),@OldDiscovery_Cutoff_Date,101)+' To '+Convert(varchar(20),@Discovery_Cutoff_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Discovery Cutoff')
				END
			Else IF  @OldDiscovery_Cutoff_Date is not null and @Discovery_Cutoff_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Discovery Cutoff Date Updated : From '+Convert(varchar(20),@OldDiscovery_Cutoff_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Discovery Cutoff')
				END 

			Declare @OldPretrial_Statement_Due_Date Datetime = null;
			Select  @OldPretrial_Statement_Due_Date = Pretrial_Statement_Due_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldPretrial_Statement_Due_Date is null and @Pretrial_Statement_Due_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Pretrial Statement Due Date Added : '+Convert(varchar(20),@Pretrial_Statement_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
		   Else IF(@OldPretrial_Statement_Due_Date is not null and @Pretrial_Statement_Due_Date is not null AND CONVERT(VARCHAR,@OldPretrial_Statement_Due_Date,101) <> CONVERT(VARCHAR,@Pretrial_Statement_Due_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Pretrial Statement Due Date Updated : From '+Convert(varchar(20),@OldPretrial_Statement_Due_Date,101)+' To '+Convert(varchar(20),@Pretrial_Statement_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldPretrial_Statement_Due_Date is not null and @Pretrial_Statement_Due_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Pretrial Statement Due Date Updated : From '+Convert(varchar(20),@OldPretrial_Statement_Due_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldAdjuster_Depo_Date Datetime = null;
		   Select  @OldAdjuster_Depo_Date = Adjuster_Depo_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId

		    IF @OldAdjuster_Depo_Date is null and @Adjuster_Depo_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Adjuster Deposition Date Added : '+Convert(varchar(20),@Adjuster_Depo_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			
			     IF lower(@Old_Status) !='adjuster deposition due' and lower(@Company_Type) = 'funding'
				   BEGIN
				   SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Adjuster Deposition Due')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'Adjuster Deposition Due' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Adjuster Deposition Due', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Adjuster Deposition Due';
				 END
				 END
			 END
             Else IF(@OldAdjuster_Depo_Date is not null and @Adjuster_Depo_Date is not null AND CONVERT(VARCHAR,@OldAdjuster_Depo_Date,101) <> CONVERT(VARCHAR,@Adjuster_Depo_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Adjuster Deposition Date Updated : From '+Convert(varchar(20),@OldAdjuster_Depo_Date,101)+' To '+Convert(varchar(20),@Adjuster_Depo_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF @OldAdjuster_Depo_Date is not null and @Adjuster_Depo_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Adjuster Deposition Date Updated : From '+Convert(varchar(20),@OldAdjuster_Depo_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

			Declare @OldDefense_Discovery_Receipt_Date Datetime = null;
			Select  @OldDefense_Discovery_Receipt_Date = Defense_Discovery_Receipt_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldDefense_Discovery_Receipt_Date is null and @Defense_Discovery_Receipt_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Defense Discovery Receipt Date Added : '+Convert(varchar(20),@Defense_Discovery_Receipt_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			     IF lower(@Old_Status) !='defense discovery received' and lower(@Company_Type) = 'funding'
				   BEGIN
				    SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				    SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Defense Discovery Received')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN
						Update tblcase set Status = 'Defense Discovery Received' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Defense Discovery Received', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Defense Discovery Received';
					END
				 END
			  END
          Else IF(@OldDefense_Discovery_Receipt_Date is not null and @Defense_Discovery_Receipt_Date is not null AND CONVERT(VARCHAR,@OldDefense_Discovery_Receipt_Date,101) <> CONVERT(VARCHAR,@Defense_Discovery_Receipt_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Discovery Receipt Date Updated : From '+Convert(varchar(20),@OldDefense_Discovery_Receipt_Date,101)+' To '+Convert(varchar(20),@Defense_Discovery_Receipt_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				 
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Discovery Stipulation', 'Plaintiff Response to Defense Discovery Due Today'))
				END
			Else IF  @OldDefense_Discovery_Receipt_Date is not null and @Defense_Discovery_Receipt_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Discovery Receipt Date Updated : From '+Convert(varchar(20),@OldDefense_Discovery_Receipt_Date,101)+' To '+Convert(varchar(20),@Defense_Discovery_Receipt_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Discovery Stipulation', 'Plaintiff Response to Defense Discovery Due Today'))
				END 

		    Declare @OldPlaintiff_Propounded_Discovery_Sent_Date Datetime = null;
			Select  @OldPlaintiff_Propounded_Discovery_Sent_Date = Plaintiff_Propounded_Discovery_Sent_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldPlaintiff_Propounded_Discovery_Sent_Date is null and @Plaintiff_Propounded_Discovery_Sent_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Plaintiff Propounded Discovery Sent Date Added : '+Convert(varchar(20),@Plaintiff_Propounded_Discovery_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			   
			   IF lower(@Old_Status) !='propound discovery' and lower(@Company_Type) = 'funding'
				   BEGIN
				    SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				    SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Propound Discovery')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN
						Update tblcase set Status = 'Propound Discovery' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Propound Discovery', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Propound Discovery';
						end
				 END
			END
          Else IF(@OldPlaintiff_Propounded_Discovery_Sent_Date is not null and @Plaintiff_Propounded_Discovery_Sent_Date is not null AND CONVERT(VARCHAR,@OldPlaintiff_Propounded_Discovery_Sent_Date,101) <> CONVERT(VARCHAR,@Plaintiff_Propounded_Discovery_Sent_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Propounded Discovery Sent Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Propounded_Discovery_Sent_Date,101)+' To '+Convert(varchar(20),@Plaintiff_Propounded_Discovery_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Answer to Our Discovery Are Due Today')
				END
			Else IF  @OldPlaintiff_Propounded_Discovery_Sent_Date is not null and @Plaintiff_Propounded_Discovery_Sent_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Propounded Discovery Sent Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Propounded_Discovery_Sent_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				      Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					  and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Answer to Our Discovery Are Due Today')
				END
				
		    Declare @OldDefense_Answers_to_our_Discovery_Completed_Date Datetime = null;
			Select  @OldDefense_Answers_to_our_Discovery_Completed_Date = Defense_Answers_to_our_Discovery_Completed_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldDefense_Answers_to_our_Discovery_Completed_Date is null and @Defense_Answers_to_our_Discovery_Completed_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Defense Answers to our Discovery Completed Date Added : '+Convert(varchar(20),@Defense_Answers_to_our_Discovery_Completed_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			   
			   IF lower(@Old_Status) !='received response to plaintiff discovery' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Received Response To Plaintiff Discovery')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'Received Response To Plaintiff Discovery' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Received Response To Plaintiff Discovery', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Received Response To Plaintiff Discovery';

						END
				 END

				 Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
				 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Answers to Our Discovery')
			END
          Else IF(@OldDefense_Answers_to_our_Discovery_Completed_Date is not null and @Defense_Answers_to_our_Discovery_Completed_Date is not null AND CONVERT(VARCHAR,@OldDefense_Answers_to_our_Discovery_Completed_Date,101) <> CONVERT(VARCHAR,@Defense_Answers_to_our_Discovery_Completed_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Answers to our Discovery Completed Date Updated : From '+Convert(varchar(20),@OldDefense_Answers_to_our_Discovery_Completed_Date,101)+' To '+Convert(varchar(20),@Defense_Answers_to_our_Discovery_Completed_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
					 Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Answers to Our Discovery')
				END
			Else IF  @OldDefense_Answers_to_our_Discovery_Completed_Date is not null and @Defense_Answers_to_our_Discovery_Completed_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Answers to our Discovery Completed Date Updated : From '+Convert(varchar(20),@OldDefense_Answers_to_our_Discovery_Completed_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Answers to Our Discovery')
				END

			Declare @OldDiscovery_Stip_Sent_Date Datetime = null;
			Select  @OldDiscovery_Stip_Sent_Date = Discovery_Stip_Sent_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldDiscovery_Stip_Sent_Date is null and @Discovery_Stip_Sent_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Discovery Stip Sent Date Added : '+Convert(varchar(20),@Discovery_Stip_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
          Else IF(@OldDiscovery_Stip_Sent_Date is not null and @Discovery_Stip_Sent_Date is not null AND CONVERT(VARCHAR,@OldDiscovery_Stip_Sent_Date,101) <> CONVERT(VARCHAR,@Discovery_Stip_Sent_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Discovery Stip Sent Date Updated : From '+Convert(varchar(20),@OldDiscovery_Stip_Sent_Date,101)+' To '+Convert(varchar(20),@Discovery_Stip_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldDiscovery_Stip_Sent_Date is not null and @Discovery_Stip_Sent_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Discovery Stip Sent Date Updated : From '+Convert(varchar(20),@OldDiscovery_Stip_Sent_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

			Declare @OldPlaintiff_Discovery_Responses_Completed_Date Datetime = null;
			Select  @OldPlaintiff_Discovery_Responses_Completed_Date = Plaintiff_Discovery_Responses_Completed_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		  IF @OldPlaintiff_Discovery_Responses_Completed_Date is null and @Plaintiff_Discovery_Responses_Completed_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Plaintiff Discovery Response Completed Date Added : '+Convert(varchar(20),@Plaintiff_Discovery_Responses_Completed_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			     IF lower(@Old_Status) !='discovery answered' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Discovery Answered')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'Discovery Answered' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Discovery Answered', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Discovery Answered';

						END
				   END
			  END
           Else IF(@OldPlaintiff_Discovery_Responses_Completed_Date is not null and @Plaintiff_Discovery_Responses_Completed_Date is not null AND CONVERT(VARCHAR,@OldPlaintiff_Discovery_Responses_Completed_Date,101) <> CONVERT(VARCHAR,@Plaintiff_Discovery_Responses_Completed_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Discovery Response Completed Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Discovery_Responses_Completed_Date,101)+' To '+Convert(varchar(20),@Plaintiff_Discovery_Responses_Completed_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				 
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Discovery Stipulation'))
				END
			Else IF  @OldPlaintiff_Discovery_Responses_Completed_Date is not null and @Plaintiff_Discovery_Responses_Completed_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Discovery Response Completed Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Discovery_Responses_Completed_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Discovery Stipulation'))
				END 

           Declare @OldDefense_Deposition_Date Datetime = null;
		   Select  @OldDefense_Deposition_Date = Defense_Deposition_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldDefense_Deposition_Date is null and @Defense_Deposition_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Defense Deposition Date Added : '+CONVERT(VARCHAR(10), @Defense_Deposition_Date, 101) + ' ' + RIGHT(CONVERT(VARCHAR, @Defense_Deposition_Date, 100), 7) , @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
			 Else IF(@OldDefense_Deposition_Date is not null and @Defense_Deposition_Date is not null AND CONVERT(VARCHAR,@OldDefense_Deposition_Date,22) <> CONVERT(VARCHAR,@Defense_Deposition_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Deposition Date Updated : From '+Convert(varchar(20),@OldDefense_Deposition_Date,22)+' To '+Convert(varchar(20),@Defense_Deposition_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				 
				 Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Deposition Date')
				END
			Else IF  @OldDefense_Deposition_Date is not null and @Defense_Deposition_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Deposition Date Updated : From '+Convert(varchar(20),@OldDefense_Deposition_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Defense Deposition Date')
				END 

           Declare @OldPlaintiff_Deposition_Date Datetime = null;
		   Select  @OldPlaintiff_Deposition_Date = Plaintiff_Deposition_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldPlaintiff_Deposition_Date is null and @Plaintiff_Deposition_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Plaintiff Deposition Date Added : '+CONVERT(VARCHAR(10), @Plaintiff_Deposition_Date, 101) + ' ' + RIGHT(CONVERT(VARCHAR, @Plaintiff_Deposition_Date, 100), 7) , @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
           Else IF(@OldPlaintiff_Deposition_Date is not null and @Plaintiff_Deposition_Date is not null AND CONVERT(VARCHAR,@OldPlaintiff_Deposition_Date,22) <> CONVERT(VARCHAR,@Plaintiff_Deposition_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Deposition Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Deposition_Date,22)+' To '+Convert(varchar(20),@Plaintiff_Deposition_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				  
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
				    and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Plaintiff Deposition Date')
				END
			Else IF  @OldPlaintiff_Deposition_Date is not null and @Plaintiff_Deposition_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Plaintiff Deposition Date Updated : From '+Convert(varchar(20),@OldPlaintiff_Deposition_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Plaintiff Deposition Date')
				END 
           
		   Declare @OldSettlement_Date Datetime = null;
		   Select  @OldSettlement_Date = Settlement_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldSettlement_Date is null and @Settlement_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Settlement Date Added : '+Convert(varchar(20),@Settlement_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			    
				IF lower(@Old_Status) !='settled awaiting payment' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='SETTLED AWAITING PAYMENT')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'SETTLED AWAITING PAYMENT' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : SETTLED AWAITING PAYMENT', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'SETTLED AWAITING PAYMENT';

						END
				 END
			  END
           Else IF(@OldSettlement_Date is not null and @Settlement_Date is not null AND CONVERT(VARCHAR,@OldSettlement_Date,101) <> CONVERT(VARCHAR,@Settlement_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement Date Updated : From '+Convert(varchar(20),@OldSettlement_Date,101)+' To '+Convert(varchar(20),@Settlement_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				  
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Release F/U')
				END
			Else IF  @OldSettlement_Date is not null and @Settlement_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement Date Updated : From '+Convert(varchar(20),@OldSettlement_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Release F/U')
				END 

		   Declare @OldSettlement_FU_letter_Date_1 Datetime = null;
		   Select  @OldSettlement_FU_letter_Date_1 = Settlement_FU_letter_Date_1 from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldSettlement_FU_letter_Date_1 is null and @Settlement_FU_letter_Date_1 is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Settlement F/U Letter Date Added : '+Convert(varchar(20),@Settlement_FU_letter_Date_1,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
           Else IF(@OldSettlement_FU_letter_Date_1 is not null and @Settlement_FU_letter_Date_1 is not null AND CONVERT(VARCHAR,@OldSettlement_FU_letter_Date_1,101) <> CONVERT(VARCHAR,@Settlement_FU_letter_Date_1,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement F/U Letter Date Updated : From '+Convert(varchar(20),@OldSettlement_FU_letter_Date_1,101)+' To '+Convert(varchar(20),@Settlement_FU_letter_Date_1,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldSettlement_FU_letter_Date_1 is not null and @Settlement_FU_letter_Date_1 is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement F/U Letter Date Updated : From '+Convert(varchar(20),@OldSettlement_FU_letter_Date_1,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 
            
		   Declare @OldPayment_Received_Date Datetime = null;
		   Select  @OldPayment_Received_Date = Payment_Received_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldPayment_Received_Date is null and @Payment_Received_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Payment Received Date Added : '+Convert(varchar(20),@Payment_Received_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			     IF lower(@Old_Status) !='settled & paid' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='SETTLED & PAID')
						---IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'SETTLED & PAID' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : SETTLED & PAID', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'SETTLED & PAID';

						END
				   END

				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Payment Reminder Letter'))

			  END
           Else IF(@OldPayment_Received_Date is not null and @Payment_Received_Date is not null AND CONVERT(VARCHAR,@OldPayment_Received_Date,101) <> CONVERT(VARCHAR,@Payment_Received_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Payment Received Date Updated : From '+Convert(varchar(20),@OldPayment_Received_Date,101)+' To '+Convert(varchar(20),@Payment_Received_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldPayment_Received_Date is not null and @Payment_Received_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Payment Received Date Updated : From '+Convert(varchar(20),@OldPayment_Received_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		 --  Declare @OldSettlement_FU_letter_Date_2 Datetime = null;
		 --  Select  @OldSettlement_FU_letter_Date_2 = Settlement_FU_letter_Date_2 from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		 --  IF @OldSettlement_FU_letter_Date_2 is null and @Settlement_FU_letter_Date_2 is not null
			--  BEGIN
			--	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	Values('2nd Settlement F/U Letter Date Added : '+Convert(varchar(20),@Settlement_FU_letter_Date_2,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--  END
		 --  Else IF(@OldSettlement_FU_letter_Date_2 is not null and @Settlement_FU_letter_Date_2 is not null AND CONVERT(VARCHAR,@OldSettlement_FU_letter_Date_2,101) <> CONVERT(VARCHAR,@Settlement_FU_letter_Date_2,101))
			--	BEGIN
			--		Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('2nd Settlement F/U Letter Date Updated : From '+Convert(varchar(20),@OldSettlement_FU_letter_Date_2,101)+' To '+Convert(varchar(20),@Settlement_FU_letter_Date_2,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END
			--Else IF  @OldSettlement_FU_letter_Date_2 is not null and @Settlement_FU_letter_Date_2 is null
			--	BEGIN
			--	    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('2nd Settlement F/U Letter Date Updated : From '+Convert(varchar(20),@OldSettlement_FU_letter_Date_2,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END 
           
		   Declare @OldClient_Release_Execution_Request_Date Datetime = null;
		   Select  @OldClient_Release_Execution_Request_Date = Client_Release_Execution_Request_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldClient_Release_Execution_Request_Date is null and @Client_Release_Execution_Request_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Client Release Execution Request Date Added : '+Convert(varchar(20),@Client_Release_Execution_Request_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
          Else IF(@OldClient_Release_Execution_Request_Date is not null and @Client_Release_Execution_Request_Date is not null AND CONVERT(VARCHAR,@OldClient_Release_Execution_Request_Date,101) <> CONVERT(VARCHAR,@Client_Release_Execution_Request_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Client Release Execution Request Date Updated : From '+Convert(varchar(20),@OldClient_Release_Execution_Request_Date,101)+' To '+Convert(varchar(20),@Client_Release_Execution_Request_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				  
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Settlement F/U Letter', '2nd Settlement F/U Letter', 'Client Release F/U', 'Payment Reminder Letter'))

				END
			Else IF  @OldClient_Release_Execution_Request_Date is not null and @Client_Release_Execution_Request_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Client Release Execution Request Date Updated : From '+Convert(varchar(20),@OldClient_Release_Execution_Request_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Settlement F/U Letter', '2nd Settlement F/U Letter', 'Client Release F/U', 'Payment Reminder Letter'))
				END 

		 --  Declare @OldRelease_FU_Date Datetime = null;
		 --  Select  @OldRelease_FU_Date = Release_FU_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		 --  IF @OldRelease_FU_Date is null and @Release_FU_Date is not null
			--  BEGIN
			--	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	Values('Release F/U Date Added : '+Convert(varchar(20),@Release_FU_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--  END
   --         Else IF(@OldRelease_FU_Date is not null and @Release_FU_Date is not null AND CONVERT(VARCHAR,@OldRelease_FU_Date,101) <> CONVERT(VARCHAR,@Release_FU_Date,101))
			--	BEGIN
			--		Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('Release F/U Date Updated : From '+Convert(varchar(20),@OldRelease_FU_Date,101)+' To '+Convert(varchar(20),@Release_FU_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END
			--Else IF  @OldRelease_FU_Date is not null and @Release_FU_Date is null
			--	BEGIN
			--	    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			--	    Values('Release F/U Date Updated : From '+Convert(varchar(20),@OldRelease_FU_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			--	END 

		   Declare @OldCase_Evaluation_Date Datetime = null;
		   Select  @OldCase_Evaluation_Date = Case_Evaluation_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldCase_Evaluation_Date is null and @Case_Evaluation_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Case Evaluation Date Added : '+Convert(varchar(20),@Case_Evaluation_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			    
				IF lower(@Old_Status) !='case evaluation held' and lower(@Company_Type) = 'funding'
				   BEGIN
				   SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='CASE EVALUATION HELD')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'CASE EVALUATION HELD' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : CASE EVALUATION HELD', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'CASE EVALUATION HELD';

				   END
				 END
			  END
		    Else IF(@OldCase_Evaluation_Date is not null and @Case_Evaluation_Date is not null AND CONVERT(VARCHAR,@OldCase_Evaluation_Date,22) <> CONVERT(VARCHAR,@Case_Evaluation_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Date,22)+' To '+Convert(varchar(20),@Case_Evaluation_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Case Evaluation Summary Due', 'Case Evaluation Date', 'Case Evaluation Accept/Reject Pending'))
				END
			Else IF  @OldCase_Evaluation_Date is not null and @Case_Evaluation_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Case Evaluation Summary Due', 'Case Evaluation Date', 'Case Evaluation Accept/Reject Pending'))
				END 

		   Declare @OldCase_Evaluation_Summary_Due_Date Datetime = null;
		   Select  @OldCase_Evaluation_Summary_Due_Date = Case_Evaluation_Summary_Due_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldCase_Evaluation_Summary_Due_Date is null and @Case_Evaluation_Summary_Due_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Case Evaluation Summary Due Date Added : '+Convert(varchar(20),@Case_Evaluation_Summary_Due_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
		   Else IF(@OldCase_Evaluation_Summary_Due_Date is not null and @Case_Evaluation_Summary_Due_Date is not null AND CONVERT(VARCHAR,@OldCase_Evaluation_Summary_Due_Date,22) <> CONVERT(VARCHAR,@Case_Evaluation_Summary_Due_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Summary Due Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Summary_Due_Date,22)+' To '+Convert(varchar(20),@Case_Evaluation_Summary_Due_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Case Evaluation Summary Due Date', 'Case Evaluation Summary Due Date Reminder'))
				END
			Else IF  @OldCase_Evaluation_Summary_Due_Date is not null and @Case_Evaluation_Summary_Due_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Summary Due Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Summary_Due_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Case Evaluation Summary Due Date', 'Case Evaluation Summary Due Date Reminder'))
				END 

		   Declare @OldCase_Evaluation_Status int;
		   Select  @OldCase_Evaluation_Status = Case_Evaluation_Status from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF (@OldCase_Evaluation_Status is null or @OldCase_Evaluation_Status = 0) and @Case_Evaluation_Status != 0
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Case Evaluation '+iif(@Case_Evaluation_Status=1,'Accepted', 'Rejected'), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			    
				IF @Case_Evaluation_Status=1 and lower(@Old_Status) !='case settled mace' and lower(@Company_Type) = 'funding'
				   BEGIN
				   SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='CASE SETTLED MACE')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'CASE SETTLED MACE' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : CASE SETTLED MACE', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'CASE SETTLED MACE';

						END
				   END
				ELSE IF @Case_Evaluation_Status=2 and lower(@Old_Status) !='settlement conference' and lower(@Company_Type) = 'funding'
					BEGIN

					 IF (dbo.CheckStatusHierarchy(@Case_id, @old_Status,'Settlement Conference' , @CreatedBy, @DomainId) = 1 OR @DomainId!='AMT') SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Settlement Conference')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

					     Update tblcase set Status = 'Settlement Conference' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Settlement Conference', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Settlement Conference';

						END
					END

			  END
		   Else IF (@OldCase_Evaluation_Status is not null or @OldCase_Evaluation_Status != 0) and @Case_Evaluation_Status != 0 AND @OldCase_Evaluation_Status <> @Case_Evaluation_Status
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Updated : From '+iif(@OldCase_Evaluation_Status=1,'Accepted', 'Rejected')+' To '+iif(@Case_Evaluation_Status=1,'Accepted', 'Rejected'), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)

					IF @Case_Evaluation_Status=1 and lower(@Old_Status) !='case settled mace' and lower(@Company_Type) = 'funding'
				   BEGIN
					 SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				     SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='CASE SETTLED MACE')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN


						Update tblcase set Status = 'CASE SETTLED MACE' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : CASE SETTLED MACE', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'CASE SETTLED MACE';

						END
				   END
				ELSE IF @Case_Evaluation_Status=2 and lower(@Old_Status) !='Settlement Conference' and lower(@Company_Type) = 'funding'
					BEGIN

					 SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				     SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Settlement Conference')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

					     Update tblcase set Status = 'Settlement Conference' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Settlement Conference', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Settlement Conference';

						END
					END
				END
			Else IF (@OldCase_Evaluation_Status is not null and @OldCase_Evaluation_Status != 0) and @Case_Evaluation_Status = 0
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Updated : From '+iif(@OldCase_Evaluation_Status=1,'Accepted', 'Rejected')+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldCase_Evaluation_Status_Date Datetime = null;
		   Select  @OldCase_Evaluation_Status_Date = Case_Evaluation_Status_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldCase_Evaluation_Status_Date is null and @Case_Evaluation_Status_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Case Evaluation Status Date Added : '+Convert(varchar(20),@Case_Evaluation_Status_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
				 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Case Evaluation Accept/Reject Pending'))
			  END
		   Else IF(@OldCase_Evaluation_Status_Date is not null and @Case_Evaluation_Status_Date is not null AND CONVERT(VARCHAR,@OldCase_Evaluation_Status_Date,101) <> CONVERT(VARCHAR,@Case_Evaluation_Status_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Status Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Status_Date,101)+' To '+Convert(varchar(20),@Case_Evaluation_Status_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldCase_Evaluation_Status_Date is not null and @Case_Evaluation_Status_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Case Evaluation Status Date Updated : From '+Convert(varchar(20),@OldCase_Evaluation_Status_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldFacilitaion_Date Datetime = null;
		   Select  @OldFacilitaion_Date = Facilitation_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldFacilitaion_Date is null and @Facilitation_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Facilitation Date Added : '+Convert(varchar(20),@Facilitation_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			   
			   IF lower(@Old_Status) !='facilitation summary due' and lower(@Company_Type) = 'funding'
				   BEGIN
				  SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)	
				  SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Facilitation Summary Due')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'Facilitation Summary Due' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Facilitation Summary Due', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Facilitation Summary Due';

						END
				   END
			 END
		   Else IF(@OldFacilitaion_Date is not null and @Facilitation_Date is not null AND CONVERT(VARCHAR,@OldFacilitaion_Date,22) <> CONVERT(VARCHAR,@Facilitation_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Facilitation Date Updated : From '+Convert(varchar(20),@OldFacilitaion_Date,22)+' To '+Convert(varchar(20),@Facilitation_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				 
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Facilitation Summary Due', 'Facilitation Date'))
				END
			Else IF  @OldFacilitaion_Date is not null and @Facilitation_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Facilitation Date Updated : From '+Convert(varchar(20),@OldFacilitaion_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
				    and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Facilitation Summary Due', 'Facilitation Date'))
				END 

		   Declare @OldFacilitation_Summary_Due_Date Datetime = null;
		   Select  @OldFacilitation_Summary_Due_Date = Facilitation_Summary_Due_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldFacilitation_Summary_Due_Date is null and @Facilitation_Summary_Due_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Facilitation Summary Due Date Added : '+Convert(varchar(20),@Facilitation_Summary_Due_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
            Else IF(@OldFacilitation_Summary_Due_Date is not null and @Facilitation_Summary_Due_Date is not null AND CONVERT(VARCHAR,@OldFacilitation_Summary_Due_Date,22) <> CONVERT(VARCHAR,@Facilitation_Summary_Due_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Facilitaion Summary Due Date Updated : From '+Convert(varchar(20),@OldFacilitation_Summary_Due_Date,22)+' To '+Convert(varchar(20),@Facilitation_Summary_Due_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Facilitation Summary Due Date', 'Facilitation Summary Due Date Reminder'))
				END
			Else IF  @OldFacilitation_Summary_Due_Date is not null and @Facilitation_Summary_Due_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Facilitaion Summary Due Date Updated : From '+Convert(varchar(20),@OldFacilitation_Summary_Due_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Facilitation Summary Due Date', 'Facilitation Summary Due Date Reminder'))
				END 

		   Declare @OldSettlement_Conference_Date Datetime = null;
		   Select  @OldSettlement_Conference_Date = Settlement_Conference_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldSettlement_Conference_Date is null and @Settlement_Conference_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Settlement Conference(Circuit) Date Added : '+Convert(varchar(20),@Settlement_Conference_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			       IF lower(@Old_Status) !='pretrial statement due' and lower(@Company_Type) = 'funding'
				   BEGIN
				   SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='Pretrial Statement Due')
						--IF (@newStatusHierarchy>=@oldStatusHierarchy)
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'Pretrial Statement Due' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Pretrial Statement Due', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'Pretrial Statement Due';

						END
				   END
			  END
		   Else IF(@OldSettlement_Conference_Date is not null and @Settlement_Conference_Date is not null AND CONVERT(VARCHAR,@OldSettlement_Conference_Date,22) <> CONVERT(VARCHAR,@Settlement_Conference_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement Conference(Circuit) Date Updated : From '+Convert(varchar(20),@OldSettlement_Conference_Date,22)+' To '+Convert(varchar(20),@Settlement_Conference_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Settlement Conference Date'))
				END
			Else IF  @OldSettlement_Conference_Date is not null and @Settlement_Conference_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Settlement Conference(Circuit) Date Updated : From '+Convert(varchar(20),@OldSettlement_Conference_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				      Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					  and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Settlement Conference Date'))
				END 

		   Declare @OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date Datetime = null;
		   Select  @OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date = Final_Pretrial_Statement_Trial_Notebook_Sent_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date is null and @Final_Pretrial_Statement_Trial_Notebook_Sent_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Final Pretrial Statement/Trial Notebook Date Added : '+Convert(varchar(20),@Final_Pretrial_Statement_Trial_Notebook_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
			Else IF(@OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date is not null and @Final_Pretrial_Statement_Trial_Notebook_Sent_Date is not null AND CONVERT(VARCHAR,@OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date,101) <> CONVERT(VARCHAR,@Final_Pretrial_Statement_Trial_Notebook_Sent_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Final Pretrial Statement/Trial Notebook Date Updated : From '+Convert(varchar(20),@OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date,101)+' To '+Convert(varchar(20),@Final_Pretrial_Statement_Trial_Notebook_Sent_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date is not null and @Final_Pretrial_Statement_Trial_Notebook_Sent_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Final Pretrial Statement/Trial Notebook Date Updated : From '+Convert(varchar(20),@OldFinal_Pretrial_Statement_Trial_Notebook_Sent_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldTrial_Date Datetime = null;
		   Select  @OldTrial_Date = Trial_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldTrial_Date is null and @Trial_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Trial Date Added : '+Convert(varchar(20),@Trial_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
		   Else IF(@OldTrial_Date is not null and @Trial_Date is not null AND CONVERT(VARCHAR,@OldTrial_Date,22) <> CONVERT(VARCHAR,@Trial_Date,22))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Trial Date Updated : From '+Convert(varchar(20),@OldTrial_Date,22)+' To '+Convert(varchar(20),@Trial_Date,22), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				  
				     Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					 and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Final Trial Notebook', 'Trial Date'))
				END
			Else IF  @OldTrial_Date is not null and @Trial_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Trial Date Updated : From '+Convert(varchar(20),@OldTrial_Date,22)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				
				    Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) in ('Final Trial Notebook', 'Trial Date'))
				END 

		   Declare @OldAppeal_Date Datetime = null;
		   Select  @OldAppeal_Date = Appeal_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldAppeal_Date is null and @Appeal_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Appeal Date Added : '+Convert(varchar(20),@Appeal_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			    IF lower(@Old_Status) !='appeal pending' and lower(@Company_Type) = 'funding'
				   BEGIN
					  SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
				      SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='APPEAL PENDING')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'APPEAL PENDING' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : Appeal Pending', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'APPEAL PENDING';

						END
				   END
			  END
           Else IF(@OldAppeal_Date is not null and @Appeal_Date is not null AND CONVERT(VARCHAR,@OldAppeal_Date,101) <> CONVERT(VARCHAR,@Appeal_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Appeal Date Updated : From '+Convert(varchar(20),@OldAppeal_Date,101)+' To '+Convert(varchar(20),@Appeal_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldAppeal_Date is not null and @Appeal_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Appeal Date Updated : From '+Convert(varchar(20),@OldAppeal_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldClosing_Statement_Date Datetime = null;
		   Select  @OldClosing_Statement_Date = Closing_Statement_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldClosing_Statement_Date is null and @Closing_Statement_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Closing Statement Date Added : '+Convert(varchar(20),@Closing_Statement_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
		   Else IF(@OldClosing_Statement_Date is not null and @Closing_Statement_Date is not null AND CONVERT(VARCHAR,@OldClosing_Statement_Date,101) <> CONVERT(VARCHAR,@Closing_Statement_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Closing Statement Date Updated : From '+Convert(varchar(20),@OldClosing_Statement_Date,101)+' To '+Convert(varchar(20),@Closing_Statement_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldClosing_Statement_Date is not null and @Closing_Statement_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Closing Statement Date Updated : From '+Convert(varchar(20),@OldClosing_Statement_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldDismissal_Date Datetime = null;
		   Select  @OldDismissal_Date = Dismissal_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldDismissal_Date is null and @Dismissal_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Dismissal Date Added : '+Convert(varchar(20),@Dismissal_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  
			     IF lower(@Old_Status) !='closed' and lower(@Company_Type) = 'funding'
				   BEGIN

				        SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='CLOSED')
					--	IF (@newStatusHierarchy>=@oldStatusHierarchy)
					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
                    BEGIN

						Update tblcase set Status = 'CLOSED' where Case_Id = @Case_Id and DomainId = @DomainId
						EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type=@NotesType,@Ndesc = 'Status Changed To : CLOSED', @user_Id=@CreatedBy, @ApplyToGroup = 0  
						
						SET @Old_Status = 'CLOSED';

						END
				   END
			  END
             Else IF(@OldDismissal_Date is not null and @Dismissal_Date is not null AND CONVERT(VARCHAR,@OldDismissal_Date,101) <> CONVERT(VARCHAR,@Dismissal_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Dismissal Date Updated : From '+Convert(varchar(20),@OldDismissal_Date,101)+' To '+Convert(varchar(20),@Dismissal_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldDismissal_Date is not null and @Dismissal_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Dismissal Date Updated : From '+Convert(varchar(20),@OldDismissal_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

		   Declare @OldComplaint_Amended_Print_Date Datetime = null;
		   Select  @OldComplaint_Amended_Print_Date = Complaint_Amended_Print_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldComplaint_Amended_Print_Date is null and @Complaint_Amended_Print_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Complaint Amended Print Date Added : '+Convert(varchar(20),@Complaint_Amended_Print_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
             Else IF(@OldComplaint_Amended_Print_Date is not null and @Complaint_Amended_Print_Date is not null AND CONVERT(VARCHAR,@OldComplaint_Amended_Print_Date,101) <> CONVERT(VARCHAR,@Complaint_Amended_Print_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Complaint Amended Print Date Updated : From '+Convert(varchar(20),@OldComplaint_Amended_Print_Date,101)+' To '+Convert(varchar(20),@Complaint_Amended_Print_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF  @OldComplaint_Amended_Print_Date is not null and @Complaint_Amended_Print_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Complaint Amended Print Date Updated : From '+Convert(varchar(20),@OldComplaint_Amended_Print_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 

           Declare @OldRelease_Received_Date Datetime = null;
		   Select  @OldRelease_Received_Date = Release_Received_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
			
		   IF @OldRelease_Received_Date is null and @Release_Received_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Release Received Date Added : '+Convert(varchar(20),@Release_Received_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
             Else IF(@OldRelease_Received_Date is not null and @Release_Received_Date is not null AND CONVERT(VARCHAR,@OldRelease_Received_Date,101) <> CONVERT(VARCHAR,@Release_Received_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Release Received Date Updated : From '+Convert(varchar(20),@OldRelease_Received_Date,101)+' To '+Convert(varchar(20),@Release_Received_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				    
					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Client Release F/U')
				END
			Else IF @OldRelease_Received_Date is not null and @Release_Received_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Release Received Date Updated : From '+Convert(varchar(20),@OldRelease_Received_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)

					Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where Case_Id = @Case_Id and DomainId = @DomainId 
					and TriggerTypeId in (Select Id from tblTriggerType Where DomainId = @DomainId and LTRIM(RTRIM(Name)) = 'Client Release F/U')
				END 

		

		   Declare @OldDefense_Answer_To_Discovery_Due_Date Datetime = null;
		   Select  @OldDefense_Answer_To_Discovery_Due_Date = Defense_Answer_To_Discovery_Due_Date from tblCase_Date_Details where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId

		   IF @OldDefense_Answer_To_Discovery_Due_Date is null and @Defense_Answer_To_Discovery_Due_Date is not null
			  BEGIN
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				Values('Defense Answers to our Discovery Due Date Added : '+Convert(varchar(20),@Defense_Answer_To_Discovery_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
			  END
             Else IF(@OldDefense_Answer_To_Discovery_Due_Date is not null and @Defense_Answer_To_Discovery_Due_Date is not null AND CONVERT(VARCHAR,@OldDefense_Answer_To_Discovery_Due_Date,101) <> CONVERT(VARCHAR,@Defense_Answer_To_Discovery_Due_Date,101))
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Answers to our Discovery Due Date Updated : From '+Convert(varchar(20),@OldDefense_Answer_To_Discovery_Due_Date,101)+' To '+Convert(varchar(20),@Defense_Answer_To_Discovery_Due_Date,101), @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END
			Else IF @OldDefense_Answer_To_Discovery_Due_Date is not null and @Defense_Answer_To_Discovery_Due_Date is null
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				    Values('Defense Answers to our Discovery Due Date Updated : From '+Convert(varchar(20),@OldDefense_Answer_To_Discovery_Due_Date,101)+' To ', @NotesType, 1, @Case_Id, GETDATE(), @CreatedBy, @DomainId)
				END 
			
END
