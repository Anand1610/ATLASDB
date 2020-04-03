CREATE TABLE [dbo].[tblSettlements] (
    [Settlement_Id]           INT             IDENTITY (1, 1) NOT NULL,
    [Settlement_Amount]       MONEY           NULL,
    [Settlement_Int]          MONEY           NULL,
    [Settlement_Af]           MONEY           NULL,
    [Settlement_Ff]           MONEY           NULL,
    [Settlement_Total]        MONEY           NULL,
    [Settlement_Date]         DATETIME        NULL,
    [Treatment_Id]            INT             NULL,
    [Case_Id]                 NVARCHAR (50)   NOT NULL,
    [User_Id]                 VARCHAR (50)    NOT NULL,
    [SettledWith]             NVARCHAR (2000) NULL,
    [Settlement_Notes]        NVARCHAR (2000) NULL,
    [Settlement_Rfund_PR]     MONEY           NULL,
    [Settlement_Rfund_Int]    MONEY           NULL,
    [Settlement_Rfund_Total]  MONEY           NULL,
    [Settlement_Rfund_date]   DATETIME        NULL,
    [Settlement_Rfund_Batch]  INT             NULL,
    [Settlement_Rfund_UserId] VARCHAR (50)    NULL,
    [Settlement_Batch]        VARCHAR (20)    NULL,
    [Settlement_SubBatch]     INT             NULL,
    [Settled_With_Name]       NVARCHAR (400)  NULL,
    [Settled_With_Phone]      NVARCHAR (100)  NULL,
    [Settled_With_Fax]        NVARCHAR (100)  NULL,
    [Settled_Type]            NVARCHAR (100)  NULL,
    [Settled_by]              INT             NULL,
    [Settled_Percent]         DECIMAL (5, 2)  NULL,
    [DomainId]                NVARCHAR (512)  DEFAULT ('h1') NOT NULL,
    [Settlement_Id_Old]       INT             NULL,
    CONSTRAINT [PK_tblSettlements] PRIMARY KEY CLUSTERED ([Settlement_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid_CaseId]
    ON [dbo].[tblSettlements]([DomainId] ASC, [Case_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_Settlement]
    ON [dbo].[tblSettlements]([Case_Id] ASC)
    INCLUDE([Settlement_Amount], [Settled_Type]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Amount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Af';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Af';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Af';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Af';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Af';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Ff';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Ff';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Ff';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Ff';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Ff';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Treatment_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Treatment_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Treatment_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Treatment_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Treatment_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Case_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Case_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Case_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 2370, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Case_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Case_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'User_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'User_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'User_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'User_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'User_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'SettledWith';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'SettledWith';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'SettledWith';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'SettledWith';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'SettledWith';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_PR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_PR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_PR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_PR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_PR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Int';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Total';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Batch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Batch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Batch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Batch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_Batch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblSettlements', @level2type = N'COLUMN', @level2name = N'Settlement_Rfund_UserId';

