CREATE TABLE [dbo].[DK_OLD_DATA] (
    [SZ_PATIENT_FIRST_NAME] NVARCHAR (255) NULL,
    [SZ_PATIENT_LAST_NAME]  NVARCHAR (255) NULL,
    [Date_AAA_Arb_Filed]    DATETIME       NULL,
    [old_Case_id]           FLOAT (53)     NULL,
    [IndexOrAAA_Number]     NVARCHAR (255) NULL,
    [FLT_BILL_AMOUNT]       FLOAT (53)     NULL,
    [Status_Done]           NVARCHAR (255) NULL,
    [SZ_INSURANCE_NAME]     NVARCHAR (255) NULL,
    [FLT_PAID]              FLOAT (53)     NULL,
    [Provider_Name]         NVARCHAR (255) NULL,
    [AssignLaw_firm]        NVARCHAR (255) NULL,
    [ProviderID]            FLOAT (53)     NULL,
    [InsuranceCompanyId]    FLOAT (53)     NULL,
    [Status_Done_old]       NVARCHAR (255) NULL,
    [autoid]                FLOAT (53)     NULL,
    [Status]                NVARCHAR (255) NULL,
    [DomainId]              NVARCHAR (50)  DEFAULT ('h1') NOT NULL
);

