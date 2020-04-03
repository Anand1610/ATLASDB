CREATE TABLE [dbo].[ProcedureCodeConfiguration] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [LastTranfertDate] DATETIME      NULL,
    [DomainId]         VARCHAR (50)  NULL,
    [EmailFrom]        VARCHAR (64)  NULL,
    [EmailTO]          VARCHAR (256) NULL,
    [EmailCC]          VARCHAR (256) NULL,
    [SmtpServer]       VARCHAR (32)  NULL,
    [SmtpPort]         VARCHAR (8)   NULL,
    [EmailPassword]    VARCHAR (256) NULL
);

