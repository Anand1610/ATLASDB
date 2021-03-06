﻿CREATE TABLE [dbo].[BILLS_WITH_PROCEDURE_CODES_temp] (
    [Account]              VARCHAR (255)   NULL,
    [BillNumber]           VARCHAR (255)   NULL,
    [Code]                 VARCHAR (50)    NULL,
    [Description]          VARCHAR (MAX)   NULL,
    [Amount]               FLOAT (53)      NULL,
    [DOS]                  DATETIME        NULL,
    [Specialty]            VARCHAR (255)   NULL,
    [BillAmount]           FLOAT (53)      NULL,
    [ins_fee_schedule]     MONEY           NULL,
    [CPT_ATUO_ID]          INT             IDENTITY (1, 1) NOT NULL,
    [Case_ID]              VARCHAR (50)    NULL,
    [fk_Treatment_Id]      INT             NULL,
    [DomainID]             VARCHAR (50)    NOT NULL,
    [created_by_user]      NVARCHAR (255)  NOT NULL,
    [created_date]         DATETIME        NULL,
    [modified_by_user]     NVARCHAR (255)  NULL,
    [modified_date]        DATETIME        NULL,
    [CollectedAmount]      DECIMAL (18, 2) NULL,
    [ICD10_3]              VARCHAR (100)   NULL,
    [ICD10_2]              VARCHAR (100)   NULL,
    [ICD10_1]              VARCHAR (100)   NULL,
    [MOD]                  INT             NULL,
    [UNITS]                INT             NULL,
    [Deductible]           FLOAT (53)      NULL,
    [Intrest]              FLOAT (53)      NULL,
    [AttorneyFee]          FLOAT (53)      NULL,
    [LITCollectedAmount]   DECIMAL (18, 2) NULL,
    [LITIntrest]           DECIMAL (18, 2) NULL,
    [LITFees]              DECIMAL (18, 2) NULL,
    [CourtFees]            DECIMAL (18, 2) NULL,
    [Purchase_Freeze_Date] DATETIME        NULL,
    [Bill_Adjustment]      FLOAT (53)      NULL,
    [Refund_Freeze_Date]   DATETIME        NULL,
    [GP_Freeze_Date]       DATETIME        NULL,
    [GBBCodeID]            VARCHAR (20)    NULL
);

