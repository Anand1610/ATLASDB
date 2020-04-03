CREATE TABLE [dbo].[tblSettlement_Type] (
    [SettlementType_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Settlement_Type]       VARCHAR (100)  NOT NULL,
    [DomainId]              VARCHAR (50)   CONSTRAINT [DF__tblSettle__Domai__047AA831] DEFAULT ('h1') NOT NULL,
    [created_by_user]       NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]          DATETIME       CONSTRAINT [DF_Settlement_Type_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]      NVARCHAR (255) NULL,
    [modified_date]         DATETIME       NULL,
    [SettlementType_Id_old] INT            NULL,
    CONSTRAINT [PK_Settlement_Type] PRIMARY KEY CLUSTERED ([DomainId] ASC, [Settlement_Type] ASC)
);

