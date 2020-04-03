CREATE TABLE [dbo].[tblsettlement_type_rfa_import_temp] (
    [SettlementType_Id] INT            IDENTITY (1, 1) NOT NULL,
    [Settlement_Type]   NVARCHAR (500) NULL,
    [created_by_user]   VARCHAR (255)  NULL,
    [created_date]      DATETIME       NULL,
    [modified_by_user]  VARCHAR (255)  NULL,
    [modified_date]     DATETIME       NULL
);

