CREATE TABLE [dbo].[tblEmailSend_Info] (
    [AutoID]      INT            IDENTITY (1, 1) NOT NULL,
    [UserId]      NVARCHAR (50)  NULL,
    [Case_ID]     NVARCHAR (50)  NULL,
    [EmailID]     NVARCHAR (50)  NULL,
    [Send_Status] NVARCHAR (50)  NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

