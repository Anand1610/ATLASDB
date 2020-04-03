CREATE TABLE [dbo].[tblStatus] (
    [Status_Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Status_Type]        NVARCHAR (50)   NOT NULL,
    [Status_Abr]         NVARCHAR (50)   NULL,
    [Status_Hierarchy]   INT             CONSTRAINT [DF_tblStatus_Status_Hierarchy] DEFAULT ((0)) NULL,
    [Auto_bill_amount]   MONEY           NULL,
    [Auto_bill_type]     NVARCHAR (20)   NULL,
    [Auto_bill_notes]    VARCHAR (200)   NULL,
    [Status_Description] NVARCHAR (2000) NULL,
    [Final_Status]       NVARCHAR (200)  NULL,
    [IsActive]           NVARCHAR (10)   NULL,
    [forum]              NVARCHAR (50)   NULL,
    [Filed_Unfiled]      NVARCHAR (50)   NULL,
    [hierarchy_Id]       INT             NULL,
    [DomainId]           VARCHAR (50)    CONSTRAINT [DF__tblStatus__Domai__084B3915] DEFAULT ('h1') NOT NULL,
    [status_age_limit]   VARCHAR (20)    NULL,
    [created_by_user]    VARCHAR (255)   CONSTRAINT [DF__tblStatus__creat__0FAD2F12] DEFAULT ('admin') NOT NULL,
    [created_date]       DATETIME        CONSTRAINT [DF_Status_Type_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]   VARCHAR (255)   NULL,
    [modified_date]      DATETIME        NULL,
    CONSTRAINT [PK_Status_Type] PRIMARY KEY CLUSTERED ([DomainId] ASC, [Status_Type] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblStatus]
    ON [dbo].[tblStatus]([Status_Type] ASC)
    INCLUDE([DomainId]);

