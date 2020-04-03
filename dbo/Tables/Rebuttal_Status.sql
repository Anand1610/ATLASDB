CREATE TABLE [dbo].[Rebuttal_Status] (
    [PK_Rebuttal_Status_ID] INT            IDENTITY (1, 1) NOT NULL,
    [Rebuttal_Status]       VARCHAR (200)  NOT NULL,
    [DomainID]              VARCHAR (50)   NOT NULL,
    [created_by_user]       NVARCHAR (255) NOT NULL,
    [created_date]          DATETIME       CONSTRAINT [DF_Rebuttal_Status_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]      NVARCHAR (255) NULL,
    [modified_date]         DATETIME       NULL,
    CONSTRAINT [PK_Rebuttal_Status] PRIMARY KEY CLUSTERED ([Rebuttal_Status] ASC, [DomainID] ASC)
);

