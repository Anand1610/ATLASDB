CREATE TABLE [dbo].[TXN_EXHIBIT_SEQUENCE] (
    [SZ_PROCESS_CODE]             NVARCHAR (10)  NULL,
    [I_INSURANCE_COMPANY_ID]      INT            NULL,
    [I_DOCUMENT_TYPE]             INT            NULL,
    [I_SEQUENCE]                  INT            NOT NULL,
    [SZ_ABSENT_EXHIBIT_STATEMENT] NVARCHAR (400) NULL,
    [DomainId]                    NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [FK_TBLDOCUMENTTYPE] FOREIGN KEY ([I_DOCUMENT_TYPE]) REFERENCES [dbo].[tblDocumentType] ([Document_ID])
);

