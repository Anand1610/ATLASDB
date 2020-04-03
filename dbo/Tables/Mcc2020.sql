CREATE TABLE [dbo].[Mcc2020] (
    [AUTOID]              FLOAT (53)     NULL,
    [PatientFirstName]    NVARCHAR (255) NULL,
    [PatientLastName]     NVARCHAR (255) NULL,
    [Claim Number]        NVARCHAR (255) NULL,
    [IndexOrAAA_Number]   NVARCHAR (255) NULL,
    [FltBillAmount]       FLOAT (53)     NULL,
    [Paid_Amount]         NVARCHAR (255) NULL,
    [DateOfService_Start] DATETIME       NULL,
    [DateOfService_End]   DATETIME       NULL,
    [DateofAccident]      NVARCHAR (255) NULL,
    [AtlasProviderId]     NVARCHAR (255) NULL,
    [AtlasInsuranceId]    FLOAT (53)     NULL,
    [Date_AAA_Arb_Filed]  NVARCHAR (255) NULL,
    [PolicyNumber]        NVARCHAR (255) NULL,
    [BILL_NUMBER]         NVARCHAR (255) NULL,
    [case_code]           NVARCHAR (255) NULL,
    [Domainid]            NVARCHAR (255) NULL,
    [SERVICE_TYPE]        NVARCHAR (255) NULL
);

