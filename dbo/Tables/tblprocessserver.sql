CREATE TABLE [dbo].[tblprocessserver] (
    [psid]        INT            IDENTITY (1, 1) NOT NULL,
    [psfirstname] VARCHAR (100)  NULL,
    [pslastname]  VARCHAR (100)  NULL,
    [pslicense]   VARCHAR (100)  NULL,
    [Active]      BIT            CONSTRAINT [DF_tblprocessserver_Active] DEFAULT ((1)) NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

