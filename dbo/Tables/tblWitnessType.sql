CREATE TABLE [dbo].[tblWitnessType] (
    [WitnessTypeID]    INT           IDENTITY (1, 1) NOT NULL,
    [WitnessType]      VARCHAR (250) NOT NULL,
    [Description]      VARCHAR (500) NULL,
    [DomainId]         VARCHAR (50)  NOT NULL,
    [created_by_user]  VARCHAR (150) NULL,
    [created_date]     DATETIME      NULL,
    [modified_by_user] VARCHAR (150) NULL,
    [modified_date]    DATETIME      NULL,
    CONSTRAINT [PK_tblWitnessType] PRIMARY KEY CLUSTERED ([WitnessTypeID] ASC)
);

