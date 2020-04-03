CREATE TABLE [dbo].[TblReviewingDoctor_rfa_import_temp] (
    [Doctor_id]        INT           NOT NULL,
    [Doctor_Name]      VARCHAR (100) NULL,
    [Active]           BIT           NOT NULL,
    [created_by_user]  VARCHAR (255) NULL,
    [created_date]     DATETIME      NULL,
    [modified_by_user] VARCHAR (255) NULL,
    [modified_date]    DATETIME      NULL
);

