CREATE TYPE [dbo].[CPTPayDetails_Update] AS TABLE (
    [TCPT_ATUO_ID]           INT             NULL,
    [TPrev_Collected_Amount] DECIMAL (18, 2) NULL,
    [TCurrent_Paid]          DECIMAL (18, 2) NULL,
    [TPrev_Deductible]       DECIMAL (18, 2) NULL,
    [TDeductible]            DECIMAL (18, 2) NULL,
    [TPrev_Intrest]          DECIMAL (18, 2) NULL,
    [TInterest_Paid]         DECIMAL (18, 2) NULL,
    [TPrev_AttorneyFee]      DECIMAL (18, 2) NULL,
    [TAttorneyFee]           DECIMAL (18, 2) NULL,
    [TCase_ID]               NVARCHAR (50)   NULL,
    [TCreated_By]            NVARCHAR (500)  NULL,
    [TDomainID]              NVARCHAR (50)   NULL,
    [TPayment_Id]            INT             NULL);

