CREATE TABLE [dbo].[tblInsurance_TPA_Group] (
    [PK_TPA_Group_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [TPA_Group_Name]   VARCHAR (500) NOT NULL,
    [Address]          VARCHAR (250) NOT NULL,
    [City]             VARCHAR (100) NOT NULL,
    [State]            VARCHAR (20)  NOT NULL,
    [ZipCode]          VARCHAR (50)  NOT NULL,
    [Email]            VARCHAR (50)  NOT NULL,
    [created_by_user]  VARCHAR (255) NOT NULL,
    [created_date]     DATETIME      NOT NULL,
    [modified_by_user] VARCHAR (255) NULL,
    [modified_date]    DATETIME      NULL,
    [Notes]            VARCHAR (200) NULL,
    [IsActive]         BIT           CONSTRAINT [DF_tblInsurance_TPA_Group_IsActive] DEFAULT ((0)) NOT NULL,
    [DomainId]         VARCHAR (20)  NOT NULL,
    CONSTRAINT [PK_tblInsurance_TPA_Group] PRIMARY KEY CLUSTERED ([PK_TPA_Group_ID] ASC)
);

