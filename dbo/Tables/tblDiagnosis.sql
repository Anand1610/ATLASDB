CREATE TABLE [dbo].[tblDiagnosis] (
    [Diag_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Diag_Code] NVARCHAR (50)  NOT NULL,
    [Diag_Name] NVARCHAR (300) NULL,
    [DomainId]  NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblDiagnosis] PRIMARY KEY CLUSTERED ([Diag_Id] ASC)
);

