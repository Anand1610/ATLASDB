CREATE TABLE [dbo].[tblDenialReasons_rfa_import_temp] (
    [DenialReasons_Id]   INT           NOT NULL,
    [DenialReasons_Type] VARCHAR (80)  NULL,
    [Denial_Colorcode]   NVARCHAR (50) NULL,
    [I_CATEGORY_ID]      INT           NULL,
    [created_by_user]    VARCHAR (255) NULL,
    [created_date]       DATETIME      NULL,
    [modified_by_user]   VARCHAR (255) NULL,
    [modified_date]      DATETIME      NULL
);

