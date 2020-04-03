CREATE TABLE [dbo].[TblArbitrator] (
    [ARBITRATOR_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [ARBITRATOR_NAME]    VARCHAR (50)   NULL,
    [ABITRATOR_LOCATION] VARCHAR (50)   NULL,
    [ARBITRATOR_PHONE]   VARCHAR (20)   NULL,
    [ARBITRATOR_FAX]     VARCHAR (20)   NULL,
    [IS_AAA]             BIT            NULL,
    [ARBITRATOR_Email]   VARCHAR (MAX)  NULL,
    [DomainId]           NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]    NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]       DATETIME       NULL,
    [modified_by_user]   NVARCHAR (255) NULL,
    [modified_date]      DATETIME       NULL,
    [ARBITRATOR_ID_OLD]  INT            NULL,
    CONSTRAINT [PK_TblArbitrator] PRIMARY KEY CLUSTERED ([ARBITRATOR_ID] ASC)
);

