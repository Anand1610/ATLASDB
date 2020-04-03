CREATE TYPE [dbo].[CPTBillsUpdateLIT] AS TABLE (
    [TCPT_ATUO_ID]        INT             NULL,
    [TLITCollectedAmount] DECIMAL (18, 2) NULL,
    [TLITIntrest]         DECIMAL (18, 2) NULL,
    [TLITFees]            DECIMAL (18, 2) NULL,
    [TCourtFees]          DECIMAL (18, 2) NULL,
    [TDomainID]           NVARCHAR (50)   NULL);

