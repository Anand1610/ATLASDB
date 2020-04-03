CREATE TABLE [dbo].[JLALLDATA] (
    [Client_Id]         FLOAT (53)     NULL,
    [Client_Name]       NVARCHAR (255) NULL,
    [Bill Id]           FLOAT (53)     NULL,
    [Status]            NVARCHAR (255) NULL,
    [Insurance_Company] NVARCHAR (255) NULL,
    [Paid_amount]       NVARCHAR (255) NULL,
    [Billed_Amt]        FLOAT (53)     NULL,
    [F8]                NVARCHAR (255) NULL,
    [autoid]            INT            IDENTITY (1, 1) NOT NULL,
    [StatusDone]        VARCHAR (40)   NULL
);

