CREATE TABLE [dbo].[MST_PROCEDURE_CODES] (
    [Code]                      VARCHAR (32)   NULL,
    [Description]               NVARCHAR (255) NULL,
    [Amount]                    MONEY          NULL,
    [Specialty]                 NVARCHAR (255) NULL,
    [ins_fee_schedule]          MONEY          NULL,
    [Auto_Proc_id]              INT            IDENTITY (1, 1) NOT NULL,
    [ServiceTypeID]             INT            NULL,
    [DomainId]                  VARCHAR (1024) NULL,
    [RegionIVfeeScheduleAmount] MONEY          NULL,
    [Comment]                   VARCHAR (1024) NULL,
    [CreatedBY]                 VARCHAR (512)  NULL,
    [CreatedDate]               DATETIME       NULL,
    [UpdatedBy]                 VARCHAR (512)  NULL,
    [UpdateDate]                DATETIME       NULL,
    [GBBCodeID]                 VARCHAR (20)   NULL,
    [IsDeleted]                 BIT            DEFAULT ((0)) NULL
);

