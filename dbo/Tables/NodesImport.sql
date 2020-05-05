CREATE TABLE [dbo].[NodesImport] (
    [NodeID]       FLOAT (53)     NULL,
    [ParentID]     FLOAT (53)     NULL,
    [NodeName]     NVARCHAR (255) NULL,
    [NodeLevel]    FLOAT (53)     NULL,
    [Expanded]     FLOAT (53)     NULL,
    [FriendlyName] NVARCHAR (255) NULL,
    [DomainId]     NVARCHAR (255) NULL,
    [NodeId_Old]   NVARCHAR (255) NULL
);

