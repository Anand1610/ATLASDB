CREATE TABLE [dbo].[tblClientPayment] (
    [ClientPaymentId] INT             IDENTITY (1, 1) NOT NULL,
    [Provider_id]     VARCHAR (50)    NOT NULL,
    [Payment_Amount]  MONEY           NOT NULL,
    [Payment_Date]    DATETIME        NOT NULL,
    [Payment_Desc]    NVARCHAR (2500) NULL,
    [DomainId]        NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

