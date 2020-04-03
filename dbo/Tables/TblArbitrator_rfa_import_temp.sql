CREATE TABLE [dbo].[TblArbitrator_rfa_import_temp] (
    [ARBITRATOR_ID]      INT           NOT NULL,
    [ARBITRATOR_NAME]    VARCHAR (50)  NULL,
    [ABITRATOR_LOCATION] VARCHAR (50)  NULL,
    [ARBITRATOR_PHONE]   VARCHAR (20)  NULL,
    [ARBITRATOR_FAX]     VARCHAR (20)  NULL,
    [IS_AAA]             BIT           NULL,
    [ARBITRATOR_Email]   VARCHAR (255) NULL,
    [created_by_user]    VARCHAR (255) NULL,
    [created_date]       DATETIME      NULL,
    [modified_by_user]   VARCHAR (255) NULL,
    [modified_date]      DATETIME      NULL
);

