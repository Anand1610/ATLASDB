CREATE TABLE [dbo].[CasesList6] (
    [Client Id]         NVARCHAR (255) NULL,
    [Client Name]       NVARCHAR (255) NULL,
    [Bill Id]           NVARCHAR (255) NULL,
    [Bill Mailed On]    NVARCHAR (255) NULL,
    [Billed Amt]        FLOAT (53)     NULL,
    [Paid Amt]          FLOAT (53)     NULL,
    [Balance]           FLOAT (53)     NULL,
    [Doctor Name]       NVARCHAR (255) NULL,
    [Office Name]       NVARCHAR (255) NULL,
    [Service Date From] NVARCHAR (255) NULL,
    [Service Date To]   NVARCHAR (255) NULL,
    [AUTOID]            INT            IDENTITY (1, 1) NOT NULL,
    [StatusDone]        VARCHAR (100)  NULL
);

