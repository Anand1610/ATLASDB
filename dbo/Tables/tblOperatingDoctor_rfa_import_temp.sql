CREATE TABLE [dbo].[tblOperatingDoctor_rfa_import_temp] (
    [Doctor_Id]        INT           NOT NULL,
    [Doctor_Name]      VARCHAR (80)  NULL,
    [Active]           BIT           NULL,
    [created_by_user]  VARCHAR (255) NULL,
    [created_date]     DATETIME      NULL,
    [modified_by_user] VARCHAR (255) NULL,
    [modified_date]    DATETIME      NULL
);

