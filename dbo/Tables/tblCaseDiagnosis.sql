CREATE TABLE [dbo].[tblCaseDiagnosis] (
    [CaseDiag_Id] INT            IDENTITY (1, 1) NOT NULL,
    [Case_Id]     NVARCHAR (50)  NOT NULL,
    [Diag_Id]     INT            NOT NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblCaseDiagnosis] PRIMARY KEY CLUSTERED ([CaseDiag_Id] ASC)
);

