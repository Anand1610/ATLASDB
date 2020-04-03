CREATE TABLE [dbo].[Tbl_Rules] (
    [Rules_ID]           INT             IDENTITY (1, 1) NOT NULL,
    [Rules_Disc]         NVARCHAR (MAX)  NULL,
    [Provider_ID]        INT             NULL,
    [InsuranceCompanyID] INT             NULL,
    [Provider_Group]     NVARCHAR (250)  NULL,
    [Insurance_Group]    NVARCHAR (250)  NULL,
    [Status]             VARCHAR (50)    NULL,
    [Date_Created]       DATE            CONSTRAINT [DF_Tbl_Rules_Date_Created] DEFAULT (getdate()) NOT NULL,
    [Created_By]         VARCHAR (50)    NULL,
    [Rule_RequestedBy]   NVARCHAR (250)  NULL,
    [Rule_Component]     NVARCHAR (MAX)  NULL,
    [Rule_Action]        NVARCHAR (MAX)  NULL,
    [Rule_Type]          NVARCHAR (MAX)  NULL,
    [DomainId]           NVARCHAR (50)   CONSTRAINT [DF_Tbl_Rules_DomainId] DEFAULT ('h1') NULL,
    [FilePath]           NVARCHAR (1000) NULL,
    [Filename]           NVARCHAR (250)  NULL,
    [Category]           NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Rules] PRIMARY KEY CLUSTERED ([Rules_ID] ASC)
);

