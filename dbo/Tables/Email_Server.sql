CREATE TABLE [dbo].[Email_Server] (
    [AutoID]        INT            IDENTITY (1, 1) NOT NULL,
    [DomainID]      VARCHAR (100)  NULL,
    [from_email_id] VARCHAR (100)  NULL,
    [password]      VARCHAR (100)  NULL,
    [smtp_server]   VARCHAR (50)   NULL,
    [smtp_port]     INT            NULL,
    [type]          VARCHAR (150)  NULL,
    [CC]            VARCHAR (100)  NULL,
    [BCC]           VARCHAR (100)  NULL,
    [mail_subject]  VARCHAR (300)  NULL,
    [mail_body]     VARCHAR (4000) NULL,
    [to_email_id]   VARCHAR (500)  NULL,
    [status]        VARCHAR (200)  NULL,
    [node_id]       INT            NULL
);

