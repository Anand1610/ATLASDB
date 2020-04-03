CREATE TABLE [dbo].[Billing_Packet] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [Case_ID]          VARCHAR (50)   NOT NULL,
    [DomainID]         VARCHAR (50)   NULL,
    [Packeted_Case_ID] VARCHAR (50)   NULL,
    [Notes]            VARCHAR (2000) NULL,
    [created_by_user]  VARCHAR (255)  NULL,
    [created_date]     DATETIME       CONSTRAINT [DF__Billing_P__creat__7AB2122C] DEFAULT (getdate()) NOT NULL
);

