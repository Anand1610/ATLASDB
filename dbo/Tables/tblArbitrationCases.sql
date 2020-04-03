CREATE TABLE [dbo].[tblArbitrationCases] (
    [Case_Id]       NVARCHAR (50)  NULL,
    [ready_date]    DATETIME       NULL,
    [printed_date]  DATETIME       NULL,
    [ready_by_user] NVARCHAR (10)  NULL,
    [AutoId]        INT            IDENTITY (1, 1) NOT NULL,
    [MailSendDate]  DATETIME       NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [BatchCode]     NVARCHAR (50)  NULL
);

