﻿CREATE TABLE [dbo].[tblEmail] (
    [Email_Id]         INT             IDENTITY (1, 1) NOT NULL,
    [Email_Desc]       NVARCHAR (500)  NULL,
    [Case_Id]          NVARCHAR (100)  NULL,
    [User_Id]          NVARCHAR (100)  NULL,
    [Message_Id]       VARCHAR (8000)  NULL,
    [UID]              VARCHAR (8000)  NULL,
    [Message_Date]     DATETIME        NOT NULL,
    [Subject]          NVARCHAR (100)  NULL,
    [Headers]          NVARCHAR (500)  NULL,
    [Body]             NVARCHAR (4000) NULL,
    [Html]             VARCHAR (8000)  NULL,
    [Message_To]       VARCHAR (8000)  NOT NULL,
    [Message_From]     VARCHAR (8000)  NOT NULL,
    [Message_FromName] VARCHAR (8000)  NULL,
    [Message_FromIP]   VARCHAR (8000)  NULL,
    [Message_CC]       VARCHAR (8000)  NULL,
    [Message_BCC]      VARCHAR (8000)  NULL,
    [Message_ReplyTo]  VARCHAR (8000)  NULL,
    [Attachments]      VARCHAR (8000)  NULL,
    [MIMEText]         VARCHAR (8000)  NULL,
    [ReturnPath]       VARCHAR (8000)  NULL,
    [Date_Created]     DATETIME        NOT NULL,
    [Attachment_Files] VARCHAR (8000)  NULL,
    [DomainId]         NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

