CREATE TABLE [dbo].[tblPrintDocs] (
    [Print_Id]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [Case_id]      VARCHAR (50)   NULL,
    [Doc_Id]       INT            NULL,
    [Requested_On] DATETIME       NULL,
    [Requested_By] INT            NULL,
    [Printed_On]   DATETIME       NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblPrintDocs] PRIMARY KEY CLUSTERED ([Print_Id] ASC) WITH (FILLFACTOR = 90)
);

