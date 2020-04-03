CREATE TABLE [dbo].[GreenBillsCases] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [SZ_COMPANY_ID]    NVARCHAR (20)  NOT NULL,
    [SZ_CASE_ID]       NVARCHAR (20)  NOT NULL,
    [SZ_CASE_NO]       NVARCHAR (50)  NOT NULL,
    [FHKP_CASE_ID]     NVARCHAR (50)  NULL,
    [fhkp_provider_id] VARCHAR (500)  NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

