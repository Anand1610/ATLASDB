CREATE TABLE [dbo].[tblInvoicePayment_Documents] (
    [IDocID]           INT            IDENTITY (1, 1) NOT NULL,
    [InvPay_Doc_Name]  NVARCHAR (100) NULL,
    [InvPay_File_Path] NVARCHAR (200) NULL,
    [Provider_Id]      INT            NULL,
    [Payment_Id]       INT            NULL,
    [CreatedBy]        NVARCHAR (50)  NULL,
    [CreatedDate]      DATETIME       NULL,
    [DomainId]         NVARCHAR (50)  NULL,
    [DocType]          NVARCHAR (100) NULL,
    [BasePathId]       INT            NULL,
    CONSTRAINT [PK_tblInvoicePayment_Documents] PRIMARY KEY CLUSTERED ([IDocID] ASC)
);

