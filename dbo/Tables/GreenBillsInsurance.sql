CREATE TABLE [dbo].[GreenBillsInsurance] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [SZ_COMPANY_ID]       VARCHAR (100) NOT NULL,
    [SZ_INSURANCE_ID]     VARCHAR (100) NOT NULL,
    [INSURANCECOMPANY_ID] INT           NULL,
    [Gbb_Type]            VARCHAR (20)  NOT NULL,
    [DomainID]            VARCHAR (50)  NOT NULL
);

