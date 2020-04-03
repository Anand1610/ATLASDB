CREATE TABLE [dbo].[tblCase_Date_Details] (
    [Auto_Id]                                           INT            IDENTITY (1, 1) NOT NULL,
    [Case_Id]                                           VARCHAR (50)   NULL,
    [DomainId]                                          VARCHAR (50)   NULL,
    [Date_Open_Verification_Response_Sent1]             DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Date_Open_Verification_Response_Sent1] DEFAULT (NULL) NULL,
    [Date_Open_Verification_Response_Sent2]             DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Date_Open_Verification_Response_Sent2] DEFAULT (NULL) NULL,
    [CASE_EVALUATION_DATE]                              DATETIME       CONSTRAINT [DF_tblCase_Date_Details_CASE_EVALUATION_DATE] DEFAULT (NULL) NULL,
    [LITIGATION_PAYMENT_DATE]                           DATETIME       CONSTRAINT [DF_tblCase_Date_Details_LITIGATION_PAYMENT_DATE] DEFAULT (NULL) NULL,
    [Appeal_Date]                                       DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Appeal_Date] DEFAULT (NULL) NULL,
    [Summons_and_Complaint_Date]                        DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Summons_and_Complaint_Date] DEFAULT (NULL) NULL,
    [Date_Summons_Expires]                              DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Date_Summons_Expires] DEFAULT (NULL) NULL,
    [Plaintiff_Disccovery_Request_Package]              DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Plaintiff_Disccovery_Request_Package] DEFAULT (NULL) NULL,
    [Plaintiff_Discovery_Responses_Completed]           DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Plaintiff_Discovery_Responses_Completed] DEFAULT (NULL) NULL,
    [Date_Case_Purchased]                               DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Date_Case_Purchased] DEFAULT (NULL) NULL,
    [Defense_Discovery_Receipt_Date]                    DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Defense_Discovery_Receipt_Date] DEFAULT (NULL) NULL,
    [Motion_For_Ext_of_Time_1]                          DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Motion_For_Ext_of_Time_1] DEFAULT (NULL) NULL,
    [Motion_For_Ext_of_Time_2]                          DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Motion_For_Ext_of_Time_2] DEFAULT (NULL) NULL,
    [Pre_Trial_Conf_Date]                               DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Pre_Trial_Conf_Date] DEFAULT (NULL) NULL,
    [Case_Evaluation_Summary_Due_Date]                  DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Case_Evaluation_Summary_Due_Date] DEFAULT (NULL) NULL,
    [Case_Evaluation_Accept_or_Reject]                  BIT            CONSTRAINT [DF_tblCase_Date_Details_Case_Evaluation_Accept_or_Reject] DEFAULT (NULL) NULL,
    [Settlement_Conference]                             VARCHAR (100)  CONSTRAINT [DF_tblCase_Date_Details_Settlement_Conference] DEFAULT (NULL) NULL,
    [Facilitation_Date]                                 DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Facilitation_Date] DEFAULT (NULL) NULL,
    [Witness_and_Exhibit_List_Due_Date]                 DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Witness_and_Exhibit_List_Due_Date] DEFAULT (NULL) NULL,
    [Trial_Notebook_Due_Date]                           DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Trial_Notebook_Due_Date] DEFAULT (NULL) NULL,
    [Dismissal_Date]                                    DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Dismissal_Date] DEFAULT (NULL) NULL,
    [Date_Answer_Received]                              DATETIME       CONSTRAINT [DF_tblCase_Date_Details_Date_Answer_Received] DEFAULT (NULL) NULL,
    [First_Party_Suit_Filed_Date]                       DATETIME       NULL,
    [Complaint_Print_Date]                              DATETIME       NULL,
    [Date_Filed]                                        DATETIME       NULL,
    [Proof_of_Service_Date]                             DATETIME       NULL,
    [Scheduling_Order_Issue_Date]                       DATETIME       NULL,
    [Witness_list_Due_Date]                             DATETIME       NULL,
    [Motion_Cutoff_Date]                                DATETIME       NULL,
    [Discovery_Cutoff_Date]                             DATETIME       NULL,
    [Pretrial_Statement_Due_Date]                       DATETIME       NULL,
    [Pretrial_Conf_Date]                                DATETIME       NULL,
    [Plaintiff_Propounded_Discovery_Sent_Date]          DATETIME       NULL,
    [Discovery_Stip_Sent_Date]                          DATETIME       NULL,
    [Plaintiff_Discovery_Responses_Completed_Date]      DATETIME       NULL,
    [Defense_Deposition_Date]                           DATETIME       NULL,
    [Plaintiff_Deposition_Date]                         DATETIME       NULL,
    [Settlement_Date]                                   DATETIME       NULL,
    [Settlement_FU_letter_Date_1]                       DATETIME       NULL,
    [Settlement_FU_letter_Date_2]                       DATETIME       NULL,
    [Client_Release_Execution_Request_Date]             DATETIME       NULL,
    [Release_FU_Date]                                   DATETIME       NULL,
    [Case_Evaluation_Status]                            INT            DEFAULT ((0)) NULL,
    [Case_Evaluation_Status_Date]                       DATETIME       NULL,
    [Facilitation_Summary_Due_Date]                     DATETIME       NULL,
    [Settlement_Conference_Date]                        DATETIME       NULL,
    [Final_Pretrial_Statement_Trial_Notebook_Sent_Date] DATETIME       NULL,
    [Closing_Statement_Date]                            DATETIME       NULL,
    [CreatedBy]                                         NVARCHAR (100) NULL,
    [CreatedDate]                                       DATETIME       NULL,
    [UpdatedBy]                                         NVARCHAR (100) NULL,
    [UpdatedDate]                                       DATETIME       NULL,
    [trial_date]                                        DATETIME       NULL,
    [Complaint_Amended_Print_Date]                      DATETIME       NULL,
    [Release_Received_Date]                             DATETIME       NULL,
    [Adjuster_Depo_Date]                                DATETIME       NULL,
    [Defense_Answer_To_Discovery_Due_Date]              DATETIME       NULL,
    [Defense_Answers_to_our_Discovery_Completed_Date]   DATETIME       NULL,
    [Payment_Received_Date]                             DATETIME       NULL,
    [Packeted_Status_Date]                              DATETIME       NULL,
    CONSTRAINT [PK_tblCase_Date_Details] PRIMARY KEY CLUSTERED ([Auto_Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblCase_Date_Details_Did_Cid]
    ON [dbo].[tblCase_Date_Details]([DomainId] ASC, [Case_Id] ASC)
    INCLUDE([Date_Open_Verification_Response_Sent1], [Date_Open_Verification_Response_Sent2], [CASE_EVALUATION_DATE], [LITIGATION_PAYMENT_DATE], [Appeal_Date], [Summons_and_Complaint_Date], [Date_Summons_Expires], [Plaintiff_Disccovery_Request_Package], [Plaintiff_Discovery_Responses_Completed], [Date_Case_Purchased], [Defense_Discovery_Receipt_Date], [Motion_For_Ext_of_Time_1], [Motion_For_Ext_of_Time_2], [Pre_Trial_Conf_Date], [Case_Evaluation_Summary_Due_Date], [Case_Evaluation_Accept_or_Reject], [Settlement_Conference], [Facilitation_Date], [Witness_and_Exhibit_List_Due_Date], [Trial_Notebook_Due_Date], [Dismissal_Date], [Date_Answer_Received], [First_Party_Suit_Filed_Date], [Complaint_Print_Date], [Date_Filed], [Proof_of_Service_Date], [Scheduling_Order_Issue_Date], [Witness_list_Due_Date], [Motion_Cutoff_Date], [Discovery_Cutoff_Date], [Pretrial_Statement_Due_Date], [Pretrial_Conf_Date], [Plaintiff_Propounded_Discovery_Sent_Date], [Discovery_Stip_Sent_Date], [Plaintiff_Discovery_Responses_Completed_Date], [Defense_Deposition_Date], [Plaintiff_Deposition_Date], [Settlement_Date], [Settlement_FU_letter_Date_1], [Settlement_FU_letter_Date_2], [Client_Release_Execution_Request_Date], [Release_FU_Date], [Case_Evaluation_Status], [Case_Evaluation_Status_Date], [Facilitation_Summary_Due_Date], [Settlement_Conference_Date], [Final_Pretrial_Statement_Trial_Notebook_Sent_Date], [Closing_Statement_Date], [trial_date], [Complaint_Amended_Print_Date], [Release_Received_Date], [Adjuster_Depo_Date], [Defense_Answer_To_Discovery_Due_Date], [Defense_Answers_to_our_Discovery_Completed_Date], [Payment_Received_Date]);


GO
CREATE NONCLUSTERED INDEX [IX_Case_Date_Details_Complaint_Print]
    ON [dbo].[tblCase_Date_Details]([DomainId] ASC, [Complaint_Print_Date] ASC)
    INCLUDE([Case_Id]);


GO
CREATE NONCLUSTERED INDEX [tblCase_Date_Details_Answer_Received]
    ON [dbo].[tblCase_Date_Details]([Date_Answer_Received] ASC, [Date_Summons_Expires] ASC)
    INCLUDE([Case_Id], [DomainId]);

