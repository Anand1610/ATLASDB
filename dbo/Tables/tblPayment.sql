CREATE TABLE [dbo].[tblPayment] (
    [Payment_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Provider_Id]    NVARCHAR (50)  NULL,
    [Payment_Amount] MONEY          NULL,
    [Payment_Date]   DATETIME       NULL,
    [Payment_Desc]   NVARCHAR (500) NULL,
    [Payment_Type]   VARCHAR (10)   NULL,
    [User_id]        VARCHAR (50)   NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL
);


GO
CREATE CLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblPayment]([DomainId] ASC);

