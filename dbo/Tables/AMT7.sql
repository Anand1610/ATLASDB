CREATE TABLE [dbo].[AMT7] (
    [ID]                    NVARCHAR (255) NULL,
    [AUTOID]                NVARCHAR (255) NULL,
    [Patient Last Name]     NVARCHAR (255) NULL,
    [Patient First Name]    NVARCHAR (255) NULL,
    [insurancecompany_name] NVARCHAR (255) NULL,
    [Total Billed Amount]   FLOAT (53)     NULL,
    [FltPaid]               NVARCHAR (255) NULL,
    [DOS]                   DATETIME       NULL,
    [LastVisitDate]         DATETIME       NULL,
    [DateofAccident]        DATETIME       NULL,
    [DomainId]              NVARCHAR (255) NULL,
    [AtlasProviderId]       NVARCHAR (255) NULL,
    [AtlasInsuranceId]      NVARCHAR (255) NULL,
    [ClaimNumber]           NVARCHAR (255) NULL,
    [Date_BillSent]         DATETIME       NULL,
    [Transferd_Status]      VARCHAR (50)   NULL,
    [CPT]                   NCHAR (10)     NULL,
    [units]                 NCHAR (10)     NULL
);

