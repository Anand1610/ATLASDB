﻿CREATE TABLE [dbo].[TBLBILLING_DATA] (
    [BILLING_AUTO_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [SZ_CASE_ID]           VARCHAR (100)  NULL,
    [SZ_CASE_NO]           VARCHAR (100)  NULL,
    [SZ_PATIENT_NAME]      VARCHAR (500)  NULL,
    [SZ_PATIENT_ADDRESS]   VARCHAR (1000) NULL,
    [SZ_PATIENT_CITY]      VARCHAR (100)  NULL,
    [SZ_PATIENT_STATE]     VARCHAR (100)  NULL,
    [SZ_PATIENT_ZIP]       VARCHAR (100)  NULL,
    [SZ_PATIENT_PHONE]     VARCHAR (50)   NULL,
    [DT_DATE_OF_ACCIDENT]  VARCHAR (100)  NULL,
    [DT_DOB]               VARCHAR (100)  NULL,
    [SZ_POLICY_HOLDER]     VARCHAR (500)  NULL,
    [SZ_POLICY_NUMBER]     VARCHAR (100)  NULL,
    [SZ_CLAIM_NUMBER]      VARCHAR (100)  NULL,
    [SZ_INSURANCE_NAME]    VARCHAR (500)  NULL,
    [SZ_INSURANCE_ADDRESS] VARCHAR (1000) NULL,
    [SZ_INSURANCE_CITY]    VARCHAR (100)  NULL,
    [SZ_STATE]             VARCHAR (100)  NULL,
    [SZ_INSURANCE_ZIP]     VARCHAR (100)  NULL,
    [SZ_INSURANCE_EMAIL]   VARCHAR (100)  NULL,
    [SZ_STATUS_NAME]       VARCHAR (100)  NULL,
    [SZ_ATTORNEY_NAME]     VARCHAR (500)  NULL,
    [SZ_ATTORNEY_ADDRESS]  VARCHAR (1000) NULL,
    [SZ_ATTORNEY_CITY]     VARCHAR (100)  NULL,
    [SZ_ATTORNEY_STATE]    VARCHAR (100)  NULL,
    [SZ_ATTORNEY_ZIP]      VARCHAR (100)  NULL,
    [SZ_ATTORNEY_FAX]      VARCHAR (100)  NULL,
    [SZ_PROVIDER]          VARCHAR (1000) NULL,
    [SZ_BILL_NUMBER]       VARCHAR (100)  NULL,
    [DT_START_VISIT_DATE]  VARCHAR (100)  NULL,
    [DT_END_VISIT_DATE]    VARCHAR (100)  NULL,
    [FLT_BILL_AMOUNT]      VARCHAR (100)  NULL,
    [FLT_PAID]             VARCHAR (100)  NULL,
    [FLT_BALANCE]          VARCHAR (100)  NULL,
    [SZ_COMPANY_ID]        VARCHAR (50)   NULL,
    [SZ_OFFICE_ID]         VARCHAR (50)   NULL,
    [SZ_INSURANCE_ID]      VARCHAR (50)   NULL,
    [DomainId]             NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_TBLBILLING_DATA] PRIMARY KEY CLUSTERED ([BILLING_AUTO_ID] ASC)
);

