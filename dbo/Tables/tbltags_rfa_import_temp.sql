CREATE TABLE [dbo].[tbltags_rfa_import_temp] (
    [RowID]      BIGINT        NULL,
    [NodeID]     INT           NOT NULL,
    [ParentID]   INT           NULL,
    [NodeName]   VARCHAR (300) NOT NULL,
    [CaseID]     VARCHAR (50)  NOT NULL,
    [DocTypeID]  INT           NULL,
    [NodeIcon]   NVARCHAR (50) NULL,
    [NodeLevel]  INT           NULL,
    [Expanded]   BIT           NULL,
    [TSTAMP]     DATETIME      NULL,
    [NodeType]   NVARCHAR (6)  NULL,
    [CaseType]   NVARCHAR (50) NULL,
    [ParentName] VARCHAR (300) NULL
);

