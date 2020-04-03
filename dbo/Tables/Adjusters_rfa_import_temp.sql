CREATE TABLE [dbo].[Adjusters_rfa_import_temp] (
    [Adjuster_Id]         INT            NOT NULL,
    [Adjuster_LastName]   NVARCHAR (100) NULL,
    [Adjuster_FirstName]  NVARCHAR (100) NULL,
    [InsuranceCompany_Id] NVARCHAR (50)  NOT NULL,
    [Adjuster_Phone]      NVARCHAR (50)  NULL,
    [Adjuster_Fax]        NVARCHAR (50)  NULL,
    [Adjuster_Email]      NVARCHAR (50)  NULL,
    [Adjuster_Extension]  NVARCHAR (50)  NULL,
    [Adjuster_Address]    NVARCHAR (250) NULL,
    [created_by_user]     VARCHAR (255)  NULL,
    [created_date]        DATETIME       NULL,
    [modified_by_user]    VARCHAR (255)  NULL,
    [modified_date]       DATETIME       NULL
);

