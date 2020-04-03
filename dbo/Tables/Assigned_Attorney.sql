CREATE TABLE [dbo].[Assigned_Attorney] (
    [PK_Assigned_Attorney_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [Assigned_Attorney]         VARCHAR (200)  NOT NULL,
    [DomainID]                  VARCHAR (50)   NOT NULL,
    [created_by_user]           NVARCHAR (255) NOT NULL,
    [created_date]              DATETIME       CONSTRAINT [DF_Assigned_Attorney_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]          NVARCHAR (255) NULL,
    [modified_date]             DATETIME       NULL,
    [LawFirm_Name]              VARCHAR (200)  NULL,
    [Assigned_Attorney_Address] NVARCHAR (200) NULL,
    [Assigned_Attorney_Phone]   NVARCHAR (50)  NULL,
    [Assigned_Attorney_Fax]     NVARCHAR (50)  NULL,
    [Assigned_Attorney_Email]   NVARCHAR (200) NULL,
    CONSTRAINT [PK_Assigned_Attorney] PRIMARY KEY CLUSTERED ([Assigned_Attorney] ASC, [DomainID] ASC)
);

