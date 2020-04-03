CREATE TABLE [dbo].[tblCaseWorkflowAttachments] (
    [AutoID]            INT           IDENTITY (1, 1) NOT NULL,
    [WorkflowQueue_Id]  BIGINT        NULL,
    [AttachmentImageID] BIGINT        NULL,
    [DomainId]          VARCHAR (150) NULL,
    CONSTRAINT [PK_tblCaseWorkflowAttachments] PRIMARY KEY CLUSTERED ([AutoID] ASC)
);

