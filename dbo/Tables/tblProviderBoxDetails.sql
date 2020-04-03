CREATE TABLE [dbo].[tblProviderBoxDetails] (
    [auto_id]       INT            IDENTITY (1, 1) NOT NULL,
    [provider_id]   VARCHAR (50)   NULL,
    [provider_name] VARCHAR (100)  NULL,
    [box_rec_date]  DATETIME       NULL,
    [no_of_cases]   INT            NULL,
    [status]        VARCHAR (50)   NULL,
    [file_scanned]  INT            NULL,
    [file_pending]  INT            NULL,
    [batch_no]      VARCHAR (50)   NULL,
    [UserName]      NVARCHAR (510) NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    UNIQUE NONCLUSTERED ([batch_no] ASC)
);

