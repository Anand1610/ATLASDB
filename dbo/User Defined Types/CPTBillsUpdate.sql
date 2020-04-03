CREATE TYPE [dbo].[CPTBillsUpdate] AS TABLE (
    [TCPT_ATUO_ID]     INT             NULL,
    [TCollectedAmount] DECIMAL (18, 2) NULL,
    [TDeductible]      DECIMAL (18, 2) NULL,
    [TIntrest]         DECIMAL (18, 2) NULL,
    [TAttorneyFee]     DECIMAL (18, 2) NULL,
    [TDomainID]        NVARCHAR (50)   NULL);

