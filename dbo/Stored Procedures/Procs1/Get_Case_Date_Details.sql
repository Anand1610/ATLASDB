
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Get_Case_Date_Details 
	@s_a_DomainId varchar(50),
	@s_a_CaseId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	   Select 
		 Auto_Id
		,cd.Case_Id
		,cd.DomainId
		,iif(Arbitrator_ID is null, 0, Arbitrator_ID) Arbitrator_ID
		,Convert(varchar(50), Complaint_Print_Date, 101) Complaint_Print_Date
		,Convert(varchar(50), Date_Summons_Expires, 101) Date_Summons_Expires
		,Convert(varchar(50), Date_Filed, 101) Date_Filed
		,Convert(varchar(50), Proof_of_Service_Date, 101) Proof_of_Service_Date 
		,Convert(varchar(50), Date_Answer_Received, 101) Date_Answer_Received
		,Convert(varchar(50), Scheduling_Order_Issue_Date, 101) Scheduling_Order_Issue_Date
		,Convert(varchar(50), Witness_list_Due_Date, 101) Witness_list_Due_Date
		,Convert(varchar(50), Motion_Cutoff_Date, 101) Motion_Cutoff_Date
		,Convert(varchar(50), Discovery_Cutoff_Date, 101) Discovery_Cutoff_Date
		,Convert(varchar(50), Pretrial_Statement_Due_Date, 101) Pretrial_Statement_Due_Date
		,Convert(varchar(50), Pretrial_Conf_Date, 101) Pretrial_Conf_Date
		,Convert(varchar(50), Defense_Discovery_Receipt_Date, 101) Defense_Discovery_Receipt_Date
		,Convert(varchar(50), Plaintiff_Propounded_Discovery_Sent_Date, 101) Plaintiff_Propounded_Discovery_Sent_Date
		,Convert(varchar(50), Discovery_Stip_Sent_Date, 101) Discovery_Stip_Sent_Date
		,Convert(varchar(50), Plaintiff_Discovery_Responses_Completed_Date, 101) Plaintiff_Discovery_Responses_Completed_Date
		,Defense_Deposition_Date
		,Plaintiff_Deposition_Date
		--,Convert(varchar(50), Defense_Deposition_Date, 101) Defense_Deposition_Date
		--,Convert(varchar(50), Plaintiff_Deposition_Date, 101) Plaintiff_Deposition_Date
		,Convert(varchar(50), Settlement_Date, 101) Settlement_Date
		,Convert(varchar(50), Settlement_FU_letter_Date_1, 101) Settlement_FU_letter_Date_1
		,Convert(varchar(50), Settlement_FU_letter_Date_2, 101) Settlement_FU_letter_Date_2
		,Convert(varchar(50), Client_Release_Execution_Request_Date, 101) Client_Release_Execution_Request_Date
		,Convert(varchar(50), Release_FU_Date, 101) Release_FU_Date
		,Case_Evaluation_Date
		--,Convert(varchar(50), Case_Evaluation_Date, 101) Case_Evaluation_Date
		,Case_Evaluation_Summary_Due_Date
		--,Convert(varchar(50), Case_Evaluation_Summary_Due_Date, 101) Case_Evaluation_Summary_Due_Date
		,Case_Evaluation_Status
		,Convert(varchar(50), Case_Evaluation_Status_Date, 101) Case_Evaluation_Status_Date
		,Facilitation_Date
		--,Convert(varchar(50), Facilitation_Date, 101) Facilitation_Date
		,Facilitation_Summary_Due_Date
		--,Convert(varchar(50), Facilitation_Summary_Due_Date, 101) Facilitation_Summary_Due_Date
		,Settlement_Conference_Date
		--,Convert(varchar(50), Settlement_Conference_Date, 101) Settlement_Conference_Date
		,Convert(varchar(50), Final_Pretrial_Statement_Trial_Notebook_Sent_Date, 101) Final_Pretrial_Statement_Trial_Notebook_Sent_Date
		,Trial_Date
		--,Convert(varchar(50), Trial_Date, 101) Trial_Date
		,Convert(varchar(50), Appeal_Date, 101) Appeal_Date
		,Convert(varchar(50), Closing_Statement_Date, 101) Closing_Statement_Date
		,Convert(varchar(50), Dismissal_Date, 101) Dismissal_Date
		,Convert(varchar(50), Complaint_Amended_Print_Date, 101) Complaint_Amended_Print_Date
		,Convert(varchar(50), Release_Received_Date, 101) Release_Received_Date
		,Convert(varchar(50), Adjuster_Depo_Date, 101) Adjuster_Depo_Date
		,Convert(varchar(50), Defense_Answer_To_Discovery_Due_Date, 101) Defense_Answer_To_Discovery_Due_Date
		,Convert(varchar(50), Defense_Answers_to_our_Discovery_Completed_Date, 101) Defense_Answers_to_our_Discovery_Completed_Date
		,Convert(varchar(50), Payment_Received_Date, 101) Payment_Received_Date
		,CreatedBy
		,CreatedDate
		,UpdatedBy
		,UpdatedDate
	from tblcase(NOLOCK) c left join tblCase_Date_Details(NOLOCK) cd on cd.Case_Id = c.Case_Id 
	Where cd.Case_Id = @s_a_CaseId and cd.DomainId = @s_a_DomainId
END
