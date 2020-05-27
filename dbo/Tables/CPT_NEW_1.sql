CREATE TABLE [dbo].[CPT_NEW_1] (
    [Code]                                  NVARCHAR (255) NULL,
    [Description]                           NVARCHAR (MAX) NULL,
    [Amount]                                FLOAT (53)     NULL,
    [Specialty]                             NVARCHAR (255) NULL,
    [ins_fee_schedule]                      FLOAT (53)     NULL,
    [Auto_Proc_id]                          FLOAT (53)     NULL,
    [ServiceTypeID]                         FLOAT (53)     NULL,
    [DomainId]                              NVARCHAR (255) NULL,
    [RegionIVfeeScheduleAmount]             FLOAT (53)     NULL,
    [Comment]                               NVARCHAR (255) NULL,
    [Oct - 2020 RegionIVfeeScheduleAmount ] NVARCHAR (255) NULL,
    [CreatedBY]                             NVARCHAR (255) NULL,
    [CreatedDate]                           FLOAT (53)     NULL,
    [UpdatedBy]                             NVARCHAR (255) NULL,
    [UpdateDate]                            NVARCHAR (255) NULL,
    [GBBCodeID]                             NVARCHAR (255) NULL,
    [s]                                     FLOAT (53)     NULL,
    [ID]                                    INT            IDENTITY (1, 1) NOT NULL
);

