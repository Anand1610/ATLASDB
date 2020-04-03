CREATE TABLE [dbo].[tblDefendant] (
    [Defendant_id]          INT            IDENTITY (1, 1) NOT NULL,
    [Defendant_Name]        VARCHAR (100)  NULL,
    [Defendant_DisplayName] VARCHAR (100)  NULL,
    [Defendant_Address]     VARCHAR (255)  NULL,
    [Defendant_City]        VARCHAR (100)  NULL,
    [Defendant_State]       VARCHAR (100)  NULL,
    [Defendant_Zip]         VARCHAR (20)   NULL,
    [Defendant_Phone]       VARCHAR (20)   NULL,
    [Defendant_Fax]         VARCHAR (20)   NULL,
    [Defendant_Email]       VARCHAR (100)  NULL,
    [active]                INT            CONSTRAINT [DF_tblDefendant_active] DEFAULT ((1)) NULL,
    [DomainId]              NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]       NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]          DATETIME       NULL,
    [modified_by_user]      NVARCHAR (255) NULL,
    [modified_date]         DATETIME       NULL,
    [lawfirmname]           VARCHAR (MAX)  NULL,
    [Defendant_id_old]      INT            NULL,
    CONSTRAINT [PK_tblDefendant] PRIMARY KEY CLUSTERED ([Defendant_id] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblDefendant]([DomainId] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'[tblDefendant].[Defendant_Name], [tblDefendant].[Defendant_id]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 4710, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 5175, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'Defendant_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblDefendant', @level2type = N'COLUMN', @level2name = N'active';

