CREATE TABLE [dbo].[tblApplicationSettings] (
    [ParameterID]    INT            IDENTITY (1, 1) NOT NULL,
    [ParameterName]  VARCHAR (50)   NOT NULL,
    [ParameterValue] VARCHAR (512)  NOT NULL,
    [displayname]    VARCHAR (255)  NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

