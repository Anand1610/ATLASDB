-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Case_Date_Details_Insert 
	@Auto_Id int,
	@Case_Id varchar(50),
	@DomainId varchar(50),
	--@Complaint_Print_Date DateTime = null,
	@Date_Summons_Expires DateTime = null,
	@Date_Filed DateTime = null,
	@Proof_of_Service_Date DateTime = null,
	@Date_Answer_Received DateTime = null,
	@Scheduling_Order_Issue_Date DateTime = null,
	@Witness_list_Due_Date DateTime = null,
	@Motion_Cutoff_Date DateTime = null,
	@Discovery_Cutoff_Date DateTime = null,
	@Pretrial_Statement_Due_Date DateTime = null,
	@Pretrial_Conf_Date DateTime = null,
	@Defense_Discovery_Receipt_Date DateTime = null,
	@Plaintiff_Propounded_Discovery_Sent_Date DateTime = null,
	@Discovery_Stip_Sent_Date DateTime = null,
	@Plaintiff_Discovery_Responses_Completed_Date DateTime = null,
	@Defense_Deposition_Date DateTime = null,
	@Plaintiff_Deposition_Date DateTime = null,
	@Settlement_Date DateTime = null,
	@Settlement_FU_letter_Date_1 DateTime = null,
	@Settlement_FU_letter_Date_2 DateTime = null,
	@Client_Release_Execution_Request_Date DateTime = null,
	@Release_FU_Date DateTime = null,
	@Case_Evaluation_Date DateTime = null,
	@Case_Evaluation_Summary_Due_Date DateTime = null,
	@Case_Evaluation_Status int = 0,
	@Case_Evaluation_Status_Date DateTime = null,
	@Facilitation_Date DateTime = null,
	@Facilitation_Summary_Due_Date DateTime = null,
	@Settlement_Conference_Date DateTime = null,
	@Final_Pretrial_Statement_Trial_Notebook_Sent_Date DateTime = null,
	@Trial_Date DateTime = null,
	@Appeal_Date DateTime = null,
	@Closing_Statement_Date DateTime = null,
	@Dismissal_Date DateTime  = null,
	@Complaint_Amended_Print_Date Datetime = null,
	@Release_Received_Date Datetime = null,
	@Adjuster_Depo_Date Datetime = null,
    @Defense_Answer_To_Discovery_Due_Date Datetime = null,
	@Defense_Answers_to_our_Discovery_Completed_Date Datetime = null,
	@Payment_Received_Date Datetime = null,
	@CreatedBy varchar(100)

AS
BEGIN
     
	  If @Auto_Id = 0 and Exists(Select Auto_Id  from tblCase_Date_Details Where Case_Id = @Case_Id and DomainId = @DomainId)
		BEGIN
	      Select @Auto_Id = Auto_Id from tblCase_Date_Details Where Case_Id = @Case_Id and DomainId = @DomainId
		END

		Exec Case_Date_Details_Notes_Insert @Auto_Id,@Case_Id,@DomainId,@Date_Summons_Expires,@Date_Filed,
			@Proof_of_Service_Date,@Date_Answer_Received,@Scheduling_Order_Issue_Date,@Witness_list_Due_Date,@Motion_Cutoff_Date,
	        @Discovery_Cutoff_Date,@Pretrial_Statement_Due_Date,@Pretrial_Conf_Date,@Defense_Discovery_Receipt_Date,@Plaintiff_Propounded_Discovery_Sent_Date,
			@Discovery_Stip_Sent_Date,@Plaintiff_Discovery_Responses_Completed_Date,@Defense_Deposition_Date,@Plaintiff_Deposition_Date,
			@Settlement_Date,@Settlement_FU_letter_Date_1,@Settlement_FU_letter_Date_2,@Client_Release_Execution_Request_Date,
			@Release_FU_Date,@Case_Evaluation_Date,@Case_Evaluation_Summary_Due_Date,@Case_Evaluation_Status,@Case_Evaluation_Status_Date,
			@Facilitation_Date,@Facilitation_Summary_Due_Date,@Settlement_Conference_Date,@Final_Pretrial_Statement_Trial_Notebook_Sent_Date,
			@Trial_Date,@Appeal_Date,@Closing_Statement_Date,@Dismissal_Date,@Complaint_Amended_Print_Date,@Release_Received_Date,
			@Adjuster_Depo_Date,@Defense_Answer_To_Discovery_Due_Date,@Defense_Answers_to_our_Discovery_Completed_Date,@Payment_Received_Date,@CreatedBy

    If @Auto_Id = 0
	BEGIN
	  
	  If @Date_Summons_Expires is null and @Date_Filed is not null
	  BEGIN
	     SET @Date_Summons_Expires = DATEADD(Day, 90, @Date_Filed)
	  END

	  Insert into tblCase_Date_Details (
	         Case_Id
			,DomainId
			,Date_Summons_Expires
			,Date_Filed
			,Proof_of_Service_Date 
			,Date_Answer_Received
			,Scheduling_Order_Issue_Date
			,Witness_list_Due_Date
			,Motion_Cutoff_Date
			,Discovery_Cutoff_Date
			,Pretrial_Statement_Due_Date
			,Pretrial_Conf_Date
			,Defense_Discovery_Receipt_Date
			,Plaintiff_Propounded_Discovery_Sent_Date
			,Discovery_Stip_Sent_Date
			,Plaintiff_Discovery_Responses_Completed_Date
			,Defense_Deposition_Date
			,Plaintiff_Deposition_Date
			,Settlement_Date
			,Settlement_FU_letter_Date_1
			--,Settlement_FU_letter_Date_2
			,Client_Release_Execution_Request_Date
			--,Release_FU_Date
			,Case_Evaluation_Date
			,Case_Evaluation_Summary_Due_Date
			,Case_Evaluation_Status
			,Case_Evaluation_Status_Date
			,Facilitation_Date
			,Facilitation_Summary_Due_Date
			,Settlement_Conference_Date
			,Final_Pretrial_Statement_Trial_Notebook_Sent_Date
			,Trial_Date
			,Appeal_Date
			,Closing_Statement_Date
			,Dismissal_Date
			,Complaint_Amended_Print_Date
			,Release_Received_Date
			,Adjuster_Depo_Date
			,Defense_Answer_To_Discovery_Due_Date
			,Defense_Answers_to_our_Discovery_Completed_Date
			,Payment_Received_Date
			,CreatedBy
			,CreatedDate)
			Values (
			 @Case_Id
			,@DomainId
			,@Date_Summons_Expires
			,@Date_Filed
			,@Proof_of_Service_Date 
			,@Date_Answer_Received
			,@Scheduling_Order_Issue_Date
			,@Witness_list_Due_Date
			,@Motion_Cutoff_Date
			,@Discovery_Cutoff_Date
			,@Pretrial_Statement_Due_Date
			,@Pretrial_Conf_Date
			,@Defense_Discovery_Receipt_Date
			,@Plaintiff_Propounded_Discovery_Sent_Date
			,@Discovery_Stip_Sent_Date
			,@Plaintiff_Discovery_Responses_Completed_Date
			,@Defense_Deposition_Date
			,@Plaintiff_Deposition_Date
			,@Settlement_Date
			,@Settlement_FU_letter_Date_1
			--,@Settlement_FU_letter_Date_2
			,@Client_Release_Execution_Request_Date
			--,@Release_FU_Date
			,@Case_Evaluation_Date
			,@Case_Evaluation_Summary_Due_Date
			,@Case_Evaluation_Status
			,@Case_Evaluation_Status_Date
			,@Facilitation_Date
			,@Facilitation_Summary_Due_Date
			,@Settlement_Conference_Date
			,@Final_Pretrial_Statement_Trial_Notebook_Sent_Date
			,@Trial_Date
			,@Appeal_Date
			,@Closing_Statement_Date
			,@Dismissal_Date
			,@Complaint_Amended_Print_Date
			,@Release_Received_Date
			,@Adjuster_Depo_Date
			,@Defense_Answer_To_Discovery_Due_Date
			,@Defense_Answers_to_our_Discovery_Completed_Date
			,@Payment_Received_Date
			,@CreatedBy
			,GETDATE())

	END
	ELSE
	BEGIN
	    
      If @Date_Summons_Expires is null and @Date_Filed is not null
	  and (Select Date_Summons_Expires from tblCase_Date_Details(NOLOCK) where Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId) is null
	  BEGIN
	     SET @Date_Summons_Expires = DATEADD(Day, 90, @Date_Filed)
	  END

	  Update tblCase_Date_Details Set
			 Date_Summons_Expires = @Date_Summons_Expires
			,Date_Filed = @Date_Filed
			,Proof_of_Service_Date = @Proof_of_Service_Date
			,Date_Answer_Received = @Date_Answer_Received
			,Scheduling_Order_Issue_Date = @Scheduling_Order_Issue_Date
			,Witness_list_Due_Date = @Witness_list_Due_Date
			,Motion_Cutoff_Date = @Motion_Cutoff_Date
			,Discovery_Cutoff_Date = @Discovery_Cutoff_Date
			,Pretrial_Statement_Due_Date = @Pretrial_Statement_Due_Date
			,Pretrial_Conf_Date = @Pretrial_Conf_Date
			,Defense_Discovery_Receipt_Date = @Defense_Discovery_Receipt_Date
			,Plaintiff_Propounded_Discovery_Sent_Date = @Plaintiff_Propounded_Discovery_Sent_Date
			,Discovery_Stip_Sent_Date = @Discovery_Stip_Sent_Date
			,Plaintiff_Discovery_Responses_Completed_Date = @Plaintiff_Discovery_Responses_Completed_Date
			,Defense_Deposition_Date = @Defense_Deposition_Date
			,Plaintiff_Deposition_Date = @Plaintiff_Deposition_Date
			,Settlement_Date = @Settlement_Date
			,Settlement_FU_letter_Date_1 = @Settlement_FU_letter_Date_1
			--,Settlement_FU_letter_Date_2 = @Settlement_FU_letter_Date_2
			,Client_Release_Execution_Request_Date = @Client_Release_Execution_Request_Date
			--,Release_FU_Date = @Release_FU_Date
			,Case_Evaluation_Date = @Case_Evaluation_Date
			,Case_Evaluation_Summary_Due_Date = @Case_Evaluation_Summary_Due_Date
			,Case_Evaluation_Status = @Case_Evaluation_Status
			,Case_Evaluation_Status_Date = @Case_Evaluation_Status_Date
			,Facilitation_Date = @Facilitation_Date
			,Facilitation_Summary_Due_Date = @Facilitation_Summary_Due_Date
			,Settlement_Conference_Date = @Settlement_Conference_Date
			,Final_Pretrial_Statement_Trial_Notebook_Sent_Date = @Final_Pretrial_Statement_Trial_Notebook_Sent_Date
			,Trial_Date = @Trial_Date
			,Appeal_Date = @Appeal_Date
			,Closing_Statement_Date = @Closing_Statement_Date
			,Dismissal_Date = @Dismissal_Date
			,Complaint_Amended_Print_Date = @Complaint_Amended_Print_Date
			,Release_Received_Date = @Release_Received_Date
			,Adjuster_Depo_Date = @Adjuster_Depo_Date
			,Defense_Answer_To_Discovery_Due_Date = @Defense_Answer_To_Discovery_Due_Date
			,Defense_Answers_to_our_Discovery_Completed_Date = @Defense_Answers_to_our_Discovery_Completed_Date
			,Payment_Received_Date = @Payment_Received_Date
			,UpdatedBy = @CreatedBy
		    ,UpdatedDate = GETDATE()
			Where
			Auto_Id = @Auto_Id and Case_Id = @Case_Id and DomainId = @DomainId
	END
END
