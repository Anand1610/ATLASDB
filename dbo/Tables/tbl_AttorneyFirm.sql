CREATE TABLE [dbo].[tbl_AttorneyFirm] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [LocationId]       INT           NULL,
    [Type_Of_Practice] VARCHAR (50)  NULL,
    [Created_Date]     DATE          NULL,
    [DomainId]         NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

