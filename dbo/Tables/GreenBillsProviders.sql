CREATE TABLE [dbo].[GreenBillsProviders] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [SZ_COMPANY_ID]  NVARCHAR (20) NOT NULL,
    [SZ_OFFICE_ID]   NVARCHAR (20) NOT NULL,
    [PROVIDER_ID]    INT           NULL,
    [Gbb_Type]       VARCHAR (20)  NULL,
    [DomainId]       VARCHAR (50)  NOT NULL,
    [Initial_Status] VARCHAR (200) NULL,
    [Status]         VARCHAR (500) NULL
);

