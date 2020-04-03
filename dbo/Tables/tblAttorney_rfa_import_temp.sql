CREATE TABLE [dbo].[tblAttorney_rfa_import_temp] (
    [Attorney_AutoId]    INT           NOT NULL,
    [Attorney_Id]        VARCHAR (40)  NOT NULL,
    [Attorney_LastName]  VARCHAR (100) NULL,
    [Attorney_FirstName] VARCHAR (100) NULL,
    [Attorney_Address]   VARCHAR (255) NULL,
    [Attorney_City]      VARCHAR (50)  NULL,
    [Attorney_State]     VARCHAR (50)  NULL,
    [Attorney_Zip]       VARCHAR (50)  NULL,
    [Attorney_Phone]     VARCHAR (20)  NULL,
    [Attorney_Fax]       VARCHAR (20)  NULL,
    [Attorney_Email]     VARCHAR (40)  NULL,
    [Defendant_Id]       NVARCHAR (50) NOT NULL,
    [created_by_user]    VARCHAR (255) NULL,
    [created_date]       DATETIME      NULL,
    [modified_by_user]   VARCHAR (255) NULL,
    [modified_date]      DATETIME      NULL
);

