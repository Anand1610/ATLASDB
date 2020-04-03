CREATE TABLE [dbo].[tblInsuranceCompanyGroup] (
    [InsuranceCompanyGroup_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [InsuranceCompanyGroup_Name] VARCHAR (255)  NOT NULL,
    [DomainId]                   NVARCHAR (100) NOT NULL,
    [created_by_user]            NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]               DATETIME       CONSTRAINT [DF_CaseStatus_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]           NVARCHAR (255) NULL,
    [modified_date]              DATETIME       NULL,
    CONSTRAINT [PK_InsuranceCompanyGroup] PRIMARY KEY CLUSTERED ([DomainId] ASC, [InsuranceCompanyGroup_Name] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblInsuranceCompanyGroup]([DomainId] ASC);

