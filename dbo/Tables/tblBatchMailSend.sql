CREATE TABLE [dbo].[tblBatchMailSend] (
    [CASE_ID]      VARCHAR (100)  NULL,
    [MailSendDate] DATETIME       NULL,
    [TYPE]         VARCHAR (100)  NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [BatchCode]    NVARCHAR (50)  NULL
);

