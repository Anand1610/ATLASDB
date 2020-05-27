CREATE TABLE [dbo].[cpt_new_4] (
    [Code]                      NVARCHAR (255) NULL,
    [Description]               NVARCHAR (MAX) NULL,
    [Amount]                    FLOAT (53)     NULL,
    [Specialty]                 NVARCHAR (255) NULL,
    [RegionIVfeeScheduleAmount] FLOAT (53)     NULL,
    [ID]                        INT            IDENTITY (1, 1) NOT NULL
);

