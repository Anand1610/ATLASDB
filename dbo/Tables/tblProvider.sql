CREATE TABLE [dbo].[tblProvider] (
    [Provider_Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [Provider_Code]               NVARCHAR (100)  NULL,
    [Provider_Name]               NVARCHAR (100)  NULL,
    [Provider_Suitname]           NVARCHAR (100)  NULL,
    [Provider_Type]               VARCHAR (40)    NULL,
    [Provider_Local_Address]      VARCHAR (255)   NULL,
    [Provider_Local_City]         VARCHAR (100)   NULL,
    [Provider_Local_State]        VARCHAR (100)   NULL,
    [Provider_Local_Zip]          VARCHAR (50)    NULL,
    [Provider_Local_Phone]        VARCHAR (100)   NULL,
    [Provider_Local_Fax]          VARCHAR (100)   NULL,
    [Provider_Contact]            VARCHAR (100)   NULL,
    [Provider_Perm_Address]       VARCHAR (255)   NULL,
    [Provider_Perm_City]          VARCHAR (100)   NULL,
    [Provider_Perm_State]         VARCHAR (100)   NULL,
    [Provider_Perm_Zip]           VARCHAR (50)    NULL,
    [Provider_Perm_Phone]         VARCHAR (100)   NULL,
    [Provider_Perm_Fax]           VARCHAR (100)   NULL,
    [Provider_Email]              VARCHAR (100)   NULL,
    [Provider_Billing]            FLOAT (53)      CONSTRAINT [DF_tblProvider_Provider_Billing] DEFAULT ((0)) NULL,
    [Provider_Contact2]           VARCHAR (100)   NULL,
    [Provider_IntBilling]         FLOAT (53)      CONSTRAINT [DF_tblProvider_Provider_IntBilling] DEFAULT ((0)) NULL,
    [Invoice_Type]                VARCHAR (10)    CONSTRAINT [DF_tblProvider_Invoice_Type] DEFAULT ('E') NULL,
    [cost_balance]                MONEY           CONSTRAINT [DF_tblProvider_cost_balance] DEFAULT ((0)) NULL,
    [Provider_Notes]              NVARCHAR (4000) NULL,
    [Provider_ReferredBy]         NVARCHAR (100)  NULL,
    [Provider_President]          NVARCHAR (100)  NULL,
    [Provider_TaxID]              NVARCHAR (50)   NULL,
    [Provider_FF]                 NCHAR (10)      NULL,
    [Provider_ReturnFF]           NCHAR (10)      NULL,
    [Provider_SeesFF]             NVARCHAR (10)   CONSTRAINT [DF_tblProvider_Provider_SeesFF] DEFAULT ((1)) NULL,
    [Provider_SeesRFF]            NVARCHAR (10)   CONSTRAINT [DF_tblProvider_Provider_SeesRFF] DEFAULT ((1)) NULL,
    [Provider_InvoicedFF]         NVARCHAR (50)   NULL,
    [provider_Rfunds]             TINYINT         NULL,
    [Provider_GroupName]          NVARCHAR (50)   NULL,
    [Provider_Collection_Agent]   NVARCHAR (100)  NULL,
    [Provider_attachChecks]       NVARCHAR (50)   NULL,
    [Temp_Tag]                    DECIMAL (4, 4)  NULL,
    [Active]                      BIT             CONSTRAINT [DF_tblProvider_Active] DEFAULT ((1)) NULL,
    [SZ_SHORT_NAME]               NVARCHAR (100)  NULL,
    [BX_SERV]                     BIT             CONSTRAINT [DF_tblProvider_BX_SERV] DEFAULT ((0)) NULL,
    [BX_SHR_FEE]                  FLOAT (53)      NULL,
    [BX_PSTG]                     MONEY           NULL,
    [SD_CODE]                     VARCHAR (5)     NULL,
    [BX_FEE_SCHEDULE]             INT             NULL,
    [isFromNassau]                BIT             NULL,
    [BitVerification]             INT             NULL,
    [FH_ACTIVE]                   BIT             CONSTRAINT [DF_tblProvider_FH_ACTIVE] DEFAULT ((1)) NULL,
    [FileReturn]                  BIT             NULL,
    [Position]                    NVARCHAR (4000) NULL,
    [Practice]                    NVARCHAR (4000) NULL,
    [Billing_Manager]             NVARCHAR (200)  NULL,
    [Email_For_Arb_Awards]        NVARCHAR (200)  NULL,
    [Email_For_Invoices]          NVARCHAR (200)  NULL,
    [Email_For_Closing_Reports]   NVARCHAR (200)  NULL,
    [Email_For_Monthly_Report]    NVARCHAR (200)  NULL,
    [LawFirm_Attorney]            VARCHAR (100)   NULL,
    [DomainId]                    NVARCHAR (512)  CONSTRAINT [DF__tblProvid__Domai__6D9742D9] DEFAULT ('h1') NOT NULL,
    [Funding_Company]             NVARCHAR (100)  NOT NULL,
    [Provider_Initial_Billing]    FLOAT (53)      CONSTRAINT [DF_tblProvider_Provider_Initial_Billing] DEFAULT ((0.00)) NULL,
    [Provider_Initial_IntBilling] FLOAT (53)      CONSTRAINT [DF_tblProvider_Provider_Initial_IntBilling] DEFAULT ((0.00)) NULL,
    [Provider_Contact3]           VARCHAR (100)   NULL,
    [Provider_Rebuttal]           VARCHAR (100)   NULL,
    [Settlement_Principal]        DECIMAL (18, 2) NULL,
    [Settlement_Interest]         DECIMAL (18, 2) NULL,
    [packet_type]                 VARCHAR (100)   NULL,
    [Vendor_Service]              BIT             NULL,
    [Vendor_Fee_Type]             VARCHAR (50)    NULL,
    [Vendor_Fee]                  FLOAT (53)      NULL,
    [Vendor_Name]                 VARCHAR (200)   NULL,
    [FK_ClientPriority_Level_ID]  INT             NULL,
    [FHKP_ATTORNEY]               VARCHAR (100)   NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_DomainId_Provider_ID]
    ON [dbo].[tblProvider]([DomainId] ASC, [Provider_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblProvider]([DomainId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_ProviderNameGroup]
    ON [dbo].[tblProvider]([Provider_Name] ASC)
    INCLUDE([Provider_Id], [Provider_GroupName]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = N'[tblProvider].[Provider_Name]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = 3750, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Local_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Address';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_City';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Zip';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Perm_Fax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Email';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Billing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Billing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Billing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Billing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Billing';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Contact2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_IntBilling';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_IntBilling';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_IntBilling';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_IntBilling';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_IntBilling';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Invoice_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Invoice_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Invoice_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Invoice_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Invoice_Type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'cost_balance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'cost_balance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'cost_balance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'cost_balance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'cost_balance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Notes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReferredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReferredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReferredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReferredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReferredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_President';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_President';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_President';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_President';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_President';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_TaxID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_TaxID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_TaxID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_TaxID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_TaxID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_FF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_FF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_FF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_FF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_FF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReturnFF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReturnFF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReturnFF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReturnFF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_ReturnFF';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'provider_Rfunds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'provider_Rfunds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'provider_Rfunds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'provider_Rfunds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'provider_Rfunds';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Provider_Collection_Agent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_AggregateType', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Temp_Tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHidden', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Temp_Tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnOrder', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Temp_Tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidth', @value = -1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Temp_Tag';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TextAlign', @value = 0x, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblProvider', @level2type = N'COLUMN', @level2name = N'Temp_Tag';

