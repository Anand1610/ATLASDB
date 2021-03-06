﻿CREATE TABLE [dbo].[tbldelcase] (
    [Case_AutoId]                  INT             IDENTITY (1, 1) NOT NULL,
    [Case_Id]                      NVARCHAR (50)   NOT NULL,
    [Case_Code]                    VARCHAR (100)   NULL,
    [Provider_Code]                VARCHAR (100)   NULL,
    [InsuranceCompany_Code]        VARCHAR (100)   NULL,
    [Provider_Id]                  INT             NULL,
    [InsuranceCompany_Id]          INT             NULL,
    [InjuredParty_LastName]        NVARCHAR (100)  NULL,
    [InjuredParty_FirstName]       NVARCHAR (100)  NULL,
    [InjuredParty_Address]         NVARCHAR (255)  NULL,
    [InjuredParty_City]            NVARCHAR (40)   NULL,
    [InjuredParty_State]           NVARCHAR (40)   NULL,
    [InjuredParty_Zip]             NVARCHAR (40)   NULL,
    [InjuredParty_Phone]           VARCHAR (20)    NULL,
    [InjuredParty_Misc]            VARCHAR (50)    NULL,
    [InsuredParty_LastName]        NVARCHAR (100)  NULL,
    [InsuredParty_FirstName]       NVARCHAR (100)  NULL,
    [InsuredParty_Address]         NVARCHAR (255)  NULL,
    [InsuredParty_City]            NVARCHAR (40)   NULL,
    [InsuredParty_State]           NVARCHAR (40)   NULL,
    [InsuredParty_Zip]             NVARCHAR (40)   NULL,
    [InsuredParty_Misc]            VARCHAR (50)    NULL,
    [Accident_Date]                DATETIME        NULL,
    [Accident_Address]             NVARCHAR (255)  NULL,
    [Accident_City]                NVARCHAR (40)   NULL,
    [Accident_State]               NVARCHAR (40)   NULL,
    [Accident_Zip]                 NVARCHAR (40)   NULL,
    [Policy_Number]                VARCHAR (40)    NULL,
    [Ins_Claim_Number]             NVARCHAR (50)   NULL,
    [IndexOrAAA_Number]            VARCHAR (40)    NULL,
    [Status]                       NVARCHAR (50)   NULL,
    [Defendant_Id]                 NVARCHAR (50)   NULL,
    [Date_Opened]                  DATETIME        NULL,
    [Last_Status]                  VARCHAR (50)    NULL,
    [Initial_Status]               NVARCHAR (20)   NULL,
    [Memo]                         NVARCHAR (255)  NULL,
    [InjuredParty_Type]            NVARCHAR (20)   NULL,
    [InsuredParty_Type]            NVARCHAR (20)   NULL,
    [Adjuster_Id]                  INT             NULL,
    [DenialReasons_Type]           NVARCHAR (50)   NULL,
    [Court_Id]                     INT             NULL,
    [Attorney_FileNumber]          NVARCHAR (100)  NULL,
    [Group_Data]                   INT             NULL,
    [Group_Id]                     INT             NULL,
    [Date_Status_Changed]          DATETIME        NULL,
    [Date_Answer_Received]         DATETIME        NULL,
    [Motion_Date]                  DATETIME        NULL,
    [Trial_Date]                   CHAR (50)       NULL,
    [Attorney_Id]                  VARCHAR (50)    NULL,
    [Date_Answer_Expected]         DATETIME        NULL,
    [Reply_Date]                   DATETIME        NULL,
    [Calendar_Part]                VARCHAR (50)    NULL,
    [Motion_Type]                  VARCHAR (100)   NULL,
    [Whose_Motion]                 VARCHAR (50)    NULL,
    [Defense_Opp_Due]              DATETIME        NULL,
    [Date_Ext_Of_Time_2]           DATETIME        NULL,
    [XMotion_Type]                 VARCHAR (50)    NULL,
    [Case_Billing]                 FLOAT (53)      NULL,
    [DateOfService_Start]          VARCHAR (50)    NULL,
    [DateOfService_End]            VARCHAR (50)    NULL,
    [Claim_Amount]                 VARCHAR (100)   NULL,
    [Paid_Amount]                  VARCHAR (100)   NULL,
    [Date_BillSent]                VARCHAR (250)   NULL,
    [Caption]                      NVARCHAR (1000) NULL,
    [Group_ClaimAmt]               NVARCHAR (200)  NULL,
    [Group_PaidAmt]                NVARCHAR (200)  NULL,
    [Group_Balance]                NVARCHAR (200)  NULL,
    [Group_InsClaimNo]             NVARCHAR (200)  NULL,
    [Group_All]                    NVARCHAR (500)  NULL,
    [Date_Packeted]                DATETIME        NULL,
    [Group_Accident]               NVARCHAR (200)  NULL,
    [Group_PolicyNum]              NVARCHAR (200)  NULL,
    [GROUP_CASE_SEQUENCE]          INT             NULL,
    [Our_SJ_Motion_Activity]       NVARCHAR (100)  NULL,
    [Their_SJ_Motion_Activity]     NVARCHAR (100)  NULL,
    [Our_Discovery_Demands]        NVARCHAR (100)  NULL,
    [Our_Discovery_Responses]      NVARCHAR (100)  NULL,
    [Date_Summons_Printed]         DATETIME        NULL,
    [Plaintiff_Discovery_Due_Date] DATETIME        NULL,
    [Defendant_Discovery_Due_Date] DATETIME        NULL,
    [Date_Bill_Submitted]          DATETIME        NULL,
    [Date_Index_Number_Purchased]  DATETIME        NULL,
    [Date_Afidavit_Filed]          DATETIME        NULL,
    [Date_Ext_Of_Time]             DATETIME        NULL,
    [Date_Summons_Sent_Court]      DATETIME        NULL,
    [Date_Ext_Of_Time_3]           DATETIME        NULL,
    [Served_To]                    VARCHAR (100)   NULL,
    [Served_On_Date]               DATETIME        NULL,
    [Served_On_Time]               VARCHAR (50)    NULL,
    [Date_Closed]                  DATETIME        NULL,
    [Notary_id]                    INT             NULL,
    [DomainId]                     NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

