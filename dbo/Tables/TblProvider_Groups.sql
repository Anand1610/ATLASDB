CREATE TABLE [dbo].[TblProvider_Groups] (
    [Provider_Group_ID]         INT           IDENTITY (1, 1) NOT NULL,
    [Provider_Group_Name]       VARCHAR (200) CONSTRAINT [DF_TblProvider_Groups_Provider_Group_Name] DEFAULT ('p1') NOT NULL,
    [DESCRIPTION]               VARCHAR (500) NULL,
    [SD_CODE]                   VARCHAR (50)  NULL,
    [AF_Show]                   BIT           NULL,
    [Email_For_Arb_Awards]      VARCHAR (200) NULL,
    [Email_For_Invoices]        VARCHAR (200) NULL,
    [Email_For_Closing_Reports] VARCHAR (200) NULL,
    [Email_For_Monthly_Report]  VARCHAR (200) NULL,
    [DomainId]                  VARCHAR (50)  CONSTRAINT [DF__TblProvid__Domai__753864A1] DEFAULT ('h1') NOT NULL,
    [created_by_user]           VARCHAR (255) CONSTRAINT [DF__TblProvid__creat__5674B1B6] DEFAULT ('admin') NOT NULL,
    [created_date]              DATETIME      CONSTRAINT [DF_Provider_Groups_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user]          VARCHAR (255) NULL,
    [modified_date]             DATETIME      NULL,
    CONSTRAINT [PK_TblProvider_Groups] PRIMARY KEY CLUSTERED ([Provider_Group_Name] ASC, [DomainId] ASC)
);

