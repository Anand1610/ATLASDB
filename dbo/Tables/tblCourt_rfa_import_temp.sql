CREATE TABLE [dbo].[tblCourt_rfa_import_temp] (
    [Court_Id]         INT            NOT NULL,
    [Court_Name]       NVARCHAR (50)  NULL,
    [Court_Venue]      NVARCHAR (50)  NULL,
    [Court_Address]    NVARCHAR (255) NULL,
    [Court_Basis]      NVARCHAR (50)  NULL,
    [Court_Misc]       NVARCHAR (50)  NULL,
    [created_by_user]  VARCHAR (255)  NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] VARCHAR (255)  NULL,
    [modified_date]    DATETIME       NULL
);

