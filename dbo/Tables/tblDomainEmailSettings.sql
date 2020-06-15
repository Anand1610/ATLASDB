CREATE TABLE [dbo].[tblDomainEmailSettings] (
    [pk_domain_email_id] INT           IDENTITY (1, 1) NOT NULL,
    [Domain_Id]          VARCHAR (50)  NOT NULL,
    [EmailFrom]          VARCHAR (MAX) NOT NULL,
    [Password]           VARCHAR (MAX) NOT NULL,
    [SMTP_Port_Number]   INT           NOT NULL,
    [SMTP_Server_Name]   VARCHAR (MAX) NOT NULL,
    [isSSLEnabled]       BIT           NOT NULL,
    [ReplyToEmailId]     VARCHAR (MAX) NULL,
    [EmailCC] VARCHAR(1000) NULL, 
    [EmailBCC] VARCHAR(1000) NULL, 
    CONSTRAINT [PK_tblDomainEmailSettings] PRIMARY KEY CLUSTERED ([pk_domain_email_id] ASC)
);

