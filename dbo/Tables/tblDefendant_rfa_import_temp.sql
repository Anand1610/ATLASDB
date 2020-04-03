CREATE TABLE [dbo].[tblDefendant_rfa_import_temp] (
    [Defendant_id]          INT           NOT NULL,
    [Defendant_Name]        VARCHAR (100) NULL,
    [Defendant_DisplayName] VARCHAR (100) NULL,
    [Defendant_Address]     VARCHAR (255) NULL,
    [Defendant_City]        VARCHAR (100) NULL,
    [Defendant_State]       VARCHAR (100) NULL,
    [Defendant_Zip]         VARCHAR (20)  NULL,
    [Defendant_Phone]       VARCHAR (20)  NULL,
    [Defendant_Fax]         VARCHAR (20)  NULL,
    [Defendant_Email]       VARCHAR (100) NULL,
    [active]                INT           NULL,
    [created_by_user]       VARCHAR (255) NULL,
    [created_date]          DATETIME      NULL,
    [modified_by_user]      VARCHAR (255) NULL,
    [modified_date]         DATETIME      NULL
);

