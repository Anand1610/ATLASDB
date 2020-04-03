CREATE TABLE [dbo].[tblTags] (
    [NodeID]    INT            IDENTITY (1, 1) NOT NULL,
    [ParentID]  INT            NULL,
    [NodeName]  NVARCHAR (300) NULL,
    [CaseID]    NVARCHAR (50)  NOT NULL,
    [DocTypeID] INT            NULL,
    [NodeIcon]  NVARCHAR (50)  NULL,
    [NodeLevel] INT            NULL,
    [Expanded]  BIT            NULL,
    [TSTAMP]    DATETIME       CONSTRAINT [DF_tblTags_TSTAMP] DEFAULT (getdate()) NULL,
    [NodeType]  NVARCHAR (6)   NULL,
    [CaseType]  NVARCHAR (50)  NULL,
    [DomainId]  NVARCHAR (512) CONSTRAINT [DF__tblTags__DomainI__0A338187] DEFAULT ('h1') NOT NULL,
    [nodeid1]   INT            NULL,
    CONSTRAINT [PK_tblTags] PRIMARY KEY CLUSTERED ([DomainId] ASC, [CaseID] ASC, [NodeID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tbltags_NodeId]
    ON [dbo].[tblTags]([DomainId] ASC, [NodeID] ASC)
    INCLUDE([NodeName], [ParentID]);


GO
CREATE NONCLUSTERED INDEX [IDX_tbltags_case_NodeName]
    ON [dbo].[tblTags]([DomainId] ASC, [CaseID] ASC, [NodeName] ASC)
    INCLUDE([NodeID], [ParentID], [Expanded]);


GO
CREATE NONCLUSTERED INDEX [IX_TAgs]
    ON [dbo].[tblTags]([CaseID] ASC)
    INCLUDE([NodeName], [NodeLevel], [NodeType]);


GO
CREATE NONCLUSTERED INDEX [IDX_NodeName]
    ON [dbo].[tblTags]([NodeID] ASC)
    INCLUDE([NodeName]);

