CREATE TABLE [dbo].[tblTransactionType] (
    [autoid]        INT           IDENTITY (1, 1) NOT NULL,
    [payment_type]  VARCHAR (100) NULL,
    [payment_value] VARCHAR (50)  NULL,
    [Report_Type]   VARCHAR (100) NULL
);

