CREATE TABLE [dbo].[tblAFData] (
    [CASE_ID]            VARCHAR (50)  NULL,
    [BILL_NUMBER]        VARCHAR (50)  NULL,
    [Claim_Amount]       FLOAT (53)    NULL,
    [Paid_Amount]        FLOAT (53)    NULL,
    [Fee_Schedule]       FLOAT (53)    NULL,
    [Date_Bill_Sent]     DATETIME      NULL,
    [Settlemnt_Amount]   FLOAT (53)    NULL,
    [Settlemnt_Int]      FLOAT (53)    NULL,
    [Packeted_Case_ID]   VARCHAR (50)  NULL,
    [DATE_AAA_ARB_FILED] DATETIME      NULL,
    [Provider_Group]     VARCHAR (200) NULL,
    [Status]             VARCHAR (200) NULL,
    [Status_ACT]         VARCHAR (200) NULL,
    [Payment_Amount_C]   FLOAT (53)    NULL,
    [Payment_Amount_I]   FLOAT (53)    NULL,
    [Payment_Amount_AF]  FLOAT (53)    NULL,
    [Settlemnt_AF]       FLOAT (53)    NULL,
    [vol_date]           DATETIME      NULL,
    [Col_date]           DATETIME      NULL
);

