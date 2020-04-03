CREATE TABLE [dbo].[tbl_Client] (
    [Auto_ID]                INT            IDENTITY (1, 1) NOT NULL,
    [DomainId]               VARCHAR (20)   NOT NULL,
    [LawFirmName]            VARCHAR (200)  NULL,
    [CompanyType]            VARCHAR (50)   DEFAULT ('attorney') NOT NULL,
    [Client_Billing_Address] VARCHAR (255)  NULL,
    [Client_Billing_City]    VARCHAR (100)  NULL,
    [Client_Billing_State]   VARCHAR (100)  NULL,
    [Client_Billing_Zip]     VARCHAR (50)   NULL,
    [Client_Billing_Phone]   VARCHAR (100)  NULL,
    [Client_Billing_Fax]     VARCHAR (100)  NULL,
    [Client_Contact]         VARCHAR (100)  NULL,
    [Client_Email]           VARCHAR (100)  NULL,
    [Client_First_Name]      VARCHAR (100)  NULL,
    [Client_Last_Name]       VARCHAR (100)  NULL,
    [client_header]          VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([DomainId] ASC)
);

