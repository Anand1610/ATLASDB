CREATE TABLE [dbo].[tblClient] (
    [Client_AutoId]        INT            IDENTITY (1, 1) NOT NULL,
    [Client_Id]            NVARCHAR (50)  NOT NULL,
    [Client_Name]          NVARCHAR (100) NOT NULL,
    [Client_Type]          VARCHAR (40)   NULL,
    [Client_Local_Address] VARCHAR (255)  NULL,
    [Client_Local_City]    VARCHAR (100)  NULL,
    [Client_Local_State]   VARCHAR (100)  NULL,
    [Client_Local_Zip]     VARCHAR (50)   NULL,
    [Client_Local_Phone]   VARCHAR (100)  NULL,
    [Client_Local_Fax]     VARCHAR (100)  NULL,
    [Client_Contact]       VARCHAR (100)  NULL,
    [Client_Perm_Address]  VARCHAR (255)  NULL,
    [Client_Perm_City]     VARCHAR (100)  NULL,
    [Client_Perm_State]    VARCHAR (100)  NULL,
    [Client_Perm_Zip]      VARCHAR (50)   NULL,
    [Client_Perm_Phone]    VARCHAR (100)  NULL,
    [Client_Perm_Fax]      VARCHAR (100)  NULL,
    [Client_Email]         VARCHAR (100)  NULL,
    [DomainId]             NVARCHAR (512) DEFAULT ('h1') NOT NULL
);


GO
CREATE CLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblClient]([DomainId] ASC);

