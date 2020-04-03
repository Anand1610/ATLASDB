CREATE TABLE [dbo].[tblBasePathAtlasGybMap] (
    [ID]                INT          IDENTITY (1, 1) NOT NULL,
    [AtlasBasPathID]    INT          NOT NULL,
    [GybBasePathID]     INT          NOT NULL,
    [GBApplicationType] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

