CREATE TABLE [dbo].[tblCourt] (
    [Court_Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Court_Name]       NVARCHAR (250) NULL,
    [Court_Venue]      NVARCHAR (250) NULL,
    [Court_Address]    NVARCHAR (255) NULL,
    [Court_Basis]      NVARCHAR (50)  NULL,
    [Court_Misc]       NVARCHAR (50)  NULL,
    [DomainId]         NVARCHAR (512) CONSTRAINT [DF__tblCourt__Domain__373B3228] DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    [COURT_ID_OLD]     INT            NULL,
    [County]           VARCHAR (500)  NULL,
    [State]            VARCHAR (250)  NULL,
    [City]             VARCHAR (250)  NULL,
    [Zip]              VARCHAR (10)   NULL,
    CONSTRAINT [PK_tblCourt] PRIMARY KEY CLUSTERED ([Court_Id] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 1875, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Venue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Venue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Venue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Venue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Venue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Basis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Basis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Basis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Basis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Basis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Misc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Misc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Misc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Misc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblCourt', @level2type = N'COLUMN', @level2name = N'Court_Misc';

