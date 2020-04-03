CREATE TABLE [dbo].[MST_DOCUMENT_NODES] (
    [NodeID]       INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]     INT            NULL,
    [NodeName]     NVARCHAR (300) NULL,
    [NodeLevel]    INT            NULL,
    [Expanded]     BIT            NULL,
    [FriendlyName] NVARCHAR (300) NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [NodeId_Old]   INT            NULL,
    CONSTRAINT [PK_MST_DOCUMENT_NODES] PRIMARY KEY CLUSTERED ([NodeID] ASC)
);

