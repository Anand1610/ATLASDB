CREATE TABLE [dbo].[StatusMapping] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [RFAStatus]   VARCHAR (120) NULL,
    [AtlasStatus] VARCHAR (120) NULL,
    [DomainID]    VARCHAR (50)  NULL
);

