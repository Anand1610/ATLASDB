﻿CREATE TABLE [dbo].[case_search_saved_query] (
    [pk_search_query_id]       INT            IDENTITY (1, 1) NOT NULL,
    [domainid]                 VARCHAR (100)  NULL,
    [column_value]             VARCHAR (MAX)  NULL,
    [column_name]              VARCHAR (MAX)  NULL,
    [query_name]               NVARCHAR (250) NULL,
    [userid]                   INT            NULL,
    [modified_userid]          INT            NULL,
    [create_date]              DATETIME       NULL,
    [modified_date]            DATETIME       NULL,
    [providersel]              VARCHAR (MAX)  NULL,
    [insurancesel]             VARCHAR (MAX)  NULL,
    [currentstatussel]         VARCHAR (MAX)  NULL,
    [initialstatussel]         VARCHAR (MAX)  NULL,
    [case_id]                  VARCHAR (2000) NULL,
    [oldcaseid]                VARCHAR (100)  NULL,
    [injuredname]              VARCHAR (100)  NULL,
    [insuredname]              VARCHAR (100)  NULL,
    [policyno]                 VARCHAR (100)  NULL,
    [claimno]                  VARCHAR (100)  NULL,
    [billnumber]               VARCHAR (200)  NULL,
    [indexoraaano]             VARCHAR (100)  NULL,
    [denailreasonid]           VARCHAR (1000) NULL,
    [courtsel]                 VARCHAR (MAX)  NULL,
    [defendantsel]             INT            NULL,
    [reviewingdoctor]          INT            NULL,
    [providergroupsel]         VARCHAR (100)  NULL,
    [insurancegroupsel]        VARCHAR (100)  NULL,
    [date_opened_from]         VARCHAR (10)   NULL,
    [date_opened_to]           VARCHAR (10)   NULL,
    [dos_from]                 VARCHAR (10)   NULL,
    [dos_to]                   VARCHAR (10)   NULL,
    [date_status_changed_from] VARCHAR (10)   NULL,
    [date_status_changed_to]   VARCHAR (10)   NULL,
    [Final_Status]             NVARCHAR (200) NULL,
    [forum]                    NVARCHAR (200) NULL,
    [injuredfirstname]         VARCHAR (100)  NULL,
    [injuredlastname]          VARCHAR (100)  NULL,
    [insuredfirstname]         VARCHAR (100)  NULL,
    [insuredlastname]          VARCHAR (100)  NULL,
    [packetid]                 VARCHAR (100)  NULL,
    [adjusterfirstname]        VARCHAR (100)  NULL,
    [adjusterlastname]         VARCHAR (100)  NULL,
    [accidentdate]             VARCHAR (10)   NULL,
    [accountno]                VARCHAR (100)  NULL,
    [checknumber]              VARCHAR (100)  NULL,
    [paymentdatefrom]          VARCHAR (10)   NULL,
    [paymentdateto]            VARCHAR (10)   NULL,
    [filledunfiled]            VARCHAR (20)   NULL,
    [specialityid]             VARCHAR (MAX)  NULL,
    [attorneyfirmid]           VARCHAR (MAX)  NULL,
    [rebuttalstatusid]         VARCHAR (MAX)  NULL,
    [casetypeid]               VARCHAR (MAX)  NULL,
    [locationid]               VARCHAR (MAX)  NULL,
    [PortfolioId]              VARCHAR (MAX)  NULL,
    [Date_AAA_Arb_Filed]       DATETIME       NULL,
    [Status_Age]               NVARCHAR (200) NULL,
    [Case_Age]                 NVARCHAR (200) NULL,
    [Date_BillSent]            DATETIME       NULL,
    [Packet_Indicator]         VARCHAR (200)  NULL
);

