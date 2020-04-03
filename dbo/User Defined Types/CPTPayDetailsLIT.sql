CREATE TYPE [dbo].[CPTPayDetailsLIT] AS TABLE (
    [TCPT_ATUO_ID]               INT             NULL,
    [TPrev_LIT_Collected_Amount] DECIMAL (18, 2) NULL,
    [TCurrent_LIT_Paid]          DECIMAL (18, 2) NULL,
    [TPrev_LIT_Intrest]          DECIMAL (18, 2) NULL,
    [TLITIntrest]                DECIMAL (18, 2) NULL,
    [TPrev_LIT_Fees]             DECIMAL (18, 2) NULL,
    [TLITFees]                   DECIMAL (18, 2) NULL,
    [TPrev_LIT_CourtFee]         DECIMAL (18, 2) NULL,
    [TCourtFees]                 DECIMAL (18, 2) NULL,
    [TCase_ID]                   NVARCHAR (50)   NULL,
    [TCreated_By]                NVARCHAR (500)  NULL,
    [TDomainID]                  NVARCHAR (50)   NULL,
    [TPayment_Id]                INT             NULL);

